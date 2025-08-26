const BOOT_API   = '${springBootApiUrl}';
const accessTokenKey = 'accessToken';
function setAccessToken(t){ localStorage.setItem(accessTokenKey, t); }
function getAccessToken(){ return localStorage.getItem(accessTokenKey); }
function clearAccessToken(){ localStorage.removeItem(accessTokenKey); }

// 모든 AJAX 요청 시 Authorization 헤더 자동 부착 + 쿠키 전송
$.ajaxSetup({
    beforeSend: function(xhr){
        const token = getAccessToken();
        if(token){
            xhr.setRequestHeader('Authorization', 'Bearer ' + token);
        }
        this.xhrFields = $.extend({}, this.xhrFields, { withCredentials: true });
        this.crossDomain = true;
    }
});

// 401 에러 처리: refresh 시도 후 재요청, 실패 시 로그아웃
$(document).ajaxError(async function(event, jqxhr, settings){
    if(jqxhr.status === 401 && !settings._retried){
        try{
            const refreshResp = await $.ajax({
                url: BOOT_API + '/auth/refresh',
                type: 'POST',
                xhrFields: { withCredentials: true }
            });
            const newAccess = refreshResp?.data?.accessToken;
            if(newAccess){
                setAccessToken(newAccess);
                const retryOpts = $.extend(true, {}, settings, { _retried: true });
                $.ajax(retryOpts);
                return;
            }
        } catch(e){
            // refresh 실패 무시
        }
        clearAccessToken();
        window.location.href='${cpath}/auth/login';
    }
});

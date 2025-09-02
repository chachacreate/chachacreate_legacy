package com.chacha.create.util;

import com.chacha.create.util.s3.AwsS3Config;
import com.chacha.create.util.s3.AwsS3Properties;
import com.chacha.create.util.s3.S3Uploader;
import com.zaxxer.hikari.HikariDataSource;
import io.github.cdimascio.dotenv.Dotenv;
import net.sf.log4jdbc.Log4jdbcProxyDataSource;
import net.sf.log4jdbc.tools.Log4JdbcCustomFormatter;
import org.apache.ibatis.session.SqlSessionFactory;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.core.JdbcTemplate;
import software.amazon.awssdk.services.s3.S3Client;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.Properties;

@Configuration
public class DataSourceConfig {
    
    private static final Logger log = LoggerFactory.getLogger(DataSourceConfig.class);
    
    private final StandardPBEStringEncryptor encryptor;
    private final Properties properties;
    
    public DataSourceConfig() {
        Dotenv dotenv = Dotenv.load();
        String encryptorPassword = dotenv.get("JASYPT_ENCRYPTOR_PASSWORD");
        
        this.encryptor = new StandardPBEStringEncryptor();
        encryptor.setPassword(encryptorPassword);
        encryptor.setAlgorithm("PBEWithMD5AndDES");
        
        this.properties = new Properties();
        loadProperties();
    }
    
    private void loadProperties() {
        try {
            ClassPathResource dbProps = new ClassPathResource("git_submodule_chacha/application-db.properties");
            ClassPathResource secretProps = new ClassPathResource("git_submodule_chacha/application-secrets.properties");
            
            Properties tempProps = new Properties();
            
            if (dbProps.exists()) {
                tempProps.load(dbProps.getInputStream());
            }
            if (secretProps.exists()) {
                tempProps.load(secretProps.getInputStream());
            }
            
            for (String key : tempProps.stringPropertyNames()) {
                String value = tempProps.getProperty(key);
                if (value != null && value.startsWith("ENC(") && value.endsWith(")")) {
                    String encryptedValue = value.substring(4, value.length() - 1);
                    try {
                        String decryptedValue = encryptor.decrypt(encryptedValue);
                        properties.setProperty(key, decryptedValue);
                    } catch (Exception e) {
                        properties.setProperty(key, value);
                    }
                } else {
                    properties.setProperty(key, value);
                }
            }
            
        } catch (IOException e) {
            throw new RuntimeException("Failed to load properties", e);
        }
    }
    
    private String getProperty(String key) {
        String value = properties.getProperty(key);
        if (value == null) {
            throw new RuntimeException("Property not found: " + key);
        }
        return value;
    }

    @Bean(name = "customHikariDataSource")
    public DataSource customHikariDataSource() throws IOException {
        String walletUrl = getProperty("oracle.wallet.url");
        String username = getProperty("oracle.wallet.username");
        String password = getProperty("oracle.wallet.password");
        
        // ClassPath 기반으로 Wallet 경로 설정
        ClassPathResource walletResource = new ClassPathResource("git_submodule_chacha/wallet");
        String walletDir = walletResource.getFile().getAbsolutePath();
        
        // 시스템 프로퍼티 설정
        System.setProperty("oracle.net.tns_admin", walletDir);
        System.setProperty("oracle.net.wallet_location", walletDir);
        
        HikariDataSource ds = new HikariDataSource();
        ds.setDriverClassName("oracle.jdbc.OracleDriver");
        
        // URL 정리
        String cleanUrl = walletUrl;
        if (cleanUrl.contains("?TNS_ADMIN=")) {
            cleanUrl = cleanUrl.substring(0, cleanUrl.indexOf("?TNS_ADMIN="));
        }
        
        ds.setJdbcUrl(cleanUrl);
        ds.setUsername(username);
        ds.setPassword(password);
        
        // HikariCP 설정
        ds.setMaximumPoolSize(10);
        ds.setMinimumIdle(2);
        ds.setConnectionTimeout(30000);
        ds.setIdleTimeout(300000);
        ds.setMaxLifetime(900000);
        ds.setLeakDetectionThreshold(60000);
        
        log.info("Oracle Database 연결 완료: {}", cleanUrl);
        
        return ds;
    }

    @Bean(name = "jdbcTemplate")
    public JdbcTemplate jdbcTemplate() throws IOException {
        return new JdbcTemplate(customHikariDataSource());
    }

    @Bean(name = "dataSource")
    public DataSource dataSource() throws IOException {
        Log4jdbcProxyDataSource proxyDataSource = new Log4jdbcProxyDataSource(customHikariDataSource());
        
        Log4JdbcCustomFormatter formatter = new Log4JdbcCustomFormatter();
        formatter.setSqlPrefix("[ SQL문장 ] ");
        
        proxyDataSource.setLogFormatter(formatter);
        
        return proxyDataSource;
    }

    @Bean(name = "sqlSessionFactory")
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource());
        
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        factoryBean.setConfigLocation(resolver.getResource("classpath:mybatis/sqlMapConfig.xml"));
        factoryBean.setMapperLocations(resolver.getResources("classpath:mybatis/mappers/**/*.xml"));
        
        return factoryBean.getObject();
    }

    @Bean(name = "sqlSession")
    public SqlSessionTemplate sqlSession() throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory());
    }
    
    @Bean(name = "awsS3Properties")
    public AwsS3Properties awsS3Properties() {
        AwsS3Properties props = new AwsS3Properties();
        props.setAccessKeyId(getProperty("aws.s3.access-key-id"));
        props.setSecretAccessKey(getProperty("aws.s3.secret-access-key"));
        props.setRegion(getProperty("aws.s3.region"));
        props.setBucketName(getProperty("aws.s3.bucket-name"));
        return props;
    }
    
    @Bean(name = "awsS3Config")
    public AwsS3Config awsS3Config() {
        return new AwsS3Config(awsS3Properties());
    }
    
    @Bean(name = "s3Client")
    public S3Client s3Client() {
        return awsS3Config().buildS3Client();
    }
    
    @Bean(name = "s3Uploader")
    public S3Uploader s3Uploader() {
        return new S3Uploader(s3Client(), getProperty("aws.s3.bucket-name"), "10MB");
    }
}
package com.chacha.create.util.s3;

import net.coobird.thumbnailator.Thumbnails;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.UUID;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

public class ImageUtil {
    
    // 정적 초기화 블록에서 WebP 지원 확인
    static {
        try {
            String[] readerFormats = ImageIO.getReaderFormatNames();
            String[] writerFormats = ImageIO.getWriterFormatNames();
            
            boolean webpReaderFound = false;
            boolean webpWriterFound = false;
            
            for (String format : readerFormats) {
                if ("webp".equalsIgnoreCase(format)) {
                    webpReaderFound = true;
                    break;
                }
            }
            
            for (String format : writerFormats) {
                if ("webp".equalsIgnoreCase(format)) {
                    webpWriterFound = true;
                    break;
                }
            }
            
            System.out.println("WebP Reader 지원: " + webpReaderFound);
            System.out.println("WebP Writer 지원: " + webpWriterFound);
            
        } catch (Exception e) {
            System.err.println("WebP 지원 확인 중 오류: " + e.getMessage());
        }
    }
    
    // 원본 파일명 생성 (UUID.webp)
    public static String generateOriginalFileName() {
        return UUID.randomUUID().toString() + ".webp";
    }
    
    // 썸네일 파일명 생성 (UUID_thumb.webp)
    public static String generateThumbnailFileName(String originalFileName) {
        return originalFileName.replace(".webp", "_thumb.webp");
    }
    
    // InputStream → WebP 변환
    public static InputStream convertToWebP(InputStream inputStream) throws IOException {
        System.out.println("WebP 변환 시작...");
        
        BufferedImage image = ImageIO.read(inputStream);
        if (image == null) {
            throw new IllegalArgumentException("이미지를 읽을 수 없습니다.");
        }
        
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        boolean success = ImageIO.write(image, "webp", os);
        
        if (!success) {
            System.err.println("WebP 변환 실패, 사용 가능한 Writer 형식:");
            String[] formats = ImageIO.getWriterFormatNames();
            for (String format : formats) {
                System.err.println("- " + format);
            }
            throw new IOException("WebP 형식으로 변환할 수 없습니다.");
        }
        
        System.out.println("WebP 변환 성공! 크기: " + os.size() + " bytes");
        return new ByteArrayInputStream(os.toByteArray());
    }
    
    // InputStream → 썸네일 생성
    public static InputStream createThumbnail(InputStream inputStream) throws IOException {
        System.out.println("썸네일 생성 시작...");
        
        BufferedImage image = ImageIO.read(inputStream);
        if (image == null) {
            throw new IllegalArgumentException("이미지를 읽을 수 없습니다.");
        }
        
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        
        try {
            // Thumbnailator로 WebP 썸네일 생성 시도
            Thumbnails.of(image)
                    .size(300, 300)
                    .outputFormat("webp")
                    .toOutputStream(os);
            System.out.println("Thumbnailator WebP 썸네일 생성 성공!");
        } catch (Exception e) {
            System.out.println("Thumbnailator WebP 실패, 수동 생성으로 전환: " + e.getMessage());
            
            // Fallback: 수동 썸네일 생성 후 WebP 변환
            os.reset();
            BufferedImage thumbnailImage = createThumbnailManually(image, 300, 300);
            boolean success = ImageIO.write(thumbnailImage, "webp", os);
            
            if (!success) {
                throw new IOException("WebP 썸네일을 생성할 수 없습니다.");
            }
            System.out.println("수동 WebP 썸네일 생성 성공!");
        }
        
        return new ByteArrayInputStream(os.toByteArray());
    }
    
    // 수동 썸네일 생성
    private static BufferedImage createThumbnailManually(BufferedImage originalImage, int targetWidth, int targetHeight) {
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();
        
        // 비율 유지하면서 크기 조정
        double ratio = Math.min((double) targetWidth / originalWidth, (double) targetHeight / originalHeight);
        int newWidth = (int) (originalWidth * ratio);
        int newHeight = (int) (originalHeight * ratio);
        
        // 고품질 썸네일 생성
        BufferedImage thumbnailImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = thumbnailImage.createGraphics();
        
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        
        g2d.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
        g2d.dispose();
        
        return thumbnailImage;
    }
}
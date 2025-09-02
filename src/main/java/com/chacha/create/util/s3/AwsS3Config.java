package com.chacha.create.util.s3;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

public class AwsS3Config {

    private final AwsS3Properties properties;

    // XML에서 constructor-arg 로 주입
    public AwsS3Config(AwsS3Properties properties) {
        this.properties = properties;
    }

    // XML에서 factory-method 로 호출할 메서드
    public S3Client buildS3Client() {
        return S3Client.builder()
                .region(Region.of(properties.getRegion()))
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(
                                properties.getAccessKeyId(),
                                properties.getSecretAccessKey()
                        )
                ))
                .build();
    }
}

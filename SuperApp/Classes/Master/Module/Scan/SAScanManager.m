//
//  SAScanManager.m
//  SuperApp
//
//  Created by Tia on 2023/4/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAScanManager.h"


@interface SAScanManager () <AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
/// 会话
@property (nonatomic, strong) AVCaptureSession *session;

/**
 扫描中心识别区域范围
 */
@property (nonatomic, assign) CGRect scanFrame;

/**
 展示输出流的视图——即照相机镜头下的内容
 */
@property (nonatomic, strong) UIView *preview;

@property (nonatomic, copy) void (^completionHandler)(UIImage *image);

@property (nonatomic, strong) AVCapturePhotoOutput *imageOutPut;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@end


@implementation SAScanManager

- (instancetype)initWithPreview:(UIView *)preview andScanFrame:(CGRect)scanFrame {
    if (self == [super init]) {
        self.preview = preview;
        self.scanFrame = scanFrame;
        [self configuredScanManager];
        [self createQueue];
    }
    return self;
}

- (void)createQueue {
    dispatch_queue_t sessionQueue = dispatch_queue_create("xxx session queue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}

#pragma mark - private methods
// 初始化采集配置信息
- (void)configuredScanManager {
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.preview.layer.bounds;
    self.preview.layer.masksToBounds = YES;
    [self.preview.layer insertSublayer:layer atIndex:0];
}

#pragma mark - event response
- (void)openFlashSwitch:(BOOL)open {
    if (self.flashOpen == open) {
        return;
    }
    self.flashOpen = open;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if ([device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        if (self.flashOpen) {
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOn;
        } else {
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
        }
        [device unlockForConfiguration];
    }
}

#pragma mark - public methods
- (void)sessionStartRunning {
    dispatch_async(self.sessionQueue, ^{
        if (!self.session.running) {
            [self.session startRunning];
        }
    });
    //    [_session startRunning];
}

- (void)sessionStopRunning {
    dispatch_async(self.sessionQueue, ^{
        if (self.session.running) {
            [self.session stopRunning];
        }
    });
}

- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *))completionHandler {
    //    self.completionHandler = completionHandler;
    //
    //    AVCaptureConnection *videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    //    if (!videoConnection || !self.session.isRunning) {
    //        completionHandler(nil);
    //        return;
    //    }
    //    [self.imageOutPut capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];


    AVCaptureStillImageOutput *output = self.session.outputs.firstObject;
    AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [output captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];

            completionHandler(image);
            //            [self.session stopRunning];
            //            if (block) {
            //                block(image);
            //            }
        }
    }];
}


#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    if (!error) {
        NSData *imageData = [photo fileDataRepresentation];

        UIImage *image = [UIImage imageWithData:imageData];

        !self.completionHandler ?: self.completionHandler(image);
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate的方法
// 扫描过程中执行，主要用来判断环境的黑暗程度
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (self.ambientLightChangedBlock == nil) {
        return;
    }

    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary *)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    !self.ambientLightChangedBlock ?: self.ambientLightChangedBlock(brightnessValue);
}

#pragma mark - lazy load
- (AVCaptureSession *)session {
    if (!_session) {
        // 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) {
            return nil;
        }

        // 创建二维码扫描输出流
        //        self.imageOutPut = [[AVCapturePhotoOutput alloc] init];
        //        AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
        //        NSDictionary *setting = @{AVVideoCodecKey:AVVideoCodecJPEG};


        // 设置代理 在主线程里刷新
        //        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // 设置采集扫描区域的比例 默认全屏是（0，0，1，1）
        // rectOfInterest 填写的是一个比例，输出流视图preview.frame为 x , y, w, h, 要设置的矩形快的scanFrame 为 x1, y1, w1, h1. 那么rectOfInterest 应该设置为 CGRectMake(y1/y, x1/x, h1/h, w1/w)。
        //        CGFloat x = CGRectGetMinX(self.scanFrame) / CGRectGetWidth(self.preview.frame);
        //        CGFloat y = CGRectGetMinY(self.scanFrame) / CGRectGetHeight(self.preview.frame);
        //        CGFloat width = CGRectGetWidth(self.scanFrame) / CGRectGetWidth(self.preview.frame);
        //        CGFloat height = CGRectGetHeight(self.scanFrame) / CGRectGetHeight(self.preview.frame);
        //        output.rectOfInterest = CGRectMake(y, x, height, width);

        // 创建环境光感输出流
        AVCaptureVideoDataOutput *lightOutput = [[AVCaptureVideoDataOutput alloc] init];
        [lightOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

        _session = [[AVCaptureSession alloc] init];
        // 高质量采集率
        //        [_session setSessionPreset:AVCaptureSessionPresetHigh];


        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            _session.sessionPreset = AVCaptureSessionPreset1280x720;
        }


        [_session addInput:input];
        //        [_session addOutput:self.imageOutPut];

        AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *setting = @{AVVideoCodecKey: AVVideoCodecJPEG};
        [imageOutput setOutputSettings:setting];

        if ([_session canAddOutput:imageOutput]) {
            [_session addOutput:imageOutput];
        }


        [_session addOutput:lightOutput];
    }
    return _session;
}

@end

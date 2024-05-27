//
//  HDTakingPhotoViewController.m
//  SuperApp
//
//  Created by VanJay on 19/4/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTakingPhotoViewController.h"
#import "Masonry.h"
#import "SAMultiLanguageManager.h"
#import <AVFoundation/AVFoundation.h>
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDKitCore/UIViewController+HDKitCore.h>
#import <HDUIKit/HDAlertView.h>
#import <HDUIKit/NAT.h>


@interface HDTakingPhotoViewController () <AVCapturePhotoCaptureDelegate>
// 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
// AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;
// 当启动摄像头开始捕获输入
//@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCapturePhotoOutput *imageOutPut;
// session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;
// 图像预览层，实时显示捕获的图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) HDTakingPhotoView *cameraView; ///< 界面
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isFlashLightOn;
/// 当前拍下的图片
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) AVCaptureFlashMode flashMode;

@end


@implementation HDTakingPhotoViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 请求权限
    if ([self canUseCamera]) {
        [self setupView];

        [self startSession];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self canUseCamera]) {
        [self startSession];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopSession];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.cameraView.frame = self.view.bounds;
    self.imageView.frame = self.view.bounds;
}

- (void)setupView {
    // 解决dismiss时按钮还残留在界面上
    self.view.clipsToBounds = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.cameraView];

    @HDWeakify(self);
    self.cameraView.takePhotoBlock = ^(BOOL isSelected) {
        @HDStrongify(self);
        if (isSelected) {
            [self takePhoto];
        }
    };
    self.cameraView.cancelBlock = ^{
        @HDStrongify(self);
        [self cancel];
    };
    self.cameraView.switchFlashLightBlock = ^(BOOL isSelected) {
        @HDStrongify(self);
        [self switchFlashLight:isSelected];
    };
    self.cameraView.switchCameraBlock = ^(BOOL isSelected) {
        @HDStrongify(self);
        [self switchCamera:isSelected];
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (_isFlashLightOn) {
        [self switchFlashLight:NO];
    }
}

- (void)dealloc {
    HDLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupCamera {
    self.view.backgroundColor = [UIColor whiteColor];

    // 使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }

    // 使用设备初始化输入
    if (!_input) {
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        if (!_input) {
            @HDWeakify(self);
            [NAT showAlertWithMessage:SALocalizedString(@"system_alert", @"系统提示") buttonTitle:SALocalizedString(@"system_camera_error", @"未能找到相机设备")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                                  @HDStrongify(self);
                                  [self dismissAnimated:YES completion:nil];
                              }];
            return;
        }
    }

    if (!_imageOutPut) {
        _imageOutPut = [[AVCapturePhotoOutput alloc] init];
    }

    // 生成会话，用来结合输入输出
    if (!_session) {
        self.session = [[AVCaptureSession alloc] init];
        if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        }

        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }

        if ([self.session canAddOutput:self.imageOutPut]) {
            [self.session addOutput:self.imageOutPut];
        }

        //        // 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错(如下设置条形码和二维码兼容)
        //        [_output setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code ]];
    }

    // 使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = self.view.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_previewLayer.connection setVideoOrientation:(AVCaptureVideoOrientation)[UIApplication sharedApplication].statusBarOrientation];
        [self.view.layer insertSublayer:_previewLayer atIndex:0];
    }
    if ([_device lockForConfiguration:nil]) {
        NSArray *outputs = _session.outputs;
        for (AVCaptureOutput *output in outputs) {
            if ([output isMemberOfClass:[AVCapturePhotoOutput class]]) {
                AVCapturePhotoOutput *photoOutput = (AVCapturePhotoOutput *)output;
                BOOL flashSupported = [[photoOutput supportedFlashModes] containsObject:@(AVCaptureFlashModeAuto)];
                if (flashSupported) {
                    AVCapturePhotoSettings *photoSettings = photoOutput.photoSettingsForSceneMonitoring;
                    photoSettings.flashMode = AVCaptureFlashModeAuto;
                    self.flashMode = AVCaptureFlashModeAuto;
                } else {
                    NSLog(@"ERROR : PHOTOOUTPUT CAN NOT SUPPORT AVCAPTUREMODE TYPE");
                }
            }
        }

        // 自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

#pragma mark - private methods
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                                                                          mediaType:AVMediaTypeVideo
                                                                                                                           position:position];
    //获取 devices
    NSArray<AVCaptureDevice *> *devices = videoDeviceDiscoverySession.devices;

    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)focusAtPoint:(CGPoint)point {
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake(point.y / size.height, 1 - point.x / size.width);
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }

        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }

        [self.device unlockForConfiguration];

        [_cameraView focusAtPoint:point];
    }
}

#pragma mark - Gesture
- (void)focusGesture:(UITapGestureRecognizer *)gesture {
    // caller 设置不显示或者会话未开始不继续
    if (!_config.showFocusFrame || !self.session.isRunning)
        return;

    CGPoint point = [gesture locationInView:gesture.view];

    [_cameraView focusAtPoint:point];
}

#pragma mark - event response
- (void)takePhoto {
    AVCaptureConnection *videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection || !self.session.isRunning) {
        HDLog(@"take photo failed!");
        return;
    }
    AVCapturePhotoSettings *set = [AVCapturePhotoSettings photoSettings];
    set.flashMode = self.flashMode;
    [self.imageOutPut capturePhotoWithSettings:set delegate:self];
}

- (void)cancel {
    !self.choosedImageBlock ?: self.choosedImageBlock(nil, [NSError errorWithDomain:@"" code:999 userInfo:nil]);
    [self dismissAnimated:YES completion:nil];
}

- (void)switchFlashLight:(BOOL)isSelected {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]) {
            [device lockForConfiguration:nil];
            if (isSelected) {
                [device setTorchMode:AVCaptureTorchModeOn];
                self.flashMode = AVCaptureFlashModeOn;
                _isFlashLightOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                self.flashMode = AVCaptureFlashModeOff;
                _isFlashLightOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)switchCamera:(BOOL)isSelected {
    if (self.session.isRunning) {
        NSError *error;
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront) {
            [_cameraView isFlashLightEnabled:YES];
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        } else {
            // 前置摄像头禁用闪光灯按钮
            [_cameraView isFlashLightEnabled:NO];
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }

        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];

        } else if (error) {
            HDLog(@"toggle carema failed, error = %@", error);
        }
        return;
    }
    // 使用照片
    if (self.image && self.imageView) {
        !self.choosedImageBlock ?: self.choosedImageBlock(self.imageView.image, nil);
        [self dismissAnimated:YES completion:nil];
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    if (!error) {
        NSData *imageData = [photo fileDataRepresentation];

        self.image = [UIImage imageWithData:imageData];

        [self stopSession];
    }
}

#pragma mark - private methods
- (void)startSession {
    [self setupCamera];

    // 开始启动
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self.session isRunning]) {
            [self.session startRunning];
        }
    });

    [self.cameraView dealingWithButtonsState:YES isFrontCamera:self.input.device.position == AVCaptureDevicePositionFront];

    if (self.image || self.imageView) {
        self.imageView.hidden = true;
        self.image = nil;
    }
}

- (void)stopSession {
    // 开始启动

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.session.running) {
            [self.session stopRunning];
        }
    });

    [_cameraView dealingWithButtonsState:NO isFrontCamera:self.input.device.position == AVCaptureDevicePositionFront];

    if (self.image) {
        self.imageView.hidden = false;

        // 修正方向
        self.image = [self.image fixOrientation];

        // 判断是否需要水平翻转
        BOOL isFrontCamera = self.input.device.position == AVCaptureDevicePositionFront;
        if (isFrontCamera && self.config.shouldHorizontalFlipFrontCameraImage) {
            self.image = [self.image rotateWithOrientation:UIImageOrientationUpMirrored];
        }

        self.imageView.image = self.image;
    } else {
        self.imageView.hidden = true;
    }
}

#pragma mark - 检查相机权限
- (BOOL)canUseCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        [NAT showAlertWithMessage:SALocalizedString(@"camera_use_auth_tip", @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机")
                      buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                          [alertView dismiss];

                          !self.choosedImageBlock ?: self.choosedImageBlock(nil, [NSError errorWithDomain:@"user reject" code:-1 userInfo:nil]);
                          [self cancel];
                      }];
        return NO;
    } else {
        return YES;
    }
    return YES;
}

#pragma mark - override system methods
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // You could make a call to update constraints based on the
        // new orientation here.
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [CATransaction commit];
    }];
}

#pragma mark - lazy load
- (HDTakingPhotoView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[HDTakingPhotoView alloc] init];
        _cameraView.config = self.config;
    }
    return _cameraView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.hidden = true;
    }
    return _imageView;
}
@end

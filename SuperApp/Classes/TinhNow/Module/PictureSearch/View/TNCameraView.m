//
//  TNCameraView.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCameraView.h"
#import <AVFoundation/AVFoundation.h>


@interface TNCameraView () <AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/// 输入输出设备管理
@property (atomic, strong) AVCaptureSession *session;
/// 设备硬件
@property (atomic, strong) AVCaptureDevice *device;
/// 输入设备
@property (strong, nonatomic) AVCaptureDeviceInput *input;
///
@property (strong, nonatomic) AVCapturePhotoOutput *outPut;
/// 实时预览视图
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
/// 底部视图
@property (strong, nonatomic) UIView *bottomView;
/// 相机按钮
@property (strong, nonatomic) HDUIButton *cameraBtn;
/// 相册按钮
@property (strong, nonatomic) HDUIButton *photosBtn;
/// 提示文本
@property (strong, nonatomic) HDLabel *tipsLabel;
@property (nonatomic) dispatch_queue_t sessionQueue;
@end


@implementation TNCameraView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:_device];
    _session = nil;
    _device = nil;
    _input = nil;
    _outPut = nil;
}
- (void)hd_setupViews {
    self.backgroundColor = [UIColor blackColor];
    [self checkCameraPermission];

    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.cameraBtn];
    [self.bottomView addSubview:self.photosBtn];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    [self.cameraBtn sizeToFit];
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.top.equalTo(self.bottomView.mas_top).offset(kRealWidth(18));
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-kRealWidth(18) - kiPhoneXSeriesSafeBottomHeight);
    }];

    [self.photosBtn sizeToFit];
    [self.photosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cameraBtn.mas_centerY);
        make.right.equalTo(self.bottomView.mas_right).offset(-kRealWidth(50));
    }];
}

- (void)startRunning {
    dispatch_async(self.sessionQueue, ^{
        if (!self.session.isRunning) {
            [self.session startRunning];
        }
    });
}

- (void)stopRunning {
    dispatch_async(self.sessionQueue, ^{
        if (self.session.isRunning) {
            [self.session stopRunning];
        }
    });
}
#pragma mark -初始化相机
- (void)initCamera {
    self.session = [[AVCaptureSession alloc] init];
    //开始配置
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;

    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];

    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    self.outPut = [[AVCapturePhotoOutput alloc] init];
    if ([self.session canAddOutput:self.outPut]) {
        [self.session addOutput:self.outPut];
    }

    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.layer insertSublayer:self.previewLayer atIndex:0];

    //监听相机自动对焦
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];

    [self showTipsLabel];

    [self startRunning];
}

#pragma mark -拍照代理
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *data = [photo fileDataRepresentation];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (self.takePhotoCallBack) {
            self.takePhotoCallBack(image);
        }
    }
}
///重新对焦通知
- (void)subjectAreaDidChange:(NSNotification *)notification {
    if (self.device.isFocusPointOfInterestSupported && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        if ([self.device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:self.center];
            [self.device setFocusPointOfInterest:cameraPoint];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [self.device unlockForConfiguration];
            HDLog(@"%@", @"Focus...");
        } else {
            HDLog(@"lock camera error%@", error);
        }

    } else {
        HDLog(@"%@", @"no support autoFocus!");
    }
}

#pragma mark -验证权限
- (void)checkCameraPermission {
    @HDWeakify(self);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @HDStrongify(self);
            if (granted) {
                if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
                    //模拟器
                    [NAT showAlertWithMessage:@"模拟器不支持相机" buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                        [alertView dismiss];
                        [self.viewController.navigationController popViewControllerAnimated:YES];
                    }];
                } else {
                    //真机
                    [self initCamera];
                }

            } else {
                NSString *title = TNLocalizedString(@"irAQFrqj", @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机");
                [NAT showAlertWithMessage:title confirmButtonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            [alertView dismiss];
                        }];
                    }
                    cancelButtonTitle:TNLocalizedString(@"tn_button_cancel_title", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        [self.viewController.navigationController popViewControllerAnimated:YES];
                    }];
            }
        });
    }];
}

- (void)showTipsLabel {
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-kRealWidth(20));
        make.left.equalTo(self.mas_left).offset(kRealWidth(68));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(68));
        make.height.mas_equalTo(kRealWidth(35));
    }];
    [self performSelector:@selector(removeTipsLabel) withObject:nil afterDelay:5];
}
- (void)removeTipsLabel {
    [self.tipsLabel removeFromSuperview];
}
#pragma mark -相机拍照
- (void)cameraClick {
    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
    if ([self.outPut.availablePhotoCodecTypes containsObject:AVVideoCodecTypeJPEG]) {
        NSDictionary *format = @{AVVideoCodecKey: AVVideoCodecTypeJPEG};
        photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:format];
    }
    photoSettings.autoStillImageStabilizationEnabled = YES;
    [self.outPut capturePhotoWithSettings:photoSettings delegate:self];
}
#pragma mark -相册点击
- (void)photosClick {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    if (self.takePhotoCallBack) {
        self.takePhotoCallBack(image);
    }
    [picker dismissAnimated:YES completion:nil];
}
/** @lazy bottomView */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.40];
        ;
    }
    return _bottomView;
}
/** @lazy cameraBtn */
- (HDUIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage imageNamed:@"tn_camera_getpic"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}
/** @lazy photosBtn */
- (HDUIButton *)photosBtn {
    if (!_photosBtn) {
        _photosBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_photosBtn setImage:[UIImage imageNamed:@"tn_photos"] forState:UIControlStateNormal];
        [_photosBtn addTarget:self action:@selector(photosClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photosBtn;
}

/** @lazy tipsLabel */
- (HDLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[HDLabel alloc] init];
        _tipsLabel.text = TNLocalizedString(@"P740wqf3", @"对准商品拍照哦");
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _tipsLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18];
        };
    }
    return _tipsLabel;
}
// 队列懒加载
- (dispatch_queue_t)sessionQueue {
    if (_sessionQueue == NULL) {
        _sessionQueue = dispatch_queue_create("com.picSearch.sessionQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _sessionQueue;
}
@end

//
//  SASystemSettingsViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SASystemSettingsViewController.h"
#import "SASystemSettingsItemView.h"


@interface SASystemSettingsViewController ()

/// 个性化推送
@property (nonatomic, strong) SASystemSettingsItemView *pushView;
/// 位置信息
@property (nonatomic, strong) SASystemSettingsItemView *locationView;
/// 拍照
@property (nonatomic, strong) SASystemSettingsItemView *cameraView;
/// 相册
@property (nonatomic, strong) SASystemSettingsItemView *photoView;
/// 麦克风
@property (nonatomic, strong) SASystemSettingsItemView *micView;

@end


@implementation SASystemSettingsViewController

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.pushView];
    [self.scrollViewContainer addSubview:self.locationView];
    [self.scrollViewContainer addSubview:self.cameraView];
    [self.scrollViewContainer addSubview:self.photoView];
    [self.scrollViewContainer addSubview:self.micView];


    [self updateStatus];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"login_new2_Settings", @"系统设置");
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;
    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            make.height.mas_equalTo(52);
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastView = view;
    }

    [super updateViewConstraints];
}

- (void)applicationBecomeActive {
    [self updateStatus];
}

- (void)updateStatus {
    //个性化推送
    { self.pushView.itemSwitch.on = SAGeneralUtil.isNotificationEnable; }

    //定位权限
    {
        CLAuthorizationStatus authStatus = CLLocationManager.authorizationStatus;
        self.locationView.itemSwitch.on = !(authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted || authStatus == kCLAuthorizationStatusNotDetermined);
    }

    //拍照权限
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        self.cameraView.itemSwitch.on = !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined);
    }

    //相册权限
    {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        self.photoView.itemSwitch.on = !(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusNotDetermined);
    }

    //麦克风权限
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        self.micView.itemSwitch.on = !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined);
    }
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)openPush:(UISwitch *)sw {
    //非初次去系统
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

- (void)openLocation:(UISwitch *)sw {
    //    if(sw.on) {
    //        CLAuthorizationStatus authStatus = CLLocationManager.authorizationStatus;
    //        //初次
    //        if(authStatus == kCLAuthorizationStatusNotDetermined){
    //            if ([CLLocationManager locationServicesEnabled] &&
    //                (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
    //                 authStatus == kCLAuthorizationStatusAuthorizedAlways)) {
    //                sw.on = YES;
    //            }
    //        }
    //    }
    //非初次去系统
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

- (void)openCamera:(UISwitch *)sw {
    if (sw.on) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        //初次
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sw.on = granted;
                });
            }];
            return;
        }
    }
    //非初次去系统
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

- (void)openPhoto:(UISwitch *)sw {
    if (sw.on) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        //初次
        if (authStatus == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (@available(iOS 14, *)) {
                    if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            sw.on = YES;
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            sw.on = NO;
                        });
                    }
                } else {
                    if (status == PHAuthorizationStatusAuthorized) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            sw.on = YES;
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            sw.on = NO;
                        });
                    }
                }
            }];
            return;
        }
    }
    //非初次去系统
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

- (void)openMic:(UISwitch *)sw {
    if (sw.on) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        //初次
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sw.on = granted;
                });
            }];
            return;
        }
    }
    //非初次去系统
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

/// 是否隐藏导航栏底部线条
- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return false;
}

#pragma mark - lazy load
- (SASystemSettingsItemView *)pushView {
    if (!_pushView) {
        SASystemSettingsItemView *view = SASystemSettingsItemView.new;
        view.textLabel.text = SALocalizedString(@"login_new2_Allow personalized push", @"允许个性化推送");
        [view.itemSwitch addTarget:self action:@selector(openPush:) forControlEvents:UIControlEventValueChanged];
        _pushView = view;
    }
    return _pushView;
}

- (SASystemSettingsItemView *)locationView {
    if (!_locationView) {
        SASystemSettingsItemView *view = SASystemSettingsItemView.new;
        view.textLabel.text = SALocalizedString(@"login_new2_Allow Location information to access", @"允许访问位置信息");
        [view.itemSwitch addTarget:self action:@selector(openLocation:) forControlEvents:UIControlEventValueChanged];
        _locationView = view;
    }
    return _locationView;
}

- (SASystemSettingsItemView *)cameraView {
    if (!_cameraView) {
        SASystemSettingsItemView *view = SASystemSettingsItemView.new;
        view.textLabel.text = SALocalizedString(@"login_new2_Allow camera to access", @"允许访问相机");
        [view.itemSwitch addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventValueChanged];
        _cameraView = view;
    }
    return _cameraView;
}

- (SASystemSettingsItemView *)photoView {
    if (!_photoView) {
        SASystemSettingsItemView *view = SASystemSettingsItemView.new;
        view.textLabel.text = SALocalizedString(@"login_new2_Allow photos to access", @"允许访问照片");
        [view.itemSwitch addTarget:self action:@selector(openPhoto:) forControlEvents:UIControlEventValueChanged];
        _photoView = view;
    }
    return _photoView;
}

- (SASystemSettingsItemView *)micView {
    if (!_micView) {
        SASystemSettingsItemView *view = SASystemSettingsItemView.new;
        view.textLabel.text = SALocalizedString(@"login_new2_Allow microphone to access", @"允许访问麦克风");
        [view.itemSwitch addTarget:self action:@selector(openMic:) forControlEvents:UIControlEventValueChanged];
        _micView = view;
    }
    return _micView;
}


@end

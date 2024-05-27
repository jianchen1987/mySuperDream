//
//  SAScanViewController.m
//  SuperApp
//
//  Created by Tia on 2023/4/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAScanViewController.h"
#import "SAScanManager.h"
#import "SAScanView.h"
#import "NSBundle+HDScanCode.h"
#import <HDKitCore/HDLog.h>
#import "SAScanResultViewController.h"

#define kPapersAspectRatio (19.0 / 30.0)

#define kPastpostAspectRatio (88.0 / 125.0)


@interface SAScanViewController () <SAScanResultControllerDelegate>
@property (nonatomic, strong) SAScanManager *scanTool;
@property (nonatomic, strong) SAScanView *scanView;

@property (nonatomic, assign) CGRect scanRetangleRect;

/// 扫描类型，1为身份证，2为护照
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) void (^callback)(NSDictionary *dic);

@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end


@implementation SAScanViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.cancelBlock = [parameters objectForKey:@"cancelCallback"];
    self.callback = [parameters objectForKey:@"callback"];
    self.type = [[parameters objectForKey:@"type"] integerValue];

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    self.hd_interactivePopDisabled = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopSession];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    //    return HDViewControllerNavigationBarStyleTransparent;
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)setup {
    self.hd_navigationItem.title = SALocalizedString(@"ocr_Document_scanning", @"证件扫描");

    CGFloat x = 25;
    CGFloat y = kNavigationBarH + 120;
    CGFloat w = self.view.bounds.size.width - 2 * x;
    CGFloat h = w * kPapersAspectRatio;
    if (self.type == 2) {
        h = kPastpostAspectRatio * w;
    }

    self.scanRetangleRect = CGRectMake(x, y, w, h);

    // 输出流视图
    UIView *preview = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:preview];

    @HDWeakify(self);
    // 构建扫描样式视图
    self.scanView = [[SAScanView alloc] initWithFrame:self.view.bounds];
    _scanView.type = self.type;
    _scanView.colorAngle = [UIColor redColor];
    _scanView.photoframeLineW = 3;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonAreaColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.clickedFlashLightBlock = ^(BOOL open) {
        @HDStrongify(self);
        [self.scanTool openFlashSwitch:open];
    };

    _scanView.scanRetangleRect = self.scanRetangleRect;

    _scanView.photoClickBlock = ^{
        HDLog(@"点击拍照");
        @HDStrongify(self);
        @HDWeakify(self);
        [self.scanTool takePhotoWithCompletionHandler:^(UIImage *_Nonnull image) {
            @HDStrongify(self);
            [self stopSession];
            if (image) {
                //裁剪图片
                UIImage *im = [self clipImage:image];
                if (im) {
                    SAScanResultViewController *vc = SAScanResultViewController.new;
                    vc.type = self.type;
                    vc.delegate = self;
                    vc.scanRetangleRect = self.scanRetangleRect;
                    [vc setImage:im];
                    [self.navigationController pushViewController:vc animated:NO];
                }
            }
        }];
    };

    [self.view addSubview:_scanView];

    // 初始化扫描工具
    self.scanTool = [[SAScanManager alloc] initWithPreview:preview andScanFrame:_scanView.scanRetangleRect];

    _scanTool.ambientLightChangedBlock = ^(float brightness) {
        @HDStrongify(self);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [self.scanView showFlashSwitch:YES];
        } else if (brightness > 0) {
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if (!self.scanTool.flashOpen) {
                [self.scanView showFlashSwitch:NO];
            }
        }
    };

    [_scanTool sessionStartRunning];
}

#pragma mark - SAScanResultControllerDelegate
/// 重拍
- (void)SAScanResultControllerClickRemake {
    HDLog(@"重拍");
    [self.navigationController popViewControllerAnimated:NO];
}
/// 完成
- (void)SAScanResultControllerClickDetermineWithDic:(NSDictionary *)dic {
    HDLog(@"完成");
    if (self.callback)
        self.callback(dic);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter
- (void)setCustomerTitle:(NSString *)customerTitle {
    _customerTitle = customerTitle;
    self.hd_navigationItem.title = customerTitle;
}

#pragma mark - private methods

- (UIImage *)clipImage:(UIImage *)image {
    CGSize sz = [image size];
    CGSize size = self.view.bounds.size;

    double camearRatio = 9 / 16.f; // 相机画面宽高比
    double widthRatio = 0;
    double heightRatio = 0;
    CGFloat topPadding = 0.f;                    // 相机画面填充后，超出屏幕上方的距离
    CGFloat leftPadding = 0.f;                   // 相机画面填充后，超出屏幕左侧的距离
    CGFloat cameraW = size.height * camearRatio; // 相机应该有的宽度
    CGFloat cameraH = size.width / camearRatio;  // 相机应该有的高度
    if (cameraW > size.width) {
        leftPadding = (cameraW - size.width) / 2.f;
        widthRatio = sz.width / cameraW;
    } else {
        widthRatio = sz.width / size.width;
    }
    if (cameraH > size.height) {
        topPadding = (cameraH - size.height) / 2.f;
        heightRatio = sz.height / cameraH;
    } else {
        heightRatio = sz.height / size.height;
    }

    CGFloat x = widthRatio * (self.scanRetangleRect.origin.x + leftPadding);
    CGFloat y = heightRatio * (self.scanRetangleRect.origin.y + topPadding);
    CGFloat w = widthRatio * (self.scanRetangleRect.size.width);
    CGFloat h = w * self.scanRetangleRect.size.height / self.scanRetangleRect.size.width;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0);
    [image drawAtPoint:CGPointMake(-x, -y)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}

- (void)startSession {
    [_scanTool sessionStartRunning];
}

- (void)stopSession {
    [_scanView finishedHandle];
    [_scanView showFlashSwitch:NO];
    [_scanTool sessionStopRunning];
}

#pragma mark - event response
- (void)hd_backItemClick:(id)sender {
    !self.cancelBlock ?: self.cancelBlock();
    [super hd_backItemClick:sender];
}

@end

//
//  SAScanView.m
//  SuperApp
//
//  Created by Tia on 2023/4/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAScanView.h"
#import "NSBundle+HDScanCode.h"
#import "HDLog.h"
#import "SAOperationButton.h"
#import "SAAppTheme.h"
#import "SAMultiLanguageManager.h"


@interface SAScanView ()
/// 网络状态提示语
@property (nonatomic, strong) UILabel *netLabel;
/**
 菊花等待
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
/**
 扫描结果处理中
 */
@property (nonatomic, strong) UIView *handlingView;
/// 手电筒开关
@property (nonatomic, strong) UIButton *flashBtn;
/**
 闪光灯开关的状态
 */
@property (nonatomic, assign) BOOL flashOpen;

@end


@implementation SAScanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _isNeedShowRetangle = YES;
        _photoframeLineW = 6;
        _notRecoginitonAreaColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        // 默认居中
        const CGFloat scanAreaWidth2ScreenWidth = 0.7;
        const CGFloat screenWidth = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
        const CGFloat scanAreaWidth = scanAreaWidth2ScreenWidth * screenWidth;

        _scanRetangleRect = CGRectMake((screenWidth - scanAreaWidth) * 0.5, (CGRectGetHeight(frame) - scanAreaWidth) * 0.5, scanAreaWidth, scanAreaWidth);

        _photoframeAngleW = 20;
        _photoframeAngleH = 20;
        _colorAngle = [UIColor greenColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    [self drawScanRect];


    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.scanRetangleRect.origin.y + self.scanRetangleRect.size.height + 100, rect.size.width, 20)];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.0];
    descLabel.text = SALocalizedString(@"ocr_tip", @"请将证件机读码对准红色线框内");
    [self addSubview:descLabel];
    //
    SAOperationButton *photoCode = [[SAOperationButton alloc] initWithFrame:CGRectMake(self.scanRetangleRect.origin.x,
                                                                                       self.scanRetangleRect.origin.y + self.scanRetangleRect.size.height + 100 + 100,
                                                                                       rect.size.width - self.scanRetangleRect.origin.x * 2,
                                                                                       44)];
    photoCode.titleLabel.font = HDAppTheme.font.sa_standard14;
    [photoCode setTitle:SALocalizedString(@"ocr_Photograph", @"拍照") forState:UIControlStateNormal];
    [photoCode addTarget:self action:@selector(photoClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoCode];

    //    [self addSubview:self.iv];
    //    self.iv.frame = CGRectMake(50, self.scanRetangleRect.origin.y -270 , 300, 200);
}

// 绘制扫描区域
- (void)drawScanRect {
    CGSize sizeRetangle = self.scanRetangleRect.size;
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.scanRetangleRect.origin.y;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleLeft = self.scanRetangleRect.origin.x;
    CGFloat XRetangleRight = XRetangleLeft + sizeRetangle.width;


    HDLog(@"%f-%f-%f-%f", YMinRetangle, YMaxRetangle, XRetangleLeft, XRetangleRight);
    CGContextRef context = UIGraphicsGetCurrentContext();

    //非扫码区域半透明
    {
        //设置非识别区域颜色
        const CGFloat *components = CGColorGetComponents(self.notRecoginitonAreaColor.CGColor);

        CGFloat red_notRecoginitonAreaColor = components[0];
        CGFloat green_notRecoginitonAreaColor = components[1];
        CGFloat blue_notRecoginitonAreaColor = components[2];
        CGFloat alpa_notRecoginitonAreaColor = components[3];

        CGContextSetRGBFillColor(context, red_notRecoginitonAreaColor, green_notRecoginitonAreaColor, blue_notRecoginitonAreaColor, alpa_notRecoginitonAreaColor);

        // 填充矩形

        // 扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        HDLog(@"上 = %@", NSStringFromCGRect(rect));
        CGContextFillRect(context, rect);

        // 扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        HDLog(@"左 = %@", NSStringFromCGRect(rect));
        CGContextFillRect(context, rect);

        // 扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, self.frame.size.width - XRetangleRight, sizeRetangle.height);
        HDLog(@"右 = %@", NSStringFromCGRect(rect));
        CGContextFillRect(context, rect);

        // 扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width, self.frame.size.height - YMaxRetangle);
        HDLog(@"下 = %@", NSStringFromCGRect(rect));
        CGContextFillRect(context, rect);
        // 执行绘画
        CGContextStrokePath(context);
    }

    if (self.isNeedShowRetangle) {
        // 中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, self.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        CGRect r = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
        HDLog(@"%@", NSStringFromCGRect(r));
        CGContextAddRect(context, r);
        CGContextStrokePath(context);
    }

    // 画矩形框4格外围相框角

    // 相框角的宽度和高度
    int wAngle = self.photoframeAngleW;
    int hAngle = self.photoframeAngleH;
    // 4个角的 线的宽度
    CGFloat linewidthAngle = self.photoframeLineW; // 经验参数：6和4

    // 画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    diffAngle = -linewidthAngle / 3;

    CGContextSetStrokeColorWithColor(context, self.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, linewidthAngle);

    // 顶点位置
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;

    // 左上角水平线
    CGContextMoveToPoint(context, leftX - linewidthAngle / 2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    // 左上角垂直线
    CGContextMoveToPoint(context, leftX, topY - linewidthAngle / 2);
    CGContextAddLineToPoint(context, leftX, topY + hAngle);

    // 左下角水平线
    CGContextMoveToPoint(context, leftX - linewidthAngle / 2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    // 左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY + linewidthAngle / 2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);

    // 右上角水平线
    CGContextMoveToPoint(context, rightX + linewidthAngle / 2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    // 右上角垂直线
    CGContextMoveToPoint(context, rightX, topY - linewidthAngle / 2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);

    // 右下角水平线
    CGContextMoveToPoint(context, rightX + linewidthAngle / 2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    // 右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY + linewidthAngle / 2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);

    CGContextStrokePath(context);

    //中间横线
    CGContextSetStrokeColorWithColor(context, self.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 1);

    if (self.type == 2) {
        CGContextMoveToPoint(context, leftX, topY + sizeRetangle.height * 0.77);
        CGContextAddLineToPoint(context, rightX, topY + sizeRetangle.height * 0.77);
    } else {
        CGContextMoveToPoint(context, leftX, topY + sizeRetangle.height * 0.63);
        CGContextAddLineToPoint(context, rightX, topY + sizeRetangle.height * 0.63);
    }
    CGContextStrokePath(context);
}

#pragma mark-- Events Handle
- (void)photoClicked {
    !self.photoClickBlock ?: self.photoClickBlock();
}

- (void)handlingResultsOfScan {
    self.handlingView.center = CGPointMake(self.frame.size.width / 2.0, self.scanRetangleRect.origin.y + self.scanRetangleRect.size.height / 2);
    [self addSubview:self.handlingView];
    [self.activityView startAnimating];
}

- (void)finishedHandle {
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    [self.handlingView removeFromSuperview];
    self.handlingView = nil;
}

- (void)flashBtnClicked:(UIButton *)flashBtn {
    if (self.clickedFlashLightBlock != nil) {
        self.flashOpen = !self.flashOpen;
        self.clickedFlashLightBlock(self.flashOpen);
    }
}

- (void)showFlashSwitch:(BOOL)show {
    if (show == YES) {
        self.flashBtn.hidden = NO;
        [self addSubview:self.flashBtn];
    } else {
        self.flashBtn.hidden = YES;
        [self.flashBtn removeFromSuperview];
    }
}

#pragma mark-- Getter
// 加载中指示器
- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityView startAnimating];
        _activityView.frame = CGRectMake(0, 0, self.scanRetangleRect.size.width, 40);
    }
    return _activityView;
}
//正在处理视图
- (UIView *)handlingView {
    if (_handlingView == nil) {
        _handlingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scanRetangleRect.size.width, 40 + 40)];
        [_handlingView addSubview:self.activityView];

        UILabel *handleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, _handlingView.frame.size.width, 40)];
        handleLabel.font = [UIFont systemFontOfSize:12];
        handleLabel.textAlignment = NSTextAlignmentCenter;
        handleLabel.textColor = [UIColor whiteColor];
        handleLabel.text = SALocalizedString(@"ocr_processing", @"正在处理");
        [_handlingView addSubview:handleLabel];
    }
    return _handlingView;
}

- (UIButton *)flashBtn {
    if (_flashBtn == nil) {
        _flashBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_flashBtn setImage:[UIImage imageNamed:@"scanFlashlight" inBundle:[NSBundle hd_ScanCodeResources] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_flashBtn addTarget:self action:@selector(flashBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _flashBtn.center = CGPointMake(self.frame.size.width / 2.0, self.scanRetangleRect.origin.y + self.scanRetangleRect.size.height + 40);
    }
    return _flashBtn;
}

//- (UIImageView *)iv {
//    if(!_iv) {
//        _iv = UIImageView.new;
//        _iv.backgroundColor = UIColor.whiteColor;
//        _iv.contentMode = UIViewContentModeScaleAspectFit;
//    }
//    return _iv;
//}

- (void)dealloc {
    [self finishedHandle];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

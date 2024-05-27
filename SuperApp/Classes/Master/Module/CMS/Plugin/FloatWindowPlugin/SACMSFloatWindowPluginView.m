//
//  SACMSFloatWindowPluginView.m
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSFloatWindowPluginView.h"
#import "LKDataRecord.h"
#import "SACMSFloatWindowPluginViewConfig.h"

#define kCloseButtonHeight kRealWidth(20)


@interface SACMSFloatWindowPluginView ()

/// 按钮
@property (nonatomic, strong) UIImageView *floatView;
///< 关闭按钮
@property (nonatomic, strong) UIImageView *closeBtnView;
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// 是否正在展示
@property (atomic, assign) BOOL isShowing;
///< 配置
@property (nonatomic, strong) SACMSFloatWindowPluginViewConfig *floatWindowConfig;

@end


@implementation SACMSFloatWindowPluginView

- (instancetype)initWithConfig:(SACMSPluginViewConfig *)config {
    SACMSFloatWindowPluginViewConfig *floatWindowConfig = [SACMSFloatWindowPluginViewConfig yy_modelWithDictionary:[config getPluginContent]];
    CGRect frame
        = (CGRect){kScreenWidth - floatWindowConfig.width - kRealWidth(8), kScreenHeight - floatWindowConfig.height - kRealWidth(100), CGSizeMake(floatWindowConfig.width, floatWindowConfig.height)};
    self = [super initWithFrame:frame];
    if (self) {
        self.floatWindowConfig = floatWindowConfig;
        self.config = config;
    }
    return self;
}

- (void)setConfig:(SACMSPluginViewConfig *)config {
    [super setConfig:config];

    self.backgroundColor = [UIColor clearColor];
    [self hd_removeAllSubviews];

    self.floatWindowConfig = [SACMSFloatWindowPluginViewConfig yy_modelWithDictionary:[config getPluginContent]];

    self.floatView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.floatWindowConfig.width, self.floatWindowConfig.height)];
    [HDWebImageManager setImageWithURL:self.floatWindowConfig.image placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.floatWindowConfig.width, self.floatWindowConfig.height)]
                             imageView:self.floatView];
    self.floatView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnImageView:)];
    [self.floatView addGestureRecognizer:tap];

    [self addSubview:self.floatView];

    self.closeBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(self.floatWindowConfig.width - kCloseButtonHeight, 0, kCloseButtonHeight, kCloseButtonHeight)];
    self.closeBtnView.image = [UIImage imageNamed:@"yn_search_del"];
    self.closeBtnView.userInteractionEnabled = YES;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnClose:)];
    [self.closeBtnView addGestureRecognizer:closeTap];
    [self addSubview:self.closeBtnView];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer = panGestureRecognizer;
    [self addGestureRecognizer:panGestureRecognizer];

    self.isShowing = YES; //默认进来是显示的

    [self setNeedsUpdateConstraints];
}

- (void)clickedOnImageView:(UITapGestureRecognizer *)tap {
    [self expand];
    if (HDIsStringNotEmpty(self.floatWindowConfig.link)) {
        [SAWindowManager openUrl:self.floatWindowConfig.link withParameters:@{
            @"source" : [NSString stringWithFormat:@"%@.%@.image@0", self.config.pageConfig.pageName, self.config.pluginName]
        }];
    }

    [LKDataRecord.shared traceClickEvent:@"click_floatWindowPlugin" parameters:@{@"route": self.floatWindowConfig.link}
                                     SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@""]];

    !self.clickedHander ?: self.clickedHander(self.config);
}

- (void)clickedOnClose:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    [LKDataRecord.shared traceClickEvent:@"click_floatWindowPlugin_close" parameters:nil SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@""]];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    // 获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    // 清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    // 重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.center.x + offsetPoint.x;
    CGFloat newY = panView.center.y + offsetPoint.y;

    const CGFloat margin = kRealWidth(10);
    if (newX < self.floatWindowConfig.width / 2 + margin) {
        newX = self.floatWindowConfig.width / 2 + margin;
    }
    if (newX > kScreenWidth - self.floatWindowConfig.width / 2) {
        newX = kScreenWidth - self.floatWindowConfig.width / 2;
    }
    if (newY < self.floatWindowConfig.height / 2 + kStatusBarH + margin) {
        newY = self.floatWindowConfig.height / 2 + kStatusBarH + margin;
    }
    if (newY > kScreenHeight - self.floatWindowConfig.height / 2 - kTabBarH) {
        newY = kScreenHeight - self.floatWindowConfig.height / 2 - kTabBarH;
    }
    panView.center = CGPointMake(newX, newY);

    if (sender.state == UIGestureRecognizerStateEnded) {
        [self expand];
    }
}

#pragma mark - Data

#pragma mark - setter
- (void)setDisablePanGesture:(BOOL)disablePanGesture {
    _disablePanGesture = disablePanGesture;

    self.panGestureRecognizer.enabled = !disablePanGesture;
}

#pragma mark - public methods
// 显示
- (void)expand {
    if (self.isShowing) {
        return;
    }
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - self.floatWindowConfig.width - 10;
        } else {
            frame.origin.x = 10;
        }
        self.frame = frame;
        self.floatView.frame = self.bounds;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = YES;
    }];
}
// 隐藏
- (void)shrink {
    if (!self.isShowing) {
        return;
    }
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - 0.5 * self.floatWindowConfig.width;
        } else {
            frame.origin.x = -0.5 * self.floatWindowConfig.width;
        }
        self.frame = frame;
        self.floatView.frame = self.bounds;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = NO;
    }];
}

@end

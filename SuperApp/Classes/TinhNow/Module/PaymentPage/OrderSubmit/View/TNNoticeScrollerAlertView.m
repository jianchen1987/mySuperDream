//
//  TNNoticeScrollerView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNoticeScrollerAlertView.h"
#import <Masonry/Masonry.h>
#import <HDKitCore/HDKitCore.h>
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"


@interface TNNoticeScrollerAlertView ()
/// 圆角背景
@property (strong, nonatomic) UIView *contentView;

/// 滚动视图
@property (strong, nonatomic) UIScrollView *scrollView;
/// 滚动底部视图
@property (strong, nonatomic) UIView *scrollViewContainer;
/// 文本
@property (strong, nonatomic) HDLabel *contentLB;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *confirBtn;
/// 文本内容
@property (nonatomic, copy) NSString *contentText;
@end


@implementation TNNoticeScrollerAlertView
+ (instancetype)alertViewWithContentText:(NSString *)content {
    return [[TNNoticeScrollerAlertView alloc] initWithContentText:content];
}

- (instancetype)initWithContentText:(NSString *)content {
    self = [super init];
    if (self) {
        self.contentText = content;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = YES;
    }
    return self;
}
- (void)layoutContainerView {
    self.containerView.frame = [UIScreen mainScreen].bounds;
}
/// 设置containerview的属性,比如切边啥的
- (void)setupContainerViewAttributes {
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
}
/// 给containerview添加子视图
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.contentView];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.contentLB];
    [self.contentView addSubview:self.confirBtn];
    self.contentLB.text = self.contentText;
}
/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(25));
        make.right.equalTo(self.containerView.mas_left).offset(-kRealWidth(25));
    }];

    CGFloat contentHeight = [self.contentText boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(15) * 2 - kRealWidth(25 * 2), CGFLOAT_MAX) font:self.contentLB.font lineSpacing:3].height;
    contentHeight = contentHeight > kScreenHeight / 2 ? kScreenHeight / 2 : contentHeight;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(50);
        make.bottom.equalTo(self.confirBtn.mas_top).offset(-40);
        make.height.mas_equalTo(contentHeight);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollViewContainer);
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];

    [self.confirBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(55));
    }];
}

/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _contentLB.textColor = HDAppTheme.TinhNowColor.G1;
        _contentLB.textAlignment = NSTextAlignmentCenter;
        _contentLB.numberOfLines = 0;
        _contentLB.hd_lineSpace = 3;
    }
    return _contentLB;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.alwaysBounceVertical = true;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = false;
        }
    }
    return _scrollView;
}

- (UIView *)scrollViewContainer {
    if (!_scrollViewContainer) {
        _scrollViewContainer = UIView.new;
    }
    return _scrollViewContainer;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFFFFF"];
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _contentView;
}
/** @lazy confirBtn */
- (HDUIButton *)confirBtn {
    if (!_confirBtn) {
        _confirBtn = [[HDUIButton alloc] init];
        _confirBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _confirBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:17];
        [_confirBtn setTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") forState:UIControlStateNormal];
        [_confirBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_confirBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _confirBtn;
}
@end

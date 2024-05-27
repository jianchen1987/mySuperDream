//
//  TNTermsAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTermsAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNTermsAlertView ()
/// 圆角背景
@property (strong, nonatomic) UIView *contentView;
/// 上部分视图
@property (strong, nonatomic) UIView *topView;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *closeBtn;
/// 滚动视图
@property (strong, nonatomic) UIScrollView *scrollView;
/// 滚动底部视图
@property (strong, nonatomic) UIView *scrollViewContainer;
/// 文本
@property (strong, nonatomic) HDLabel *contentLB;
/// 文本内容
@property (nonatomic, copy) NSString *contentText;
@end


@implementation TNTermsAlertView
+ (instancetype)alertViewWithContentText:(NSString *)content {
    return [[TNTermsAlertView alloc] initWithContentText:content];
}

- (instancetype)initWithContentText:(NSString *)content {
    self = [super init];
    if (self) {
        self.contentText = content;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
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
    [self.contentView addSubview:self.topView];
    [self.topView addSubview:self.closeBtn];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.contentLB];
    self.contentLB.text = self.contentText;
}
/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.closeBtn sizeToFit];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.right.equalTo(self.topView.mas_right).offset(-kRealWidth(10));
    }];

    CGFloat contentHeight = [self.contentText boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(15) * 2, CGFLOAT_MAX) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:5].height + 100;
    contentHeight = contentHeight > kScreenHeight / 2 ? kScreenHeight / 2 : contentHeight;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.height.mas_equalTo(contentHeight);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(15));
    }];
}
/** @lazy topView */
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
/** @lazy closeBtn */
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"tn_alert_close_k"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _closeBtn;
}
/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = HDAppTheme.TinhNowFont.standard12;
        _contentLB.textColor = HDAppTheme.TinhNowColor.G2;
        _contentLB.numberOfLines = 0;
        _contentLB.hd_lineSpace = 5;
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
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
        };
    }
    return _contentView;
}
@end

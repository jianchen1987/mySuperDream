//
//  GNRedundAlertView.m
//  SuperApp
//
//  Created by wmz on 2023/1/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "GNRedundAlertView.h"
#import "GNMultiLanguageManager.h"
#import "GNTheme.h"
#import "Masonry.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>


@interface GNRedundAlertView ()
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// contentLB
@property (nonatomic, strong) HDLabel *contentLB;
/// confirmBTN
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// config
@property (nonatomic, strong) GNNormalAlertConfig *config;
/// cancelBTN
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// agreeBTN
@property (nonatomic, strong) HDUIButton *agreeBTN;

@end


@implementation GNRedundAlertView

- (instancetype)initWithConfig:(GNNormalAlertConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleFade;
    }
    return self;
}

- (void)setConfig:(GNNormalAlertConfig *)config {
    _config = config;
    self.titleLB.text = config.title;
    self.contentLB.text = config.content;
    [self.confirmBTN setTitle:config.confirm forState:UIControlStateNormal];
    if (!self.titleLB.isHidden) {
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.titleLB.text];
        mstr.yy_lineSpacing = kRealWidth(4);
        mstr.yy_alignment = NSTextAlignmentCenter;
        self.titleLB.attributedText = mstr;
    }
    if (!self.contentLB.isHidden) {
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.contentLB.text];
        mstr.yy_lineSpacing = kRealWidth(4);
        self.contentLB.attributedText = mstr;
    }
}

/** 布局containerview的位置,就是那个看得到的视图 */
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.centerY.mas_equalTo(0);
    }];
}

/** 设置containerview的属性,比如圆角 */
- (void)setupContainerViewAttributes {
    self.containerView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    self.containerView.layer.cornerRadius = kRealWidth(12);
}

/** 给containerview添加子视图 */
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.contentLB];
    [self.containerView addSubview:self.confirmBTN];
    [self.containerView addSubview:self.agreeBTN];
    [self.containerView addSubview:self.cancelBTN];
}

/** 设置子视图的frame */
- (void)layoutContainerViewSubViews {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        make.left.top.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.agreeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLB.mas_bottom).offset(kRealWidth(24));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_lessThanOrEqualTo(-kRealWidth(16));
        make.centerX.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeBTN.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.height.mas_equalTo(kRealWidth(48));
    }];

    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmBTN.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(20));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.width.equalTo(self.containerView);
    }];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.color.gn_333Color;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [HDAppTheme.font gn_boldForSize:16];
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)contentLB {
    if (!_contentLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.color.gn_333Color;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.font gn_ForSize:14];
        _contentLB = label;
    }
    return _contentLB;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.titleLabel.font = [HDAppTheme.font gn_boldForSize:16];
        _confirmBTN.adjustsButtonWhenHighlighted = NO;
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBTN.layer.cornerRadius = kRealWidth(12);
        _confirmBTN.enabled = NO;
        _confirmBTN.alpha = 0.3;
        _confirmBTN.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.config.confirmHandle) {
                self.config.confirmHandle(self, self.confirmBTN);
            }
            else {
                [self dismiss];
            }
        }];
    }
    return _confirmBTN;
}

- (HDUIButton *)cancelBTN {
    if (!_cancelBTN) {
        _cancelBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _cancelBTN.adjustsButtonWhenHighlighted = NO;
        [_cancelBTN setTitle:GNLocalizedString(@"gn_refund_protocol_not", @"do not buy") forState:UIControlStateNormal];
        [_cancelBTN setTitleColor:HDAppTheme.color.gn_mainColor forState:UIControlStateNormal];
        _cancelBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:14];
        @HDWeakify(self)[_cancelBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.config.cancelHandle) {
                self.config.cancelHandle(self, self.cancelBTN);
            }
            else {
                [self dismiss];
            }
        }];
    }
    return _cancelBTN;
}

- (HDUIButton *)agreeBTN {
    if (!_agreeBTN) {
        _agreeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _agreeBTN.adjustsButtonWhenHighlighted = NO;
        _agreeBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_agreeBTN setImage:[UIImage imageNamed:@"gn_order_agree_nor"] forState:UIControlStateNormal];
        [_agreeBTN setImage:[UIImage imageNamed:@"gn_order_agree_select"] forState:UIControlStateSelected];
        [_agreeBTN setTitle:GNLocalizedString(@"gn_refund_protocol_agree", @"I have read and agree to the above agreement") forState:UIControlStateNormal];
        _agreeBTN.spacingBetweenImageAndTitle = kRealWidth(2);
        [_agreeBTN setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _agreeBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:14];
        @HDWeakify(self)[_agreeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.agreeBTN.selected = !self.agreeBTN.isSelected;
            self.confirmBTN.enabled = self.agreeBTN.isSelected;
            self.confirmBTN.alpha = self.confirmBTN.isEnabled ? 1 : 0.3;
        }];
    }
    return _agreeBTN;
}

@end


@implementation GNNormalAlertConfig

@end

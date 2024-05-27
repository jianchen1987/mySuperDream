//
//  WMNormalAlertView.m
//  SuperApp
//
//  Created by wmz on 2022/10/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMNormalAlertView.h"
#import "HDAppTheme+YumNow.h"
#import "Masonry.h"
#import "WMMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>


@interface WMNormalAlertView ()
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// contentLB
@property (nonatomic, strong) HDLabel *contentLB;
/// confirmBTN
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// cancelBTN
@property (nonatomic, strong) HDUIButton *cancelBTN;
/// config
@property (nonatomic, strong) WMNormalAlertConfig *config;

@end


@implementation WMNormalAlertView

- (instancetype)initWithConfig:(WMNormalAlertConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleFade;
    }
    return self;
}

- (void)setConfig:(WMNormalAlertConfig *)config {
    _config = config;
    self.titleLB.text = config.title;
    self.contentLB.text = config.content;
    [self.confirmBTN setTitle:config.confirm forState:UIControlStateNormal];
    [self.cancelBTN setTitle:config.cancel forState:UIControlStateNormal];
    self.titleLB.hidden = HDIsStringEmpty(config.title);
    self.contentLB.hidden = HDIsStringEmpty(config.content);
    self.confirmBTN.hidden = HDIsStringEmpty(config.confirm);
    self.cancelBTN.hidden = HDIsStringEmpty(config.cancel);
    if (!self.titleLB.isHidden) {
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.titleLB.text];
        mstr.yy_lineSpacing = kRealWidth(4);
        mstr.yy_alignment = NSTextAlignmentCenter;
        self.titleLB.attributedText = mstr;
    }
    if (!self.contentLB.isHidden) {
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.contentLB.text];
        mstr.yy_lineSpacing = kRealWidth(4);
        mstr.yy_alignment = self.config.contentAligment;
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
    [self.containerView addSubview:self.cancelBTN];
}

/** 设置子视图的frame */
- (void)layoutContainerViewSubViews {
    __block UIView *view = nil;
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLB.isHidden) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
            make.left.top.mas_equalTo(kRealWidth(16));
            make.right.mas_equalTo(-kRealWidth(16));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            view = self.titleLB;
        }
    }];

    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.contentLB.isHidden) {
            if (!view) {
                make.top.mas_equalTo(kRealWidth(16));
            } else {
                make.top.equalTo(view.mas_bottom).offset(kRealWidth(16));
            }
            make.left.mas_equalTo(kRealWidth(16));
            make.right.mas_equalTo(-kRealWidth(16));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            view = self.contentLB;
        }
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.confirmBTN.isHidden) {
            if (!view) {
                make.top.mas_equalTo(kRealWidth(16));
            } else {
                make.top.equalTo(view.mas_bottom).offset(kRealWidth(20));
            }
            if (self.cancelBTN.isHidden) {
                make.left.mas_equalTo(kRealWidth(16));
            } else {
                make.left.equalTo(self.cancelBTN.mas_right).offset(kRealWidth(9));
            }
            make.right.mas_equalTo(-kRealWidth(16));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            make.height.mas_equalTo(kRealWidth(48));
        }
    }];

    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.cancelBTN.isHidden) {
            make.top.height.width.equalTo(self.confirmBTN);
            make.left.mas_equalTo(kRealWidth(16));
        }
    }];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)contentLB {
    if (!_contentLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        _contentLB = label;
    }
    return _contentLB;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _confirmBTN.adjustsButtonWhenHighlighted = NO;
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBTN.layer.cornerRadius = kRealWidth(12);
        _confirmBTN.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
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
        _cancelBTN.hidden = YES;
        _cancelBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _cancelBTN.adjustsButtonWhenHighlighted = NO;
        [_cancelBTN setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        _cancelBTN.layer.cornerRadius = kRealWidth(12);
        _cancelBTN.layer.backgroundColor = [UIColor hd_colorWithHexString:@"#FEF0F2"].CGColor;
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

@end


@implementation WMNormalAlertConfig
- (instancetype)init {
    if (self = [super init]) {
        self.contentAligment = NSTextAlignmentLeft;
        self.title = WMLocalizedString(@"notice", @"提示");
        self.confirm = WMLocalizedString(@"wm_button_confirm", @"确认");
    }
    return self;
}
@end

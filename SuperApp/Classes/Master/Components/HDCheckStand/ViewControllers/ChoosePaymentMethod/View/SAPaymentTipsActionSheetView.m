//
//  SAPaymentTipsActionSheetView.m
//  SuperApp
//
//  Created by Tia on 2023/4/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAPaymentTipsActionSheetView.h"
#import "SAOperationButton.h"
#import <Masonry/Masonry.h>
#import "SAAppTheme.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>


@interface SAPaymentTipsActionSheetView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 详情
@property (nonatomic, strong) UILabel *detailLabel;
/// 取消按钮
@property (nonatomic, strong) SAOperationButton *cancelBTN;
/// 取消按钮
@property (nonatomic, strong) SAOperationButton *submitBTN;

@end


@implementation SAPaymentTipsActionSheetView

- (instancetype)init {
    if (self = [super init]) {
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.detailLabel];
    [self.containerView addSubview:self.cancelBTN];
    [self.containerView addSubview:self.submitBTN];
}

- (void)layoutContainerViewSubViews {
    CGFloat margin = 12;

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(16);
    }];

    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.containerView).offset(-margin);
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(16);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.containerView).offset(-margin);
        make.height.mas_equalTo(44);
    }];

    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitBTN.mas_bottom).offset(margin);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.containerView).offset(-margin);
        make.height.equalTo(self.submitBTN);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + margin));
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self needsUpdateConstraints];
}

- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    self.detailLabel.text = detailText;
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        //        label.text = SALocalizedString(@"", @"Credit/Debit Card");
        label.textColor = HDAppTheme.color.sa_C333;
        label.font = HDAppTheme.font.sa_standard16H;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HDAppTheme.color.sa_C666;
        label.font = HDAppTheme.font.sa_standard12;
        label.numberOfLines = 0;
        label.hd_lineSpace = 5;
        label.text = SALocalizedString(@"pay_card_tip", @"1. 仅支持在柬埔寨开通的“VISA、MasterCard、UnionPay、JCB”信用卡，不支持国际信用卡\n2. 信用卡退款3-7天到账，具体到账时间以银行为准");
        _detailLabel = label;
    }
    return _detailLabel;
}

- (SAOperationButton *)cancelBTN {
    if (!_cancelBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];

        [button setTitle:SALocalizedStringFromTable(@"pay_btn_title2", @"选择其他付款方式", @"Buttons") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16B;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _cancelBTN = button;
    }
    return _cancelBTN;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:SALocalizedStringFromTable(@"pay_btn_title1", @"继续付款", @"Buttons") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16B;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.submitBlock ?: self.submitBlock();
        }];
        _submitBTN = button;
    }
    return _submitBTN;
}

@end

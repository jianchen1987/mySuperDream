//
//  TNCutomerServicePopCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCutomerServicePopCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNCutomerServicePopCell ()
/// 客服
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
/// 电话
@property (nonatomic, strong) HDUIButton *phoneBtn;
/// SMS
@property (nonatomic, strong) HDUIButton *smsBtn;
@end


@implementation TNCutomerServicePopCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.customerServiceBtn];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.smsBtn];
}
- (void)updateConstraints {
    [self.customerServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kRealWidth(80));
    }];
    [self.phoneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.customerServiceBtn.mas_right);
        make.width.mas_equalTo(kRealWidth(80));
    }];
    [self.smsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.phoneBtn.mas_right);
        make.width.mas_equalTo(kRealWidth(80));
    }];
    [super updateConstraints];
}
/** @lazy customerServiceBtn */
- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setImagePosition:HDUIButtonImagePositionTop];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tn_pop_chat"] forState:UIControlStateNormal];
        [_customerServiceBtn setTitle:TNLocalizedString(@"NCLB5d4E", @"在线沟通") forState:UIControlStateNormal];
        _customerServiceBtn.titleLabel.numberOfLines = 2;
        _customerServiceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _customerServiceBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_customerServiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_customerServiceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.chatClickCallBack ?: self.chatClickCallBack();
        }];
    }
    return _customerServiceBtn;
}

/** @lazy phoneBtn */
- (HDUIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setImagePosition:HDUIButtonImagePositionTop];
        [_phoneBtn setImage:[UIImage imageNamed:@"tn_pop_call"] forState:UIControlStateNormal];
        [_phoneBtn setTitle:TNLocalizedString(@"tn_product_phone", @"电话") forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_phoneBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.phoneClickCallBack ?: self.phoneClickCallBack();
        }];
    }
    return _phoneBtn;
}

/** @lazy smsBtn */
- (HDUIButton *)smsBtn {
    if (!_smsBtn) {
        _smsBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_smsBtn setImagePosition:HDUIButtonImagePositionTop];
        [_smsBtn setImage:[UIImage imageNamed:@"tn_pop_sms"] forState:UIControlStateNormal];
        [_smsBtn setTitle:TNLocalizedString(@"tn_product_sms", @"SMS") forState:UIControlStateNormal];
        _smsBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:11.f];
        [_smsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_smsBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.smsClickCallBack ?: self.smsClickCallBack();
        }];
    }
    return _smsBtn;
}
@end

//
//  TNRefundCustomerServerCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundCustomerServerCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNRefundCustomerServerCell ()
/// 申请退款前请先与商家协商：
@property (nonatomic, strong) UILabel *preTitleLabel;
///  商家电话
@property (nonatomic, strong) UILabel *customerPhoneLabel;
/// 商家客服
//@property (nonatomic, strong) UILabel *customerTitleLabel;
/// 商家客服IM 按钮
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
///
//@property (nonatomic, strong) UIView *bottomBgView;
/// 如需平台介入, 请联系
@property (nonatomic, strong) UILabel *platformLabel;
/// 平台客服 按钮
@property (nonatomic, strong) HDUIButton *platformBtn;
@end


@implementation TNRefundCustomerServerCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.preTitleLabel];
    [self.contentView addSubview:self.customerPhoneLabel];
    //    [self.contentView addSubview:self.customerTitleLabel];
    [self.contentView addSubview:self.customerServiceBtn];
    //    [self.contentView addSubview:self.bottomBgView];
    [self.contentView addSubview:self.platformLabel];
    [self.contentView addSubview:self.platformBtn];
}

- (void)updateConstraints {
    [self.preTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];

    [self.customerPhoneLabel sizeToFit];
    [self.customerPhoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.preTitleLabel.mas_bottom).offset(10.f);
    }];

    //    [self.customerTitleLabel sizeToFit];
    //    [self.customerTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
    //        make.top.mas_equalTo(self.customerPhoneLabel.mas_bottom).offset(16.f);
    //    }];

    [self.customerServiceBtn sizeToFit];
    [self.customerServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.customerPhoneLabel.mas_bottom).offset(16.f);
        make.size.mas_equalTo(self.customerServiceBtn.bounds.size);
    }];


    //    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self.customerServiceBtn.mas_bottom).offset(30.f);
    //        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15.f);
    //        make.height.equalTo(@(22.f));
    //        make.centerX.equalTo(self.contentView.mas_centerX);
    //    }];

    //    [self.platformLabel sizeToFit];
    [self.platformLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.customerServiceBtn.mas_bottom).offset(30.f);
    }];

    [self.platformBtn sizeToFit];
    [self.platformBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.platformLabel.mas_bottom).offset(5.f);
        make.size.mas_equalTo(self.platformBtn.bounds.size);
        make.centerX.mas_equalTo(self.platformLabel.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20.f);
    }];

    [super updateConstraints];
}

- (void)setCustomerPhone:(NSString *)customerPhone {
    _customerPhone = customerPhone;
    if (HDIsStringNotEmpty(_customerPhone)) {
        self.customerPhoneLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_service_phone", @"商家电话"), self.customerPhone];
        self.customerPhoneLabel.hidden = NO;
    } else {
        self.customerPhoneLabel.text = @"";
        self.customerPhoneLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UILabel *)preTitleLabel {
    if (!_preTitleLabel) {
        _preTitleLabel = [[UILabel alloc] init];
        _preTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _preTitleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _preTitleLabel.text = TNLocalizedString(@"tn_refund_pre_talk", @"申请退款前请先与商家协商：");
        _preTitleLabel.numberOfLines = 0;
    }
    return _preTitleLabel;
}

- (UILabel *)customerPhoneLabel {
    if (!_customerPhoneLabel) {
        _customerPhoneLabel = [[UILabel alloc] init];
        _customerPhoneLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _customerPhoneLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _customerPhoneLabel.text = TNLocalizedString(@"tn_service_phone", @"商家电话");
    }
    return _customerPhoneLabel;
}

/*
- (UILabel *)customerTitleLabel {
    if (!_customerTitleLabel) {
        _customerTitleLabel = [[UILabel alloc] init];
        _customerTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _customerTitleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _customerTitleLabel.text = TNLocalizedString(@"tn_refund_customer", @"商家客服");

    }
    return _customerTitleLabel;
}
*/

- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setTitleColor:HDAppTheme.TinhNowColor.cFF8824 forState:UIControlStateNormal];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tn_orderdetail_customer"] forState:0];
        _customerServiceBtn.adjustsButtonWhenHighlighted = false;
        _customerServiceBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12M;
        [_customerServiceBtn setTitle:TNLocalizedString(@"tn_customer", @"联系商家") forState:0];
        [_customerServiceBtn setImagePosition:HDUIButtonImagePositionLeft];
        _customerServiceBtn.spacingBetweenImageAndTitle = 5;
        _customerServiceBtn.layer.borderWidth = PixelOne;
        _customerServiceBtn.layer.borderColor = HDAppTheme.TinhNowColor.cFF8824.CGColor;
        _customerServiceBtn.layer.cornerRadius = 15.f;
        _customerServiceBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 0);
        _customerServiceBtn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 12);
        @HDWeakify(self);
        [_customerServiceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.customerServiceButtonClickedHander) {
                self.customerServiceButtonClickedHander();
            }
        }];
    }
    return _customerServiceBtn;
}

//- (UIView *)bottomBgView {
//    if (!_bottomBgView) {
//        _bottomBgView = [[UIView alloc] init];
//    }
//    return _bottomBgView;
//}

- (UILabel *)platformLabel {
    if (!_platformLabel) {
        _platformLabel = [[UILabel alloc] init];
        _platformLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _platformLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _platformLabel.text = TNLocalizedString(@"tn_refund_platform_contact", @"如需平台介入, 请联系");
        _platformLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _platformLabel;
}

- (HDUIButton *)platformBtn {
    if (!_platformBtn) {
        _platformBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_platformBtn setTitleColor:HDAppTheme.TinhNowColor.cFF8824 forState:UIControlStateNormal];
        [_platformBtn setImage:[UIImage imageNamed:@"tn_small_phone"] forState:0];
        _platformBtn.adjustsButtonWhenHighlighted = false;
        [_platformBtn setTitle:TNLocalizedString(@"tn_platform_phone", @"平台客服") forState:0];
        _platformBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:10.f];
        [_platformBtn setImagePosition:HDUIButtonImagePositionLeft];
        _platformBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 0);
        _platformBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        _platformBtn.spacingBetweenImageAndTitle = 2;
        _platformBtn.layer.borderWidth = PixelOne;
        _platformBtn.layer.borderColor = HDAppTheme.TinhNowColor.cFF8824.CGColor;
        _platformBtn.layer.cornerRadius = 4.f;
        @HDWeakify(self);
        [_platformBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.platformButtonClickedHander) {
                self.platformButtonClickedHander();
            }
        }];
    }
    return _platformBtn;
}


@end


@implementation TNRefundCustomerServerCellModel

@end

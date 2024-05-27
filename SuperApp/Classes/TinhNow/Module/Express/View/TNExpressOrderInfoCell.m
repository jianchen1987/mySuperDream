//
//  TNExpressInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  运单信息

#import "TNExpressOrderInfoCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNExpressDetailsModel.h"
#import "SAGeneralUtil.h"


@interface TNExpressOrderInfoCell ()
/// 小卡车icon
@property (nonatomic, strong) UIImageView *iconImgView;
/// 物流公司名称
@property (nonatomic, strong) UILabel *expressName;
/// 物流单号
@property (nonatomic, strong) UILabel *expressNo;
/// 物流时间
@property (nonatomic, strong) UILabel *createTimeLabel;

/// 拷贝按钮
@property (strong, nonatomic) HDUIButton *expressNoCopyButton;

@end


@implementation TNExpressOrderInfoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.expressName];
    [self.contentView addSubview:self.expressNo];
    [self.contentView addSubview:self.createTimeLabel];
    [self.contentView addSubview:self.expressNoCopyButton];

    self.contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setGradualChangingColorFromColor:HDAppTheme.TinhNowColor.C1 toColor:HDAppTheme.TinhNowColor.C2];
    };
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20.f);
        make.size.mas_equalTo(self.iconImgView.image.size);
    }];

    [self.expressName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(22.f);
    }];

    [self.expressNo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.top.mas_equalTo(self.expressName.mas_bottom).offset(5.f);
        make.right.greaterThanOrEqualTo(self.expressNoCopyButton.mas_left).offset(-5.f);
    }];
    [self.expressNoCopyButton sizeToFit];
    [self.expressNoCopyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressNo);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];

    [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.expressNo.mas_bottom).offset(5.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20.f);
    }];

    [super updateConstraints];
}

- (void)setModel:(TNExpressDetailsModel *)model {
    _model = model;
    self.expressName.text = model.deliveryCorp;
    self.expressNo.text = [TNLocalizedString(@"dK5ckXzw", @"运单号：") stringByAppendingString:HDIsStringNotEmpty(model.trackingNo) ? model.trackingNo : @""];

    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:[model.createdDate doubleValue] / 1000.0];
    self.createTimeLabel.text = [SAGeneralUtil getDateStrWithDate:createdDate format:@"dd/MM/yyyy HH:mm:ss"];

    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"tn_order_detail_express_car"];
    }
    return _iconImgView;
}

- (UILabel *)expressName {
    if (!_expressName) {
        _expressName = [[UILabel alloc] init];
        _expressName.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
        _expressName.textColor = [UIColor whiteColor];
    }
    return _expressName;
}

- (UILabel *)expressNo {
    if (!_expressNo) {
        _expressNo = [[UILabel alloc] init];
        _expressNo.font = [HDAppTheme.TinhNowFont fontRegular:14.f];
        _expressNo.textColor = [UIColor whiteColor];
    }
    return _expressNo;
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
        _createTimeLabel.textColor = [UIColor whiteColor];
    }
    return _createTimeLabel;
}
/** @lazy expressNoCopyButton */
- (HDUIButton *)expressNoCopyButton {
    if (!_expressNoCopyButton) {
        _expressNoCopyButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_expressNoCopyButton setImage:[UIImage imageNamed:@"tn_copy_white"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_expressNoCopyButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (HDIsStringNotEmpty(self.model.trackingNo)) {
                [UIPasteboard generalPasteboard].string = self.model.trackingNo;
                [HDTips showWithText:TNLocalizedString(@"tn_copy_success", @"复制成功")];
            }
        }];
    }
    return _expressNoCopyButton;
}
@end

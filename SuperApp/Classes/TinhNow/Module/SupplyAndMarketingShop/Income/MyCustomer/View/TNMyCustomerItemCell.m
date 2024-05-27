//
//  TNMyCustomerItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyCustomerItemCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNMyCustomerItemCell ()

@property (nonatomic, strong) UIView *bView;
/// 用户头像
@property (nonatomic, strong) UIImageView *iconImgView;
/// 昵称
@property (nonatomic, strong) HDLabel *nickNameLabel;
/// 手机号
@property (nonatomic, strong) HDLabel *phoneLabel;
/// 下单时间
@property (nonatomic, strong) HDLabel *orderTimeLabel;
@end


@implementation TNMyCustomerItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bView];
    [self.bView addSubview:self.iconImgView];
    [self.bView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.orderTimeLabel];
}

- (void)updateConstraints {
    [self.bView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(kRealWidth(60)));
        make.width.equalTo(@(kScreenWidth / 3));
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
        make.centerY.equalTo(self.bView.mas_centerY);
    }];

    [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bView.mas_right).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.bView.mas_top);
        make.bottom.mas_equalTo(self.bView.mas_bottom);
    }];

    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_right).offset(kRealWidth(5));
        make.width.equalTo(@(kScreenWidth / 3));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.orderTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLabel.mas_right).offset(kRealWidth(5));
        make.width.equalTo(@(kScreenWidth / 3));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(TNMyCustomerModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.imgUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(20), kRealWidth(20))] imageView:self.iconImgView];
    self.nickNameLabel.text = model.nickname;
    if (HDIsStringNotEmpty(model.mobile)) {
        NSString *mobile;
        if (model.mobile.length == 1) {
            mobile = @"***";
        } else if (model.mobile.length <= 4) {
            mobile = [NSString stringWithFormat:@"%@***", [model.mobile substringToIndex:1]];
        } else {
            mobile = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(0, model.mobile.length - 4) withString:@"***"];
        }
        self.phoneLabel.text = mobile;
    } else {
        self.phoneLabel.text = @"***";
    }
    self.orderTimeLabel.text = model.bindTime;
}

#pragma mark
- (UIView *)bView {
    if (!_bView) {
        _bView = [[UIView alloc] init];
    }
    return _bView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _iconImgView;
}

- (HDLabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[HDLabel alloc] init];
        _nickNameLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _nickNameLabel.numberOfLines = 1;
        _nickNameLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _nickNameLabel;
}

- (HDLabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[HDLabel alloc] init];
        _phoneLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _phoneLabel.numberOfLines = 1;
        _phoneLabel.font = HDAppTheme.TinhNowFont.standard12;
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}

- (HDLabel *)orderTimeLabel {
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[HDLabel alloc] init];
        _orderTimeLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _orderTimeLabel.numberOfLines = 1;
        _orderTimeLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _orderTimeLabel;
}

@end

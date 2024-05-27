//
//  PNInterTransferStatusCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferStatusCell.h"
#import "PNCommonUtils.h"


@interface PNInterTransferStatusCell ()
///
@property (strong, nonatomic) UIImageView *statusImageView;
///
@property (strong, nonatomic) UILabel *statusLabel;
///
@property (strong, nonatomic) UILabel *desLabel;
@end


@implementation PNInterTransferStatusCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.statusImageView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.desLabel];
}

- (void)updateConstraints {
    [self.statusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(32));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.statusImageView.mas_bottom).offset(kRealWidth(15));
    }];

    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(50));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNInterTransferStatusCellModel *)model {
    _model = model;

    self.desLabel.text = self.model.reason;
    self.statusLabel.text = [PNCommonUtils getInterTransferOrderStatus:self.model.status];

    PNInterTransferOrderStatus status = self.model.status;
    NSString *imageNmaeStr = @"pn_transfer_status_fail";
    if (status == PNInterTransferOrderStatusFaild || status == PNInterTransferOrderStatusRejuect | status == PNInterTransferOrderStatusABNORMAL) {
        imageNmaeStr = @"pn_transfer_status_fail";
    } else if (status == PNInterTransferOrderStatusConfirmIng || status == PNInterTransferOrderStatusTransferIng) {
        imageNmaeStr = @"pn_transfer_status_process";
    } else {
        imageNmaeStr = @"pn_transfer_status_success";
    }

    self.statusImageView.image = [UIImage imageNamed:imageNmaeStr];

    [self setNeedsUpdateConstraints];
}

#pragma mark
/** @lazy statusImageView */
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pn_transfer_status_process"]];
        [_statusImageView sizeToFit];
    }
    return _statusImageView;
}

/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [HDAppTheme.PayNowFont fontSemibold:16];
        _statusLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _statusLabel.numberOfLines = 0;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

/** @lazy desLabel */
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = HDAppTheme.PayNowFont.standard12;
        _desLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _desLabel.numberOfLines = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}

@end


@implementation PNInterTransferStatusCellModel

@end

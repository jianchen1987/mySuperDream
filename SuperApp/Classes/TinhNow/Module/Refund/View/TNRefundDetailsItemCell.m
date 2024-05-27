//
//  TNRefundDetailsItemCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundDetailsItemCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNRefundDetailsItemView.h"
#import "SAGeneralUtil.h"


@interface TNRefundDetailsItemCell ()
///
@property (nonatomic, strong) UIImageView *leftIconImgView;
///
@property (nonatomic, strong) UILabel *statusTitleLabel;
///
@property (nonatomic, strong) UILabel *dateTimeLabel;
///
@property (nonatomic, strong) UILabel *statusLabel;
///
@property (nonatomic, strong) TNRefundDetailsItemView *detailsView;

@end


@implementation TNRefundDetailsItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.leftIconImgView];
    [self.contentView addSubview:self.statusTitleLabel];
    [self.contentView addSubview:self.dateTimeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.detailsView];
}

- (void)updateConstraints {
    [self.leftIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(@(self.leftIconImgView.image.size));
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15.f);
    }];

    [self.statusTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIconImgView.mas_right).offset(10.f);
        make.centerY.equalTo(self.leftIconImgView);
    }];

    [self.dateTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.statusTitleLabel);
    }];

    if (!self.statusLabel.hidden) {
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.statusTitleLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
            make.top.mas_equalTo(self.leftIconImgView.mas_bottom).offset(10.f);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15.f);
        }];
    }

    if (!self.detailsView.hidden) {
        [self.detailsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.leftIconImgView.mas_bottom).offset(10.f);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15.f);
        }];
    }


    [super updateConstraints];
}

- (void)setItemModel:(TNRefundDetailsItemsModel *)itemModel {
    _itemModel = itemModel;
    self.leftIconImgView.image = [UIImage imageNamed:itemModel.iconStr];
    self.statusTitleLabel.text = _itemModel.title;
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[self.itemModel.date doubleValue] / 1000.0];
    NSString *timeStr = [SAGeneralUtil getDateStrWithDate:orderDate format:@"dd/MM/yyyy HH:mm:ss"];
    self.dateTimeLabel.text = timeStr;

    if (HDIsStringNotEmpty(self.itemModel.refundAmount) && !HDIsObjectNil(self.itemModel.refundAmountMoney)) {
        self.statusLabel.hidden = YES;
        self.detailsView.hidden = NO;
        self.detailsView.model = self.itemModel;
    } else {
        self.statusLabel.text = self.itemModel.content;
        self.statusLabel.hidden = NO;
        self.detailsView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}


#pragma mark -
- (UIImageView *)leftIconImgView {
    if (!_leftIconImgView) {
        _leftIconImgView = [[UIImageView alloc] init];
        _leftIconImgView.image = [UIImage imageNamed:[self getIconName:@"1"]];
    }
    return _leftIconImgView;
}

- (UILabel *)statusTitleLabel {
    if (!_statusTitleLabel) {
        _statusTitleLabel = [[UILabel alloc] init];
        _statusTitleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _statusTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:17.f];
    }
    return _statusTitleLabel;
}

- (UILabel *)dateTimeLabel {
    if (!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc] init];
        _dateTimeLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _dateTimeLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
    }
    return _dateTimeLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HDAppTheme.TinhNowColor.c585858;
        _statusLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _statusLabel.hidden = YES;
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (TNRefundDetailsItemView *)detailsView {
    if (!_detailsView) {
        _detailsView = [[TNRefundDetailsItemView alloc] init];
        _detailsView.hidden = YES;
    }
    return _detailsView;
}

#pragma mark -
- (NSString *)getIconName:(NSString *)statsus {
    NSString *iconNameStr = @"";
    if ([statsus isEqualToString:@"1"]) {
        iconNameStr = @"tn_refund_details_canceled";
    } else if ([statsus isEqualToString:@"2"]) {
        iconNameStr = @"tn_refund_details_platform";
    } else if ([statsus isEqualToString:@"3"]) {
        iconNameStr = @"tn_refund_details_apply";
    } else {
        iconNameStr = @"";
    }
    return iconNameStr;
}
@end


@implementation TNRefundDetailsItemCellModel

@end

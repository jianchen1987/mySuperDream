//
//  TNWithDrawDetailTipsCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithDrawDetailTipsCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"


@interface TNWithDrawDetailTipsCell ()
@property (strong, nonatomic) UILabel *titleLabel;  ///< 标题
@property (strong, nonatomic) UILabel *detailLabel; ///< 详细
@end


@implementation TNWithDrawDetailTipsCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
}
- (void)setModel:(TNWithDrawDetailTipsCellModel *)model {
    _model = model;
    if ([model.status isEqualToString:TNWithDrawApplyStatusApproved]) {
        //审核通过
        self.titleLabel.hidden = YES;
        self.detailLabel.text = TNLocalizedString(@"tn_withdraw_success_tips", @"平台已提交资金渠道处理, 通常情况下, 提现资金会在2-7天内到账");
        self.detailLabel.textColor = HDAppTheme.TinhNowColor.C1;
    } else if ([model.status isEqualToString:TNWithDrawApplyStatusFailed]) {
        //审核不通过
        self.titleLabel.hidden = NO;
        self.detailLabel.text = model.memo;
        self.detailLabel.textColor = HexColor(0xFF2323);
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (!self.titleLabel.isHidden) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLabel.isHidden) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        }
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];

    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _titleLabel.text = TNLocalizedString(@"tn_reason", @"原因");
    }
    return _titleLabel;
}
/** @lazy titleLabel */
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = HDAppTheme.TinhNowFont.standard12;
        _detailLabel.textColor = HexColor(0xFF2323);
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
@end


@implementation TNWithDrawDetailTipsCellModel

@end

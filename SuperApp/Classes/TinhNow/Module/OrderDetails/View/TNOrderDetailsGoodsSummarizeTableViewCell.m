//
//  TNOrderDetailsGoodsSummarizeTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsGoodsSummarizeTableViewCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNOrderDetailsGoodsSummarizeTableViewCell ()
/// 汇总字段
@property (nonatomic, strong) UILabel *summarizeLabel;
/// 商家已改价, 改价原因
@property (nonatomic, strong) UILabel *reasonTitleLabel;
/// 改价原因
@property (nonatomic, strong) UILabel *reasonLabel;
@end


@implementation TNOrderDetailsGoodsSummarizeTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.summarizeLabel];
    [self.contentView addSubview:self.reasonTitleLabel];
    [self.contentView addSubview:self.reasonLabel];
}

- (void)updateConstraints {
    [self.summarizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        if (!self.reasonLabel.isHidden) {
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-15);
        } else {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        }
    }];

    if (!self.reasonLabel.isHidden) {
        [self.reasonTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
            make.top.mas_equalTo(self.summarizeLabel.mas_bottom).offset(13.f);
            make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(15);
        }];

        [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.reasonTitleLabel.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }

    [super updateConstraints];
}

- (void)setModel:(TNOrderDetailsGoodsSummarizeTableViewCellModel *)model {
    _model = model;
    //    [self setSummarizeTextWithQuantity:_model.goodsQuantity totalPrice:model.totalPrice];
    self.summarizeLabel.text = [NSString stringWithFormat:TNLocalizedString(@"kI6BaJBD", @"共计%ld件商品"), model.goodsQuantity];
    if (HDIsStringNotEmpty(model.changeReason)) {
        [self setReasonTextWithReason:model.changeReason];
        self.reasonLabel.hidden = NO;
        self.reasonTitleLabel.hidden = NO;
    } else {
        self.reasonLabel.hidden = YES;
        self.reasonTitleLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

//- (void)setSummarizeTextWithQuantity:(NSUInteger)quantity totalPrice:(SAMoneyModel *)totalPrice {
//    NSString *start = [NSString stringWithFormat:TNLocalizedString(@"tn_order_total_info2", @"共计%d件商品，商品总额 "), quantity];
//    NSString *end = totalPrice.thousandSeparatorAmount;
//
//    NSMutableAttributedString *attriteString = [[NSMutableAttributedString alloc] initWithString:[start stringByAppendingString:end]];
//    [attriteString addAttributes:@{NSFontAttributeName : HDAppTheme.TinhNowFont.standard15, NSForegroundColorAttributeName : HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, start.length)];
//    [attriteString addAttributes:@{NSFontAttributeName : HDAppTheme.TinhNowFont.standard17B, NSForegroundColorAttributeName : HDAppTheme.TinhNowColor.R1} range:NSMakeRange(start.length,
//    end.length)]; self.summarizeLabel.attributedText = attriteString;
//}
- (void)setReasonTextWithReason:(NSString *)reason {
    NSString *reasonTitleStr = TNLocalizedString(@"tn_change_price_reason_title", @"商家已改价，改价原因:");
    self.reasonTitleLabel.text = reasonTitleStr;
    self.reasonLabel.text = reason;
}

#pragma mark - lazy load
/** @lazy summarizelabel */
- (UILabel *)summarizeLabel {
    if (!_summarizeLabel) {
        _summarizeLabel = [[UILabel alloc] init];
        _summarizeLabel.textAlignment = NSTextAlignmentRight;
        _summarizeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _summarizeLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _summarizeLabel;
}
/** @lazy reason */
- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _reasonLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _reasonLabel.textAlignment = NSTextAlignmentRight;
        _reasonLabel.numberOfLines = 0;
    }
    return _reasonLabel;
}

- (UILabel *)reasonTitleLabel {
    if (!_reasonTitleLabel) {
        _reasonTitleLabel = [[UILabel alloc] init];
        _reasonTitleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _reasonTitleLabel.textColor = HDAppTheme.TinhNowColor.c666666;
        _reasonTitleLabel.textAlignment = NSTextAlignmentRight;
        _reasonTitleLabel.numberOfLines = 0;
    }
    return _reasonTitleLabel;
}

@end


@implementation TNOrderDetailsGoodsSummarizeTableViewCellModel

@end

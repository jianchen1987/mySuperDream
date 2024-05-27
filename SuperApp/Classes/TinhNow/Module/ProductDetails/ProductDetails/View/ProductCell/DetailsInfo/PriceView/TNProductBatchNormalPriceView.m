//
//  TNProductBatchNormalPriceView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchNormalPriceView.h"


@interface TNProductBatchNormalPriceView ()
/// 销售价
@property (strong, nonatomic) UILabel *salePriceLabel;
/// 批发价文字
@property (strong, nonatomic) UILabel *wholesaleKeyLabel;
/// 批发价
@property (strong, nonatomic) UILabel *wholesalePriceLabel;
/// 收益
@property (nonatomic, strong) UILabel *revenuePriceLabel;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 起批文案
@property (nonatomic, strong) UILabel *wholesaleStartLabel;
/// 限购一件
@property (strong, nonatomic) UILabel *limitLabel;
@end


@implementation TNProductBatchNormalPriceView

- (void)hd_setupViews {
    [self addSubview:self.salePriceLabel];
    [self addSubview:self.revenuePriceLabel];
    [self addSubview:self.wholesalePriceLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.wholesaleStartLabel];
    [self addSubview:self.wholesaleKeyLabel];
    [self addSubview:self.limitLabel];
}
- (void)setModel:(TNProductBatchPriceInfoModel *)model {
    _model = model;
    if (HDIsArrayEmpty(model.priceRanges)) {
        return;
    }
    TNPriceRangesModel *rangeModel = model.priceRanges.firstObject;
    self.salePriceLabel.font = HDAppTheme.TinhNowFont.standard15;
    if (model.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
        //选品
        if (model.isJoinSales) {
            //加入销售
            self.wholesaleKeyLabel.hidden = YES;
            self.revenuePriceLabel.hidden = NO;
            self.wholesalePriceLabel.hidden = NO;
            self.salePriceLabel.font = HDAppTheme.TinhNowFont.standard12;
            self.revenuePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"1dh32q2n", @"收益"), rangeModel.additionPrice.thousandSeparatorAmount];
            self.salePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"vg0PzsXn", @"销售价"), rangeModel.price.thousandSeparatorAmount];
            self.wholesalePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), rangeModel.tradePrice.thousandSeparatorAmount];
        } else {
            //未加入销售
            self.revenuePriceLabel.hidden = YES;
            self.wholesalePriceLabel.hidden = YES;
            self.wholesaleKeyLabel.hidden = NO;
            self.salePriceLabel.text = rangeModel.price.thousandSeparatorAmount;
        }
    } else {
        //普通
        self.revenuePriceLabel.hidden = YES;
        self.wholesalePriceLabel.hidden = YES;
        self.wholesaleKeyLabel.hidden = YES;
        self.salePriceLabel.text = rangeModel.price.thousandSeparatorAmount;
    }

    self.wholesaleStartLabel.text = [NSString stringWithFormat:TNLocalizedString(@"JAl17oWr", @"%ld件起批"), rangeModel.startQuantity];
    self.limitLabel.hidden = !model.goodsLimitBuy;
    if (model.goodsLimitBuy) {
        self.limitLabel.hidden = NO;
        self.limitLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_limit_goods_num", @"限购%ld件"), model.maxLimit];
    } else {
        self.limitLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (self.model.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
        //选品
        if (self.model.isJoinSales) {
            //加入销售
            [self.revenuePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kRealWidth(10));
                make.top.equalTo(self.mas_top).offset(kRealWidth(10));
            }];
            [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kRealWidth(10));
                make.top.equalTo(self.revenuePriceLabel.mas_bottom).offset(kRealWidth(5));
            }];
            [self.wholesalePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.salePriceLabel.mas_right).offset(kRealWidth(30));
                make.centerY.equalTo(self.salePriceLabel);
            }];
            [self.wholesaleStartLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(kRealWidth(10));
                make.top.equalTo(self.salePriceLabel.mas_bottom).offset(kRealWidth(5));
                make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(10));
            }];

        } else {
            //未加入销售
            if (!self.wholesaleKeyLabel.isHidden) {
                [self.wholesaleKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left).offset(kRealWidth(10));
                    make.centerY.equalTo(self.salePriceLabel.mas_centerY);
                }];
            }
            [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.wholesaleKeyLabel.isHidden) {
                    make.left.equalTo(self.wholesaleKeyLabel.mas_right).offset(kRealWidth(20));
                } else {
                    make.left.equalTo(self.mas_left).offset(kRealWidth(10));
                }

                make.top.equalTo(self.mas_top).offset(kRealWidth(15));
                make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(15));
            }];
            [self.wholesaleStartLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.salePriceLabel.mas_centerY);
                make.left.equalTo(self.salePriceLabel.mas_right).offset(kRealWidth(5));
            }];
        }
    } else {
        //非卖家
        [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(10));
            make.top.equalTo(self.mas_top).offset(kRealWidth(15));
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(15));
        }];
        [self.wholesaleStartLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.salePriceLabel.mas_centerY);
            make.left.equalTo(self.salePriceLabel.mas_right).offset(kRealWidth(5));
        }];
    }

    if (!self.limitLabel.isHidden) {
        [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.mas_top).offset(kRealWidth(15));
        }];
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}

/** @lazy salePriceLabel */
- (UILabel *)salePriceLabel {
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc] init];
        _salePriceLabel.textColor = HexColor(0xFF2323);
        _salePriceLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _salePriceLabel;
}
/** @lazy salePriceLabel */
- (UILabel *)wholesalePriceLabel {
    if (!_wholesalePriceLabel) {
        _wholesalePriceLabel = [[UILabel alloc] init];
        _wholesalePriceLabel.textColor = HexColor(0xFF2323);
        _wholesalePriceLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _wholesalePriceLabel;
}
/** @lazy _revenuePriceLabel */
- (UILabel *)revenuePriceLabel {
    if (!_revenuePriceLabel) {
        _revenuePriceLabel = [[UILabel alloc] init];
        _revenuePriceLabel.font = HDAppTheme.TinhNowFont.standard15;
        _revenuePriceLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _revenuePriceLabel;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _lineView;
}
/** @lazy wholesaleStartLabel */
- (UILabel *)wholesaleStartLabel {
    if (!_wholesaleStartLabel) {
        _wholesaleStartLabel = [[UILabel alloc] init];
        _wholesaleStartLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _wholesaleStartLabel.font = [HDAppTheme.TinhNowFont fontRegular:9];
    }
    return _wholesaleStartLabel;
}
/** @lazy wholesaleKeyLabel */
- (UILabel *)wholesaleKeyLabel {
    if (!_wholesaleKeyLabel) {
        _wholesaleKeyLabel = [[UILabel alloc] init];
        _wholesaleKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _wholesaleKeyLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _wholesaleKeyLabel.text = TNLocalizedString(@"QWjyhTSY", @"批发价");
    }
    return _wholesaleKeyLabel;
}
/** @lazy limitLabel */
- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
        _limitLabel.textColor = [UIColor hd_colorWithHexString:@"#7E7E7E"];
        _limitLabel.font = HDAppTheme.TinhNowFont.standard12B;
        _limitLabel.hidden = true;
    }
    return _limitLabel;
}
@end

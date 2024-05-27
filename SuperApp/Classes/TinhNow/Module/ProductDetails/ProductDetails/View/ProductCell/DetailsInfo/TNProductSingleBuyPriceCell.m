//
//  TNSingleBuyPriceViewCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductSingleBuyPriceCell.h"
#import "NSString+extend.h"
#import "SAInfoView.h"
#import "TNView.h"
#pragma mark -单买价格cell


@interface TNProductSingleBuyPriceCell ()
/// 销售价
@property (strong, nonatomic) UILabel *salePriceLabel;
/// 批发价
@property (strong, nonatomic) UILabel *wholesalePriceLabel;
/// 原价
@property (nonatomic, strong) UILabel *originalPriceLabel;
/// 收益
@property (nonatomic, strong) UILabel *revenuePriceLabel;
/// 折扣
@property (nonatomic, strong) HDLabel *discountLabel;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 限购一件
@property (strong, nonatomic) UILabel *limitLabel;
/// 找同款
@property (nonatomic, strong) HDUIButton *findSameButton;
@end


@implementation TNProductSingleBuyPriceCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.salePriceLabel];
    [self.contentView addSubview:self.originalPriceLabel];
    [self.contentView addSubview:self.revenuePriceLabel];
    [self.contentView addSubview:self.wholesalePriceLabel];
    [self.contentView addSubview:self.discountLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.limitLabel];
    [self.contentView addSubview:self.findSameButton];
}
- (void)setModel:(TNProductSingleBuyPriceCellModel *)model {
    _model = model;
    if (self.model.isJoinSales) {
        self.discountLabel.hidden = YES;
        self.originalPriceLabel.hidden = YES;
        self.revenuePriceLabel.hidden = NO;
        self.wholesalePriceLabel.hidden = NO;
        self.revenuePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"1dh32q2n", @"收益"), model.revenue];
        self.salePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"vg0PzsXn", @"销售价"), model.price];
        self.salePriceLabel.font = HDAppTheme.TinhNowFont.standard12;
        self.wholesalePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.tradePrice];
    } else {
        self.salePriceLabel.font = HDAppTheme.TinhNowFont.standard15;
        self.revenuePriceLabel.hidden = YES;
        self.wholesalePriceLabel.hidden = YES;
        if (model.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
            //选品详情
            self.originalPriceLabel.hidden = YES;
            self.discountLabel.hidden = YES;
            self.salePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.tradePrice];
        } else {
            self.salePriceLabel.text = model.price;
            self.salePriceLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
            if (!HDIsObjectNil(model.priceMoney) && HDIsStringNotEmpty(model.priceMoney.thousandSeparatorAmountNoCurrencySymbol)) {
                NSString *text = [model.priceMoney.currencySymbol stringByAppendingString:model.priceMoney.thousandSeparatorAmountNoCurrencySymbol];
                self.salePriceLabel.attributedText = [text changeFontString:model.priceMoney.thousandSeparatorAmountNoCurrencySymbol font:[HDAppTheme.TinhNowFont fontMedium:24]];
            }
            self.originalPriceLabel.hidden = HDIsStringEmpty(model.marketPrice);
            if (!self.originalPriceLabel.isHidden) {
                NSAttributedString *marketPrice = [[NSAttributedString alloc] initWithString:model.marketPrice attributes:@{
                    NSFontAttributeName: self.originalPriceLabel.font,
                    NSForegroundColorAttributeName: self.originalPriceLabel.textColor,
                    NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                    NSStrikethroughColorAttributeName: self.originalPriceLabel.textColor
                }];
                self.originalPriceLabel.attributedText = marketPrice;
            }
            self.discountLabel.hidden = HDIsStringEmpty(model.showDisCount);
            if (!self.discountLabel.isHidden) {
                self.discountLabel.text = _model.showDisCount;
            }
        }
    }

    self.limitLabel.hidden = !model.goodsLimitBuy;
    if (model.goodsLimitBuy) {
        self.limitLabel.hidden = NO;
        self.limitLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_limit_goods_num", @"限购%ld件"), model.maxLimit];
    } else {
        self.limitLabel.hidden = YES;
    }

    if ([self.model.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
        self.findSameButton.hidden = NO;
    } else {
        self.findSameButton.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (self.model.isJoinSales) {
        // 已经加入销售
        [self.revenuePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(8));
            if (self.findSameButton.isHidden) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
            }
        }];
        [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
            make.top.equalTo(self.revenuePriceLabel.mas_bottom).offset(kRealWidth(5));
            if (self.limitLabel.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom);
            }
        }];
        [self.wholesalePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.salePriceLabel.mas_right).offset(kRealWidth(30));
            make.centerY.equalTo(self.salePriceLabel);
        }];

        if (!self.limitLabel.isHidden) {
            [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.revenuePriceLabel.mas_left);
                make.top.mas_equalTo(self.wholesalePriceLabel.mas_bottom).offset(kRealWidth(5));
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }

        if (!self.findSameButton.isHidden) {
            [self.findSameButton sizeToFit];
            [self.findSameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
                make.centerY.mas_equalTo(self.revenuePriceLabel.mas_centerY);
                make.width.equalTo(@(self.findSameButton.width + 20));
                make.height.equalTo(@(kRealWidth(25)));
            }];
        }
    } else {
        //普通用户视角
        if (self.model.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
            //选品详情
            [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
                make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
                if (self.discountLabel.isHidden && self.limitLabel.isHidden) {
                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(5));
                }
            }];
        } else {
            [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
                make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(8));
                if (self.discountLabel.isHidden && self.limitLabel.isHidden) {
                    make.bottom.equalTo(self.contentView.mas_bottom);
                }
            }];
        }

        if (!self.limitLabel.isHidden) {
            [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.salePriceLabel.mas_left);
                if (!self.discountLabel.isHidden) {
                    make.top.mas_equalTo(self.discountLabel.mas_bottom).offset(kRealWidth(5));
                } else {
                    make.top.mas_equalTo(self.salePriceLabel.mas_bottom).offset(kRealWidth(5));
                }
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }

        if (!self.originalPriceLabel.isHidden) {
            [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.salePriceLabel.mas_centerY);
                make.left.equalTo(self.salePriceLabel.mas_right).offset(kRealWidth(5));
            }];
            if (!self.discountLabel.isHidden) {
                [self.discountLabel sizeToFit];
                [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
                    make.top.equalTo(self.salePriceLabel.mas_bottom).offset(kRealWidth(5));
                    if (self.limitLabel.isHidden) {
                        make.bottom.equalTo(self.contentView.mas_bottom);
                    }
                }];
            }
        }

        if (!self.findSameButton.isHidden) {
            [self.findSameButton sizeToFit];
            [self.findSameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
                make.centerY.mas_equalTo(self.salePriceLabel.mas_centerY);
                make.width.equalTo(@(self.findSameButton.width + 20));
                make.height.equalTo(@(kRealWidth(25)));
            }];
        }
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}
/** @lazy discountLabel */
- (HDLabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [[HDLabel alloc] init];
        _discountLabel.textColor = [UIColor hd_colorWithHexString:@"#FA7D00"];
        _discountLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:0.11];
        _discountLabel.font = HDAppTheme.TinhNowFont.standard12;
        _discountLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _discountLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _discountLabel;
}
/** @lazy originalPriceLabel */
- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = HDAppTheme.TinhNowFont.standard15;
        _originalPriceLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _originalPriceLabel;
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
        _lineView.hidden = YES; //隐藏不展示分割线
    }
    return _lineView;
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
- (HDUIButton *)findSameButton {
    if (!_findSameButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:TNLocalizedString(@"tn_find_the_same", @"查找同款") forState:0];
        [button setTitleColor:HexColor(0xFF8818) forState:0];
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard11;
        [button setImage:[UIImage imageNamed:@"tinhnow_find_the_same"] forState:UIControlStateNormal];
        [button setSpacingBetweenImageAndTitle:3];
        button.layer.cornerRadius = kRealWidth(12);
        button.layer.borderColor = HexColor(0xFF8818).CGColor;
        button.layer.borderWidth = 1;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            //查找同款埋点
            [TNEventTrackingInstance trackEvent:@"search_same" properties:@{@"productId": self.model.productId, @"type": @"1"}];
            if (HDIsStringNotEmpty(self.model.firstImageURL)) {
                [[HDMediator sharedInstance] navigaveToTinhNowPictureSearchViewController:@{
                    @"imageURL": self.model.firstImageURL,
                }];
            } else {
                HDLog(@"💣💣💣💣图片不能为空");
            }
        }];

        _findSameButton = button;
    }
    return _findSameButton;
}
@end


@implementation TNProductSingleBuyPriceCellModel

@end

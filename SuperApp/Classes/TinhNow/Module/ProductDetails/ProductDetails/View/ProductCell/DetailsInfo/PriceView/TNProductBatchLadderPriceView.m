//
//  TNProductBatchLadderPriceView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchLadderPriceView.h"


@interface TNPriceItemView : TNView
/// 宽度
@property (nonatomic, assign) CGFloat itemWidth;
/// 字体颜色
@property (strong, nonatomic) UIColor *itemColor;
/// 字体大小
@property (strong, nonatomic) UIFont *itemFont;
/// 展示数组
@property (strong, nonatomic) NSArray *itemArray;
@end


@implementation TNPriceItemView
- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = itemArray;
    [self hd_removeAllSubviews];
    UILabel *lastLabel = nil;
    for (NSString *item in itemArray) {
        UILabel *label = [[UILabel alloc] init];
        label.text = item;
        label.textColor = self.itemColor;
        label.font = self.itemFont;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (lastLabel) {
                make.left.equalTo(lastLabel.mas_right);
            } else {
                make.left.equalTo(self);
            }
            make.width.mas_equalTo(self.itemWidth);
        }];
        lastLabel = label;
    }
}
@end


@interface TNProductBatchLadderPriceView ()
/// 销售价文本
@property (strong, nonatomic) UILabel *salesKeyLabel;
/// 销售价
@property (strong, nonatomic) TNPriceItemView *salesPriceItemView;
/// 收益文本
@property (strong, nonatomic) UILabel *revenueKeyLabel;
/// 收益
@property (strong, nonatomic) TNPriceItemView *revenuePriceItemView;
/// 批发文本
@property (strong, nonatomic) UILabel *wholesaleKeyLabel;
/// 批发价
@property (strong, nonatomic) TNPriceItemView *wholesalePriceItemView;
/// 单位
@property (strong, nonatomic) TNPriceItemView *rangeNumItemView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
@end


@implementation TNProductBatchLadderPriceView
- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self addSubview:self.salesKeyLabel];
    [self addSubview:self.revenueKeyLabel];
    [self addSubview:self.wholesaleKeyLabel];
    [self addSubview:self.lineView];

    [self.scrollViewContainer addSubview:self.salesPriceItemView];
    [self.scrollViewContainer addSubview:self.revenuePriceItemView];
    [self.scrollViewContainer addSubview:self.wholesalePriceItemView];
    [self.scrollViewContainer addSubview:self.rangeNumItemView];

    self.scrollView.bounces = NO;
}
- (void)setInfoModel:(TNProductBatchPriceInfoModel *)infoModel {
    _infoModel = infoModel;
    if (HDIsArrayEmpty(infoModel.priceRanges)) {
        return;
    }
    if (infoModel.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
        //选品
        if (infoModel.isJoinSales) {
            [self setJoinedSalesUI];
        } else {
            [self setNoJionSalesUI];
        }
    } else {
        [self setNoJionSalesUI];
    }
    [self setNeedsUpdateConstraints];
}

- (void)setJoinedSalesUI {
    self.salesKeyLabel.hidden = NO;
    self.revenueKeyLabel.hidden = NO;
    self.wholesaleKeyLabel.hidden = NO;
    self.salesPriceItemView.hidden = NO;
    self.revenuePriceItemView.hidden = NO;
    self.wholesalePriceItemView.hidden = NO;
    CGFloat width = (kScreenWidth - kRealWidth(86)) / 3;
    NSMutableArray *salesPriceArr = [NSMutableArray array];
    NSMutableArray *revenuePriceArr = [NSMutableArray array];
    NSMutableArray *wholesePriceArr = [NSMutableArray array];
    NSMutableArray *rangeNumArr = [NSMutableArray array];
    TNPriceRangesModel *lastModel = nil;
    for (TNPriceRangesModel *model in self.infoModel.priceRanges) {
        [wholesePriceArr addObject:model.tradePrice.thousandSeparatorAmount];
        [salesPriceArr addObject:model.price.thousandSeparatorAmount];
        [revenuePriceArr addObject:model.additionPrice.thousandSeparatorAmount];
        if (lastModel) {
            NSString *rangeStr;
            if (lastModel.startQuantity < model.startQuantity - 1) {
                rangeStr = [NSString stringWithFormat:@"%ld-%ld%@", lastModel.startQuantity, model.startQuantity - 1, self.infoModel.unit];
            } else {
                rangeStr = [NSString stringWithFormat:@"%ld%@", lastModel.startQuantity, self.infoModel.unit];
            }

            [rangeNumArr addObject:rangeStr];
        }
        lastModel = model;
    }
    //还要加上最后一个
    TNPriceRangesModel *model = self.infoModel.priceRanges.lastObject;
    NSString *rangeStr = [NSString stringWithFormat:@"≥%ld%@", model.startQuantity, self.infoModel.unit];
    [rangeNumArr addObject:rangeStr];

    self.revenuePriceItemView.itemWidth = width;
    self.revenuePriceItemView.itemFont = [HDAppTheme.TinhNowFont fontSemibold:14];
    self.revenuePriceItemView.itemColor = HDAppTheme.TinhNowColor.C1;
    self.revenuePriceItemView.itemArray = revenuePriceArr;

    self.salesPriceItemView.itemWidth = width;
    self.salesPriceItemView.itemFont = [HDAppTheme.TinhNowFont fontRegular:12];
    self.salesPriceItemView.itemColor = HDAppTheme.TinhNowColor.cFF2323;
    self.salesPriceItemView.itemArray = salesPriceArr;

    self.wholesalePriceItemView.itemWidth = width;
    self.wholesalePriceItemView.itemFont = [HDAppTheme.TinhNowFont fontRegular:12];
    self.wholesalePriceItemView.itemColor = HDAppTheme.TinhNowColor.cFF2323;
    self.wholesalePriceItemView.itemArray = wholesePriceArr;

    self.rangeNumItemView.itemWidth = width;
    self.rangeNumItemView.itemFont = [HDAppTheme.TinhNowFont fontRegular:10];
    self.rangeNumItemView.itemColor = HDAppTheme.TinhNowColor.c5d667f;
    self.rangeNumItemView.itemArray = rangeNumArr;
}
///设置未加入卖家UI
- (void)setNoJionSalesUI {
    self.salesKeyLabel.hidden = YES;
    self.revenueKeyLabel.hidden = YES;
    self.revenuePriceItemView.hidden = YES;
    self.wholesalePriceItemView.hidden = YES;
    CGFloat width;
    if (self.infoModel.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
        self.wholesaleKeyLabel.hidden = NO;
        width = (kScreenWidth - kRealWidth(86)) / 3;
    } else {
        self.wholesaleKeyLabel.hidden = YES;
        width = kScreenWidth / 3;
    }

    self.salesPriceItemView.itemFont = HDAppTheme.TinhNowFont.standard15;
    self.salesPriceItemView.itemColor = HDAppTheme.TinhNowColor.cFF2323;

    self.salesPriceItemView.itemWidth = width;
    NSMutableArray *priceArr = [NSMutableArray array];
    NSMutableArray *rangeNumArr = [NSMutableArray array];
    TNPriceRangesModel *lastModel = nil;
    for (TNPriceRangesModel *model in self.infoModel.priceRanges) {
        if (self.infoModel.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
            [priceArr addObject:model.tradePrice.thousandSeparatorAmount];
        } else {
            [priceArr addObject:model.price.thousandSeparatorAmount];
        }

        if (lastModel) {
            NSString *rangeStr;
            if (lastModel.startQuantity < model.startQuantity - 1) {
                rangeStr = [NSString stringWithFormat:@"%ld-%ld%@", lastModel.startQuantity, model.startQuantity - 1, self.infoModel.unit];
            } else {
                rangeStr = [NSString stringWithFormat:@"%ld%@", lastModel.startQuantity, self.infoModel.unit];
            }
            [rangeNumArr addObject:rangeStr];
        }
        lastModel = model;
    }
    //还要加上最后一个
    TNPriceRangesModel *model = self.infoModel.priceRanges.lastObject;
    NSString *rangeStr = [NSString stringWithFormat:@"≥%ld%@", model.startQuantity, self.infoModel.unit];
    [rangeNumArr addObject:rangeStr];
    self.salesPriceItemView.itemArray = priceArr;

    self.rangeNumItemView.itemFont = [HDAppTheme.TinhNowFont fontRegular:10];
    self.rangeNumItemView.itemColor = HDAppTheme.TinhNowColor.c5d667f;
    self.rangeNumItemView.itemWidth = width;
    self.rangeNumItemView.itemArray = rangeNumArr;
}
- (void)updateConstraints {
    if (self.infoModel.isJoinSales) {
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.left.equalTo(self.revenueKeyLabel.mas_right);
            make.height.mas_equalTo(kRealWidth(150));
        }];
        [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        [self.revenueKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(86), kRealWidth(40)));
        }];
        [self.salesKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.revenueKeyLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(86), kRealWidth(40)));
        }];
        [self.wholesaleKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.salesKeyLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(86), kRealWidth(70)));
        }];
        [self.revenuePriceItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.scrollViewContainer);
            make.height.mas_equalTo(kRealWidth(40));
            make.width.mas_equalTo(self.revenuePriceItemView.itemWidth * self.revenuePriceItemView.itemArray.count);
        }];

        [self.salesPriceItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollViewContainer);
            make.top.equalTo(self.revenuePriceItemView.mas_bottom);
            make.height.mas_equalTo(kRealWidth(40));
            make.width.mas_equalTo(self.salesPriceItemView.itemWidth * self.salesPriceItemView.itemArray.count);
        }];

        [self.wholesalePriceItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollViewContainer);
            make.top.equalTo(self.salesPriceItemView.mas_bottom);
            make.height.mas_equalTo(kRealWidth(40));
            make.width.mas_equalTo(self.wholesalePriceItemView.itemWidth * self.wholesalePriceItemView.itemArray.count);
        }];
        [self.rangeNumItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollViewContainer);
            make.top.equalTo(self.wholesalePriceItemView.mas_bottom);
            make.height.mas_equalTo(kRealWidth(30));
            make.width.mas_equalTo(self.rangeNumItemView.itemWidth * self.rangeNumItemView.itemArray.count);
        }];
    } else {
        if (self.infoModel.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
            //选品
            [self.wholesaleKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.mas_equalTo(kRealWidth(86));
            }];

            [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.equalTo(self);
                make.left.equalTo(self.wholesaleKeyLabel.mas_right);
                make.height.mas_equalTo(kRealWidth(50));
            }];

        } else {
            //普通
            [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.mas_equalTo(kRealWidth(50));
            }];
        }
        [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        [self.salesPriceItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.scrollViewContainer);
            make.height.mas_equalTo(kRealWidth(30));
        }];
        [self.rangeNumItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.scrollViewContainer);
            make.height.mas_equalTo(kRealWidth(20));
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
/** @lazy salesKeyLabel */
- (UILabel *)salesKeyLabel {
    if (!_salesKeyLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = HDAppTheme.TinhNowFont.standard12;
        label.textColor = HDAppTheme.TinhNowColor.G1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = TNLocalizedString(@"vg0PzsXn", @"销售价");
        label.numberOfLines = 0;
        _salesKeyLabel = label;
    }
    return _salesKeyLabel;
}
/** @lazy revenueKeyLabel */
- (UILabel *)revenueKeyLabel {
    if (!_revenueKeyLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = HDAppTheme.TinhNowFont.standard12;
        label.textColor = HDAppTheme.TinhNowColor.G1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = TNLocalizedString(@"1dh32q2n", @"收益");
        label.numberOfLines = 0;
        _revenueKeyLabel = label;
    }
    return _revenueKeyLabel;
}
/** @lazy wholesaleKeyLabel */
- (UILabel *)wholesaleKeyLabel {
    if (!_wholesaleKeyLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = HDAppTheme.TinhNowFont.standard12;
        label.textColor = HDAppTheme.TinhNowColor.G1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = TNLocalizedString(@"QWjyhTSY", @"批发价");
        label.numberOfLines = 0;
        _wholesaleKeyLabel = label;
    }
    return _wholesaleKeyLabel;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _lineView;
}
/** @lazy salesPriceItemView */
- (TNPriceItemView *)salesPriceItemView {
    if (!_salesPriceItemView) {
        _salesPriceItemView = [[TNPriceItemView alloc] init];
    }
    return _salesPriceItemView;
}
/** @lazy revenuePriceItemView */
- (TNPriceItemView *)revenuePriceItemView {
    if (!_revenuePriceItemView) {
        _revenuePriceItemView = [[TNPriceItemView alloc] init];
    }
    return _revenuePriceItemView;
}
/** @lazy wholesalePriceItemView */
- (TNPriceItemView *)wholesalePriceItemView {
    if (!_wholesalePriceItemView) {
        _wholesalePriceItemView = [[TNPriceItemView alloc] init];
    }
    return _wholesalePriceItemView;
}
/** @lazy rangeNumItemView */
- (TNPriceItemView *)rangeNumItemView {
    if (!_rangeNumItemView) {
        _rangeNumItemView = [[TNPriceItemView alloc] init];
    }
    return _rangeNumItemView;
}
@end

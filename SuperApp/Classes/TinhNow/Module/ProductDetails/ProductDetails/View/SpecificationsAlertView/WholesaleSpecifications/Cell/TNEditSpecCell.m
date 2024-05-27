//
//  TNEditSpecCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNEditSpecCell.h"
#import "TNModifyShoppingCountView.h"
#import "TNProductSkuModel.h"
#import "TNSkuImageView.h"


@interface TNEditSpecCell ()
/// sku图片
@property (strong, nonatomic) TNSkuImageView *skuImageView;
/// 规格名称
@property (strong, nonatomic) UILabel *nameLabel;
/// 库存
@property (strong, nonatomic) UILabel *stockLabel;
/// 数量输入
@property (nonatomic, strong) TNModifyShoppingCountView *countView;
/// 缺货文本
@property (strong, nonatomic) UILabel *outOfStockLabel;
/// 价格文本
@property (strong, nonatomic) UILabel *priceLabel;

/// 倍数提示
@property (strong, nonatomic) UILabel *multipleTipLabel;
@end


@implementation TNEditSpecCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.skuImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.stockLabel];
    [self.contentView addSubview:self.countView];
    [self.contentView addSubview:self.outOfStockLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.multipleTipLabel];
}
- (void)setCellModel:(TNEditSpecCellModel *)cellModel {
    _cellModel = cellModel;
    //    [HDWebImageManager setImageWithURL:cellModel.skuModel.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(70), kRealWidth(70))] imageView:self.skuImageView];
    self.skuImageView.thumbnail = cellModel.skuModel.thumbnail;
    self.skuImageView.largeImageUrl = cellModel.skuModel.skuLargeImg;

    self.nameLabel.text = cellModel.name;
    NSString *showStock = @"";
    if ([cellModel.skuModel.stock integerValue] > 10) {
        showStock = @">10";
    } else {
        showStock = [NSString stringWithFormat:@"%@", cellModel.skuModel.stock];
    }
    if (HDIsObjectNil(cellModel.skuModel)) {
        showStock = @"0";
    }
    self.stockLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_stock_total", @"库存"), showStock];
    bool outofstock = cellModel.skuModel.isOutOfStock;
    self.priceLabel.text = cellModel.skuModel.tempSalesPrice.thousandSeparatorAmount;
    if (cellModel.batchPriceInfoModel.quoteType == TNProductQuoteTypeHasSpecByNumber || cellModel.batchPriceInfoModel.quoteType == TNProductQuoteTypeNoSpecByNumber) {
    } else {
        if (HDIsObjectNil(cellModel.skuModel.priceRange)) {
            //没有价格的特殊情况 也要展示为无货
            outofstock = YES;
        }
    }
    self.outOfStockLabel.hidden = !outofstock;

    self.countView.hidden = !self.outOfStockLabel.isHidden;

    if (cellModel.batchPriceInfoModel.batchNumber > 0) {
        self.countView.step = cellModel.batchPriceInfoModel.batchNumber;
        self.countView.firstStepCount = cellModel.batchPriceInfoModel.batchNumber;
    } else {
        self.countView.step = 1;
        self.countView.firstStepCount = 1;
    }
    if (!cellModel.batchPriceInfoModel.mixWholeSale) {
        //非混批显示提示
        if (cellModel.skuModel.editCount > 0) {
            TNPriceRangesModel *firstModel = nil;
            if (!HDIsArrayEmpty(cellModel.batchPriceInfoModel.priceRanges)) {
                firstModel = cellModel.batchPriceInfoModel.priceRanges.firstObject;
            }
            if (!HDIsObjectNil(firstModel) && cellModel.skuModel.editCount < firstModel.startQuantity) {
                self.multipleTipLabel.hidden = NO;
                self.multipleTipLabel.text = [NSString stringWithFormat:TNLocalizedString(@"zXpfvxcb", @"最小起批量为%ld件"), firstModel.startQuantity];
            } else {
                //设置倍数不够提示
                if (cellModel.skuModel.editCount > 0 && cellModel.batchPriceInfoModel.batchNumber > 0 && cellModel.skuModel.editCount % self.cellModel.batchPriceInfoModel.batchNumber != 0) {
                    //需要整批 购买
                    self.multipleTipLabel.hidden = NO;
                    self.multipleTipLabel.text = [NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), cellModel.batchPriceInfoModel.batchNumber];
                } else {
                    self.multipleTipLabel.hidden = YES;
                }
            }
        } else {
            self.multipleTipLabel.hidden = YES;
        }
    } else {
        //设置倍数不够提示
        if (cellModel.skuModel.editCount > 0 && cellModel.batchPriceInfoModel.batchNumber > 0 && cellModel.skuModel.editCount % self.cellModel.batchPriceInfoModel.batchNumber != 0) {
            //需要整批 购买
            self.multipleTipLabel.hidden = NO;
            self.multipleTipLabel.text = [NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), cellModel.batchPriceInfoModel.batchNumber];
        } else {
            self.multipleTipLabel.hidden = YES;
        }
    }

    self.countView.maxCount = [cellModel.skuModel.stock integerValue];
    [self.countView updateCount:cellModel.skuModel.editCount];

    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.skuImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skuImageView.mas_top);
        make.left.equalTo(self.skuImageView.mas_right).offset(kRealWidth(10));
        if (!self.countView.isHidden) {
            make.right.lessThanOrEqualTo(self.countView.mas_left).offset(-kRealWidth(15));
        } else {
            make.right.lessThanOrEqualTo(self.outOfStockLabel.mas_left).offset(-kRealWidth(15));
        }
    }];
    [self.stockLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_leading);
        if (!self.countView.isHidden) {
            make.right.lessThanOrEqualTo(self.countView.mas_left).offset(-kRealWidth(15));
        } else {
            make.right.lessThanOrEqualTo(self.outOfStockLabel.mas_left).offset(-kRealWidth(15));
        }
        if (!self.priceLabel.isHidden) {
            make.centerY.equalTo(self.skuImageView.mas_centerY);
        } else {
            make.bottom.equalTo(self.skuImageView.mas_bottom);
        }
    }];
    if (!self.priceLabel.isHidden) {
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_leading);
            make.bottom.equalTo(self.skuImageView.mas_bottom);
        }];
    }
    if (!self.outOfStockLabel.isHidden) {
        [self.outOfStockLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(20));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    if (!self.countView.isHidden) {
        [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([self.countView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];

        [self.multipleTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.countView.mas_bottom).offset(kRealWidth(5));
        }];
    }
    [super updateConstraints];
}
/** @lazy skuImageView */
- (TNSkuImageView *)skuImageView {
    if (!_skuImageView) {
        _skuImageView = [[TNSkuImageView alloc] init];
        _skuImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _skuImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
/** @lazy stockLabel */
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] init];
        _stockLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _stockLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _stockLabel;
}
/** @lazy outOfStockLabel */
- (UILabel *)outOfStockLabel {
    if (!_outOfStockLabel) {
        _outOfStockLabel = [[UILabel alloc] init];
        _outOfStockLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _outOfStockLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _outOfStockLabel.text = TNLocalizedString(@"tn_out_sold", @"缺货");
    }
    return _outOfStockLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _priceLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
    }
    return _priceLabel;
}
/** @lazy multipleTipLabel */
- (UILabel *)multipleTipLabel {
    if (!_multipleTipLabel) {
        _multipleTipLabel = [[UILabel alloc] init];
        _multipleTipLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _multipleTipLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _multipleTipLabel.hidden = YES;
    }
    return _multipleTipLabel;
}
- (TNModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = TNModifyShoppingCountView.new;
        @HDWeakify(self);
        _countView.changedCountHandler = ^(TNModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            self.cellModel.skuModel.editCount = count;
            !self.enterCountCallBack ?: self.enterCountCallBack(self.cellModel);
            //            if (count > 0 && self.cellModel.batchPriceInfoModel.batchNumber > 0 && count % self.cellModel.batchPriceInfoModel.batchNumber != 0) {
            //                //需要整批 购买
            //                self.multipleTipLabel.hidden = NO;
            //            } else {
            //                self.multipleTipLabel.hidden = YES;
            //            }
        };
        [_countView updateCount:0];
        _countView.minCount = 0;
    }
    return _countView;
}
@end


@implementation TNEditSpecCellModel

@end

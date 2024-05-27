//
//  TNGoodsModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGoodsModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyTools.h"
#import "TNDecimalTool.h"
#import "TNProductSkuModel.h"
#import "TNProductSpecificationModel.h"
#import "TNSellerProductModel.h"
#import <HDKitCore/HDKitCore.h>


@interface TNGoodsModel ()
/// 计算文本宽高的label 用来解决计算富文本高度 不准备的问题
@property (strong, nonatomic) UILabel *calculateLabel;
@end


@implementation TNGoodsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isSale": @[@"sale"]};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productImages": [TNImageModel class], @"skus": [TNProductSkuModel class], @"specs": [TNProductSpecificationModel class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 10, 8);
    }
    return self;
}
+ (instancetype)modelWithSellerProductModel:(TNSellerProductModel *)model {
    TNGoodsModel *goodModel = [[TNGoodsModel alloc] init];
    goodModel.productId = model.productId;
    goodModel.thumbnail = model.thumbnail;
    goodModel.productName = model.productName;
    goodModel.price = model.price;
    goodModel.marketPrice = model.marketPrice;
    goodModel.freightSetting = model.freightSetting;
    goodModel.isSale = model.promotion;
    goodModel.typeName = model.productType;
    goodModel.type = model.typeName;
    goodModel.sales = model.sales;
    goodModel.storeNo = model.storeNo;
    goodModel.storeName = model.storeName;
    goodModel.storeType = model.storeType;
    goodModel.enabledHotSale = model.enabledHotSale;
    return goodModel;
}
- (void)hd_configCellHeight {
    //    const CGFloat bgViewWidth = self.preferredWidth - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
    CGFloat maxLabelWidth = self.preferredWidth - kRealWidth(16);

    CGFloat height = 0;
    //上下间距
    height += kRealWidth(8);
    //    UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
    // 图片长宽1：1
    height += self.preferredWidth;
    // 图片到商品名
    height += kRealHeight(10);
    // 商品名
    if (HDIsStringNotEmpty(self.productName)) {
        if (self.productNameAttr) {
            self.calculateLabel.attributedText = self.productNameAttr;
        } else {
            self.calculateLabel.text = self.productName;
        }
        CGSize size = [self.calculateLabel sizeThatFits:CGSizeMake(maxLabelWidth, MAXFLOAT)];
        height += size.height;
    }
    //商品到标签
    if (self.isSale || self.freightSetting || self.stagePrice) {
        height += kRealHeight(8);
        height += kRealWidth(18);
    }
    // 商品名到价格
    height += kRealHeight(8);
    CGSize priceSize = [@"$100" boundingAllRectWithSize:CGSizeMake(maxLabelWidth + kRealWidth(1), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard17B];
    height += priceSize.height;

    if (self.isNeedShowSmallShopCar == YES) {
        if (HDIsStringNotEmpty(self.salesLabel)) {
            // 价格到销量
            height += [self getSaleNumberHeight];
        } else {
            height += kRealHeight(8);
        }
    } else {
        height += [self getSaleNumberHeight];
    }

    if (self.cellType == TNGoodsShowCellTypeGoodsAndStore) {
        // 价格到商户名
        height += kRealHeight(8);
        CGSize storeNameSize = [self.storeName boundingAllRectWithSize:CGSizeMake(maxLabelWidth - kRealWidth(15), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth - kRealWidth(15), MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0];
        height += storeNameSize.height < towRowsSize.height ? storeNameSize.height : towRowsSize.height;
    }

    self.cellHeight = height;
}

- (void)setPreferredWidth:(CGFloat)preferredWidth {
    _preferredWidth = preferredWidth;
    [self setProductAttrName];
    [self hd_configCellHeight];
}
- (void)setProductAttrName {
    NSString *imageName;
    if (self.storeType == TNStoreEnumTypeSelf) {
        imageName = @"tn_offcial_k";
    } else if (self.storeType == TNStoreEnumTypeOverseasShopping) {
        imageName = @"tn_global_k";
    }
    if (HDIsStringNotEmpty(imageName)) {
        UIImage *globalImage = [UIImage imageNamed:imageName];
        NSString *name = [NSString stringWithFormat:@" %@", self.productName];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image = globalImage;
        UIFont *font = HDAppTheme.TinhNowFont.standard15;
        CGFloat paddingTop = font.lineHeight - font.pointSize;
        imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width + 5, globalImage.size.height);
        NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
        [text insertAttributedString:attachment atIndex:0];
        [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
        self.productNameAttr = text;
    }
}
- (NSString *)showDisCount {
    if (HDIsObjectNil(self.price)) {
        return nil;
    }
    if (HDIsObjectNil(self.marketPrice)) {
        return nil;
    }
    NSString *disCount = nil;
    double price = self.price.cent.doubleValue;
    double marketPrice = self.marketPrice.cent.doubleValue;
    if (marketPrice <= 0) {
        return nil; //市场价未设置 也不显示
    }
    if (price > marketPrice) {
        return nil; //高于市场价 不计算折扣
    }
    NSDecimalNumber *disCountValue = [TNDecimalTool decimslDisCountNumber:self.price.cent num2:self.marketPrice.cent];
    if (disCountValue.doubleValue > 0) {
        disCount = [NSString stringWithFormat:@"-%ld%%", disCountValue.integerValue];
    }
    return disCount;
}
- (NSString *)soldOutImageName {
    NSString *imageName;
    if ([TNMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        imageName = @"tn_soldout_zh";
    } else if ([TNMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        imageName = @"tn_soldout_km";
    } else {
        imageName = @"tn_soldout_en";
    }
    return imageName;
}
//销量高度
- (CGFloat)getSaleNumberHeight {
    CGFloat height = 0;
    if (HDIsStringNotEmpty(self.salesLabel)) {
        CGFloat maxLabelWidth = self.preferredWidth - kRealWidth(16);
        // 价格到销量
        height += kRealHeight(3);
        CGFloat soldHeight = [@" " boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard11 lineSpacing:0].height;
        height += soldHeight;
    }
    return height;
}

/** @lazy calculateLabel */
- (UILabel *)calculateLabel {
    if (!_calculateLabel) {
        _calculateLabel = [[UILabel alloc] init];
        _calculateLabel.font = HDAppTheme.TinhNowFont.standard17B;
        _calculateLabel.textColor = HDAppTheme.TinhNowColor.C3;
        _calculateLabel.numberOfLines = 2;
    }
    return _calculateLabel;
}
@end

//
//  TNBargaingoodModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodModel.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>


@implementation TNBargainGoodModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activityId": @"id", @"registNewTips": @"newClientMsg"};
}

- (void)hd_configCellHeight {
    CGFloat maxLabelWidth = self.preferredWidth - kRealWidth(16);

    CGFloat height = 0;
    // 图片长宽1：1
    height += self.preferredWidth;
    // 图片到商品名
    height += kRealHeight(10);
    // 商品名
    if (HDIsStringNotEmpty(self.goodsName)) {
        CGSize size = [self.goodsName boundingAllRectWithSize:CGSizeMake(maxLabelWidth + 1, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15 lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth + 1, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15 lineSpacing:0];

        height += size.height < towRowsSize.height ? size.height : towRowsSize.height;
    }
    // 商品名到价格
    height += kRealHeight(10);
    NSString *price = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_bargain_price_k", @"价值"), self.goodsPriceMoney.thousandSeparatorAmount];
    if (HDIsStringNotEmpty(price)) {
        CGSize size = [price boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15B lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard15B lineSpacing:0];

        height += size.height < towRowsSize.height ? size.height : towRowsSize.height;
    }
    if ([self.salesNum integerValue] > 0) { //显示销量
        // 价格到销量
        height += kRealHeight(3);
        CGFloat soldHeight = [@" " boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard11 lineSpacing:0].height;
        height += soldHeight;
    }

    //价格到按钮
    height += kRealWidth(10);
    //按钮高度
    height += kRealWidth(32);
    //如果有提示文本
    if (HDIsStringNotEmpty(self.registNewTips)) {
        height += kRealWidth(13);
    }
    self.cellHeight = height;
}

- (void)setPreferredWidth:(CGFloat)preferredWidth {
    _preferredWidth = preferredWidth;
    [self hd_configCellHeight];
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
+ (instancetype)modelWithProductModel:(TNGoodsModel *)model {
    TNBargainGoodModel *bmodel = [[TNBargainGoodModel alloc] init];
    bmodel.images = model.thumbnail;
    bmodel.isVerifyNewMember = model.needNewUser;
    bmodel.goodsName = model.productName;
    bmodel.goodsPriceMoney = model.marketPrice;
    bmodel.lowestPriceMoney = model.activityPrice;
    bmodel.stockNumber = model.bargainStock;
    bmodel.registNewTips = model.activityMsg;
    bmodel.activityId = model.activityId;
    bmodel.salesNum = model.sales;
    return bmodel;
}
@end

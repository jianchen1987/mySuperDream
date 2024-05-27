//
//  TNMarkupPriceSettingConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TNProductSkuModel;

typedef NS_ENUM(NSInteger, TNMarkupPriceSettingType) {
    TNMarkupPriceSettingTypeGlobal = 0,        //全局设置加价
    TNMarkupPriceSettingTypeSingleProduct = 1, //单个商品加价
    TNMarkupPriceSettingTypeBatchProduct = 2   //批量修改商家加价
};
NS_ASSUME_NONNULL_BEGIN


@interface TNMarkupPriceSettingConfig : NSObject
@property (nonatomic, assign) TNMarkupPriceSettingType type;      ///<  全局还是单个商品
@property (nonatomic, strong) NSArray<TNProductSkuModel *> *skus; ///<  SKU数据 TNMarkupPriceSettingTypeSingleProduct  需要用到
@property (nonatomic, copy) NSString *productId;                  //单个商品改价的话 还要商品id
@property (strong, nonatomic) NSArray<NSString *> *products;      ///<商品id 数组
@property (nonatomic, copy) NSString *tips;                       ///<  提示文案
@property (nonatomic, copy) NSString *title;                      ///<  头部标题
+ (instancetype)defaultConfig;
@end

NS_ASSUME_NONNULL_END

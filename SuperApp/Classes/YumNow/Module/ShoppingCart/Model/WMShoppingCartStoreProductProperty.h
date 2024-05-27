//
//  WMShoppingCartStoreProductProperty.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartStoreProductProperty : WMModel
/// 商品属性选项名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 商品属性选项名称-英文
@property (nonatomic, copy) NSString *nameEn;
/// 商品属性选项名称-柬文
@property (nonatomic, copy) NSString *nameKm;
/// 商品属性选项名称-中文
@property (nonatomic, copy) NSString *nameZh;
/// 商品属性项id(子id)
@property (nonatomic, copy) NSString *propertyId;
/// 商品属性id(父id)
@property (nonatomic, copy) NSString *productPropertyId;
@end

NS_ASSUME_NONNULL_END

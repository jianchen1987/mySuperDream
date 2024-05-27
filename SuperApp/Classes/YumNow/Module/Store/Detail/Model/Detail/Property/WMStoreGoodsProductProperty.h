//
//  WMStoreGoodsProductProperty.h
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMStoreGoodsProductPropertyOption.h"

NS_ASSUME_NONNULL_BEGIN

/// 商品属性
@interface WMStoreGoodsProductProperty : WMModel
/// 商品属性 id
@property (nonatomic, copy) NSString *propertyId;
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 商品属性选项集合
@property (nonatomic, copy) NSArray<WMStoreGoodsProductPropertyOption *> *optionList;
/// 是否必选
@property (nonatomic, assign) BOOL required;
/// 最少选多少个
@property (nonatomic, assign) NSUInteger requiredSelection;
/// 最大可选多少个
@property (nonatomic, assign) NSUInteger maxSelection;
@end

NS_ASSUME_NONNULL_END

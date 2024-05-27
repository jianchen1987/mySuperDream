//
//  WMStoreGoodsProductPropertyOption.h
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"

@class SAMoneyModel;

NS_ASSUME_NONNULL_BEGIN

/// 商品属性选项
@interface WMStoreGoodsProductPropertyOption : WMModel
/// 属性 id
@property (nonatomic, copy) NSString *optionId;
/// 商品属性 id
@property (nonatomic, copy) NSString *propertyId;
/// 属性名称
@property (nonatomic, copy) NSString *name;
/// 属性加价
//@property (nonatomic, strong) SAMoneyModel *additionalPrice;
@property (nonatomic, strong) NSString *additionalPrice;

@property (nonatomic, assign) NSInteger additionalPriceCent;


/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END

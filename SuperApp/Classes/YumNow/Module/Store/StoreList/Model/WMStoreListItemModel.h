//
//  WMStoreListItemModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMModel.h"
#import "WMNextServiceTimeModel.h"
#import "WMSpecialActivesProductModel.h"
#import "WMSpecialStoreSignaturesModel.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreModel.h"
#import "WMStoreProductModel.h"
#import "WMStoreStatusModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMStoreListItemModel : WMStoreModel
///< 产品
@property (nonatomic, copy) NSArray<WMStoreProductModel *> *products;
///< 招牌菜
@property (nonatomic, copy) NSArray<WMSpecialStoreSignaturesModel *> *signatures;

#pragma mark - 绑定属性

@property (nonatomic, strong) NSMutableAttributedString *cateString;

@end

@interface WMStoreListNewItemModel : WMNewStoreModel
///< 产品
@property (nonatomic, copy) NSArray<WMStoreProductModel *> *products;
///< 招牌菜
@property (nonatomic, copy) NSArray<WMSpecialStoreSignaturesModel *> *signatures;

#pragma mark - 绑定属性

@property (nonatomic, strong) NSMutableAttributedString *cateString;

@end

NS_ASSUME_NONNULL_END

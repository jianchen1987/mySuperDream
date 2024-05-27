//
//  WMSpecialPromotionRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "WMRspModel.h"
#import "WMSearchStoreRspModel.h"
NS_ASSUME_NONNULL_BEGIN

@class WMSpecialActivesProductRspModel;
@class WMSpecialBrandPagingModel;


@interface WMSpecialPromotionCategoryModel : NSObject

/// 商品品类编码
@property (nonatomic, copy, nullable) NSString *categoryNo;
/// 商品品类名称
@property (nonatomic, copy) NSString *name;
/// 商品品类名称-中文
@property (nonatomic, copy) NSString *nameZh;
/// 商品品类名称-柬文
@property (nonatomic, copy) NSString *nameKm;
/// 选择状态
@property (nonatomic) BOOL isSelected;

@end


@interface WMSpecialPromotionRspModel : WMRspModel
/// 专题名称
@property (nonatomic, strong) SAInternationalizationModel *name;
/// 图片
@property (nonatomic, copy) NSString *image;
/// 类型
@property (nonatomic, copy) WMSpecialActiveType type;
/// 门店列表
@property (nonatomic, strong) WMSearchStoreNewRspModel *storesV2;
//@property (nonatomic, strong) WMSearchStoreRspModel *stores;
/// 商品列表
@property (nonatomic, strong) WMSpecialActivesProductRspModel *products;

@property (nonatomic, strong) WMSpecialBrandPagingModel *brands;

@property (nonatomic, strong) NSArray *categoryList;
/// 是否显示分栏
@property (nonatomic, assign) BOOL showCategoryBar;
/// 是否显示筛选栏
@property (nonatomic, assign) BOOL showBusiness;

@end

NS_ASSUME_NONNULL_END

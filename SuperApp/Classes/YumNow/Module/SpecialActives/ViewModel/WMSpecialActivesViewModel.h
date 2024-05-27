//
//  WMSpecialActivesViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMViewModel.h"
#import <CoreLocation/CoreLocation.h>
#import "WMCustomizationDTO.h"

NS_ASSUME_NONNULL_BEGIN
@class WMSpecialPromotionRspModel;
@class SAInternationalizationModel;
@class WMStoreListItemModel;
@class WMStoreListNewItemModel;
@class WMSpecialActivesProductModel;
@class WMSpecialBrandModel;
@class WMSpecialPromotionCategoryModel;


@interface WMSpecialActivesViewModel : WMViewModel
/// 活动编号
@property (nonatomic, copy) NSString *activeNo;
/// 类型
@property (nonatomic, copy) WMSpecialActiveType type;
/// 背景图片
@property (nonatomic, copy) NSString *backgroundImageUrl;
/// name
@property (nonatomic, strong) SAInternationalizationModel *activeName;
/// 门店列表
@property (nonatomic, strong) NSArray<WMStoreListNewItemModel *> *storeList;
/// 商品列表
@property (nonatomic, strong) NSArray<WMSpecialActivesProductModel *> *productList;
/// 分类列表
@property (nonatomic, strong) NSArray<WMSpecialPromotionCategoryModel *> *categoryList;
/// 品牌列表
@property (nonatomic, strong) NSArray<WMSpecialBrandModel *> *brandList;
/// 按时吃饭Model
@property (nonatomic, strong) WMMoreEatOnTimeRspModel *onTimeModel;
/// 专题页Model
@property (nonatomic, strong) WMSpecialPromotionRspModel *proModel;
/// 添加图片底部弧度
@property (nonatomic, assign) BOOL addBottomRadio;
/// 图片高度
@property (nonatomic, assign) CGFloat imageHeight;
#pragma mark - 埋点参数
//@property (nonatomic, copy) NSString *bannerId;         ///< id
//@property (nonatomic, strong) NSNumber *bannerLocation; ///< 位置
//@property (nonatomic, copy) NSString *bannerTitle;      ///< 标题

/// 是否显示分栏
@property (nonatomic, assign) BOOL showCategoryBar;
/// 是否显示筛选栏
@property (nonatomic, assign) BOOL showBusiness;


- (void)getNewData;
/// 根据活动号获取专题活动
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSpecialActivesWithPageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize
                            success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)getSpecialActivesWithPageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize
                         categoryNo:(NSString *)categoryNo
                            success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;


- (void)getSpecialActivesWithPageNo:(NSUInteger)pageNo
                           pageSize:(NSUInteger)pageSize
                           sortType:(NSString *)sortType
                     marketingTypes:(NSArray<NSString *> *)marketingTypes
                       storeFeature:(NSArray<NSString *> *)storeFeature
                       businessCode:(NSString *)businessCode
                            success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据按时吃饭专题活动
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getEatOnTimeWithId:(NSString *)ID pageNo:(NSUInteger)pageNo success:(void (^_Nullable)(WMMoreEatOnTimeRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END

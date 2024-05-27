//
//  GNHomeCustomViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNArticlePagingRspModel.h"
#import "GNFilterModel.h"
#import "GNHomeDTO.h"
#import "GNStoreViewCell.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeCustomViewModel : GNViewModel
/// 门店数据源
@property (nonatomic, strong) NSMutableArray<GNStoreCellModel *> *dataSource;
/// 筛选
@property (nonatomic, strong) GNFilterModel *filterModel;

/// 获取栏目门店
/// @param columnCode code
/// @param columnType 类型
/// @param pageNum 分页
/// @param completion 回调
- (void)getColumnStoreDataCode:(nullable NSString *)columnCode
                    columnType:(nullable GNHomeColumnType)columnType
                       pageNum:(NSInteger)pageNum
                    completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion;

/// 获取栏目文章
/// @param columnCode code
/// @param columnType 类型
/// @param pageNum 分页
/// @param completion 回调
- (void)getColumnArticleDataCode:(nullable NSString *)columnCode
                      columnType:(nullable GNHomeColumnType)columnType
                         pageNum:(NSInteger)pageNum
                      completion:(nullable void (^)(GNArticlePagingRspModel *rspModel, BOOL error))completion;

/// 获取分类下门店
/// @param classificationCode code
/// @param pageNum 分页
/// @param completion 回调
- (void)getClassificationStoreDataCode:(nullable NSString *)classificationCode
                            parentCode:(nullable NSString *)parentCode
                               pageNum:(NSInteger)pageNum
                            completion:(nullable void (^)(GNStorePagingRspModel *rspModel, BOOL error))completion;

/// 获取分类下商品
/// @param classificationCode code
/// @param pageNum 分页
/// @param completion 回调
- (void)getClassificatioProductDataCode:(nullable NSString *)classificationCode
                             parentCode:(nullable NSString *)parentCode
                                pageNum:(NSInteger)pageNum
                             completion:(nullable void (^)(GNProductPagingRspModel *rspModel, BOOL error))completion;

@end

NS_ASSUME_NONNULL_END

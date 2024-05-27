//
//  GNStoreDetailViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCommentPagingRspModel.h"
#import "GNProductModel.h"
#import "GNStoreDetailModel.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreDetailViewModel : GNViewModel
///数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;
///详情
@property (nonatomic, strong, nullable) GNStoreDetailModel *detailModel;
///刷新
@property (nonatomic, assign) BOOL refreshFlag;
///获取商家详情
///@param storeNO 门店id
///@param productCode 商品id 可为空
- (void)getStoreDetailStoreNo:(nonnull NSString *)storeNO productCode:(nullable NSString *)productCode;

/// 评论
///@param storeNO 门店id
///@param productCode 商品id 可为空
///@param pageNum 分页
///@param completion 回调
- (void)getStoreReviewStoreNo:(nonnull NSString *)storeNO
                  productCode:(nullable NSString *)productCode
                      pageNum:(NSInteger)pageNum
                   completion:(nullable void (^)(GNCommentPagingRspModel *rspModel, BOOL error))completion;
@end

NS_ASSUME_NONNULL_END

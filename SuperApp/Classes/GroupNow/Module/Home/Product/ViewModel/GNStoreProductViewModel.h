//
//  GNStoreProductViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommentPagingRspModel.h"
#import "GNProductModel.h"
#import "GNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreProductViewModel : GNViewModel
///详情model
@property (nonatomic, strong) GNProductModel *productModel;
///评价section
@property (nonatomic, strong) GNSectionModel *commentSection;
///评价头部
@property (nonatomic, strong) GNCellModel *commentHeadModel;
///评价占位
@property (nonatomic, strong) GNCellModel *notCommentModel;
///数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;

/// 产品详情
- (void)getProductDetailStoreNo:(nonnull NSString *)code completion:(nullable void (^)(void))completion;

/// 产品评论列表
- (void)getStoreReviewStoreNo:(nonnull NSString *)storeNO
                  productCode:(nullable NSString *)productCode
                      pageNum:(NSInteger)pageNum
                   completion:(nullable void (^)(GNCommentPagingRspModel *rspModel, BOOL error))completion;
@end

NS_ASSUME_NONNULL_END

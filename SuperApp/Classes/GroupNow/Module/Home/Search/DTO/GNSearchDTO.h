//
//  GNSearchDTO.h
//  SuperApp
//
//  Created by wmz on 2021/6/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "GNStorePagingRspModel.h"
#import "SAAppEnvManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNSearchDTO : GNModel

/// 搜索
/// @param keyword 搜索关键词
/// @param pageNum  页码
- (CMNetworkRequest *_Nullable)merchantSearchKeyword:(nullable NSString *)keyword
                                             pageNum:(NSInteger)pageNum
                                             success:(nullable void (^)(GNStorePagingRspModel *rspModel))successBlock
                                             failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 为您推荐
/// @param pageNum  页码
- (CMNetworkRequest *_Nullable)merchantRecommendedForYouPageNum:(NSInteger)pageNum
                                                        success:(nullable void (^)(GNStorePagingRspModel *rspModel))successBlock
                                                        failure:(nullable CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END

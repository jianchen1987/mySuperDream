//
//  TNMyReviewDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNMyHadReviewListRspModel;
@class TNMyNotReviewListRspModel;


@interface TNMyReviewDTO : TNModel
- (void)queryMyHadReviewListWithPageNum:(NSUInteger)pageNum
                               pageSize:(NSUInteger)pageSize
                                success:(void (^_Nullable)(TNMyHadReviewListRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)queryMyNotReviewListWithPageNum:(NSUInteger)pageNum
                               pageSize:(NSUInteger)pageSize
                                success:(void (^_Nullable)(TNMyNotReviewListRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 发布评论
- (void)postReviewData:(NSString *)postData success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;


/// 获取评价公告
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getReviewNoticeWithSuccess:(void (^_Nullable)(NSDictionary *data))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END

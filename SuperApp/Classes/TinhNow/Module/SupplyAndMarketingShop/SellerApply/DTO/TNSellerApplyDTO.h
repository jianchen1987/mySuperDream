//
//  TNSellerApplyDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNSellerApplyModel;
@class TNCommonAdvRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerApplyDTO : TNModel
// 获取卖家申请详情数据
- (void)querySellerApplyDataSuccess:(void (^)(TNSellerApplyModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
// 获取卖家广告位图片
- (void)querySellerApplyAdvById:(NSString *)advId success:(void (^)(TNCommonAdvRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;
// 卖家申请
- (void)postSellerApplyByModel:(TNSellerApplyModel *)applyModel success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END

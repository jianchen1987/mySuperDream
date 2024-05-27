//
//  TNReviewDTO.h
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNQueryProductReviewListRspModel;


@interface TNReviewDTO : TNModel
//是否显示错误弹窗  默认显示
@property (nonatomic, assign) BOOL showAlertErrorMsgExceptSpecCode;

- (void)queryProductReviewListWithProductId:(NSString *)productId
                                    pageNum:(NSUInteger)pageNum
                                   pageSize:(NSUInteger)pageSize
                                    success:(void (^_Nullable)(TNQueryProductReviewListRspModel *rspModel))successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END

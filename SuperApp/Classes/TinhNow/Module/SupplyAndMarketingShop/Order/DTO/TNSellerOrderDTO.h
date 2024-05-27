//
//  TNSellerOrderDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderRspModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderDTO : NSObject

/// 请求卖家订单列表数据
/// @param pageNo 页码
/// @param pageSize 页数
/// @param status 订单状态
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)querySellerOrderListWithPageNo:(NSInteger)pageNo
                              pageSize:(NSInteger)pageSize
                                status:(TNSellerOrderStatus)status
                               success:(void (^_Nullable)(TNSellerOrderRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END

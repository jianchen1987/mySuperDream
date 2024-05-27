//
//  TNMyCustomerDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyCustomerRspModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNMyCustomerDTO : NSObject

// 我的客户 列表
- (void)queryMyCustomerListWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize success:(void (^)(TNMyCustomerRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END

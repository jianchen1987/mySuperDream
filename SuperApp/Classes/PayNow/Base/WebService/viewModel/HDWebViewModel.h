//
//  HDWebViewModel.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/27.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "PNModel.h"
#import "PNNetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDWebViewModel : PNModel

+ (instancetype)share;

- (void)postWebIntferface:(NSString *)interfaceText parameter:(NSDictionary *)param success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END

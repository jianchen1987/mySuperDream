//
//  HDWebViewModel.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/27.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDBaseViewModel.h"


@interface HDWebViewModel : HDBaseViewModel

+ (instancetype)share;

- (void)postWebIntferface:(NSString *)interfaceText
                parameter:(NSDictionary *)param
                  success:(void (^)(HDJsonRspModel *rspModel))success
       transactionFailure:(TransactionFailureBlock)transactionFailBlock
           networkFailure:(NetworkRequestFailBlock)networkFailureBlock;
@end

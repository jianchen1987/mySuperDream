//
//  HDWebViewModel.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/27.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebViewModel.h"

static HDWebViewModel *_webViewModel;


@implementation HDWebViewModel

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _webViewModel = [[HDWebViewModel alloc] init];
    });

    return _webViewModel;
}

- (void)postWebIntferface:(NSString *)interfaceText
                parameter:(NSDictionary *)param
                  success:(void (^)(HDJsonRspModel *rspModel))success
       transactionFailure:(TransactionFailureBlock)transactionFailBlock
           networkFailure:(NetworkRequestFailBlock)networkFailureBlock {
    HDJsonReqModel *reqModel = [[HDJsonReqModel alloc] init];
    reqModel.retryCount = 2;
    [reqModel setReqParams:param];
    [self processRequest:reqModel url:interfaceText success:^(id rspResponse) {
        HDJsonRspModel *model = [[HDJsonRspModel alloc] initWithJson:rspResponse];
        if ([model parse]) {
            !success ?: success(model);
        }
    } transactionFailure:^(HDBaseViewModel *viewModel, NSString *reason, NSString *code) {
        transactionFailBlock(viewModel, reason, code);
    } networkRequestFail:^(NSError *error) {
        networkFailureBlock(error);
    }];
}

@end

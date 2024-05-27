//
//  SAImFeedbackViewModel.m
//  SuperApp
//
//  Created by Tia on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAImFeedbackViewModel.h"


@interface SAImFeedbackViewModel ()

/// 发布建议与反馈
@property (nonatomic, strong) CMNetworkRequest *publishSuggestionRequest;

@end


@implementation SAImFeedbackViewModel

- (void)saveFeedbackWithType:(NSString *)type
              fromOperatorNo:(NSString *)fromOperatorNo
            fromOperatorType:(NSInteger)fromOperatorType
                toOperatorNo:(NSString *)toOperatorNo
              toOperatorType:(NSInteger)toOperatorType
                 description:(NSString *)description
                   imageUrls:(NSArray *)imageUrls
                     success:(dispatch_block_t)successBlock
                     failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/notification/imsystem/feedback/saveFeedback.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(description)) {
        [params setValue:description forKey:@"description"];
    }
    if (!HDIsArrayEmpty(imageUrls)) {
        [params setValue:imageUrls forKey:@"imageUrls"];
    }
    params[@"feedbackType"] = type;
    params[@"fromOperatorNo"] = fromOperatorNo;
    params[@"fromOperatorType"] = @(fromOperatorType);
    params[@"toOperatorNo"] = toOperatorNo;
    params[@"toOperatorType"] = @(toOperatorType);

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end

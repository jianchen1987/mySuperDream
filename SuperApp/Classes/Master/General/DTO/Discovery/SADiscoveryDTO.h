//
//  SADiscoveryDTO.h
//  SuperApp
//
//  Created by seeu on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SADiscoveryDTO : SAModel

+ (void)likeContentWithContentId:(NSString *_Nonnull)contentId taskId:(NSString *_Nullable)taskId success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

+ (void)unlikeContentWithContentId:(NSString *)contentId success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

+ (void)reportContentWithContentId:(NSString *)contentId
                            reason:(NSString *_Nonnull)reason
                           bizType:(NSString *_Nonnull)bizType
                           success:(void (^)(void))successBlock
                           failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END

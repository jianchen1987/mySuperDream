//
//  GNArticleDTO.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleModel.h"
#import "GNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNArticleDTO : GNModel

///文章详情
///@param articleCode 文章code
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getArticleDetailWithCode:(NSString *)articleCode success:(void (^)(GNArticleModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END

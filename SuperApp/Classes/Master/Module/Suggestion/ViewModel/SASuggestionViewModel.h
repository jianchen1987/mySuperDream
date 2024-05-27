//
//  SASuggestionViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SASuggestionDetailModel.h"


@interface SASuggestionViewModel : SAViewModel

@property (nonatomic, copy) NSString *suggestionInfoId;

@property (nonatomic, strong) SASuggestionDetailModel *model;

/// 发布建议与反馈
/// @param content 内容
/// @param images 图片
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)publishSuggestionWithContent:(NSString *)content images:(NSArray<NSString *> *)images success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取意见详情内容
- (void)querySuggestionDetail;

/// 意见反馈状态
/// @param agree 是否已解决
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)clientUpdateStatusWithAgree:(BOOL)agree success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

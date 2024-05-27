//
//  SAImFeedbackViewModel.h
//  SuperApp
//
//  Created by Tia on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAImFeedbackViewModel : SAViewModel

@property (nonatomic, copy) NSString *fromOperatorNo;
@property (nonatomic, assign) NSInteger fromOperatorType;
@property (nonatomic, copy) NSString *toOperatorNo;
@property (nonatomic, assign) NSInteger toOperatorType;

/// 保存反馈
/// @param type 反馈类型 service_quality：服务质量 disturbance：骚扰干扰 false_content：内容不实 inferior_goods：劣质商品 other：其他
/// @param toOperatorNo 对方操作员编号
/// @param toOperatorType 对方操作员类型
/// @param description 详细描述
/// @param imageUrls 图片
/// @param fromOperatorNo 反馈人操作员编号
/// @param fromOperatorType 反馈人操作员类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)saveFeedbackWithType:(NSString *)type
              fromOperatorNo:(NSString *)fromOperatorNo
            fromOperatorType:(NSInteger)fromOperatorType
                toOperatorNo:(NSString *)toOperatorNo
              toOperatorType:(NSInteger)toOperatorType
                 description:(NSString *)description
                   imageUrls:(NSArray *)imageUrls
                     success:(dispatch_block_t)successBlock
                     failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END

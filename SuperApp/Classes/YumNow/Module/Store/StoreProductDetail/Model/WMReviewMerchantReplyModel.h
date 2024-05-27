//
//  WMReviewMerchantReplyModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 评论商家回复
@interface WMReviewMerchantReplyModel : WMModel
/// 评论实体编号
@property (nonatomic, copy) NSString *entityNo;
/// 评论时间
@property (nonatomic, assign) NSTimeInterval createTime;
/// 业务线
@property (nonatomic, copy) NSString *businessline;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 图片
@property (nonatomic, copy) NSArray<NSString *> *imageUrls;
/// 回复ID
@property (nonatomic, copy) NSString *replyId;
/// 匿名状态
@property (nonatomic, assign) WMReviewAnonymousState anonymous;
/// 父级ID
@property (nonatomic, copy) NSString *pId;
/// 评论ID
@property (nonatomic, copy) NSString *reviewId;
/// 评论内容
@property (nonatomic, copy) NSString *content;
/// 评论实体类型
@property (nonatomic, copy) WMReviewEntityType entityType;
/// 评论状态开关
@property (nonatomic, copy) SABoolValue status;
@end

NS_ASSUME_NONNULL_END

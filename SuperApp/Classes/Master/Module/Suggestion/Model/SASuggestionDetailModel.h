//
//  SASuggestionDetailModel.h
//  SuperApp
//
//  Created by Tia on 2022/11/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASuggestionDetailModel : SAModel
/// 回复的内容
@property (nonatomic, copy) NSString *contentOfReply;
/// 创建时间
@property (nonatomic, assign) NSInteger createTime;
/// 图片
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
/// 回复的图片
@property (nonatomic, strong) NSArray<NSString *> *imageUrlsOfReply;
/// 回复人
@property (nonatomic, copy) NSString *replier;
/// 回复人工号
@property (nonatomic, copy) NSString *replierNo;
/// 回复时间
@property (nonatomic, assign) NSInteger replyTime;
/// 是否已经解决，用于展示是否显示给客户解决两个按钮 10-未解决 11-已经解决
@property (nonatomic, assign) NSInteger solutionStatus;
/// 意见内容
@property (nonatomic, copy) NSString *suggestContent;
/// 详情的id
@property (nonatomic, assign) NSInteger suggestionInfoId;
/// 回复的标题
@property (nonatomic, copy) NSString *titleOfReply;

@end

NS_ASSUME_NONNULL_END

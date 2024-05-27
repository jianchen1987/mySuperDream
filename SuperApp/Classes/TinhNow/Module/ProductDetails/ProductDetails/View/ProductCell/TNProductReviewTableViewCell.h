//
//  TNProductReviewTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/26.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNProductReviewModel;
@class TNReviewMerchantReplyModel;


@interface TNProductReviewTableViewCellModel : TNModel
/// 头像地址
@property (nonatomic, copy) NSString *headImageUrl;
/// 姓名
@property (nonatomic, copy) NSString *reviewerName;
/// 评论时间
@property (nonatomic, assign) NSTimeInterval timeInterval;
/// 评分
@property (nonatomic, strong) NSNumber *score;
/// 评论内容
@property (nonatomic, copy) NSString *content;
/// 图片
@property (nonatomic, strong) NSArray *images;
/// 商户回复
@property (nonatomic, strong) NSArray<TNReviewMerchantReplyModel *> *merchantReplys;

+ (TNProductReviewTableViewCellModel *)modelWithProductReviewModel:(TNProductReviewModel *)reviewMoel;

//********************绑定属性***********/
/// 有多少条评论数据
@property (nonatomic, assign) NSInteger totalReviews;
@end


@interface TNProductReviewTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNProductReviewTableViewCellModel *model;
@end


@interface TNReviewReplyView : TNView
/// model
@property (nonatomic, strong) TNReviewMerchantReplyModel *model;
@end

NS_ASSUME_NONNULL_END

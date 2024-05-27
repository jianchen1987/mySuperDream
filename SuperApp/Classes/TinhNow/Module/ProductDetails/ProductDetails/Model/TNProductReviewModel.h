//
//  TNProductReviewModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"
#import "SAInternationalizationModel.h"
NS_ASSUME_NONNULL_BEGIN

@class TNReviewMerchantReplyModel;
@class TNMyHadReviewModel;


@interface TNReviewMerchantReplyModel : TNModel
/// 回复id
@property (nonatomic, copy) NSString *replyId;
/// 回复时间
@property (nonatomic, assign) NSTimeInterval createTime;
/// 父级Id
@property (nonatomic, copy) NSString *pId;
/// 内容
@property (nonatomic, copy) NSString *content;
/// BOOL
@property (nonatomic, assign) BOOL anoymous;
/// 回复者名称
@property (nonatomic, copy) NSString *replyName;
/// 回复图片
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
@end


@interface TNProductReviewModel : TNModel
/// 评论id
@property (nonatomic, copy) NSString *reviewId;
/// 头像
@property (nonatomic, copy) NSString *head;
/// 创建日期
@property (nonatomic, assign) NSTimeInterval createdDate;
/// 是否匿名
@property (nonatomic, assign) BOOL anonymous;
/// 内容
@property (nonatomic, copy) NSString *content;
/// 卖家
@property (nonatomic, copy) NSString *username;
/// 评分
@property (nonatomic, strong) NSNumber *itemScore;
/// 图片
@property (nonatomic, strong) NSArray *images;
/// 规格
@property (nonatomic, strong) NSArray *specifications;
/// 商户回复
@property (nonatomic, strong) NSArray<TNReviewMerchantReplyModel *> *replys;

/*****************我的评论列表用字段******************/
/// 商品id
@property (nonatomic, copy) NSString *itemId;
/// 商品价格
@property (strong, nonatomic) SAMoneyModel *price;
/// 商品数量
@property (nonatomic, assign) NSInteger quantity;
/// 小计
@property (strong, nonatomic) SAMoneyModel *totalPrice;
/// 缩虐图
@property (nonatomic, copy) NSString *thumbnail;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺名字
@property (nonatomic, strong) SAInternationalizationModel *storeNameMap;
/// 商品名称
@property (strong, nonatomic) SAInternationalizationModel *itemNameMap;
/// 订单id
@property (nonatomic, copy) NSString *orderNo;

/*****************绑定属性******************/
/// 是否开展显示
@property (nonatomic, assign) BOOL isExtend;
/// 是否来自我的评价页面
@property (nonatomic, assign) BOOL isFromMyReview;


/// 转换模型  将已评价模型 转换为商品模型复用
+ (instancetype)transformModelWithMyReviewModel:(TNMyHadReviewModel *)model;
@end

NS_ASSUME_NONNULL_END

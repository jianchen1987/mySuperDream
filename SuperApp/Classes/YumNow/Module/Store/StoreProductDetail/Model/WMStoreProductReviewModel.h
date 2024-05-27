//
//  WMStoreProductReviewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMReviewMerchantReplyModel.h"
#import "WMStoreReviewGoodsModel.h"
#import "WMUserReviewStoreInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WMStoreProductReviewCellType) {
    WMStoreProductReviewCellTypeProductDetail = 0, ///< 商品详情页，不展示星星，显示点赞按钮，不展示门店信息，不展示配送服务
    WMStoreProductReviewCellTypeAllReviews,        ///< 所有评价页，不展示星星，显示点赞按钮，不展示门店信息，不展示配送服务
    WMStoreProductReviewCellTypeStoreReview,       ///< 门店评论页，展示星星，不显示点赞按钮，展示商品标签，不展示门店信息，不展示配送服务
    WMStoreProductReviewCellTypeMyReview,          ///< 我的评价页，展示星星，显示点赞按钮，展示商品标签，展示门店信息，展示配送服务
};


@interface WMStoreProductReviewModel : WMModel
/// 创建时间
@property (nonatomic, assign) NSTimeInterval createTime;
/// 踩赞状态，不要被后端取名误导
@property (nonatomic, assign) WMReviewPraiseHateState dislike;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 评论 ID
@property (nonatomic, copy) NSString *reviewId;
/// 用户头像地址
@property (nonatomic, copy) NSString *head;
/// 用户名称
@property (nonatomic, copy) NSString *nickName;
/// 评分
@property (nonatomic, assign) float score;
/// 配送服务评分
@property (nonatomic, assign) float deliveryScore;
/// 配送服务评分显示
@property (nonatomic, copy) NSString *deliveryScoreStr;
/// 匿名状态
@property (nonatomic, assign) WMReviewAnonymousState anonymous;
/// 评论内容
@property (nonatomic, copy) NSString *content;
/// 图片
@property (nonatomic, copy) NSArray<NSString *> *imageUrls;
/// 标签
@property (nonatomic, copy) NSArray<NSString *> *tags;
/// 商家回复
@property (nonatomic, copy) NSArray<WMReviewMerchantReplyModel *> *replys;
/// 踩赞商品列表
@property (nonatomic, copy) NSArray<WMStoreReviewGoodsModel *> *itemBasicInfoRespDTOS;
/// 门店信息
@property (nonatomic, strong) WMUserReviewStoreInfoModel *storeInfo;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;

#pragma mark - 以下属性为绑定属性
/// cell 显示图片的最大张数，默认 3
@property (nonatomic, assign) NSInteger maxShowImageCount;
/// 名称显示行数，默认 1
@property (nonatomic, assign) NSInteger numberOfLinesOfNameLabel;
/// 用户评论是否展开
@property (nonatomic, assign) BOOL isUserReviewContentExpanded;
/// 评论内容超过多少行时就显示查看更多，默认 3，0 代表不显示 readMore，行数限制以 numberOfLinesOfReviewContentLabel 为准
@property (nonatomic, assign) NSInteger contentMaxRowCount;
/// 评论内容显示行数，默认 默认 3
@property (nonatomic, assign) NSInteger numberOfLinesOfReviewContentLabel;
/// 商家评论是否展开
@property (nonatomic, assign) BOOL isMerchantReplyExpanded;
/// 商家评论超过多少行时就显示查看更多，默认 3，0 代表不显示 readMore，行数限制以 numberOfLinesOfMerchantReplyLabel 为准
@property (nonatomic, assign) NSInteger merchantReplyMaxRowCount;
/// 商家回复显示行数，默认 默认 3
@property (nonatomic, assign) NSInteger numberOfLinesOfMerchantReplyLabel;
/// cell 风格
@property (nonatomic, assign) WMStoreProductReviewCellType cellType;
/// 是否需要隐藏底部线
@property (nonatomic, assign) BOOL needHideBottomLine;
@end

NS_ASSUME_NONNULL_END

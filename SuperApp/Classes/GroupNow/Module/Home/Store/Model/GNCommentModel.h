//
//  GNCommentModel.h
//  SuperApp
//
//  Created by wmz on 2021/9/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNProductModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GNReviewModel;


@interface GNCommentModel : GNCellModel
/// id
@property (nonatomic, copy) NSString *ids;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 订单编号
@property (nonatomic, copy) NSString *orderNo;
/// 商品编号
@property (nonatomic, copy) NSString *productCode;
/// 分数
@property (nonatomic, assign) CGFloat reviewScore;
/// 图片
@property (nonatomic, copy) NSString *reviewPhoto;
/// 内容
@property (nonatomic, copy) NSString *reviewContent;
/// 客户编号
@property (nonatomic, copy) NSString *customerNo;
/// 客户账号
@property (nonatomic, copy) NSString *customerLogin;
/// 客户名称
@property (nonatomic, copy) NSString *customerName;
/// 客户图片
@property (nonatomic, copy) NSString *customerHeadPhoto;
/// 评论回复
@property (nonatomic, copy) NSArray<GNReviewModel *> *reply;
/// 商品信息
@property (nonatomic, strong) GNProductModel *productInfo;
/// time
@property (nonatomic, assign) NSTimeInterval createTime;
/// height
@property (nonatomic, assign) CGFloat height;
/// 客户名称
@property (nonatomic, copy) NSString *customerNameStr;

@end


@interface GNReviewModel : GNCellModel
/// 所属评论ID
@property (nonatomic, copy) NSString *reviewId;
/// 回复人昵称
@property (nonatomic, copy) NSString *replyName;
/// 回复内容
@property (nonatomic, copy) NSString *replyContent;

@end

NS_ASSUME_NONNULL_END

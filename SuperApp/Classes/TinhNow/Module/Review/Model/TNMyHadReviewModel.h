//
//  TNMyHadReviewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"
#import "SAInternationalizationModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNMyHadReviewModel : TNModel
/// 商品名称
@property (strong, nonatomic) SAInternationalizationModel *itemNameMap;
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
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 头像
@property (nonatomic, copy) NSString *head;
/// 评论内容
@property (nonatomic, copy) NSString *content;
/// 是否匿名 10-匿名,11-非匿名
@property (nonatomic, assign) NSInteger anonymous;
/// 商品评分 1-Bad,2-Not Bad,3-Good,4-Great,5-Excellent
@property (nonatomic, strong) NSNumber *score;
/// 评论图片数组
@property (strong, nonatomic) NSArray *imageUrls;
/// 订单id
@property (nonatomic, copy) NSString *orderNo;
/// 评论
@property (strong, nonatomic) NSArray *replys;
/// 评论时间
@property (nonatomic, assign) NSTimeInterval createTime;
@end

NS_ASSUME_NONNULL_END

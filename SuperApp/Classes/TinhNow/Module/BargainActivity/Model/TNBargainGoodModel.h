//
//  TNBargaingoodModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNGoodsModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainGoodModel : TNModel
///// 任务id
//@property (nonatomic, copy) NSString *taskId;
/// 备注
@property (nonatomic, copy) NSString *remark;
/// 状态 1:未开始;2:进行中;3:暂停中;4:已结束
@property (nonatomic, assign) NSString *status;
/// 砍价成功后的最低价
@property (strong, nonatomic) SAMoneyModel *lowestPriceMoney;
/// 砍价限制 理应放在规则说明中
@property (nonatomic, copy) NSString *bargainLimit;
/// 商品名称
@property (nonatomic, copy) NSString *goodsName;
/// 限制次数
@property (nonatomic, assign) NSInteger limitTimes;
/// 商品原价
@property (strong, nonatomic) SAMoneyModel *goodsPriceMoney;
/// 图片
@property (nonatomic, copy) NSString *images;
/// 店铺名称
@property (nonatomic, copy) NSString *shopName;
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// 商品规格
@property (nonatomic, copy) NSString *goodsSpec;
/// 开始时间
@property (nonatomic, copy) NSString *startTime;
/// 结束时间
@property (nonatomic, copy) NSString *endTime;
/// 限购数量
@property (nonatomic, assign) NSInteger limitPurchasing;
/// 砍价活动id
@property (nonatomic, copy) NSString *activityId;
/// 要求助力人数
@property (nonatomic, assign) NSInteger requiredUsers;
/// 库存数量
@property (nonatomic, assign) NSInteger stockNumber;
/// 过期时间
@property (nonatomic, assign) NSTimeInterval expiredTimeMillis;
/// 优惠叠加 理应放在规则说明中
@property (nonatomic, copy) NSString *favourableTerms;
/// 新注册用户提示
@property (nonatomic, copy) NSString *registNewTips;
/// 是否显示新用户
@property (nonatomic, assign) BOOL isVerifyNewMember;
/// 是否需要下载app打开
@property (nonatomic, assign) BOOL isOpenBargainExponent;
/// 成交数量
@property (nonatomic, assign) NSInteger fixtureNum;
/// cell宽度
@property (nonatomic, assign) CGFloat preferredWidth;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 销量
@property (nonatomic, copy) NSNumber *salesNum;
/// 售罄本地三语图片地址
@property (nonatomic, copy) NSString *soldOutImageName;
/// sku大图  用于预览大图
@property (nonatomic, copy) NSString *skuLargeImg;

+ (instancetype)modelWithProductModel:(TNGoodsModel *)model;
@end

NS_ASSUME_NONNULL_END

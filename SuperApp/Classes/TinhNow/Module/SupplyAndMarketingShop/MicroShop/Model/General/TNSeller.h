//
//  TNSeller.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopPricePolicyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSeller : TNModel
/// 用户名 用户对比是否更换了账号
@property (nonatomic, copy) NSString *loginName;
/// 卖家ID
@property (nonatomic, copy) NSString *supplierId;
/// 卖家店铺图片
@property (nonatomic, copy) NSString *supplierImage;
/// 卖家code
@property (nonatomic, copy) NSString *sp;
/// 名称
@property (nonatomic, copy) NSString *nickName;
/// 卖家身份 1: 普通卖家 2: 兼职卖家
@property (nonatomic, assign) TNSellerIdentityType type;
/// 是否曾经做过兼职（1：是、2：否）
@property (nonatomic, assign) NSInteger everParttime;
/// 卖家加价策略
@property (strong, nonatomic) TNMicroShopPricePolicyModel *_Nullable pricePolicyModel;
/// 是否是卖家
@property (nonatomic, assign) BOOL isSeller;
/// 卖家身份是否可用
@property (nonatomic, assign) BOOL status;

///是否需要刷新微店列表   因为是单例  在选品中心   店铺   详情加入销售后  都需要重新刷新微店
@property (nonatomic, assign) BOOL isNeedRefreshMicroShop;
/// 是否优质卖家
@property (nonatomic, assign) BOOL isHonor;
///是否需要显示兼职收益
@property (nonatomic, assign) BOOL isNeedShowPartTimeIncome;

@end

NS_ASSUME_NONNULL_END

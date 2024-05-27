//
//  TNMyNotReviewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

//店铺模型
@interface TNMyNotReviewStoreInfo : TNModel
/// 店铺类型   type =  SELF 表示自营  需要展示自营标签
@property (nonatomic, copy) NSString *type;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 店铺电话
@property (nonatomic, copy) NSString *storePhone;
/// 店铺名称
@property (nonatomic, copy) NSString *name;
@end

//商品模型
@interface TNMyNotReviewGoodInfo : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 数量
@property (nonatomic, assign) NSInteger quantity;
/// 图片
@property (nonatomic, copy) NSString *thumbnail;
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 规格
@property (strong, nonatomic) NSArray *specificationValue;
/// 价格
@property (strong, nonatomic) SAMoneyModel *price;
@end


@interface TNMyNotReviewModel : TNModel
/// 店铺数据
@property (strong, nonatomic) TNMyNotReviewStoreInfo *storeInfo;
/// 商品数据
@property (strong, nonatomic) NSArray<TNMyNotReviewGoodInfo *> *items;
/// 中台统一订单号
@property (nonatomic, copy) NSString *unifiedOrderNo;
@end

NS_ASSUME_NONNULL_END

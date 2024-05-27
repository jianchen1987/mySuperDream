//
//  TNSellerOrderModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
typedef NS_ENUM(NSInteger, TNSellerOrderStatus) {
    TNSellerOrderStatusPaid = 0,           //已付款
    TNSellerOrderStatusFinish = 1,         //已结算
    TNSellerOrderStatusExpired = 2,        //已失效
    TNSellerOrderStatusDrawCash = 3,       //已提现 新版本也代表已结算
    TNSellerOrderStatusPendingPayment = 4, //待付款
};
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderProductsModel : TNModel
///商品图片、缩略图
@property (nonatomic, copy) NSString *thumbnail;
///商品名称
@property (nonatomic, copy) NSString *productName;
///数量
@property (nonatomic, copy) NSString *quantity;
///销售价
@property (strong, nonatomic) SAMoneyModel *price;
///卖家收益
@property (strong, nonatomic) SAMoneyModel *supplierProfit;
///规格列
@property (strong, nonatomic) NSArray<NSString *> *specsList;
/// 收益类型 0:预估收益 1结算收益
@property (nonatomic, assign) NSInteger profitType;
@end


@interface TNSellerOrderModel : TNModel
///订单编号
@property (nonatomic, copy) NSString *unifiedOrderNo;
///订单状态
@property (nonatomic, assign) TNSellerOrderStatus status;
///下单时间 字符串 ’2021-11-26 16:00:08‘
@property (nonatomic, copy) NSString *createdDate;
///用户昵称
@property (nonatomic, copy) NSString *nickName;
///用户头像
@property (nonatomic, copy) NSString *headImgUrl;
///失效原因
@property (nonatomic, copy) NSString *invalidReason;
///订单商品信息
@property (strong, nonatomic) NSArray<TNSellerOrderProductsModel *> *supplierProductDTOList;
/// 收益类型  1普通收益  2兼职收益
@property (nonatomic, assign) TNSellerIdentityType commissionType;
/// 海外购渠道  有值就是海外购
@property (nonatomic, copy) NSString *overseaChannel;
/// 收货人电话
@property (nonatomic, copy) NSString *phone;

@end

NS_ASSUME_NONNULL_END

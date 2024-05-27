//
//  GNOrderSubmitViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderDTO.h"
#import "GNReserveRspModel.h"
#import "GNViewModel.h"
#import "WMOrderSubmitRspModel.h"

@class GNReserveRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderSubmitViewModel : GNViewModel
/// 数据源
@property (nonatomic, strong) NSMutableArray<GNSectionModel *> *dataSource;
/// section
@property (nonatomic, strong) GNSectionModel *productSection;
/// 小计Model
@property (nonatomic, strong) GNCellModel *subtotalModel;
/// 增值税Model
@property (nonatomic, strong) GNCellModel *vatModel;
/// 使用优惠码Model
@property (nonatomic, strong) GNCellModel *usePromoCodeModel;
/// 优惠码Model
@property (nonatomic, strong) GNCellModel *promoCodeModel;
/// 预约Model
@property (nonatomic, strong) GNCellModel *reserveModel;
/// 优惠码
@property (nonatomic, copy, nullable) NSString *promoCode;
/// 抢购model
@property (nonatomic, strong, nullable) GNOrderRushBuyModel *rushBuyModel;

///获取抢购信息
- (void)getRushBuyDetailStoreNo:(nonnull NSString *)storeNo code:(nonnull NSString *)code completion:(void (^)(NSString *error))completion;

///优惠码计算
- (void)getPromoCodeInfoWithPromoCode:(NSString *)promoCode completion:(void (^)(GNPromoCodeRspModel *rspModel, NSString *errorCode))completion;

/// 支付
- (void)submitOrderWithInfo:(nonnull GNOrderRushBuyModel *)info completion:(void (^)(WMOrderSubmitRspModel *rspModel, NSString *errorCode))completion;
@end

NS_ASSUME_NONNULL_END

//
//  GNOrderViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderViewModel.h"
#import "GNOrderDTO.h"
#import "SAGeneralUtil.h"
#import "SAMoneyModel.h"


@interface GNOrderViewModel ()
/// 网络请求
@property (nonatomic, strong) GNOrderDTO *orderDTO;

@end


@implementation GNOrderViewModel

- (void)getOrderListMore:(NSInteger)pageNum bizState:(nullable NSString *)bizState completion:(nullable void (^)(GNOrderPagingRspModel *rspModel))completion {
    @HDWeakify(self)[self.orderDTO orderListRequestCustomerNo:SAUser.shared.operatorNo pageNum:pageNum bizState:bizState success:^(GNOrderPagingRspModel *_Nonnull rspModel) {
        @HDStrongify(self) if (!self.dataSource) {
            self.dataSource = NSMutableArray.new;
        }
        if (pageNum > 1) {
            [self.dataSource addObjectsFromArray:rspModel.list ?: @[]];
        } else {
            [self.totalLastTime removeAllObjects];
            self.dataSource = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
            self.countDownList = NSMutableArray.new;
        }
        for (GNOrderCellModel *orderModel in rspModel.list) {
            if ([orderModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline] && orderModel.payFailureTime > 0) {
                [self.countDownList addObject:orderModel];
            }
        }
        [self.dataSource enumerateObjectsUsingBlock:^(GNOrderCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.first = NO;
            obj.last = NO;
            if (idx == 0) {
                obj.first = YES;
            }
            if (idx == self.dataSource.count - 1) {
                obj.last = YES;
            }
        }];
        self.hasNextPage = rspModel.hasNextPage;
        !completion ?: completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

- (void)getOrderDetailOrderNo:(nonnull NSString *)orderNo completion:(void (^)(BOOL error))completion {
    @HDWeakify(self)[self.orderDTO orderDetailRequestCustomerNo:SAUser.shared.operatorNo orderNo:orderNo success:^(GNOrderCellModel *_Nonnull rspModel) {
        @HDStrongify(self)[self.detailSource removeAllObjects];
        if (rspModel) {
            ///二维码信息
            [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                   sectionModel.footerHeight = kRealWidth(8);
                                   sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_whiteColor;

                                   if ([rspModel.bizState.codeId isEqualToString:GNOrderStatusUse]) {
                                       GNCellModel *tipModel = GNCellModel.new;
                                       tipModel.title = GNLocalizedString(@"gn_use_tips", @"gn_use_tips");
                                       tipModel.cellClass = NSClassFromString(@"GNOrderDetailTipCell");
                                       [sectionModel.rows addObject:tipModel];
                                   }

                                   GNCellModel *model = [GNCellModel createClass:@"GNOrderProductTableViewCell"];
                                   model.businessData = rspModel;
                                   [sectionModel.rows addObject:model];
                                   int i = 0;
                                   for (GNQrCodeInfo *qrInfo in rspModel.qrCodeInfo) {
                                       GNCellModel *model = [GNCellModel createClass:@"GNOrderCoupunNumTableViewCell"];
                                       qrInfo.index = i + 1;
                                       model.businessData = qrInfo;
                                       [sectionModel.rows addObject:model];
                                       i++;
                                   }
                               })];

            ///使用流程
            if ([rspModel.bizState.codeId isEqualToString:GNOrderStatusUse]) {
                [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                       GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                                       model.title = GNLocalizedString(@"gn_process_using", @"使用流程");
                                       [sectionModel.rows addObject:model];

                                       GNCellModel *cellModel = GNCellModel.new;
                                       cellModel.cellClass = NSClassFromString(@"GNGroupTextCell");
                                       cellModel.bottomOffset = kRealWidth(12);
                                       cellModel.offset = kRealWidth(4);
                                       if ([rspModel.productInfo.type.codeId isEqualToString:GNProductTypeP1]) {
                                           cellModel.title = GNLocalizedString(@"gn_pr_useProcess", @"gn_qr_useProcess");
                                       } else {
                                           cellModel.title = GNLocalizedString(@"gn_qr_useProcess", @"gn_qr_useProcess");
                                       }
                                       [sectionModel.rows addObject:cellModel];
                                       sectionModel.headerHeight = kRealWidth(12);
                                       sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                   })];
            }

            ///优惠券活动
            if (rspModel.joinActivity) {
                [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                       GNCellModel *tipModel = GNCellModel.new;
                                       tipModel.title = [NSString stringWithFormat:GNLocalizedString(@"gn_write_off_order", @"%@前核销订单"),
                                                                                   [SAGeneralUtil getDateStrWithTimeInterval:rspModel.activityTime / 1000 format:@"dd/MM/yyyy"]];
                                       tipModel.detail = [rspModel.bizState.codeId isEqualToString:GNOrderStatusFinish] ? GNLocalizedString(@"gn_congratulation_coupon", @"恭喜您获得优惠券") :
                                                                                                                          GNLocalizedString(@"gn_available_coupon", @"可获得外卖门店优惠券");
                                       if ([rspModel.bizState.codeId isEqualToString:GNOrderStatusFinish]) {
                                           tipModel.leftHigh = YES;
                                       }
                                       tipModel.cellClass = NSClassFromString(@"GNOrderCouponActivityCell");
                                       [sectionModel.rows addObject:tipModel];
                                   })];
            }

            ///退款信息
            if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]
                && ([rspModel.refundState.codeId isEqualToString:GNOrderRefundStatusIng] || [rspModel.refundState.codeId isEqualToString:GNOrderRefundStatusFinidh])) {
                [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                       sectionModel.headerHeight = kRealWidth(12);
                                       sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;

                                       GNCellModel *model = [GNCellModel createClass:@"GNCommonCell"];
                                       model.title = SALocalizedString(@"refund_detail", @"退款详情");
                                       model.titleFont = [HDAppTheme.font gn_boldForSize:14];
                                       model.tag = @"refund";
                                       model.detailFont = [HDAppTheme.font gn_ForSize:12];
                                       model.detailColor = HDAppTheme.color.gn_mainColor;
                                       model.offset = model.bottomOffset = kRealWidth(12);
                                       if ([rspModel.refundState.codeId isEqualToString:GNOrderRefundStatusIng]) {
                                           model.detail = SALocalizedString(@"refunding", @"退款中");
                                       } else if ([rspModel.refundState.codeId isEqualToString:GNOrderRefundStatusFinidh]) {
                                           model.detail = SALocalizedString(@"refunded_success", @"退款成功");
                                       }
                                       [sectionModel.rows addObject:model];
                                   })];
            }

            ///地址信息
            [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                   sectionModel.headerHeight = kRealWidth(12);
                                   sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                   GNCellModel *model = [GNCellModel createClass:@"GNOrderStoreTableViewCell"];
                                   model.businessData = rspModel.merchantInfo;
                                   ///显示预约
                                   if ([rspModel.bizState.codeId isEqualToString:GNOrderStatusUse]) {
                                       rspModel.merchantInfo.showReserve = YES;
                                   }
                                   [sectionModel.rows addObject:model];
                               })];

            ///常规才显示
            if ([rspModel.productInfo.type.codeId isEqualToString:GNProductTypeP1]) {
                ///商品信息
                [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                       sectionModel.headerHeight = kRealWidth(12);
                                       sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                       GNCellModel *model = [GNCellModel createClass:@"GNOrderStoreTableViewCell"];
                                       model.businessData = rspModel.productInfo;
                                       [sectionModel.rows addObject:model];
                                   })];
            }

            ///购买须知
            [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                   sectionModel.headerHeight = kRealWidth(12);
                                   sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;

                                   GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                                   model.title = GNLocalizedString(@"gn_product_buyKnow", @"购买须知");
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [NSString stringWithFormat:@"%@：", GNLocalizedString(@"gn_product_vaild", @"有效期")];
                                   model.detail = [[SAGeneralUtil getDateStrWithTimeInterval:rspModel.createTime / 1000 format:@"dd/MM/yyyy"]
                                       stringByAppendingFormat:@" - %@", [SAGeneralUtil getDateStrWithTimeInterval:rspModel.effectiveTime / 1000 format:@"dd/MM/yyyy"]];
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [NSString stringWithFormat:@"%@：", GNLocalizedString(@"gn_product_useTime", @"使用时间")];
                                   model.detail = GNFillEmpty(rspModel.productInfo.useTime.desc);
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [NSString stringWithFormat:@"%@：", GNLocalizedString(@"gn_product_regular", @"使用规则")];
                                   model.detail = GNFillEmpty(rspModel.productInfo.useRules.desc);
                                   model.bottomOffset = kRealWidth(16);
                                   [sectionModel.rows addObject:model];
                               })];

            ///订单信息
            [self.detailSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                   sectionModel.headerHeight = kRealWidth(12);
                                   sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;

                                   GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                                   model.title = GNLocalizedString(@"gn_order_information", @"订单信息");
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [GNLocalizedString(@"gn_order_no", @"订单号") stringByAppendingString:@"："];
                                   model.tag = @"order";
                                   model.detail = rspModel.orderNo;
                                   model.imageTitle = TNLocalizedString(@"tn_copy", @"复制");
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [GNLocalizedString(@"gn_order_paymethor", @"支付方式") stringByAppendingString:@"："];
                                   model.detail = rspModel.paymentMethodStr;
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [GNLocalizedString(@"gn_order_time", @"下单时间") stringByAppendingString:@"："];
                                   model.detail = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.createTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
                                   [sectionModel.rows addObject:model];

                                   if ([rspModel.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]) {
                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [SALocalizedString(@"payment_time", @"支付时间") stringByAppendingString:@"："];
                                       model.detail = rspModel.payTime ? [SAGeneralUtil getDateStrWithTimeInterval:rspModel.payTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"] : @"--";
                                       [sectionModel.rows addObject:model];
                                   }

                                   if ([rspModel.bizState.codeId isEqualToString:GNOrderStatusCancel]) {
                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [GNLocalizedString(@"gn_order_cancel_time", @"取消时间") stringByAppendingString:@"："];
                                       model.detail = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.cancelTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
                                       [sectionModel.rows addObject:model];

                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [GNLocalizedString(@"gn_cancel_reason", @"取消原因") stringByAppendingString:@"："];
                                       model.detail = GNFillEmpty(rspModel.cancelCause);
                                       [sectionModel.rows addObject:model];
                                   } else if ([rspModel.bizState.codeId isEqualToString:GNOrderStatusFinish]) {
                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [GNLocalizedString(@"gn_finish_time", @"完成时间") stringByAppendingString:@"："];
                                       model.detail = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.finishTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
                                       [sectionModel.rows addObject:model];
                                   }

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [GNLocalizedString(@"gn_order_num", @"数量") stringByAppendingString:@"："];
                                   model.detail = [NSString stringWithFormat:@"%ld", rspModel.productCount];
                                   [sectionModel.rows addObject:model];

                                   model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                   model.title = [GNLocalizedString(@"gn_order_vat", @"增值税") stringByAppendingString:@"："];
                                   model.detail = GNFillMonEmpty(rspModel.vat);
                                   [sectionModel.rows addObject:model];

                                   if (rspModel.discountFee.doubleValue) {
                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [WMLocalizedString(@"OkaO8L5F", @"优惠码") stringByAppendingString:@"："];
                                       model.detail = [@"-" stringByAppendingString:GNFillMonEmpty(rspModel.discountFee)];
                                       [sectionModel.rows addObject:model];
                                   }

                                   if (!HDIsObjectNil(rspModel.payDiscountAmount) && rspModel.payDiscountAmount.cent.integerValue > 0) {
                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [SALocalizedString(@"payment_coupon", @"支付优惠") stringByAppendingString:@"："];
                                       model.detail = GNFillMonEmpty([NSDecimalNumber numberWithDouble:(0 - rspModel.payDiscountAmount.amount.doubleValue)]);
                                       [sectionModel.rows addObject:model];

                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [GNLocalizedString(@"gn_order_allPrice", @"总金额") stringByAppendingString:@"："];
                                       model.detail = GNFillMonEmpty([NSDecimalNumber numberWithDouble:rspModel.payActualPayAmount.amount.doubleValue]);
                                       model.bottomOffset = kRealWidth(16);
                                       [sectionModel.rows addObject:model];
                                   } else {
                                       model = [GNCellModel createClass:@"GNOrderInfoCell"];
                                       model.title = [GNLocalizedString(@"gn_order_allPrice", @"总金额") stringByAppendingString:@"："];
                                       model.detail = GNFillMonEmpty(rspModel.actualAmount);
                                       model.bottomOffset = kRealWidth(16);
                                       [sectionModel.rows addObject:model];
                                   }
                               })];
        }
        self.detailModel = rspModel;
        !completion ?: completion(rspModel ? NO : YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.detailModel = nil;
        !completion ?: completion(YES);
    }];
}

/// 获取订单核销信息
- (void)orderVerificationStateOrderNo:(nonnull NSString *)orderNo completion:(void (^)(GNMessageCode *rspModel))completion {
    [self.orderDTO orderVerificationStateRequestCustomerNo:SAUser.shared.operatorNo orderNo:orderNo success:^(GNMessageCode *_Nonnull rspModel) {
        !completion ?: completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

- (void)orderCouponWithOrderNo:(nonnull NSString *)orderNo {
    @HDWeakify(self)[self.orderDTO getOrderCouponListWithOrderNo:orderNo success:^(NSArray<GNCouponDetailModel *> *_Nonnull rspModel) {
        @HDStrongify(self) self.couponDataSource = [NSArray arrayWithArray:rspModel];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.couponDataSource = nil;
    }];
}

- (GNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = GNOrderDTO.new;
    }
    return _orderDTO;
}

- (NSMutableArray<GNOrderCellModel *> *)countDownList {
    return _countDownList ?: ({ _countDownList = NSMutableArray.new; });
}

- (NSMutableArray<GNSectionModel *> *)detailSource {
    return _detailSource ?: ({ _detailSource = NSMutableArray.new; });
}

@end

//
//  GNRefundViewModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNRefundViewModel.h"


@interface GNRefundViewModel ()

/// headSection
@property (nonatomic, strong) GNSectionModel *headSection;
/// infoSection
@property (nonatomic, strong) GNSectionModel *infoSection;
/// processSection
@property (nonatomic, strong) GNSectionModel *processSection;
///取消原因国际化
@property (nonatomic, strong, nullable) NSString *cancelStateStr;

@end


@implementation GNRefundViewModel

- (void)queryOrderDetailInfo {
    @HDWeakify(self);
    [self.refundDetailDTO orderRefundDetailWithOrderNo:self.orderNo success:^(GNRefundModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.rspModel = rspModel;
        [self.headSection.rows removeAllObjects];
        [self.infoSection.rows removeAllObjects];
        [self.processSection.rows removeAllObjects];
        self.processSection.headerModel.title = SALocalizedString(@"refund_process", @"refund_process");
        self.processSection.headerHeight = kRealWidth(47.5);

        if ([rspModel isKindOfClass:GNRefundModel.class]) {
            [self dealData:GNRequestTypeSuccess];
            self.refreshType = GNRequestTypeSuccess;
        } else {
            @HDWeakify(self) if (self.cancelTime && self.cancelState) {
                [self dealData:GNRequestTypeDataError];
                self.refreshType = GNRequestTypeDataError;
            }
            else {
                [self getOrderDetailCompletion:^(BOOL error) {
                    @HDStrongify(self);
                    [self dealData:GNRequestTypeDataError];
                    self.refreshType = GNRequestTypeDataError;
                }];
            }
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.rspModel = nil;
        self.refreshType = GNRequestTypeBad;
    }];
}

///根据type渲染数据
- (void)dealData:(GNRequestType)requestType {
    GNCellModel *headModel = GNCellModel.new;
    headModel.cellClass = NSClassFromString(@"GNOrderRefundHeadCell");
    [self.headSection.rows addObject:headModel];

    if (requestType == GNRequestTypeSuccess) {
        NSString *price = self.rspModel.actualRefundAmount.thousandSeparatorAmount;
        if (!price) {
            price = self.rspModel.applyRefundAmount.thousandSeparatorAmount;
        }

        if (self.rspModel.refundOrderState == SAOrderListAfterSaleStateRefunded) {
            headModel.title = [NSString stringWithFormat:@"%@ %@", SALocalizedString(@"refunded_success", @"退款成功"), price ?: @"$0"];
            headModel.image = [UIImage imageNamed:@"gn_order_refunded"];
        } else {
            headModel.title = [NSString stringWithFormat:@"%@ %@", SALocalizedString(@"refunding", @"退款中"), price ?: @"$0"];
            headModel.image = [UIImage imageNamed:@"gn_order_refunding"];
        }

        NSString *method = nil;
        if ([self.rspModel.refundWay.codeId isEqualToString:GNRefundWayOnline]) {
            method = WMLocalizedString(@"return_back", @"原路返回");
        } else if ([self.rspModel.refundWay.codeId isEqualToString:GNRefundWayOffline]) {
            method = WMLocalizedString(@"offline_refund", @"线下退款");
        }

        GNCellModel *model = GNCellModel.new;
        model.title = SALocalizedString(@"order_number", @"订单号");
        model.detail = GNFillEmptySpace(self.rspModel.businessOrderId);
        [self.infoSection.rows addObject:model];

        model = GNCellModel.new;
        model.title = SALocalizedString(@"refund_method", @"退款方式");
        model.detail = GNFillEmptySpace(method);
        [self.infoSection.rows addObject:model];

        model = GNCellModel.new;
        model.title = SALocalizedString(@"refund_amount", @"退款金额");
        model.detail = price ?: @"$0";
        [self.infoSection.rows addObject:model];
        [self.infoSection.rows enumerateObjectsUsingBlock:^(GNCellModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.cellClass = NSClassFromString(@"GNCommonCell");
            obj.imageHide = YES;
            obj.titleFont = [HDAppTheme.font gn_boldForSize:15];
            obj.detailFont = [HDAppTheme.font gn_ForSize:14];
        }];

        ///退款中
        if (self.rspModel.refundOrderState == SAOrderListAfterSaleStateRefunded) {
            GNCellModel *model = GNCellModel.new;
            model.cellClass = NSClassFromString(@"GNOrderRefundFlowCell");
            model.first = true;
            model.title = SALocalizedString(@"refunded_success", @"退款成功");
            model.time = [SAGeneralUtil getDateStrWithTimeInterval:self.rspModel.updateTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
            model.nameColor = HDAppTheme.color.gn_mainColor;
            model.detailColor = HDAppTheme.color.gn_333Color;
            [self.processSection.rows addObject:model];

            model = GNCellModel.new;
            model.nameColor = [UIColor hd_colorWithHexString:@"80333333"];
            model.last = true;
            model.detailColor = [UIColor hd_colorWithHexString:@"80333333"];
            model.cellClass = NSClassFromString(@"GNOrderRefundFlowCell");
            model.title = SALocalizedString(@"refunding", @"退款中");
            model.time = [SAGeneralUtil getDateStrWithTimeInterval:self.rspModel.createTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
            model.detail = self.cancelStateStr;
            [self.processSection.rows addObject:model];
        } else {
            GNCellModel *model = GNCellModel.new;
            model.cellClass = NSClassFromString(@"GNOrderRefundFlowCell");
            model.first = true;
            model.last = true;
            model.title = SALocalizedString(@"refunding", @"退款中");
            model.time = [SAGeneralUtil getDateStrWithTimeInterval:self.rspModel.createTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
            model.nameColor = HDAppTheme.color.gn_mainColor;
            model.detailColor = HDAppTheme.color.gn_333Color;
            model.detail = self.cancelStateStr;
            [self.processSection.rows addObject:model];
        }
    } else if (requestType == GNRequestTypeDataError) {
        headModel.title = SALocalizedString(@"refunding", @"退款中");
        headModel.image = [UIImage imageNamed:@"gn_order_refunding"];

        GNCellModel *model = GNCellModel.new;
        model.cellClass = NSClassFromString(@"GNOrderRefundFlowCell");
        model.first = true;
        model.last = true;
        model.title = SALocalizedString(@"refunding", @"退款中");
        model.time = [SAGeneralUtil getDateStrWithTimeInterval:self.cancelTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
        model.nameColor = HDAppTheme.color.gn_mainColor;
        model.detailColor = HDAppTheme.color.gn_333Color;
        model.detail = self.cancelStateStr;
        [self.processSection.rows addObject:model];
    }
}

- (void)getOrderDetailCompletion:(void (^)(BOOL error))completion {
    @HDWeakify(self)[self.refundDetailDTO orderDetailRequestCustomerNo:SAUser.shared.operatorNo orderNo:self.buinessNo success:^(GNOrderCellModel *_Nonnull rspModel) {
        @HDStrongify(self) if ([rspModel isKindOfClass:GNOrderCellModel.class]) {
            self.cancelState = rspModel.neCancelState;
            self.businessPhone = rspModel.merchantInfo.businessPhone;
            self.cancelTime = rspModel.cancelTime;
        }
        !completion ?: completion(rspModel ? NO : YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(YES);
    }];
}

- (NSString *)cancelStateStr {
    if (!_cancelStateStr) {
        _cancelStateStr = @" ";
        if ([self.cancelState isKindOfClass:NSString.class]) {
            if ([self.cancelState isEqualToString:GNOrderCancelTypeUser]) {
                _cancelStateStr = GNLocalizedString(@"gn_fail_reason_user", @"gn_fail_reason_user");
            } else if ([self.cancelState isEqualToString:GNOrderCancelTypeTime]) {
                _cancelStateStr = GNLocalizedString(@"gn_fail_reason_auto", @"gn_fail_reason_auto");
            }
        }
    }
    return _cancelStateStr;
}

- (NSMutableArray<GNSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
        [_dataSource addObjectsFromArray:@[self.headSection, self.infoSection, self.processSection]];
    }
    return _dataSource;
}

- (GNSectionModel *)headSection {
    if (!_headSection) {
        _headSection = GNSectionModel.new;
    }
    return _headSection;
}

- (GNSectionModel *)processSection {
    if (!_processSection) {
        _processSection = GNSectionModel.new;
        _processSection.cornerRadios = kRealWidth(10);
        _processSection.headerModel.titleFont = [HDAppTheme.font gn_boldForSize:16];
        _processSection.headerModel.titleColor = HDAppTheme.color.gn_333Color;
        _processSection.headerModel.backgroundColor = HDAppTheme.color.gn_whiteColor;
    }
    return _processSection;
}

- (GNSectionModel *)infoSection {
    if (!_infoSection) {
        _infoSection = GNSectionModel.new;
        _infoSection.cornerRadios = kRealWidth(10);
        _infoSection.footerHeight = kRealWidth(10);
        _infoSection.footerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    }
    return _infoSection;
}

#pragma mark - lazy load
- (GNOrderDTO *)refundDetailDTO {
    return _refundDetailDTO ?: ({ _refundDetailDTO = GNOrderDTO.new; });
}

@end

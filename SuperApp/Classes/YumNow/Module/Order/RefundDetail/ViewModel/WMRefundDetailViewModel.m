//
//  WMRefundDetailViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRefundDetailViewModel.h"
#import "SAInfoViewModel.h"
#import "WMRefundDetailDTO.h"


@interface WMRefundDetailViewModel ()
/// DTO
@property (nonatomic, strong) WMRefundDetailDTO *refundDetailDTO;
/// 详情模型
@property (nonatomic, strong) WMOrderDetailModel *detailModel;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 退款流程
@property (nonatomic, strong) HDTableViewSectionModel *refundFlowSectionModel;
/// 退款信息
@property (nonatomic, strong) HDTableViewSectionModel *refundInfoSectionModel;
/// 退款金额
@property (nonatomic, strong) SAInfoViewModel *refundAmountModel;
/// 退款方式
@property (nonatomic, strong) SAInfoViewModel *refundMethodModel;
/// 订单号
@property (nonatomic, strong) SAInfoViewModel *orderNoModel;
/// 刷新标志
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign) BOOL isLoading;
@end


@implementation WMRefundDetailViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.refundInfoSectionModel.list = @[self.refundAmountModel, self.refundMethodModel, self.orderNoModel];
        self.dataSource = @[self.refundFlowSectionModel, self.refundInfoSectionModel];
    }
    return self;
}

- (void)queryOrdeDetailInfo {
    @HDWeakify(self);
    self.isLoading = true;
    [self.refundDetailDTO queryOrderDetailInfoWithOrderNo:self.orderNo success:^(WMOrderDetailModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.isLoading = false;
        if (self.isBusinessDataError) {
            self.isBusinessDataError = false;
        }

        self.refundFlowSectionModel.list = rspModel.refundInfo.refundEventList;
        self.detailModel = rspModel;
        [self generateRefundInfoSectionDataWithOrderDetailModel:rspModel];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.isLoading = false;
        if (errorType == CMResponseErrorTypeBusinessDataError) {
            self.isBusinessDataError = true;
        } else {
            self.isNetworkError = true;
        }
        self.refreshFlag = !self.refreshFlag;
    }];
}

#pragma mark - private methods
- (void)generateRefundInfoSectionDataWithOrderDetailModel:(WMOrderDetailModel *)orderDetailModel {
    if (!HDIsObjectNil(orderDetailModel.refundInfo.actualRefundAmount)) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        NSAttributedString *appendingStr = [[NSAttributedString alloc] initWithString:WMLocalizedString(@"request_real_refund", @"实退")
                                                                           attributes:@{NSFontAttributeName: HDAppTheme.font.standard4, NSForegroundColorAttributeName: HDAppTheme.color.G4}];
        [text appendAttributedString:appendingStr];

        // 空格
        NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
        [text appendAttributedString:whiteSpace];

        appendingStr = [[NSAttributedString alloc] initWithString:orderDetailModel.refundInfo.actualRefundAmount.thousandSeparatorAmount
                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
        [text appendAttributedString:appendingStr];
        self.refundAmountModel.attrValue = text;
    } else {
        self.refundAmountModel.valueText = orderDetailModel.refundInfo.applyRefundAmount.thousandSeparatorAmount;
    }

    if (orderDetailModel.refundInfo.refundMethod == WMOrderRefundMethodOriginalMethod) {
        self.refundMethodModel.valueText = WMLocalizedString(@"return_back", @"原路返回");
    } else if (orderDetailModel.refundInfo.refundMethod == WMOrderRefundMethodOffline) {
        self.refundMethodModel.valueText = WMLocalizedString(@"offline_refund", @"线下退款");
    }
    self.orderNoModel.valueText = orderDetailModel.orderNo;
}

#pragma mark - lazy load
- (WMRefundDetailDTO *)refundDetailDTO {
    return _refundDetailDTO ?: ({ _refundDetailDTO = WMRefundDetailDTO.new; });
}

- (HDTableViewSectionModel *)refundFlowSectionModel {
    if (!_refundFlowSectionModel) {
        _refundFlowSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = WMLocalizedString(@"refund_process", @"退款流程");
        _refundFlowSectionModel.headerModel = headerModel;
    }
    return _refundFlowSectionModel;
}

- (HDTableViewSectionModel *)refundInfoSectionModel {
    if (!_refundInfoSectionModel) {
        _refundInfoSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = WMLocalizedString(@"refund_information", @"退款信息");
        _refundInfoSectionModel.headerModel = headerModel;
    }
    return _refundInfoSectionModel;
}

- (SAInfoViewModel *)refundAmountModel {
    if (!_refundAmountModel) {
        _refundAmountModel = SAInfoViewModel.new;
        _refundAmountModel.keyText = WMLocalizedString(@"refund_amount", @"退款金额");
    }
    return _refundAmountModel;
}

- (SAInfoViewModel *)refundMethodModel {
    if (!_refundMethodModel) {
        _refundMethodModel = SAInfoViewModel.new;
        _refundMethodModel.keyText = WMLocalizedString(@"refund_method", @"退款方式");
    }
    return _refundMethodModel;
}

- (SAInfoViewModel *)orderNoModel {
    if (!_orderNoModel) {
        _orderNoModel = SAInfoViewModel.new;
        _orderNoModel.keyText = WMLocalizedString(@"order_number", @"订单号");
    }
    return _orderNoModel;
}
@end

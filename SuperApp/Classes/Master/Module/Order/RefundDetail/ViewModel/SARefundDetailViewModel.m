//
//  SARefundDetailViewModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARefundDetailViewModel.h"
#import "SAInfoViewModel.h"
#import "SAOrderRefundInfoModel.h"
#import "SATopUpOrderDetailDTO.h"
#import "SATopUpOrderDetailRspModel.h"
#import "WMOrderDetailRefundInfoModel.h"


@interface SARefundDetailViewModel ()
/// DTO
@property (nonatomic, strong) SATopUpOrderDetailDTO *detailDTO;
/// 退款信息模型
@property (nonatomic, strong) SAOrderRefundInfoModel *orderRefundInfoModel;
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


@implementation SARefundDetailViewModel
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
    [self.detailDTO getTopUpOrderDetailWithOrderNo:self.orderNo success:^(SATopUpOrderDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.isLoading = false;
        if (self.isBusinessDataError) {
            self.isBusinessDataError = false;
        }
        self.refundFlowSectionModel.list = rspModel.refundInfo.refundEventList;
        self.orderRefundInfoModel = rspModel.refundInfo;
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
- (void)generateRefundInfoSectionDataWithOrderDetailModel:(SATopUpOrderDetailRspModel *)orderDetailModel {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr = [[NSAttributedString alloc] initWithString:SALocalizedString(@"request_real_refund", @"实退")
                                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard4, NSForegroundColorAttributeName: HDAppTheme.color.G3}];
    [text appendAttributedString:appendingStr];
    if (!HDIsObjectNil(orderDetailModel.refundInfo.actualRefundAmount)) {
        // 空格
        NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
        [text appendAttributedString:whiteSpace];

        appendingStr = [[NSAttributedString alloc] initWithString:orderDetailModel.refundInfo.actualRefundAmount.thousandSeparatorAmount
                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
        [text appendAttributedString:appendingStr];
    }

    self.refundAmountModel.attrValue = text;

    if (orderDetailModel.refundInfo.refundMethod == WMOrderRefundMethodOriginalMethod) {
        self.refundMethodModel.valueText = SALocalizedString(@"return_back", @"原路返回");
    } else if (orderDetailModel.refundInfo.refundMethod == WMOrderRefundMethodOffline) {
        self.refundMethodModel.valueText = SALocalizedString(@"offline_refund", @"线下退款");
    }
    self.orderNoModel.valueText = orderDetailModel.aggregateOrderNo;
}

#pragma mark - lazy load

- (HDTableViewSectionModel *)refundFlowSectionModel {
    if (!_refundFlowSectionModel) {
        _refundFlowSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = SALocalizedString(@"refund_process", @"退款流程");
        _refundFlowSectionModel.headerModel = headerModel;
    }
    return _refundFlowSectionModel;
}

- (HDTableViewSectionModel *)refundInfoSectionModel {
    if (!_refundInfoSectionModel) {
        _refundInfoSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = SALocalizedString(@"refund_information", @"退款信息");
        _refundInfoSectionModel.headerModel = headerModel;
    }
    return _refundInfoSectionModel;
}

- (SAInfoViewModel *)refundAmountModel {
    if (!_refundAmountModel) {
        _refundAmountModel = SAInfoViewModel.new;
        _refundAmountModel.keyText = SALocalizedString(@"refund_amount", @"退款金额");
        _refundAmountModel.keyColor = HDAppTheme.color.G3;
        _refundAmountModel.valueColor = HDAppTheme.color.G2;
    }
    return _refundAmountModel;
}

- (SAInfoViewModel *)refundMethodModel {
    if (!_refundMethodModel) {
        _refundMethodModel = SAInfoViewModel.new;
        _refundMethodModel.keyText = SALocalizedString(@"refund_method", @"退款方式");
        _refundMethodModel.keyColor = HDAppTheme.color.G3;
        _refundMethodModel.valueColor = HDAppTheme.color.G2;
    }
    return _refundMethodModel;
}

- (SAInfoViewModel *)orderNoModel {
    if (!_orderNoModel) {
        _orderNoModel = SAInfoViewModel.new;
        _orderNoModel.keyText = SALocalizedString(@"order_number", @"订单号");
        _orderNoModel.keyColor = HDAppTheme.color.G3;
        _orderNoModel.valueColor = HDAppTheme.color.G2;
    }
    return _orderNoModel;
}

- (SATopUpOrderDetailDTO *)detailDTO {
    if (!_detailDTO) {
        _detailDTO = [[SATopUpOrderDetailDTO alloc] init];
    }
    return _detailDTO;
}

@end

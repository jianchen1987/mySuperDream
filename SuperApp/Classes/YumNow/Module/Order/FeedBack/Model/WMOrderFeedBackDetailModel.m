//
//  WMOrderFeedBackDetailModel.m
//  SuperApp
//
//  Created by wmz on 2022/11/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackDetailModel.h"


@implementation WMOrderFeedBackDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"remark": @"description"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"commodityInfo": [WMOrderDetailProductModel class], @"postSaleTracks": [WMOrderFeedBackDetailTraclModel class]};
}

- (NSString *)postSaleTypeStr {
    if (!_postSaleTypeStr) {
        if ([self.postSaleType isEqualToString:WMOrderFeedBackPostChange]) {
            _postSaleTypeStr = WMLocalizedString(@"wm_order_feedback_exchange", @"换货");
        } else if ([self.postSaleType isEqualToString:WMOrderFeedBackPostOther]) {
            _postSaleTypeStr = WMLocalizedString(@"wm_order_feedback_other", @"其他诉求");
        } else if ([self.postSaleType isEqualToString:WMOrderFeedBackPostRefuse]) {
            _postSaleTypeStr = WMLocalizedString(@"wm_order_feedback_refund", @"退款");
        }
    }
    return _postSaleTypeStr;
}

- (NSString *)handleStatusStr {
    if (!_handleStatusStr) {
        if ([self.handleStatus isEqualToString:WMOrderFeedBackHandleWait]) {
            _handleStatusStr = WMLocalizedString(@"wm_order_feedback_status_submitted", @"已提交");
        } else if ([self.handleStatus isEqualToString:WMOrderFeedBackHandlePending]) {
            _handleStatusStr = WMLocalizedString(@"wm_order_feedback_status_processing", @"处理中");
        } else if ([self.handleStatus isEqualToString:WMOrderFeedBackHandleFinish]) {
            _handleStatusStr = WMLocalizedString(@"wm_order_feedback_status_completed", @"处理完成");
        } else if ([self.handleStatus isEqualToString:WMOrderFeedBackHandleReject]) {
            _handleStatusStr = WMLocalizedString(@"wm_order_feedback_status_rejected", @"已拒绝");
        }
    }
    return _handleStatusStr;
}

- (NSArray<WMShoppingCartStoreProduct *> *)showCommodityInfo {
    if (!_showCommodityInfo) {
        NSMutableArray *marr = NSMutableArray.new;
        for (WMOrderDetailProductModel *product in self.commodityInfo) {
            WMShoppingCartStoreProduct *pr = [WMShoppingCartStoreProduct modelWithOrderDetailProductModel:product];
            pr.orderCommodityId = product.orderCommodityId;
            [marr addObject:pr];
        }
        _showCommodityInfo = [NSArray arrayWithArray:marr];
    }
    return _showCommodityInfo;
}
@end


@implementation WMOrderFeedBackDetailTraclModel

- (NSString *)logTypeStr {
    if (!_logTypeStr) {
        if ([self.logType isEqualToString:@"PSL001"]) {
            _logTypeStr = WMLocalizedString(@"wm_order_feedback_track_submit", @"提交反馈 ");
        } else if ([self.logType isEqualToString:@"PSL002"]) {
            _logTypeStr = WMLocalizedString(@"wm_order_feedback_track_peding", @"接取");
        } else if ([self.logType isEqualToString:@"PSL003"]) {
            _logTypeStr = WMLocalizedString(@"wm_order_feedback_track_peding", @"处理");
        } else if ([self.logType isEqualToString:@"PSL004"]) {
            _logTypeStr = WMLocalizedString(@"wm_order_feedback_status_rejected", @"已驳回");
        } else if ([self.logType isEqualToString:@"PSL005"]) {
            _logTypeStr = WMLocalizedString(@"wm_order_feedback_track_finish", @"处理完成");
        } else if ([self.logType isEqualToString:@"PSL006"]) {
            _logTypeStr = WMLocalizedString(@"wm_order_feedback_track_finish", @"处理完成-已解决");
        }
    }
    return _logTypeStr;
}

@end

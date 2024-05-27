//
//  TNOrderDetailsMidPartModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsMidPartModel.h"
#import "TNOrderOperatorModel.h"

TNOrderOperationType const TNOrderOperationTypePayNow = @"PAY_NOW";                     //立即支付
TNOrderOperationType const TNOrderOperationTypeRefundDetail = @"REFUND_DETAIL";         //退款详情
TNOrderOperationType const TNOrderOperationTypeReceipt = @"CONFIRM_RECEIPT";            //确认收货
TNOrderOperationType const TNOrderOperationTypeAddReview = @"ADD_COMMENT";              //写评论
TNOrderOperationType const TNOrderOperationTypeCancelOrder = @"CANCEL_ORDER";           //取消订单
TNOrderOperationType const TNOrderOperationTypeExchange = @"EXCHANGE";                  //换货
TNOrderOperationType const TNOrderOperationTypeShowReview = @"SHOW_COMMENT";            //查看评论
TNOrderOperationType const TNOrderOperationTypeRebuy = @"RE_BUY";                       //再次购买
TNOrderOperationType const TNOrderOperationTypeApplyRefund = @"REFUND";                 //申请退款
TNOrderOperationType const TNOrderOperationTypeCancelApplyRefund = @"CANCEL_REFUND";    //取消退款
TNOrderOperationType const TNOrderOperationTypeTransferPayments = @"TRANSFER_PAYMENTS"; //转账付款
TNOrderOperationType const TNOrderOperationTypeNearbyBuy = @"NEARBY_BUY";               // 再来一单


@implementation TNOrderDetailsMidPartModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"operationList": [TNOrderOperatorModel class]};
}
@end

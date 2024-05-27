//
//  TNOrderActionBarView.m
//  SuperApp
//
//  Created by seeu on 2020/7/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderActionBarView.h"
#import "SAOperationButton.h"
#import "TNOrderDetailsViewModel.h"
#import "TNOrderOperatorModel.h"
#import "TNQueryOrderDetailsRspModel.h"
#import <HDUIKit/HDUIKit.h>


@interface TNOrderActionBarView ()
/// viewModel
@property (nonatomic, strong) TNOrderDetailsViewModel *viewModel;
/// 容器
@property (nonatomic, strong) UIView *container;
/// line
@property (nonatomic, strong) UIView *topLine;
/// 取消
@property (nonatomic, strong) SAOperationButton *cancelButton;
/// 写评论
@property (nonatomic, strong) SAOperationButton *reviewButton;
/// 确认收货
@property (nonatomic, strong) SAOperationButton *confirmButton;
/// 换货
@property (nonatomic, strong) SAOperationButton *exchangeButton;
/// 支付
@property (nonatomic, strong) SAOperationButton *paymentButton;
/// 再次购买
@property (nonatomic, strong) SAOperationButton *reBuyButton;
/// 查看评论
@property (nonatomic, strong) SAOperationButton *checkReviewButton;
/// 申请退款
@property (nonatomic, strong) SAOperationButton *applyRefundButton;
/// 取消退款
@property (nonatomic, strong) SAOperationButton *cancelApplyRefundButton;
/// 转账付款
@property (nonatomic, strong) SAOperationButton *transferPayButton;
@property (nonatomic, strong) SAOperationButton *oneMoreButton; ///< 再来一单
/// 联系客服
@property (nonatomic, strong) SAOperationButton *customerServiceButton;
/// 刷新审核状态按钮
//@property (strong, nonatomic) SAOperationButton *refrenshReviewingButton;
/// 按钮列表
@property (nonatomic, strong) NSMutableArray<SAOperationButton *> *buttons;
@end


@implementation TNOrderActionBarView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    self.buttons = NSMutableArray.new;

    [self addSubview:self.topLine];
    [self addSubview:self.container];
}

- (void)updateConstraints {
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];

    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kRealHeight(50.0f));
    }];

    SAOperationButton *rightButton = nil;
    for (SAOperationButton *button in self.buttons) {
        [button sizeToFit];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.container.mas_centerY);
            if (rightButton) {
                make.right.equalTo(rightButton.mas_left).offset(-15);
            } else {
                make.right.equalTo(self.container.mas_right).offset(-15);
            }
        }];
        rightButton = button;
    }

    [super updateConstraints];
}

- (void)hd_bindViewModel {
    if (self.viewModel.orderDetails) {
        [self generateButtons];
    }

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"orderDetails" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.orderDetails) {
            [self generateButtons];
        }
    }];
}

- (void)generateButtons {
    [self.container hd_removeAllSubviews];
    [self.buttons removeAllObjects];

    for (TNOrderOperatorModel *operator in self.viewModel.orderDetails.orderInfo.operationList) {
        if([operator.orderOperation isEqualToString:TNOrderOperationTypePayNow]) { //立即支付
            [self.buttons addObject:self.paymentButton];
            [self.container addSubview:self.paymentButton];
        } else if([operator.orderOperation isEqualToString:TNOrderOperationTypeReceipt]) { //确认收货
            [self.container addSubview:self.confirmButton];
            [self.buttons addObject:self.confirmButton];
        } else if([operator.orderOperation isEqualToString:TNOrderOperationTypeExchange]) { //换货
            [self.buttons addObject:self.exchangeButton];
            [self.container addSubview:self.exchangeButton];
        } else if([operator.orderOperation isEqualToString:TNOrderOperationTypeAddReview]) { //评价
            [self.buttons addObject:self.reviewButton];
            [self.container addSubview:self.reviewButton];
        } else if([operator.orderOperation isEqualToString:TNOrderOperationTypeCancelOrder]) { //取消订单
            [self.container addSubview:self.cancelButton];
            [self.buttons addObject:self.cancelButton];
        }  else if([operator.orderOperation isEqualToString:TNOrderOperationTypeShowReview]) { //查看评价
            [self.buttons addObject:self.checkReviewButton];
            [self.container addSubview:self.checkReviewButton];
        }  else if([operator.orderOperation isEqualToString:TNOrderOperationTypeRebuy]) {  //再次购买
            [self.buttons addObject:self.reBuyButton];
            [self.container addSubview:self.reBuyButton];
        } else if ([operator.orderOperation isEqualToString:TNOrderOperationTypeApplyRefund]) { //申请退款
            [self.buttons addObject:self.applyRefundButton];
            [self.container addSubview:self.applyRefundButton];
        } else if ([operator.orderOperation isEqualToString:TNOrderOperationTypeCancelApplyRefund]) { //取消退款
            [self.buttons addObject:self.cancelApplyRefundButton];
            [self.container addSubview:self.cancelApplyRefundButton];
        } else if ([operator.orderOperation isEqualToString:TNOrderOperationTypeTransferPayments]) { //转账付款
            [self.buttons addObject:self.transferPayButton];
            [self.container addSubview:self.transferPayButton];
        } else if ([operator.orderOperation isEqualToString:TNOrderOperationTypeNearbyBuy]) {
            [self.buttons addObject:self.oneMoreButton];
            [self.container addSubview:self.oneMoreButton];
        }
    }

    ///  海外购 待审核显示联系客服和刷新按钮
    if ([self.viewModel.orderDetails.orderDetail.type isEqualToString:TNOrderTypeOverseas] && [self.viewModel.orderDetails.orderDetail.status isEqualToString:TNOrderStatePendingReview]) {
        [self.buttons addObject:self.customerServiceButton];
        [self.container addSubview:self.customerServiceButton];

        //        [self.buttons addObject:self.refrenshReviewingButton];
        //        [self.container addSubview:self.refrenshReviewingButton];
    }

    NSArray<SAOperationButton *> *tmp = [self.buttons sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        SAOperationButton *button1 = obj1;
        SAOperationButton *button2 = obj2;
        if (button1.tag > button2.tag) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];

    self.buttons = [NSMutableArray arrayWithArray:tmp];

    for (SAOperationButton *button in self.buttons) {
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        button.layer.borderWidth = 1;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy topLine */
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _topLine;
}
/** @lazy container */
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}
/** @lazy cancelButton */
- (SAOperationButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _cancelButton.tag = 4;
        [_cancelButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_cancelButton setTitle:TNLocalizedString(@"tn_button_cancel_order_title", @"Cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_cancelButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.cancelClicked) {
                self.cancelClicked();
            }
        }];
    }
    return _cancelButton;
}
/** @lazy confirm */
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _confirmButton.tag = 3;
        [_confirmButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_confirmButton setTitle:TNLocalizedString(@"tn_button_title_receive", @"确认收货") forState:UIControlStateNormal];
        [_confirmButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.confirmClicked) {
                self.confirmClicked();
            }
        }];
    }
    return _confirmButton;
}
/** @lazy review */
- (SAOperationButton *)reviewButton {
    if (!_reviewButton) {
        _reviewButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _reviewButton.tag = 5;
        [_reviewButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.C1];
        [_reviewButton setTitle:TNLocalizedString(@"tn_write_review", @"写评论") forState:UIControlStateNormal];
        [_reviewButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_reviewButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.reviewClicked) {
                self.reviewClicked();
            }
        }];
    }
    return _reviewButton;
}

- (SAOperationButton *)checkReviewButton {
    if (!_checkReviewButton) {
        _checkReviewButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _checkReviewButton.tag = 6;
        [_checkReviewButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.C1];
        [_checkReviewButton setTitle:TNLocalizedString(@"tn_check_review", @"查看评论") forState:UIControlStateNormal];
        [_checkReviewButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_checkReviewButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.checkReviewClicked) {
                self.checkReviewClicked();
            }
        }];
    }
    return _checkReviewButton;
}
/** @lazy exchange */
- (SAOperationButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _exchangeButton.tag = 2;
        [_exchangeButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_exchangeButton setTitle:TNLocalizedString(@"tn_exchange_product", @"换货") forState:UIControlStateNormal];
        [_exchangeButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_exchangeButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.exchangeClicked) {
                self.exchangeClicked();
            }
        }];
    }
    return _exchangeButton;
}
/** @lazy payment */
- (SAOperationButton *)paymentButton {
    if (!_paymentButton) {
        _paymentButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _paymentButton.tag = 1;
        [_paymentButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.C1];
        [_paymentButton setTitle:TNLocalizedString(@"tn_button_payment", @"Pay Now") forState:UIControlStateNormal];
        [_paymentButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_paymentButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.paymentClicked) {
                self.paymentClicked();
            }
        }];
    }
    return _paymentButton;
}
/** @lazy exchange */
- (SAOperationButton *)reBuyButton {
    if (!_reBuyButton) {
        _reBuyButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _reBuyButton.tag = 7;
        [_reBuyButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_reBuyButton setTitle:TNLocalizedString(@"tn_buy_again", @"再次购买") forState:UIControlStateNormal];
        [_reBuyButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_reBuyButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.reBuyClicked) {
                self.reBuyClicked();
            }
        }];
    }
    return _reBuyButton;
}

- (SAOperationButton *)oneMoreButton {
    if (!_oneMoreButton) {
        _oneMoreButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _oneMoreButton.tag = 7;
        [_oneMoreButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_oneMoreButton setTitle:TNLocalizedString(@"btn_nearby_buy", @"附近购买") forState:UIControlStateNormal];
        [_oneMoreButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_oneMoreButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.oneMoreClicked) {
                self.oneMoreClicked();
            }
        }];
    }
    return _oneMoreButton;
}

- (SAOperationButton *)applyRefundButton {
    if (!_applyRefundButton) {
        _applyRefundButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _applyRefundButton.tag = 12;
        [_applyRefundButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_applyRefundButton setTitle:TNLocalizedString(@"tn_orderDetail_apply_refund", @"申请退款") forState:UIControlStateNormal];
        [_applyRefundButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_applyRefundButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.applyRefundClicked) {
                self.applyRefundClicked();
            }
        }];
    }
    return _applyRefundButton;
}

- (SAOperationButton *)cancelApplyRefundButton {
    if (!_cancelApplyRefundButton) {
        _cancelApplyRefundButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _cancelApplyRefundButton.tag = 13;
        [_cancelApplyRefundButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_cancelApplyRefundButton setTitle:TNLocalizedString(@"tn_orderDetail_cancel_apply_refund", @"取消退款") forState:UIControlStateNormal];
        [_cancelApplyRefundButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_cancelApplyRefundButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.cancelApplyRefundClicked) {
                self.cancelApplyRefundClicked();
            }
        }];
    }
    return _cancelApplyRefundButton;
}

- (SAOperationButton *)transferPayButton {
    if (!_transferPayButton) {
        _transferPayButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _transferPayButton.tag = 2;
        [_transferPayButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.C1];
        [_transferPayButton setTitle:TNLocalizedString(@"tn_transfer_pay", @"转账付款") forState:UIControlStateNormal];
        [_transferPayButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_transferPayButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.transferPayClicked) {
                self.transferPayClicked();
            }
        }];
    }
    return _transferPayButton;
}

//- (SAOperationButton *)refrenshReviewingButton {
//    if (!_refrenshReviewingButton) {
//        _refrenshReviewingButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
//        _refrenshReviewingButton.tag = 15;
//        [_refrenshReviewingButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
//        _refrenshReviewingButton.borderWidth = 0;
//        _refrenshReviewingButton.borderColor = HDAppTheme.TinhNowColor.C1;
//        [_refrenshReviewingButton setTitle:TNLocalizedString(@"8Je39TOV", @"刷新审核状态") forState:UIControlStateNormal];
//        [_refrenshReviewingButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
//        @HDWeakify(self);
//        [_refrenshReviewingButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
//            @HDStrongify(self);
//            if (self.refreshClicked) {
//                self.refreshClicked();
//            }
//        }];
//    }
//    return _refrenshReviewingButton;
//}

- (SAOperationButton *)customerServiceButton {
    if (!_customerServiceButton) {
        _customerServiceButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _customerServiceButton.tag = 16;
        [_customerServiceButton applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        [_customerServiceButton setTitle:TNLocalizedString(@"tn_customer", @"联系客服") forState:UIControlStateNormal];
        [_customerServiceButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 15, 6, 15)];
        @HDWeakify(self);
        [_customerServiceButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.customerServiceClicked) {
                self.customerServiceClicked();
            }
        }];
    }
    return _customerServiceButton;
}
@end

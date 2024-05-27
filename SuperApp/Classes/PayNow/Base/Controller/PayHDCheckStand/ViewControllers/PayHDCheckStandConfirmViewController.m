//
//  PayHDCheckstandConfirmViewController.m
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandConfirmViewController.h"
#import "HDCommonButton.h"
#import "HDCommonInfoRowView.h"
#import "HDDealCommonInfoRowViewModel.h"
#import "NSString+HD_Size.h"
#import "PNCashToolsRspModel.h"
#import "PNCommonUtils.h"
#import "PNRspModel.h"
#import "PayHDCheckStandChooseCouponTicketViewController.h"
#import "PayHDCheckStandChoosePayMethodViewController.h"
#import "PayHDCheckStandInputPwdViewController.h"
#import "PayHDCheckstandViewController.h"
#import "PayHDPresentViewControllerAnimation.h"
#import "PayHDTradeBuildOrderRspModel.h"
#import "PayHDTradeConfirmPaymentRspModel.h"
#import "PayHDTradeCreatePaymentRspModel.h"
#import "SAMoneyTools.h"
#import "UIImage+HDKitCore.h"
#import "UINavigationController+HDKitCore.h"
#import "VipayUser.h"


@interface PayHDCheckstandConfirmViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) BOOL isInitialLayoutEnded;                             ///< 初次布局是否完成
@property (nonatomic, strong) UIScrollView *scrollViews;                             ///< 容器
@property (nonatomic, strong) UILabel *detailLB;                                     ///< 详细
@property (nonatomic, strong) PayHDCheckstandPaymentDetailTitleModel *subTitleModel; ///< 副标题属性内容模型
@property (nonatomic, strong) HDCommonButton *confirmButton;                         ///< 确认付款
//@property (nonatomic, strong) HDCommonButton *cancelButton;                             ///< 取消
@property (nonatomic, strong) NSMutableArray<UIView *> *rowViews;                          ///< 所有的信息展示
@property (nonatomic, strong) SAMoneyModel *finalPayMentModel;                             ///< 最终付款金额
@property (nonatomic, copy) NSArray<PayHDTradePreferentialModel *> *orderPreferentialList; ///< 订单使用的优惠，nil 则不使用优惠
@property (nonatomic, copy) NSArray<PayHDTradePaymentMethodModel *> *orderPaymethodList;   ///< 订单使用的支付方式
@property (nonatomic, strong) PayHDTradePreferentialModel *currentPreferentialModel;       ///< 当前优惠
@property (nonatomic, strong) SAMoneyModel *finalCouponAmount;                             ///< 最终优惠金额
@property (nonatomic, strong) HDCommonInfoRowView *couponInfoView;                         ///< 优惠信息 View，包括常规优惠
@property (nonatomic, strong) PayHDTradeCreatePaymentRspModel *createPaymentRspModel;      ///< 创建订单成功模型
@property (nonatomic, strong) PNCashToolsRspModel *cashToosRspModel;                       ///< 娱乐缴费tools模型
@end


@implementation PayHDCheckstandConfirmViewController
+ (instancetype)checkStandWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel {
    return [[self alloc] initWithTradeBuildModel:buildModel];
}

- (instancetype)initWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel {
    self = [super init];
    if (self) {
        self.buildModel = buildModel;
    }
    return self;
}
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

    [self setupUI];

    if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet || self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ms_generateDataAndRefreshUI];
        });
    } else if (self.buildModel.subTradeType == PNTradeSubTradeTypeCoolCashCashOut) {
        [self paymentTools];
    } else if (self.buildModel.subTradeType == PNTradeSubTradeTypeEntertainment) {
        //娱乐缴费
        [self getCashTools];
    } else {
        // 根据订单号查询数据
        [self createPayment];
    }
}

- (PayHDCheckstandPaymentOverTimeEndActionType)preferedaymentOverTimeEndActionType {
    return PayHDCheckstandPaymentOverTimeEndActionTypeConfirm;
}

- (void)setupNavigationBar {
    if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet || self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        [self setTitleBtnImage:@"check_stand_logo" title:PNLocalizedString(@"pn_Confirm_to_withdraw", @"确认提现") font:nil];
    } else {
        [self setTitleBtnImage:@"check_stand_logo" title:PNLocalizedString(@"checkStand_pay_confirm", @"确认付款") font:nil];
    }
}

- (void)setupUI {
    [self.containerView addSubview:self.confirmButton];
    //    [self.containerView addSubview:self.cancelButton];
    [self.containerView addSubview:self.scrollViews];
    [self.containerView addSubview:self.detailLB];

    UINavigationController *navc = self.navigationController;
    if ([navc isKindOfClass:PayHDCheckstandViewController.class]) {
        PayHDCheckstandViewController *checkStandVc = (PayHDCheckstandViewController *)navc;

        __weak __typeof(self) weakSelf = self;
        checkStandVc.tappedShadowHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(checkStandViewBaseControllerUserClosedCheckStand:)]) {
                [strongSelf.delegate checkStandViewBaseControllerUserClosedCheckStand:strongSelf];
            }
            [strongSelf hideContainerViewAndDismissCheckStand];
        };
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    if (!self.detailLB.hidden) {
        [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBarView.mas_bottom).offset(kRealWidth(30));
            make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.containerView);
        }];
    }

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(50));
        make.bottom.equalTo(self.containerView).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];

    [self.scrollViews mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.detailLB.hidden) {
            make.top.equalTo(self.detailLB.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.equalTo(self.navBarView.mas_bottom).offset(kRealWidth(4));
        }
        make.width.centerX.equalTo(self.containerView);
        make.bottom.equalTo(self.confirmButton.mas_top);
    }];
    UIView *lastView;
    for (UIView *view in self.rowViews) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViews.mas_top).offset(kRealWidth(15));
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(15));
            }
            make.width.equalTo(self.scrollViews).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.scrollViews);
            if (![view isKindOfClass:HDCommonInfoRowView.class]) {
                make.height.mas_equalTo(1);
            }
            if ([view isEqual:self.rowViews[self.rowViews.count - 1]]) {
                make.bottom.equalTo(self.scrollViews.mas_bottom).offset(-kRealWidth(15) - kiPhoneXSeriesSafeBottomHeight);
            }
        }];
        lastView = view;
    }
}

- (void)scrollViewsDidScroll:(UIScrollView *)scrollViews {
    //    HDLog(@"%f",scrollViews.contentOffset.y);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize detailRealSize = [_detailLB sizeThatFits:CGSizeMake(MAXFLOAT, _detailLB.height)];
    CGSize detailCurrentSize = _detailLB.bounds.size;

    if (self.buildModel.tradeType == PNTransTypeExchange && !CGSizeEqualToSize(detailCurrentSize, CGSizeZero) && detailRealSize.width > detailCurrentSize.width) {
        // 这里可以根据宽度差值，动态设置两边金额的字体大小，中间保持不变
        HDLog(@"详情文字显示不全了，将重新计算最适合的文字大小并重新计算偏移");

        CGSize middleSize = [self.subTitleModel.middleStr boundingAllRectWithSize:CGSizeMake(MAXFLOAT, detailCurrentSize.height) font:[HDAppTheme.font boldForSize:self.subTitleModel.middleFontSize]];

        CGFloat beyondMinusWidth = detailRealSize.width - middleSize.width;
        CGFloat minusWidth = detailCurrentSize.width - middleSize.width;
        CGFloat scale = minusWidth / (CGFloat)beyondMinusWidth;
        // 向下取整，否则仍然可能显示不全
        CGFloat newSideFontSize = floor(self.subTitleModel.sideFontSize * scale);
        self.subTitleModel.sideFontSize = newSideFontSize;
        [self setDetailAttrTextForCurrentSubTitleModel];
    }

    if (!self.isInitialLayoutEnded) {
        // 默认隐藏
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.containerView.height);

        self.isInitialLayoutEnded = YES;
    }
}

#pragma mark - Data
- (void)getCashTools {
    if (!self.buildModel) {
        HDLog(@"订单模型为空");
        return;
    }
    self.tradeNo = self.buildModel.tradeNo;
    self.subTradeType = self.buildModel.subTradeType;

    [self showloading];
    __weak __typeof(self) weakSelf = self;
    [self.checkStandViewModel cashTool:self.tradeNo success:^(PNCashToolsRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];
        strongSelf.cashToosRspModel = rspModel;

        // 处理数据，刷新界面
        [strongSelf entertainmentGenerateDataAndRefreshUI];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];
        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
    }];
}
- (void)paymentTools {
    if (!self.buildModel) {
        HDLog(@"订单模型为空");
        return;
    }

    self.tradeNo = self.buildModel.tradeNo;
    self.subTradeType = self.buildModel.subTradeType;

    [self showloading];
    __weak __typeof(self) weakSelf = self;

    [self.checkStandViewModel paymentTools:self.tradeNo success:^(PayHDTradeCreatePaymentRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];

        strongSelf.createPaymentRspModel = rspModel;

        // 处理数据，刷新界面
        [strongSelf coolcashGenerateDataAndRefreshUIWithModel:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];
        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
    }];
}

- (void)createPayment {
    if (!self.buildModel) {
        HDLog(@"订单模型为空");
        return;
    }

    self.tradeNo = self.buildModel.tradeNo;

    [self showloading];
    __weak __typeof(self) weakSelf = self;

    [self.checkStandViewModel pn_tradeCreatePaymentWithAmount:self.buildModel.payAmt.cent currency:self.buildModel.payAmt.cy tradeNo:self.buildModel.tradeNo
        success:^(PayHDTradeCreatePaymentRspModel *_Nonnull rspModel) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissLoading];

            strongSelf.createPaymentRspModel = rspModel;

            // 处理数据，刷新界面
            [strongSelf generateDataAndRefreshUIWithModel:rspModel];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissLoading];
            [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
}
/** 获取出金订单凭证 */
- (void)requestCashOutVoucherNo {
    __weak __typeof(self) weakSelf = self;
    [self showloading];

    PNCashToolsMethodPaymentItemModel *paymentItem = nil;
    if (self.buildModel.subTradeType == PNTradeSubTradeTypeEntertainment && !HDIsArrayEmpty(self.cashToosRspModel.methodPayment)) {
        paymentItem = self.cashToosRspModel.methodPayment.firstObject;
    }
    [self.checkStandViewModel coolCashOutCashAcceptWithTradeNo:self.buildModel.tradeNo paymentCurrency:0 methodPayment:paymentItem success:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];

        HDLog(@"获取到订单凭证");
        //密码输入
        [strongSelf navigateToInputPasswordPageWithModel:rspModel];

        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(checkStandViewBaseController:confirmOrderSuccessWithVoucherNo:)]) {
            [strongSelf.delegate checkStandViewBaseController:strongSelf confirmOrderSuccessWithVoucherNo:rspModel.voucherNo];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];
        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
    }];
}

/** 获取订单凭证 */
- (void)requestVoucherNo {
    if (self.buildModel.subTradeType == PNTradeSubTradeTypeCoolCashCashOut || self.buildModel.subTradeType == PNTradeSubTradeTypeEntertainment) { //出金二维码 娱乐缴费都走汇兑
        [self requestCashOutVoucherNo];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [self showloading];

    [self.checkStandViewModel pn_tradeConfirmPaymentWithTradeNo:self.buildModel.tradeNo paymentCurrency:0 success:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];

        HDLog(@"获取到订单凭证");
        [strongSelf navigateToInputPasswordPageWithModel:rspModel];

        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(checkStandViewBaseController:confirmOrderSuccessWithVoucherNo:)]) {
            [strongSelf.delegate checkStandViewBaseController:strongSelf confirmOrderSuccessWithVoucherNo:rspModel.voucherNo];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissLoading];
        [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
    }];
}

/// 提现银行卡
- (void)withdrawToBankCardCreateOrder {
    __weak __typeof(self) weakSelf = self;
    [self showloading];

    [self.checkStandViewModel ms_withdrawToBankCardCreateOrder:self.buildModel.payAmt.cent currency:self.buildModel.caseInAccount accountNumber:self.buildModel.accountNumber
        participantCode:self.buildModel.participantCode success:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissLoading];

            HDLog(@"获取到订单凭证");
            [strongSelf navigateToInputPasswordPageWithModel:rspModel];

            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(checkStandViewBaseController:confirmOrderSuccessWithVoucherNo:)]) {
                [strongSelf.delegate checkStandViewBaseController:strongSelf confirmOrderSuccessWithVoucherNo:rspModel.cashVoucherNo];
            }
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissLoading];
            [strongSelf dealingWithTransactionFailure:rspModel.msg code:rspModel.code];
        }];
}

#pragma mark - private methods
/** 支付失败 */
- (void)dealingWithTransactionFailure:(NSString *)reason code:(NSString *)code {
    [self dismissLoading];

    if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandBaseViewController:transactionFailure:code:)]) {
        [self.delegate checkStandBaseViewController:self transactionFailure:reason code:code];
    } else {
        [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            [self.navigationController dismissAnimated:YES completion:nil];
        }];
    }
}

/**
 根据屏幕宽度动态重新计算详情文字两边字体大小并重新计算 BaselineOffset
 */
- (void)setDetailAttrTextForCurrentSubTitleModel {
    UIFont *sideFont = [HDAppTheme.font boldForSize:self.subTitleModel.sideFontSize];
    UIFont *middleFont = [HDAppTheme.font boldForSize:self.subTitleModel.middleFontSize];

    NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *leftStr = [[NSAttributedString alloc] initWithString:self.subTitleModel.leftStr
                                                                  attributes:@{NSForegroundColorAttributeName: self.subTitleModel.sideColor, NSFontAttributeName: sideFont}];
    [mutableAttrStr appendAttributedString:leftStr];

    NSAttributedString *middleStr = [[NSAttributedString alloc] initWithString:self.subTitleModel.middleStr
                                                                    attributes:@{NSForegroundColorAttributeName: self.subTitleModel.middleColor, NSFontAttributeName: middleFont}];
    [mutableAttrStr appendAttributedString:middleStr];

    NSAttributedString *rightStr = [[NSAttributedString alloc] initWithString:self.subTitleModel.rightStr
                                                                   attributes:@{NSForegroundColorAttributeName: self.subTitleModel.sideColor, NSFontAttributeName: sideFont}];
    [mutableAttrStr appendAttributedString:rightStr];

    [mutableAttrStr addAttribute:NSBaselineOffsetAttributeName value:@((sideFont.lineHeight - middleFont.lineHeight) * 0.5 + (sideFont.descender - middleFont.descender))
                           range:NSMakeRange(leftStr.length, middleStr.length)];

    _detailLB.attributedText = mutableAttrStr;
}

- (void)navigateToInputPasswordPageWithModel:(PayHDTradeConfirmPaymentRspModel *)model {
    PayHDCheckstandInputPwdViewController *inputPwdVC = [[PayHDCheckstandInputPwdViewController alloc] initWithNumberOfCharacters:6];
    inputPwdVC.model = model;
    inputPwdVC.tradeNo = model.tradeNo;
    inputPwdVC.tradeType = self.createPaymentRspModel.tradeType;
    inputPwdVC.buildModel = self.buildModel;
    inputPwdVC.buildModel.confirmRspMode = model;
    [self.navigationController pushViewControllerDiscontinuous:inputPwdVC animated:YES];
}

#pragma mark

// MARK: coolcash 出金确认
- (void)coolcashGenerateDataAndRefreshUIWithModel:(PayHDTradeCreatePaymentRspModel *)rspModel {
    HDLog(@"coolcashGenerateDataAndRefreshUIWithModel");
    // 显示界面
    [UIView animateWithDuration:kPayHDPresentDefaultTransitionDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 通知代理收银台已展示
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandBaseViewControllerDidShown:)]) {
            [self.delegate checkStandBaseViewControllerDidShown:self];
        }
    }];

    self.confirmButton.enabled = YES;

    [self.rowViews removeAllObjects];
    [self.scrollViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    HDDealCommonInfoRowViewModel *infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
    infoModel.key = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"出金金额");
    infoModel.value = rspModel.orderAmt.thousandSeparatorAmount;
    HDCommonInfoRowView *rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];

    //按产品需求
    [self.rowViews addObject:rowView];

    infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
    infoModel.key = PNLocalizedString(@"coolcash_user_fee", @"手续费");
    infoModel.value = rspModel.userFeeAmt.thousandSeparatorAmount;
    rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
    [self.rowViews addObject:rowView];

    void (^judgeShouldAddSepLine)(void) = ^() {
        // 分割线
        if (rspModel.couponList.count > 0 || rspModel.methodList.count > 0) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [HDAppTheme.color G4];
            // [self.rowViews addObject:line];
        }
    };

    __weak __typeof(self) weakSelf = self;
    // 优惠方式
    PayHDTradePreferentialModel *firstPreferential;
    if (rspModel.couponList.count > 0) {
        // 拿索引最小的那个
        firstPreferential = rspModel.couponList.firstObject;
        NSArray<PayHDTradePreferentialModel *> *filteredArr =
            [rspModel.couponList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PayHDTradePreferentialModel *model, NSDictionary *bindings) {
                                     return model.sort <= firstPreferential.sort;
                                 }]];

        if (filteredArr && filteredArr.count > 0) {
            // 排序
            filteredArr = [filteredArr sortedArrayUsingComparator:^NSComparisonResult(PayHDTradePreferentialModel *_Nonnull obj1, PayHDTradePreferentialModel *_Nonnull obj2) {
                return obj1.sort < obj2.sort;
            }];

            firstPreferential = filteredArr.lastObject;
        }

        judgeShouldAddSepLine();

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.needRightArrow = YES;
        infoModel.valueColor = [UIColor hd_colorWithHexString:@"#FD7127"];

        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];

        firstPreferential.selected = YES;
        firstPreferential.showStamp = true;

        rowView.tappedHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            HDLog(@"打开选择优惠界面");
            PayHDCheckstandChooseCouponTicketViewController *vc = [PayHDCheckstandChooseCouponTicketViewController.alloc init];
            [vc configureWithCouponList:rspModel.couponList isSelectedDontUseCoupon:WJIsArrayEmpty(strongSelf.orderPreferentialList)];

            __weak __typeof(strongSelf) weakSelf2 = strongSelf;
            vc.choosedCouponModelHandler = ^(PayHDTradePreferentialModel *_Nonnull model) {
                __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
                [strongSelf2 caculateCouponMoneyWithRspModel:rspModel couponModel:model];
            };
            vc.tradeNo = rspModel.tradeNo;
            [strongSelf.navigationController pushViewControllerDiscontinuous:vc animated:YES];
        };

        // 引用
        self.couponInfoView = rowView;
        // 无优惠就不显示
        if (firstPreferential) {
            [self.rowViews addObject:rowView];
        }
    } else {
        judgeShouldAddSepLine();
    }

    if (rspModel.methodList.count > 0) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"checkStand_pay_method", @"付款方式");

        if (rspModel.methodList.count > 1) {
            infoModel.needRightArrow = YES;
        }

        // 拿索引最小的那个
        PayHDTradePaymentMethodModel *firstPaymentMethod = rspModel.methodList.firstObject;
        NSArray<PayHDTradePaymentMethodModel *> *filteredArr =
            [rspModel.methodList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PayHDTradePreferentialModel *model, NSDictionary *bindings) {
                                     return model.sort <= firstPaymentMethod.sort;
                                 }]];
        if (filteredArr && filteredArr.count > 0) {
            firstPaymentMethod = filteredArr.firstObject;
        }

        // 设置支付方式
        self.orderPaymethodList = @[firstPaymentMethod];

        infoModel.value
            = (firstPaymentMethod.method == PNTradePaymentMethodTypeUSD || firstPaymentMethod.method == PNTradePaymentMethodTypeKHR) ? PNLocalizedString(@"Balance", @"余额") : firstPaymentMethod.desc;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];

        if (rspModel.methodList.count > 1) {
            rowView.tappedHandler = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                HDLog(@"打开付款方式界面");
                PayHDCheckstandChoosePayMethodViewController *vc = [PayHDCheckstandChoosePayMethodViewController.alloc init];
                vc.payAmount = strongSelf.finalPayMentModel;
                vc.payMethodList = rspModel.methodList;
                vc.tradeNo = rspModel.tradeNo;
                [strongSelf.navigationController pushViewControllerDiscontinuous:vc animated:true];
            };
        }
        // [self.rowViews addObject:rowView];
    }

    // 设置标题和订单详情描述
    if (self.buildModel.tradeType == PNTransTypeExchange) {
        PayHDCheckstandPaymentDetailTitleModel *model = [[PayHDCheckstandPaymentDetailTitleModel alloc] init];
        model.leftStr = self.buildModel.payAmt.thousandSeparatorAmount;
        model.middleStr = PNLocalizedString(@"checkStand_exchange_to", @" 兑换为 ");
        model.rightStr = self.buildModel.payeeAmount.thousandSeparatorAmount;
        self.subTitleModel = model;

        [self setDetailAttrTextForCurrentSubTitleModel];

    } else {
        [self caculateCouponMoneyWithRspModel:rspModel couponModel:firstPreferential];
    }

    // 订单信息
    infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
    infoModel.key = PNLocalizedString(@"Transaction_type", @"交易类型");
    infoModel.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
    [self.rowViews addObject:rowView];

    if (self.buildModel.subTradeType == PNTradeSubTradeTypeToBank || self.buildModel.subTradeType == PNTradeSubTradeTypeToBakong || self.buildModel.subTradeType == PNTradeSubTradeTypeToBakongCode
        || self.buildModel.subTradeType == PNTradeSubTradeTypeToAgent) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        VipayUser *user = [VipayUser shareInstance];
        infoModel.value = user.loginName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"Receiver_account", @"收款人");
        infoModel.value = self.buildModel.payeeName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_Receiving_bank", @"收款银行");
        infoModel.value = self.buildModel.payeeBankName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_receiver_account", @"收款账号");
        infoModel.value = self.buildModel.payeeNo;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"order_amount", @"订单金额");
        infoModel.value = rspModel.orderAmt.thousandSeparatorAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
        NSString *str = @"";
        if ([rspModel.orderAmt.cy isEqualToString:PNCurrencyTypeKHR]) {
            str = [NSString stringWithFormat:@"%@0", rspModel.orderAmt.currencySymbol];
        } else {
            str = [NSString stringWithFormat:@"%@0.00", rspModel.orderAmt.currencySymbol];
        }
        infoModel.value = rspModel.userFeeAmt.thousandSeparatorAmount.length > 0 ? rspModel.userFeeAmt.thousandSeparatorAmount : str;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        if (self.buildModel.subTradeType == PNTradeSubTradeTypeToBakongCode || self.buildModel.subTradeType == PNTradeSubTradeTypeToAgent) {
            if (self.buildModel.payeeStoreName.length > 0) {
                infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
                infoModel.key = PNLocalizedString(@"Collection_shop", @"收款店铺");
                infoModel.value = self.buildModel.payeeStoreName;
                rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
                [self.rowViews addObject:rowView];
            }
            if (self.buildModel.payeeStoreName.length > 0) {
                infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
                infoModel.key = PNLocalizedString(@"location", @"定位");
                infoModel.value = self.buildModel.payeeStoreLocation;
                rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
                [self.rowViews addObject:rowView];
            }
        }
    }

    if (rspModel.tradeType == PNTransTypeExchange) {
        // 兑换汇率
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"exchange_rate", @"兑换汇率");
        infoModel.value = [NSString stringWithFormat:@"%@1.00=%@%@",
                                                     [PNCommonUtils getCurrencySymbolByCode:PNCurrencyTypeUSD],
                                                     [PNCommonUtils getCurrencySymbolByCode:PNCurrencyTypeKHR],
                                                     [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[NSString stringWithFormat:@"%@", rspModel.exchangeRate] currencyCode:@"KHR"]];

        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    if (self.buildModel && self.buildModel.customerInfo.count) {
        for (HDDealCommonInfoRowViewModel *customerInfoModel in self.buildModel.customerInfo) {
            [self.rowViews addObject:[HDCommonInfoRowView commonInfoRowViewWithModel:customerInfoModel]];
        }
    }
    if (self.buildModel.remark.length > 0) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"Remark", @"备注");
        infoModel.value = self.buildModel.remark;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    for (UIView *view in self.rowViews) {
        [self.scrollViews addSubview:view];
    }
    [self.view setNeedsUpdateConstraints];
}

/// MARK: nor
- (void)generateDataAndRefreshUIWithModel:(PayHDTradeCreatePaymentRspModel *)rspModel {
    HDLog(@"generateDataAndRefreshUIWithModel");
    // 显示界面
    [UIView animateWithDuration:kPayHDPresentDefaultTransitionDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 通知代理收银台已展示
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandBaseViewControllerDidShown:)]) {
            [self.delegate checkStandBaseViewControllerDidShown:self];
        }
    }];

    self.confirmButton.enabled = YES;

    [self.rowViews removeAllObjects];
    [self.scrollViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    HDDealCommonInfoRowViewModel *infoModel;
    HDCommonInfoRowView *rowView;
    /// 转账到手机号
    if (rspModel.tradeType == PNTransTypeToPhone) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"transfer_amount", @"转账金额");
        infoModel.value = rspModel.orderAmt.thousandSeparatorAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    } else {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额");
        infoModel.value = rspModel.orderAmt.thousandSeparatorAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];

        // 如果有优惠才显示订单金额
        if (rspModel.couponList.count > 0 || rspModel.userFeeAmt.cent.integerValue > 0) {
            [self.rowViews addObject:rowView];
        }
    }

    if (rspModel.userFeeAmt.cent.integerValue > 0) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"vipay_user_fee", @"ViPay手续费");
        infoModel.value = rspModel.userFeeAmt.thousandSeparatorAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    void (^judgeShouldAddSepLine)(void) = ^() {
        // 分割线
        if (rspModel.couponList.count > 0 || rspModel.methodList.count > 0) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [HDAppTheme.color G4];
            // [self.rowViews addObject:line];
        }
    };

    __weak __typeof(self) weakSelf = self;
    // 优惠方式
    PayHDTradePreferentialModel *firstPreferential;
    if (rspModel.couponList.count > 0) {
        // 拿索引最小的那个
        firstPreferential = rspModel.couponList.firstObject;
        NSArray<PayHDTradePreferentialModel *> *filteredArr =
            [rspModel.couponList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PayHDTradePreferentialModel *model, NSDictionary *bindings) {
                                     return model.sort <= firstPreferential.sort;
                                 }]];

        if (filteredArr && filteredArr.count > 0) {
            // 排序
            filteredArr = [filteredArr sortedArrayUsingComparator:^NSComparisonResult(PayHDTradePreferentialModel *_Nonnull obj1, PayHDTradePreferentialModel *_Nonnull obj2) {
                return obj1.sort < obj2.sort;
            }];

            firstPreferential = filteredArr.lastObject;
        }

        judgeShouldAddSepLine();

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.needRightArrow = YES;
        infoModel.valueColor = [UIColor hd_colorWithHexString:@"#FD7127"];

        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];

        firstPreferential.selected = YES;
        firstPreferential.showStamp = true;

        rowView.tappedHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            HDLog(@"打开选择优惠界面");
            PayHDCheckstandChooseCouponTicketViewController *vc = [PayHDCheckstandChooseCouponTicketViewController.alloc init];
            [vc configureWithCouponList:rspModel.couponList isSelectedDontUseCoupon:WJIsArrayEmpty(strongSelf.orderPreferentialList)];

            __weak __typeof(strongSelf) weakSelf2 = strongSelf;
            vc.choosedCouponModelHandler = ^(PayHDTradePreferentialModel *_Nonnull model) {
                __strong __typeof(weakSelf2) strongSelf2 = weakSelf2;
                [strongSelf2 caculateCouponMoneyWithRspModel:rspModel couponModel:model];
            };
            vc.tradeNo = rspModel.tradeNo;
            [strongSelf.navigationController pushViewControllerDiscontinuous:vc animated:YES];
        };

        // 引用
        self.couponInfoView = rowView;
        // 无优惠就不显示
        if (firstPreferential) {
            [self.rowViews addObject:rowView];
        }
    } else {
        judgeShouldAddSepLine();
    }

    if (rspModel.methodList.count > 0) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"checkStand_pay_method", @"付款方式");

        if (rspModel.methodList.count > 1) {
            infoModel.needRightArrow = YES;
        }

        // 拿索引最小的那个
        PayHDTradePaymentMethodModel *firstPaymentMethod = rspModel.methodList.firstObject;
        NSArray<PayHDTradePaymentMethodModel *> *filteredArr =
            [rspModel.methodList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PayHDTradePreferentialModel *model, NSDictionary *bindings) {
                                     return model.sort <= firstPaymentMethod.sort;
                                 }]];
        if (filteredArr && filteredArr.count > 0) {
            firstPaymentMethod = filteredArr.firstObject;
        }

        // 设置支付方式
        self.orderPaymethodList = @[firstPaymentMethod];

        infoModel.value
            = (firstPaymentMethod.method == PNTradePaymentMethodTypeUSD || firstPaymentMethod.method == PNTradePaymentMethodTypeKHR) ? PNLocalizedString(@"Balance", @"余额") : firstPaymentMethod.desc;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];

        if (rspModel.methodList.count > 1) {
            rowView.tappedHandler = ^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                HDLog(@"打开付款方式界面");
                PayHDCheckstandChoosePayMethodViewController *vc = [PayHDCheckstandChoosePayMethodViewController.alloc init];
                vc.payAmount = strongSelf.finalPayMentModel;
                vc.payMethodList = rspModel.methodList;
                vc.tradeNo = rspModel.tradeNo;
                [strongSelf.navigationController pushViewControllerDiscontinuous:vc animated:true];
            };
        }
        // [self.rowViews addObject:rowView];
    }

    // 设置标题和订单详情描述
    if (self.buildModel.tradeType == PNTransTypeExchange) {
        PayHDCheckstandPaymentDetailTitleModel *model = [[PayHDCheckstandPaymentDetailTitleModel alloc] init];
        model.leftStr = self.buildModel.payAmt.thousandSeparatorAmount;
        model.middleStr = PNLocalizedString(@"checkStand_exchange_to", @" 兑换为 ");
        model.rightStr = self.buildModel.payeeAmount.thousandSeparatorAmount;
        self.subTitleModel = model;

        [self setDetailAttrTextForCurrentSubTitleModel];

    } else {
        [self caculateCouponMoneyWithRspModel:rspModel couponModel:firstPreferential];
    }

    // 订单信息
    if (rspModel.tradeType != PNTransTypeToPhone) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"Transaction_type", @"交易类型");
        infoModel.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    /*
     PNTradeSubTradeTypeToBank 转账到银行
     PNTradeSubTradeTypeToBakong 转账到bakong
     PNTradeSubTradeTypeToBakongCode 扫码转账到bakong
     PNTradeSubTradeTypeToAgent 扫码转账到代理商
     */
    if (self.buildModel.subTradeType == PNTradeSubTradeTypeToBank || self.buildModel.subTradeType == PNTradeSubTradeTypeToBakong || self.buildModel.subTradeType == PNTradeSubTradeTypeToBakongCode
        || self.buildModel.subTradeType == PNTradeSubTradeTypeToAgent) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        VipayUser *user = [VipayUser shareInstance];
        infoModel.value = user.loginName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"Receiver_account", @"收款人");
        infoModel.value = self.buildModel.payeeName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"order_amount", @"订单金额");
        infoModel.value = rspModel.orderAmt.thousandSeparatorAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        if (rspModel.userFeeAmt.cent.integerValue > 0) {
            infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
            infoModel.key = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
            NSString *str = @"";
            if ([rspModel.orderAmt.cy isEqualToString:PNCurrencyTypeKHR]) {
                str = [NSString stringWithFormat:@"%@0", rspModel.orderAmt.currencySymbol];
            } else {
                str = [NSString stringWithFormat:@"%@0.00", rspModel.orderAmt.currencySymbol];
            }
            infoModel.value = rspModel.userFeeAmt.thousandSeparatorAmount.length > 0 ? rspModel.userFeeAmt.thousandSeparatorAmount : str;
            rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
            [self.rowViews addObject:rowView];
        }

        if (self.buildModel.subTradeType == PNTradeSubTradeTypeToBakongCode || self.buildModel.subTradeType == PNTradeSubTradeTypeToAgent) {
            if (self.buildModel.payeeStoreName.length > 0) {
                infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
                infoModel.key = PNLocalizedString(@"Collection_shop", @"收款店铺");
                infoModel.value = self.buildModel.payeeStoreName;
                rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
                [self.rowViews addObject:rowView];
            }
            if (self.buildModel.payeeStoreName.length > 0) {
                infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
                infoModel.key = PNLocalizedString(@"location", @"定位");
                infoModel.value = self.buildModel.payeeStoreLocation;
                rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
                [self.rowViews addObject:rowView];
            }
        }
    }

    if (rspModel.tradeType == PNTransTypeTransfer && !WJIsObjectNil(rspModel.exchangeRate)) {
        // 兑换汇率
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"exchange_rate", @"兑换汇率");
        infoModel.value = [NSString stringWithFormat:@"%@1.00=%@%@",
                                                     [PNCommonUtils getCurrencySymbolByCode:PNCurrencyTypeUSD],
                                                     [PNCommonUtils getCurrencySymbolByCode:PNCurrencyTypeKHR],
                                                     [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[NSString stringWithFormat:@"%@", rspModel.exchangeRate] currencyCode:@"KHR"]];

        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    /// 转账才有手续费显示
    if ((WJIsStringEmpty(self.buildModel.bizType) || [self.buildModel.bizType isEqualToString:PNTransferTypeToCoolcash] || [self.buildModel.bizType isEqualToString:PNTransferTypePersonalToBaKong] ||
         [self.buildModel.bizType isEqualToString:PNTransferTypePersonalToBank] || [self.buildModel.bizType isEqualToString:PNTransferTypePersonalScanQRToBakong] ||
         [self.buildModel.bizType isEqualToString:PNTransferTypeToPhone])
        && (rspModel.tradeType == PNTransTypeTransfer || rspModel.tradeType == PNTransTypeToPhone)) {
        if (!WJIsObjectNil(rspModel.orderFeeAmt)) {
            /// 订单金额手续费
            infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
            infoModel.key = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
            NSString *str = @"";
            if ([rspModel.orderFeeAmt.cy isEqualToString:PNCurrencyTypeKHR]) {
                str = [NSString stringWithFormat:@"%@0", rspModel.orderFeeAmt.currencySymbol];
            } else {
                str = [NSString stringWithFormat:@"%@0.00", rspModel.orderFeeAmt.currencySymbol];
            }
            infoModel.value = rspModel.orderFeeAmt.thousandSeparatorAmount.length > 0 ? rspModel.orderFeeAmt.thousandSeparatorAmount : str;
            rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
            [self.rowViews addObject:rowView];
        }

        /// 活动减免
        if (rspModel.discountFeeAmt.cent.integerValue > 0) {
            infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
            infoModel.key = PNLocalizedString(@"Fee_free", @"活动减免");
            infoModel.value = [NSString stringWithFormat:@"-%@", rspModel.discountFeeAmt.thousandSeparatorAmount];
            rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
            [self.rowViews addObject:rowView];
        }
    }

    /// 转账到手机号
    if (rspModel.tradeType == PNTransTypeToPhone) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"receive_phone", @"收款手机号");
        infoModel.value = self.buildModel.payeeName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    if (self.buildModel && self.buildModel.customerInfo.count) {
        for (HDDealCommonInfoRowViewModel *customerInfoModel in self.buildModel.customerInfo) {
            [self.rowViews addObject:[HDCommonInfoRowView commonInfoRowViewWithModel:customerInfoModel]];
        }
    }
    if (self.buildModel.remark.length > 0) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"Remark", @"备注");
        infoModel.value = self.buildModel.remark;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    for (UIView *view in self.rowViews) {
        [self.scrollViews addSubview:view];
    }
    [self.view setNeedsUpdateConstraints];
}

/// MARK: 商户入金确认
- (void)ms_generateDataAndRefreshUI {
    self.subTradeType = self.buildModel.subTradeType;
    HDLog(@"ms_generateDataAndRefreshUI");
    // 显示界面
    [UIView animateWithDuration:kPayHDPresentDefaultTransitionDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 通知代理收银台已展示
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandBaseViewControllerDidShown:)]) {
            [self.delegate checkStandBaseViewControllerDidShown:self];
        }
    }];

    self.confirmButton.enabled = YES;

    [self.rowViews removeAllObjects];
    [self.scrollViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //标题
    self.detailLB.hidden = YES;
    //    self.detailLB.text = self.buildModel.caseInAmount;

    HDDealCommonInfoRowViewModel *infoModel;
    HDCommonInfoRowView *rowView;

    if (self.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_Withdrawal_account", @"提现账户");
        infoModel.value = self.buildModel.caseInAccount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"ms_receiver", @"收款人");
        infoModel.value = self.buildModel.receiver;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"Transaction_type", @"交易类型");
        infoModel.value = self.buildModel.casetInType;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_withdarw_amount", @"提现金额");
        infoModel.value = self.buildModel.caseInAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

    } else if (self.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_Receiving_bank", @"收款银行");
        infoModel.value = self.buildModel.bankName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_Receiver_name", @"收款人姓名");
        infoModel.value = self.buildModel.accountName;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_Receiver_bank_account", @"收款银行账号");
        infoModel.value = self.buildModel.accountNumber;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"pn_withdarw_amount", @"提现金额");
        infoModel.value = self.buildModel.caseInAmount;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }

    for (UIView *view in self.rowViews) {
        [self.scrollViews addSubview:view];
    }
    [self.view setNeedsUpdateConstraints];
}

/// MARK: 娱乐缴费UI
- (void)entertainmentGenerateDataAndRefreshUI {
    self.subTradeType = self.buildModel.subTradeType;
    HDLog(@"entertainmentGenerateDataAndRefreshUI");
    // 显示界面
    [UIView animateWithDuration:kPayHDPresentDefaultTransitionDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 通知代理收银台已展示
        if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandBaseViewControllerDidShown:)]) {
            [self.delegate checkStandBaseViewControllerDidShown:self];
        }
    }];

    self.confirmButton.enabled = YES;
    self.detailLB.text = self.cashToosRspModel.amt.thousandSeparatorAmount;

    [self.rowViews removeAllObjects];
    [self.scrollViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    HDDealCommonInfoRowViewModel *infoModel;
    HDCommonInfoRowView *rowView;

    // 订单信息
    infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
    infoModel.key = PNLocalizedString(@"Transaction_type", @"交易类型");
    infoModel.value = PNLocalizedString(@"bill_payment", @"账单支付");
    rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
    [self.rowViews addObject:rowView];

    if (!HDIsArrayEmpty(self.cashToosRspModel.methodPayment)) {
        __block NSString *amoutStr = @"";
        [self.cashToosRspModel.methodPayment enumerateObjectsUsingBlock:^(PNCashToolsMethodPaymentItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *money = [SAMoneyTools thousandSeparatorNoCurrencySymbolWithAmountYuan:[NSString stringWithFormat:@"%@", obj.amount] currencyCode:obj.currency];
            amoutStr = [amoutStr stringByAppendingFormat:@"%@:%@", obj.currency, money];
            if (idx != self.cashToosRspModel.methodPayment.count - 1) {
                amoutStr = [amoutStr stringByAppendingString:@"\n"];
            }
        }];

        infoModel = [[HDDealCommonInfoRowViewModel alloc] init];
        infoModel.key = PNLocalizedString(@"detail_total_amount", @"支付金额");
        infoModel.value = amoutStr;
        rowView = [HDCommonInfoRowView commonInfoRowViewWithModel:infoModel];
        [self.rowViews addObject:rowView];
    }
    for (UIView *view in self.rowViews) {
        [self.scrollViews addSubview:view];
    }
    [self.view setNeedsUpdateConstraints];
}

#pragma mark
/**
 计算优惠金额

 @param model 优惠模型
 */
- (void)caculateCouponMoneyWithRspModel:(PayHDTradeCreatePaymentRspModel *)rspModel couponModel:(PayHDTradePreferentialModel *)model {
    _detailLB.text = rspModel.payAmt.thousandSeparatorAmount;
    /*
    if (!model) {
        // 无优惠
        PayHDTradePreferentialModel *dontUseCouponModel = [[PayHDTradePreferentialModel alloc] init];
        dontUseCouponModel.couponAmt = [SAMoneyModel modelWithAmount:@"0" currency:@"USD"];
        dontUseCouponModel.isDontUseCoupon = YES;
        dontUseCouponModel.type = PNTradePreferentialTypeDefault;
        model = dontUseCouponModel;
    }

    // 设置订单优惠，不使用优惠传空数组
    self.orderPreferentialList = !model.isDontUseCoupon ? @[ model ] : @[];

    // 计算真实优惠金额
    SAMoneyModel *finalCouponAmount = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", model.couponAmt.cent.integerValue] currency:model.couponAmt.cy];

    // 处理小数点问题，因为这里的金额是单位全是分，所以瑞尔判断是100整数倍，美金判断是1整数倍
    if ([finalCouponAmount.cy isEqualToString:PNCurrencyTypeUSD]) {
        if (finalCouponAmount.cent.integerValue % 1 != 0) {
            finalCouponAmount.cent = [NSString stringWithFormat:@"%ld", (long)(finalCouponAmount.cent.integerValue / 1) * 1];
        }
    } else if ([finalCouponAmount.cy isEqualToString:PNCurrencyTypeKHR]) {
        if (finalCouponAmount.cent.integerValue % 100 != 0) {
            finalCouponAmount.cent = [NSString stringWithFormat:@"%ld", (long)(finalCouponAmount.cent.integerValue / 100) * 100];
        }
    }
    // 用于判断优惠金额是否最大利用弹出提示
    self.currentPreferentialModel = model;
    self.finalCouponAmount = finalCouponAmount;

    HDLog(@"选择了优惠");
    NSString *valueText = @"";
    if (model.isDontUseCoupon) {
        valueText = PNLocalizedString(@"coupon_title_no_use", @"不使用优惠");
    } else {
        // 暂时只会有一种优惠
        valueText = [@"-" stringByAppendingString:[PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:finalCouponAmount.cent] currencyCode:finalCouponAmount.cy]];
    }

    // 优惠
    if (self.couponInfoView) {
        [self.couponInfoView updateKeyText:model.typeDesc valueText:valueText];
    }

    // 计算实付金额
    _finalPayMentModel = [[SAMoneyModel alloc] init];
    _finalPayMentModel.cy = rspModel.payAmt.cy;

    double finalAmount = rspModel.orderAmt.cent.doubleValue - finalCouponAmount.cent.doubleValue;
    // 可能优惠后金额为负数，显示为0即可
    finalAmount = (finalAmount > 0) ? finalAmount : 0;
    // 有用户手续费的情况，实付金额加上手续费
    if (rspModel.userFeeAmt) {
        finalAmount = finalAmount + rspModel.userFeeAmt.cent.integerValue;
    }
    _finalPayMentModel.cent = [NSString stringWithFormat:@"%.2f", finalAmount];

    _detailLB.text = self.finalPayMentModel.thousandSeparatorAmount;
     */
}

#pragma mark - override
- (void)clickOnBackBarButtonItem {
    // 提示是否放弃支付
    __weak __typeof(self) weakSelf = self;
    [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_CANCEL_TRANSATION", @"是否放弃本次交易?") confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];

            __strong __typeof(weakSelf) strongSelf = weakSelf;

            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(checkStandViewBaseControllerUserClosedCheckStand:)]) {
                [strongSelf.delegate checkStandViewBaseControllerUserClosedCheckStand:strongSelf];
            }

            [strongSelf hideContainerViewAndDismissCheckStand];
        }
        cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
}

- (void)clickedCancelBtn {
    [self clickOnBackBarButtonItem];
}
#pragma mark - event response
- (void)clickedConfirmBtn {
    if (self.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        [self withdrawToBankCardCreateOrder];
        return;
    }

    // 判断实际优惠金额是否小于优惠券最大面值金额，决定是否弹出提示
    PayHDTradePreferentialModel *model = self.currentPreferentialModel;
    if (model && !model.isDontUseCoupon) {
        // 拿实际优惠金额比较
        if (self.finalCouponAmount.cent.doubleValue < model.couponMoney.cent.doubleValue) {
            [NAT showAlertWithMessage:PNLocalizedString(@"not_full_using_cash_limit_tip", @"当前订单金额小于现金红包金额，不设找零，是否继续付款？")
                confirmButtonTitle:PNLocalizedString(@"title_continue", @"继续") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                    // 申请凭证
                    [self requestVoucherNo];
                }
                cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }];
            return;
        }
    }

    // 申请凭证
    [self requestVoucherNo];
}

#pragma mark - lazy load
- (UILabel *)detailLB {
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = [HDAppTheme.font boldForSize:30];
        _detailLB.textColor = [HDAppTheme.color G1];
        _detailLB.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLB;
}

- (HDCommonButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        //        [_confirmButton setTitle:PNLocalizedString(@"checkStand_pay_rightnow", @"立即付款", nil) forState:UIControlStateNormal];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确认") forState:UIControlStateNormal];
        _confirmButton.textAlignment = NSTextAlignmentCenter;
        _confirmButton.titleLabel.font = [HDAppTheme.font standard2];
        [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setBackgroundImage:[UIImage hd_imageWithColor:[UIColor hd_colorWithHexString:@"#FD7127"]] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage hd_imageWithColor:[UIColor hd_colorWithHexString:@"#EFB795"]] forState:UIControlStateDisabled];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

- (UIScrollView *)scrollViews {
    if (!_scrollViews) {
        _scrollViews = [[UIScrollView alloc] init];
        _scrollViews.delegate = self;
        _scrollViews.pagingEnabled = YES;
        _scrollViews.scrollEnabled = YES;
        _scrollViews.showsVerticalScrollIndicator = NO;
        _scrollViews.showsHorizontalScrollIndicator = NO;
    }
    return _scrollViews;
}

- (NSMutableArray<UIView *> *)rowViews {
    if (!_rowViews) {
        _rowViews = [NSMutableArray array];
    }
    return _rowViews;
}
@end

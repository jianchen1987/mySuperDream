//
//  SAAvailablePaymentMethodViewController.m
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAvailablePaymentMethodViewController.h"
#import "HDCheckStandChoosePaymentMethodViewModel.h"
#import "HDCheckStandInputPwdViewController.h"
#import "HDCheckStandPaymentMethodView.h"
#import "HDCheckStandRepaymentAlertView.h"
#import "HDCheckstandWebViewController.h"
#import "HDPaymentMethodType.h"
#import "PNPaymentComfirmViewController.h"
#import "SAChooseActivityAlertView.h"
#import "SAMoneyModel.h"
#import "SAOperationButton.h"
#import "SAPayHelper.h"
#import "SAPaymentActivityModel.h"
#import "SAPaymentMethodContainerTitleView.h"
#import "SAPaymentToolsActivityModel.h"
#import "SAWalletManager.h"
#import "SAWechatPayRequestModel.h"
#import "WXApiManager.h"
#import <HDUIKit/HDAnnouncementView.h>
#import <HDUIkit/HDCustomViewActionView.h>
#import "SAAppSwitchManager.h"
#import "HDCheckStandRepaymentShortAlertView.h"
#import "SAPaymentTipsActionSheetView.h"
#import "SAPaymentTipView.h"
#import "HDCheckstandQRCodePayViewController.h"
#import "LKDataRecord.h"

//针对汇旺不支持模拟器
#if !TARGET_IPHONE_SIMULATOR

#import <HuionePaySDK_iOS/HuionePaySDK_iOS.h>
#import "RRMerchantManager.h"

#endif


@interface SAAvailablePaymentMethodViewController () <PNPaymentComfirmViewControllerDelegate>
///< 公告栏
@property (nonatomic, strong) HDAnnouncementView *announcementView;
///< 实付金额
@property (nonatomic, strong) SALabel *actuallyPaidAmountLabel;
///< 应付金额
@property (nonatomic, strong) SALabel *payableAmountLabel;
///< 滑动容器
@property (nonatomic, strong) UIScrollView *scrollerView;
///< 线上支付容器
@property (nonatomic, strong) UIView *onlineContainer;
///< 线下支付容器
@property (nonatomic, strong) UIView *offlineContainer;
/// 扫码支付容器
@property (nonatomic, strong) UIView *qrCodePayContainer;
/// 维护提示容器
@property (nonatomic, strong) SAPaymentTipView *maintenanceTipsContainer;
///< 确认按钮
@property (nonatomic, strong) SAOperationButton *confirmButton;
///< vm
@property (nonatomic, strong) HDCheckStandChoosePaymentMethodViewModel *viewModel;
///< 当前选中的支付方式
@property (nonatomic, strong) HDCheckStandPaymentMethodCellModel *selectedPaymentMethod;
///< 应付金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
///< 实付金额
@property (nonatomic, strong) SAMoneyModel *actuallyPaidAmount;
/// 是否已经展示过选择信用卡提示
@property (nonatomic) BOOL showCreditTips;
/// 当前提交支付时间
@property (nonatomic, assign) NSInteger currentPayTime;
/// aba支付轮询等待时间
@property (nonatomic, assign) NSInteger abaPayLoadingTime;

@property (nonatomic, strong) HDTips *hud;
/// 是否已经展示过选择QRCode扫码提示
@property (nonatomic) BOOL showQRCodeTips;

///< 开始时间，调试用
@property (nonatomic, assign) NSTimeInterval startTime;

@end


@implementation SAAvailablePaymentMethodViewController

+ (instancetype)checkStandWithTradeBuildModel:(HDTradeBuildOrderModel *)buildModel {
    SAAvailablePaymentMethodViewController *vc = [[SAAvailablePaymentMethodViewController alloc] init];
    if (vc) {
        vc.viewModel.merchantNo = buildModel.merchantNo;
        vc.viewModel.storeNo = buildModel.storeNo;
        vc.viewModel.supportedPaymentMethod = buildModel.supportedPaymentMethods;
        vc.viewModel.payableAmount = buildModel.payableAmount;
        vc.viewModel.businessLine = buildModel.businessLine;
        vc.viewModel.goods = buildModel.goods;
        vc.viewModel.lastChoosedMethod = buildModel.selectedPaymentMethod;
        vc.viewModel.orderNo = buildModel.orderNo;
        vc.viewModel.outPayOrderNo = buildModel.outPayOrderNo;
        vc.startTime = [[NSDate new] timeIntervalSince1970];
    }
    return vc;
}

- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.containerView addSubview:self.announcementView];
    [self.containerView addSubview:self.actuallyPaidAmountLabel];
    [self.containerView addSubview:self.payableAmountLabel];
    [self.containerView addSubview:self.scrollView];
    [self.scrollView addSubview:self.onlineContainer];
    [self.scrollView addSubview:self.offlineContainer];
    [self.scrollView addSubview:self.qrCodePayContainer];
    [self.scrollView addSubview:self.maintenanceTipsContainer];
    [self.containerView addSubview:self.confirmButton];

    // 监听微信支付返回
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidReceivedWechatPayResult:) name:kNotificationWechatPayOnResponse object:nil];
    // 监听太子银行返回
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidReceivePrinceBankPayResult:) name:kNotificationNamePrinceBankResp object:nil];

#if !TARGET_IPHONE_SIMULATOR
    // 监听汇旺支付返回
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidReceiveHuiOnePayResult:) name:kNotificationNameHuiOneResp object:nil];
#endif
    [self logMessageString:@"子视图装载完毕..."];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationWechatPayOnResponse object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNamePrinceBankResp object:nil];
#if !TARGET_IPHONE_SIMULATOR
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameHuiOneResp object:nil];
#endif
}

- (void)hd_setupNavigation {
    [self setTitleBtnImage:nil title:SALocalizedString(@"order_choose_payment_method_title", @"选择支付方式") font:HDAppTheme.font.standard2Bold];
    [self setHd_statusBarStyle:UIStatusBarStyleDefault];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"paymentAnnoncement" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.viewModel.paymentAnnoncement)) {
            HDAnnouncementViewConfig *config = HDAnnouncementViewConfig.new;
            config.text = self.viewModel.paymentAnnoncement;
            config.backgroundColor = [UIColor hd_colorWithHexString:@"#FFEC9B"];
            config.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            config.textColor = [UIColor hd_colorWithHexString:@"#73000000"];
            self.announcementView.config = config;
            self.announcementView.hidden = NO;
        } else {
            self.announcementView.hidden = YES;
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"availablePaymentMethods" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self logMessageString:@"初始化数据加载完毕，开始生成布局..."];
        [self generateUI];
    }];

    self.actuallyPaidAmount = self.viewModel.payableAmount;
    [self logMessageString:@"开始初始化数据..."];
    [self.viewModel initialize];
}

- (void)updateViewConstraints {
    if (!self.announcementView.isHidden) {
        [self.announcementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.width.centerX.equalTo(self.containerView);
            make.height.mas_equalTo(kRealHeight(42));
        }];
    }

    [self.actuallyPaidAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView.mas_right).offset(-HDAppTheme.value.padding.right);
        if (!self.announcementView.isHidden) {
            make.top.equalTo(self.announcementView.mas_bottom).offset(kRealHeight(20));
        } else {
            make.top.equalTo(self.containerView.mas_top).offset(kRealHeight(20));
        }
        make.height.mas_equalTo(kRealHeight(50));
    }];

    if (!self.payableAmountLabel.isHidden) {
        [self.payableAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.containerView.mas_right).offset(-HDAppTheme.value.padding.right);
            make.top.equalTo(self.actuallyPaidAmountLabel.mas_bottom).offset(kRealHeight(5));
        }];
    }

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealHeight(10) - kiPhoneXSeriesSafeBottomHeight);
        make.height.mas_equalTo(kRealHeight(50));
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.actuallyPaidAmountLabel.mas_bottom).offset(kRealHeight(46));
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-kRealHeight(20));
    }];

    if (!self.onlineContainer.isHidden) {
        [self.onlineContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.scrollView);
            make.left.right.top.equalTo(self.scrollView);
            if (self.offlineContainer.isHidden && self.qrCodePayContainer.isHidden) {
                make.bottom.equalTo(self.scrollView.mas_bottom);
            }
        }];

        UIView *topView = nil;
        for (UIView *subView in self.onlineContainer.subviews) {
            [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.onlineContainer.mas_left);
                make.right.equalTo(self.onlineContainer.mas_right);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom);
                } else {
                    make.top.equalTo(self.onlineContainer);
                }
            }];
            topView = subView;
        }
        if (topView) {
            [topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.onlineContainer.mas_bottom);
            }];
        }
    }

    if (!self.offlineContainer.isHidden) {
        [self.offlineContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.scrollView);
            make.left.right.equalTo(self.scrollView);

            if (self.onlineContainer.isHidden) {
                make.top.equalTo(self.scrollView.mas_top);
            } else {
                make.top.equalTo(self.onlineContainer.mas_bottom).offset(kRealHeight(10));
            }
            if (self.qrCodePayContainer.hidden && self.maintenanceTipsContainer.hidden) {
                make.bottom.equalTo(self.scrollView);
            }
        }];

        UIView *topView = nil;
        for (UIView *subView in self.offlineContainer.subviews) {
            [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.offlineContainer.mas_left);
                make.right.equalTo(self.offlineContainer.mas_right);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom);
                } else {
                    make.top.equalTo(self.offlineContainer);
                }
            }];
            topView = subView;
        }
        if (topView) {
            [topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.offlineContainer.mas_bottom);
            }];
        }
    }

    if (!self.qrCodePayContainer.hidden) {
        [self.qrCodePayContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.scrollView);
            make.left.right.bottom.equalTo(self.scrollView);
            if (!self.offlineContainer.isHidden) {
                make.top.equalTo(self.offlineContainer.mas_bottom).offset(kRealHeight(10));
            } else if (!self.onlineContainer.isHidden) {
                make.top.equalTo(self.onlineContainer.mas_bottom).offset(kRealHeight(10));
            } else {
                make.top.equalTo(self.scrollView.mas_top);
            }
        }];

        UIView *topView = nil;
        for (UIView *subView in self.qrCodePayContainer.subviews) {
            [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.qrCodePayContainer.mas_left);
                make.right.equalTo(self.qrCodePayContainer.mas_right);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom);
                } else {
                    make.top.equalTo(self.qrCodePayContainer);
                }
            }];
            topView = subView;
        }
        if (topView) {
            [topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.qrCodePayContainer.mas_bottom);
            }];
        }
    }

    if (!self.maintenanceTipsContainer.hidden) {
        [self.maintenanceTipsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.scrollView);
            make.left.right.bottom.equalTo(self.scrollView);
            if (!self.qrCodePayContainer.hidden) {
                make.top.equalTo(self.qrCodePayContainer.mas_bottom).offset(kRealHeight(10));
            } else if (!self.offlineContainer.hidden) {
                make.top.equalTo(self.offlineContainer.mas_bottom).offset(kRealHeight(10));
            } else {
                make.top.equalTo(self.scrollView.mas_top);
            }
            make.height.mas_equalTo(100);
        }];
    }

    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)generateUI {
    // 清空
    [self.onlineContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:HDCheckStandPaymentMethodView.class]) {
            [obj removeFromSuperview];
        }
    }];

    [self.offlineContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:HDCheckStandPaymentMethodView.class]) {
            [obj removeFromSuperview];
        }
    }];

    [self.qrCodePayContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:HDCheckStandPaymentMethodView.class]) {
            [obj removeFromSuperview];
        }
    }];

    @HDWeakify(self);
    [self.viewModel.availablePaymentMethods enumerateObjectsUsingBlock:^(HDCheckStandPaymentMethodCellModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);

        @HDWeakify(self);
        HDCheckStandPaymentMethodView *methodView =
            [[HDCheckStandPaymentMethodView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding), kRealHeight(65))];
        methodView.model = model;
        methodView.clickedHandler = ^(HDCheckStandPaymentMethodView *_Nonnull view, HDCheckStandPaymentMethodCellModel *_Nonnull model) {
            @HDStrongify(self);
            if (!model.isShow)
                return;
            [self clickedOnPaymentMethodView:view];
        };
        methodView.clickedActivityHandler = ^(HDCheckStandPaymentMethodView *_Nonnull view, HDCheckStandPaymentMethodCellModel *_Nonnull model) {
            @HDStrongify(self);
            [self showActivitysChooseViewWithCurrentView:view model:model];
        };

        if (model.paymentMethod == SAOrderPaymentTypeOnline) {
            [self.onlineContainer addSubview:methodView];
            self.onlineContainer.hidden = NO;
        } else if (model.paymentMethod == SAOrderPaymentTypeQRCode) {
            [self.qrCodePayContainer addSubview:methodView];
            self.qrCodePayContainer.hidden = NO;
        } else {
            [self.offlineContainer addSubview:methodView];
            self.offlineContainer.hidden = NO;
        }
    }];

    if (self.onlineContainer.hidden) {
        self.maintenanceTipsContainer.hidden = NO;
        if (!self.offlineContainer.hidden || !self.qrCodePayContainer.hidden) {
            self.maintenanceTipsContainer.isOnlyOnline = YES;
        }
    }


    [self adjustPayableAmount];

    [self showloading];
    [self autoSubmitCompletion:^(BOOL showCheckStand) {
        @HDStrongify(self);
        [self dismissLoading];
        
        if (showCheckStand) {
            [self logMessageString:@"准备显示收银台..."];
            [self showCheckStandView];
        } else {
            [self logMessageString:@"不需要显示收银台，直接跳到支付工具页面"];
        }
    }];
    [self logMessageString:@"布局准备完毕..."];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Event
- (void)clickedOnConfirmButton:(SAOperationButton *)button {
    @HDWeakify(self);
    //信用卡支付提示
    if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsCredit] && !self.showCreditTips) {
        self.showCreditTips = YES;
        SAPaymentTipsActionSheetView *alertView = SAPaymentTipsActionSheetView.new;
        alertView.title = self.selectedPaymentMethod.text;
        alertView.submitBlock = ^{
            @HDStrongify(self);
            [self clickedOnConfirmButton:button];
            HDLog(@"点击继续付款喔");
        };
        [alertView show];
        return;
    }


    if (self.selectedPaymentMethod.paymentMethod == SAOrderPaymentTypeQRCode && !self.showQRCodeTips) {
        self.showQRCodeTips = YES;
        SAPaymentTipsActionSheetView *alertView = SAPaymentTipsActionSheetView.new;
        alertView.title = self.selectedPaymentMethod.text;
        alertView.detailText = SALocalizedString(@"pay_khqr_tip1", @"需要使用Bakong App或支持KHQR的银行App，扫描生成的KHQR二维码来完成付款");
        alertView.submitBlock = ^{
            @HDStrongify(self);
            [self clickedOnConfirmButton:button];
        };
        [alertView show];
        return;
    }

    if (self.choosePaymentMethodHandler) {
        HDPaymentMethodType *paymentMethod = HDPaymentMethodType.new;
        paymentMethod.method = self.selectedPaymentMethod.paymentMethod;
        paymentMethod.toolCode = [self.selectedPaymentMethod.toolCode copy];
        if (self.selectedPaymentMethod.currentActivity) {
            paymentMethod.ruleNo = self.selectedPaymentMethod.currentActivity.ruleNo;
        }
        self.choosePaymentMethodHandler(paymentMethod, self.selectedPaymentMethod.currentActivity.discountAmt);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    // 没有支付单，检查聚合单
    if (HDIsStringNotEmpty(self.viewModel.orderNo)) {
        // 有聚合单，创建支付单然后提交支付
        [self showloading];
        [self createPaymentOrderAndSubmitCompletion:^(BOOL showCheckStand) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else if (HDIsStringNotEmpty(self.viewModel.outPayOrderNo)) {
        // 已经有支付单，直接提交支付
        [self showloading];
        [self submitPaymentParamsCompletion:^(BOOL showCheckStand) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else {
        [NAT showAlertWithMessage:SALocalizedString(@"vC5GSc6S", @"订单号为空") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                              [self.navigationController dismissViewControllerAnimated:true completion:nil];
                          }];
    }
}

- (void)clickedOnPaymentMethodView:(HDCheckStandPaymentMethodView *)view {
    if ([view.model.toolCode isEqualToString:HDCheckStandPaymentToolsBalance] && !view.model.isUsable) {
        /// 未开通,去开通钱包  /  已注册未激活
        if (self.viewModel.userWallet && (!self.viewModel.userWallet.walletCreated || (self.viewModel.userWallet.walletCreated && [self.viewModel.userWallet.accountStatus isEqualToString:PNWAlletAccountStatusNotActive]))) {
            @HDWeakify(self);

            [SAWalletManager adjustShouldSettingPayPwdCompletion:^(BOOL needSetting, BOOL isSuccess) {
                @HDStrongify(self);
                if (isSuccess) {
                    HDLog(@"开通钱包完成/激活钱包 刷新");
                    [self.viewModel initialize];
                }
            }];
        }
        return;
    }

    if (!self.onlineContainer.isHidden) {
        [self.onlineContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:HDCheckStandPaymentMethodView.class]) {
                HDCheckStandPaymentMethodView *trueView = obj;
                if ([trueView isEqual:view]) {
                    [trueView setSelected:YES animated:YES];
                } else {
                    [trueView setSelected:NO animated:YES];
                }
            }
        }];
    }

    if (!self.offlineContainer.isHidden) {
        [self.offlineContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:HDCheckStandPaymentMethodView.class]) {
                HDCheckStandPaymentMethodView *trueView = obj;
                if ([trueView isEqual:view]) {
                    [trueView setSelected:YES animated:YES];
                } else {
                    [trueView setSelected:NO animated:YES];
                }
            }
        }];
    }

    if (!self.qrCodePayContainer.isHidden) {
        [self.qrCodePayContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:HDCheckStandPaymentMethodView.class]) {
                HDCheckStandPaymentMethodView *trueView = obj;
                if ([trueView isEqual:view]) {
                    [trueView setSelected:YES animated:YES];
                } else {
                    [trueView setSelected:NO animated:YES];
                }
            }
        }];
    }


    [self adjustPayableAmount];
}

#pragma mark - private methods
- (void)showCheckStandView {
    @HDWeakify(self);
    void (^completion)(BOOL) = ^void(BOOL finished) {
        @HDStrongify(self);
        [self logMessageString:@"收银台展示完毕..."];
        // 通知代理收银台已展示
        if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerDidShown:)]) {
            [self.checkStand.resultDelegate checkStandViewControllerDidShown:self.checkStand];
        }
    };

    void (^animations)(void) = ^void(void) {
        @HDStrongify(self);
        self.checkStand.view.transform = CGAffineTransformIdentity;
    };

    // 显示界面
    [UIView animateWithDuration:kHDCSPresentDefaultTransitionDuration
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:animations
                     completion:completion];
}

- (void)autoSubmitCompletion:(void (^)(BOOL showCheckStand))completion {
    if (self.choosePaymentMethodHandler) {
        !completion ?: completion(YES);
        return;
    }

    if (!HDIsObjectNil(self.viewModel.lastChoosedMethod) && !HDIsObjectNil(self.selectedPaymentMethod)) {
        // 之前有选过，且当前可用，直接提交
        [self logMessageString:@"已经预选支付方式，自动创建支付单..."];
        [self createPaymentOrderAndSubmitCompletion:completion];
    } else {
        !completion ?: completion(YES);
    }
}

///似乎已废弃
- (void)showRepaymetAlert {
    HDCheckStandRepaymentAlertViewConfig *config = HDCheckStandRepaymentAlertViewConfig.new;
    @HDWeakify(self);
    config.clickOnContinuePaymentHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
        @HDStrongify(self);
        [self createPaymentOrderAndSubmitCompletion:nil];
    };
    config.clickOnWailtPaymentResultHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
        @HDStrongify(self);
        [self wailtForPaymentResult];
    };
    config.clickOnServiceHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
        @HDStrongify(self);
        [self contactCustomerService];
    };
    HDCheckStandRepaymentAlertView *alertView = [HDCheckStandRepaymentAlertView alertViewWithConfig:config];
    alertView.identitableString = @"HDCheckStandRepaymentAlertView";
    [alertView show];
}

- (void)wailtForPaymentResult {
    [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:nil];
}

- (void)contactCustomerService {
    [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
        [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/help-center"}];
    }];
}

- (void)showRepaymentShortAlert {
    HDCheckStandRepaymentShortAlertViewConfig *config = HDCheckStandRepaymentShortAlertViewConfig.new;
    @HDWeakify(self);
    // 还没付款
    config.clickOnWailtPaymentResultHandler = ^(HDCheckStandRepaymentShortAlertView *_Nonnull alertView) {
        @HDStrongify(self);
        [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];
    };

    HDCheckStandRepaymentShortAlertView *alertView = [HDCheckStandRepaymentShortAlertView alertViewWithConfig:config];
    alertView.identitableString = @"HDCheckStandRepaymentShortAlertView"; // 加上标志，确保只弹一次
    [alertView show];
}

- (void)createPaymentOrderAndSubmitCompletion:(void (^)(BOOL showCheckStand))completion {
    @HDWeakify(self);
    [self.viewModel createPayOrderWithOrderNo:self.viewModel.orderNo
                                      trialId:self.selectedPaymentMethod.currentActivity.trialId
                                payableAmount:self.viewModel.payableAmount
                               discountAmount:self.selectedPaymentMethod.currentActivity.discountAmt
                             isCashOnDelivery:self.selectedPaymentMethod.paymentMethod == SAOrderPaymentTypeCashOnDelivery
                                      success:^(HDCreatePayOrderRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
        [self logMessageString:@"支付单创建成功..."];
            self.viewModel.outPayOrderNo = rspModel.outPayOrderNo;
            self.checkStand.buildModel.outPayOrderNo = rspModel.outPayOrderNo; // 更新支付单号

            if ([self.viewModel.payableAmount minus:self.selectedPaymentMethod.currentActivity.discountAmt].cent.integerValue == 0) {
                HDLog(@"实付金额为0，直接交易成功");
                !completion ?: completion(NO);
                [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];
                return;
            }

            if (self.selectedPaymentMethod.paymentMethod == SAOrderPaymentTypeCashOnDelivery) {
                HDLog(@"货到付款提交成功");
                !completion ?: completion(NO);

                [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                    if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerCashOnDeliveryCompleted:bussineLine:orderNo:)]) {
                        [self.checkStand.resultDelegate checkStandViewControllerCashOnDeliveryCompleted:self.checkStand bussineLine:self.viewModel.businessLine orderNo:self.viewModel.orderNo];
                    }
                }];

                return;
            }

            if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
                [self dismissLoading];
                [self goToWalletPaymentComfirm:rspModel.outPayOrderNo completion:completion];
                //扫码支付直接跳转
            } else if (self.selectedPaymentMethod.paymentMethod == SAOrderPaymentTypeQRCode) {
                [self getQRCodePayDetailWithAggregateOrderNo:self.viewModel.orderNo completion:completion];
            } else {
                [self submitPaymentParamsCompletion:completion];
            }
        
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            !completion ?: completion(YES);
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:failureWithRspModel:errorType:error:)]) {
                [self.checkStand.resultDelegate checkStandViewController:self.checkStand failureWithRspModel:rspModel errorType:errorType error:error];
            }
        }];
}

- (void)getQRCodePayDetailWithAggregateOrderNo:(NSString *)aggregateOrderNo completion:(void (^)(BOOL showCheckstand))completion {
    @HDWeakify(self);
    [self.viewModel getQRCodePayDetailWithAggregateOrderNo:aggregateOrderNo success:^(HDCheckStandQRCodePayDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        !completion ?: completion(NO);
        @HDWeakify(self);
        [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
            @HDStrongify(self);
            HDCheckstandQRCodePayViewController *vc = HDCheckstandQRCodePayViewController.new;
            vc.model = rspModel;
            @HDWeakify(self);
            vc.closeByUser = ^{
                HDLog(@"用户关闭啦");
                @HDStrongify(self);
                //强引用self，避免收银台提前关闭丢失回调
                if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerCompletedAndPaymentUnknow:)]) {
                    [self.checkStand.resultDelegate checkStandViewControllerCompletedAndPaymentUnknow:self.checkStand];
                }
            };
            [SAWindowManager navigateToViewController:vc];
        }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(YES);
        @HDStrongify(self);
        if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:failureWithRspModel:errorType:error:)]) {
            [self.checkStand.resultDelegate checkStandViewController:self.checkStand failureWithRspModel:rspModel errorType:errorType error:error];
        }
    }];
}

- (void)submitPaymentParamsCompletion:(void (^)(BOOL showCheckstand))completion {
    @HDWeakify(self);
    [self logMessageString:@"开始提交支付参数..."];
    [self.viewModel submitPaymentParamsWithPaymentTools:self.selectedPaymentMethod.toolCode
                                                orderNo:self.viewModel.orderNo
                                          outPayOrderNo:self.viewModel.outPayOrderNo
                                                success:^(HDCheckStandOrderSubmitParamsRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
        [self logMessageString:@"支付参数提交成功，开始根据选择的支付工具处理数据..."];
            [self handlingSuccessSubmitPaymentParamsWithRspModel:rspModel completion:completion];
        
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            !completion ?: completion(YES);
            [self logMessageString:@"支付参数提交失败."];
            if ([rspModel.code isEqualToString:@"C0104"] && HDIsStringNotEmpty(self.viewModel.orderNo)) {
                // 支付处理中，可重新发起支付
                [self showRepaymetAlert];
                return;
            }
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:failureWithRspModel:errorType:error:)]) {
                [self.checkStand.resultDelegate checkStandViewController:self.checkStand failureWithRspModel:rspModel errorType:errorType error:error];
            }
        }];
}

- (void)handlingSuccessSubmitPaymentParamsWithRspModel:(HDCheckStandOrderSubmitParamsRspModel *)rspModel completion:(void (^)(BOOL showCheckstand))completion {
    // 保存当前选中的支付方式
    HDPaymentMethodType *lastSuccessPaymentMethod = [HDPaymentMethodType onlineMethodWithPaymentTool:self.selectedPaymentMethod.toolCode];
    [SACacheManager.shared setObject:lastSuccessPaymentMethod forKey:kCacheKeyCheckStandLastTimeChoosedPaymentMethod type:SACacheTypeDocumentNotPublic];

    // 根据 payWay 生成 payResult 模型
    if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsWechat]) {
        !completion ?: completion(YES);

        // 先判断是否安装微信
        BOOL isSupported = [SAPayHelper isSupportWechatPayAppNotInstalledHandler:^{
            [self paymentUnknowWithTips:SALocalizedString(@"not_install_wechat", @"未安装微信") errorType:HDCheckStandPayResultErrorTypeAppNotInstalled];
        } appNotSupportApiHandler:^{
            [self paymentUnknowWithTips:SALocalizedString(@"wechat_not_support", @"当前微信版本不支持此功能") errorType:HDCheckStandPayResultErrorTypeAppApiNotSupport];
        }];
        
        if (isSupported) {
            NSDictionary *payResultDict = rspModel.payUrl.hd_dictionary;
            SAWechatPayRequestModel *requestModel = [SAWechatPayRequestModel yy_modelWithJSON:payResultDict];
            if (!payResultDict || !requestModel) {
                [self paymentUnknowWithTips:SALocalizedString(@"invalid_payment_parameters", @"支付参数无效") errorType:HDCheckStandPayResultErrorTypeAppParamsInValid];
            } else {
                [WXApiManager.sharedManager sendPayReq:requestModel];
            }
        }
        
    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) { //钱包已经不走这里了
        HDLog(@"余额支付");
        !completion ?: completion(YES);
        [self navigateToInputPasswordPageWithModel:rspModel animated:YES];

    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsAlipay]) {
        HDLog(@"支付宝支付");
    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsABAPay]) {
        !completion ?: completion(YES);
        HDLog(@"ABA支付:%@", [NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]);
        if (HDIsStringNotEmpty(rspModel.deeplink)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]]) {
                //延时0.25，处理偶发不弹等待支付结果loading
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]] options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        [HDSystemCapabilityUtil gotoAppStoreForAppID:@"968860649"];
                    } else {
                        // 1.获取aba轮询等待时间
                        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
                        HDLog(@"ABA支付，轮询等待时间 = %ld", loadingTime);
                        // 2.轮询等待时间大于0时
                        if (loadingTime > 0) {
                            HDLog(@"需要轮询");
                            self.abaPayLoadingTime = loadingTime;
                            self.currentPayTime = time(NULL);

                            //轮询调用
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                self.hud = [HDTips showLoading:SALocalizedString(@"top_up_to_be_paid", @"等待支付结果") inView:self.view];
                                [self _checkPaymentState];
                            });

                        } else {
                            HDLog(@"不需要轮询");
                            // 拉起app不管成功失败都回调
                            [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];
                        }
                    }
                }];

            } else {
                [HDSystemCapabilityUtil gotoAppStoreForAppID:@"968860649"];
            }
        } else {
            @HDWeakify(self);
            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                @HDStrongify(self);
                [self openInWebviewWithUrl:rspModel.payUrl];
            }];
        }
    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsWing]) {
        // 1.获取aba轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        // 2.有轮询等待时间情况，需要弹窗选择框
        !completion ?: completion(loadingTime > 0 ? YES : NO);

        NSString *url = rspModel.payUrl;
        if (loadingTime > 0) {
            self.abaPayLoadingTime = loadingTime;
            self.currentPayTime = time(NULL); //记录发起时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openInWebviewWithUrl:url];
            });
        } else {
            @HDWeakify(self);
            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                @HDStrongify(self);
                [self openInWebviewWithUrl:url];
            }];
        }

    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsCredit]) {
        // 1.获取aba轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        // 2.有轮询等待时间情况，需要弹窗选择框
        !completion ?: completion(loadingTime > 0 ? YES : NO);

        NSString *url = [rspModel.payUrl stringByAppendingFormat:@"/%@", SAUser.shared.loginName];

        if (loadingTime > 0) {
            self.abaPayLoadingTime = loadingTime;
            self.currentPayTime = time(NULL); //记录发起时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openInWebviewWithUrl:url];
            });
        } else {
            @HDWeakify(self);
            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                @HDStrongify(self);
                [self openInWebviewWithUrl:url];
            }];
        }
    } else if([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsSmartPay]) {
        // 1.获取aba轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        // 2.有轮询等待时间情况，需要弹窗选择框
        !completion ?: completion(loadingTime > 0 ? YES : NO);

        if (loadingTime > 0) {
            self.abaPayLoadingTime = loadingTime;
            self.currentPayTime = time(NULL); //记录发起时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self openInWebviewWithUrl:rspModel.payUrl];
            });
        } else {
            @HDWeakify(self);
            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                @HDStrongify(self);
                [self openInWebviewWithUrl:rspModel.payUrl];
            }];
        }
    }
//    else if([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsAlipayPlus]) {
//        // 1.获取aba轮询等待时间
//        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
//        // 2.有轮询等待时间情况，需要弹窗选择框
//        !completion ?: completion(loadingTime > 0 ? YES : NO);
//
//        if (loadingTime > 0) {
//            self.abaPayLoadingTime = loadingTime;
//            self.currentPayTime = time(NULL); //记录发起时间
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self openInWebviewWithUrl:rspModel.deeplink];
//            });
//        } else {
//            @HDWeakify(self);
//            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
//                @HDStrongify(self);
//                [self openInWebviewWithUrl:rspModel.deeplink];
//            }];
//        }
//        
//    }
#if !TARGET_IPHONE_SIMULATOR
    else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsPrince]) {
        !completion ?: completion(YES);
        // xdbank://
        // 太子银行
        if (HDIsStringNotEmpty(rspModel.tokenStr)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"xdbank://rrpay"]]) {
                [[RRMerchantManager shared] openPrinceBankWithOrder:rspModel.tokenStr];
            } else {
                [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1480524848"];
            }
        } else {
            [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];
        }
    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsHuiOneV2]) {
        !completion ?: completion(YES);
        if(HDIsStringNotEmpty(rspModel.deeplink)) {
            NSDictionary *params = [rspModel.deeplink hd_dictionary];
            NSString *iOSParamStr = [params objectForKey:@"iOS"];
            NSString *data = [[iOSParamStr hd_dictionary] objectForKey:@"data"];
            NSString *payOrder = [[data hd_dictionary] objectForKey:@"outTradeNo"];
            
            [HuionePaySDK pay:payOrder name:@"huione2" callback:^(NSString * _Nonnull error) {
                if(HDIsStringNotEmpty(error)) {
                    HDLog(@"汇旺拉起异常:%@", error);
                    [LKDataRecord.shared traceEvent:@"@DEBUG" name:@"拉起汇旺SDKV2失败"
                                         parameters:@{@"resultDic": error, @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]}
                                                SPM:nil];
                    //没安装汇旺app跳转到应用市场
                    [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1177980631"];
                }
            }];

        } else {
            [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];
        }
    }
#endif
    else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsACLEDABank]) {
        !completion ?: completion(YES);
        HDLog(@"ACLEDA BANK支付:%@", [NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]);
        if (HDIsStringNotEmpty(rspModel.deeplink)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]]) {
                //延时0.25，处理偶发不弹等待支付结果loading
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]] options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1196285236"];
                    } else {
                        // 1.获取aba轮询等待时间
                        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
                        HDLog(@"ABA支付，轮询等待时间 = %ld", loadingTime);
                        // 2.轮询等待时间大于0时
                        if (loadingTime > 0) {
                            HDLog(@"需要轮询");
                            self.abaPayLoadingTime = loadingTime;
                            self.currentPayTime = time(NULL);

                            //轮询调用
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                self.hud = [HDTips showLoading:SALocalizedString(@"top_up_to_be_paid", @"等待支付结果") inView:self.view];
                                [self _checkPaymentState];
                            });

                        } else {
                            HDLog(@"不需要轮询");
                            // 拉起app不管成功失败都回调
                            [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];
                        }
                    }
                }];

            } else {
                [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1196285236"];
            }
        } else {
            @HDWeakify(self);
            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                @HDStrongify(self);
                [self openInWebviewWithUrl:rspModel.payUrl];
            }];
        }
    } else if ([self.selectedPaymentMethod.toolCode isEqualToString:HDCheckStandPaymentToolsABAKHQR]) {
        !completion ?: completion(YES);
        HDLog(@"ABA KHQR :%@", [NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]);
        //优先app拉起H5的aba khqr网页
        if (HDIsStringNotEmpty(rspModel.checkoutQrUrl)) {
            @HDWeakify(self);
            [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
                @HDStrongify(self);
                [self openInWebviewWithUrl:rspModel.checkoutQrUrl];
            }];
        }
        //如果能拉起ABA app接着拉起aba app
        if (HDIsStringNotEmpty(rspModel.deeplink)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]]) {
                //延时0.25，处理偶发不弹等待支付结果loading
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]] options:@{} completionHandler:nil];
            }
        }
    }
}

- (void)navigateToInputPasswordPageWithModel:(HDCheckStandOrderSubmitParamsRspModel *)model animated:(BOOL)animated {
    HDCheckStandInputPwdViewController *inputPwdVC = [[HDCheckStandInputPwdViewController alloc] initWithNumberOfCharacters:6];
    inputPwdVC.model = model;
    // TODO: 后面优化
    if (self.viewModel.lastChoosedMethod) {
        [self.navigationController pushViewController:inputPwdVC animated:NO];
    } else {
        [self.navigationController pushViewControllerDiscontinuous:inputPwdVC animated:animated];
    }
}

- (void)openInWebviewWithUrl:(NSString *)url {
    HDCheckstandWebViewController *webVC = [[HDCheckstandWebViewController alloc] init];
    webVC.url = url;
    @HDWeakify(self);
    webVC.closeByUser = ^{
        HDLog(@"用户关闭啦");
        @HDStrongify(self);
        //获取轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        if (loadingTime > 0) {
            HDLog(@"需要轮询");
            //轮询调用
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud = [HDTips showLoading:SALocalizedString(@"top_up_to_be_paid", @"等待支付结果") inView:self.view];
                [self _checkPaymentState];
            });

        } else {
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerCompletedAndPaymentUnknow:)]) {
                [self.checkStand.resultDelegate checkStandViewControllerCompletedAndPaymentUnknow:self.checkStand];
            }
        }
    };
    [SAWindowManager navigateToViewController:webVC];
}

- (void)showActivitysChooseViewWithCurrentView:(HDCheckStandPaymentMethodView *)view model:(HDCheckStandPaymentMethodCellModel *)model {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.contentHorizontalEdgeMargin = 0;

    NSMutableParagraphStyle *ParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    ParagraphStyle.lineHeightMultiple = 1;
    ParagraphStyle.lineSpacing = 0;
    ParagraphStyle.paragraphSpacing = 0;
    ParagraphStyle.paragraphSpacingBefore = 0;

    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"checksd_choose_coupon", @"Choose discount")
                                                                              attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold],
        NSForegroundColorAttributeName: HDAppTheme.color.G1,
        NSParagraphStyleAttributeName: ParagraphStyle
    }];

    [title appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[@" | " stringByAppendingString:model.text]
                                                                         attributes:@{
               NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightRegular],
               NSForegroundColorAttributeName: HDAppTheme.color.G1,
               NSParagraphStyleAttributeName: ParagraphStyle,
               NSBaselineOffsetAttributeName: @(([UIFont systemFontOfSize:17 weight:UIFontWeightSemibold].lineHeight - [UIFont systemFontOfSize:12 weight:UIFontWeightRegular].lineHeight) / 2
                                                + (([UIFont systemFontOfSize:17 weight:UIFontWeightSemibold].descender - [UIFont systemFontOfSize:12 weight:UIFontWeightRegular].descender)))
           }]];

    config.attriTitle = title;
    config.textAlignment = HDCustomViewActionViewTextAlignmentLeft;
    config.style = HDCustomViewActionViewStyleClose;

    SAChooseActivityAlertView *alertView = [[SAChooseActivityAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    alertView.data = model.paymentActivitys.rule;
    alertView.currentActivity = model.currentActivity;
    [alertView layoutyImmediately];

    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:alertView config:config];

    @HDWeakify(self);
    alertView.clickedActivity = ^(SAPaymentActivityModel *_Nullable activity) {
        @HDStrongify(self);
        [actionView dismiss];
        model.currentActivity = activity;
        [view updateUI];
        // 选择了活动，需要重新计算实付
        [self adjustPayableAmount];
    };

    [actionView show];
}

#pragma mark 钱包支付确认页
- (void)goToWalletPaymentComfirm:(NSString *)tradeNo completion:(void (^)(BOOL showCheckstand))completion {
    !completion ?: completion(YES);

    PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
    buildModel.tradeNo = tradeNo;
    buildModel.fromType = PNPaymentBuildFromType_Middle;
    buildModel.payWay = HDCheckStandPaymentToolsBalance;

    PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentSuccess:)]) {
        [self.checkStand.resultDelegate checkStandViewController:self.checkStand paymentSuccess:nil];
    }
    [controller removeFromParentViewController];
}

// 异常，支付状态未知，需要关闭收银台
- (void)paymentUnknowWithTips:(NSString *_Nullable)tips errorType:(HDCheckStandPayResultErrorType)type {
    
    if(HDIsStringNotEmpty(tips)) {
        [NAT showToastWithTitle:nil content:tips type:HDTopToastTypeError];
    }
    
    [self hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:^{
        if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerCompletedAndPaymentUnknow:)]) {
            [self.checkStand.resultDelegate checkStandViewControllerCompletedAndPaymentUnknow:self.checkStand];
        }
    }];
}

- (void)adjustPayableAmount {
    // 实付金额用应付初始化
    SAMoneyModel *actuallyPaidAmount = self.viewModel.payableAmount;

    HDCheckStandPaymentMethodCellModel *currentChoosePaymentMethod = [self.viewModel.availablePaymentMethods hd_filterWithBlock:^BOOL(HDCheckStandPaymentMethodCellModel *_Nonnull item) {
                                                                         return item.isSelected;
                                                                     }].firstObject;

    if (!currentChoosePaymentMethod) {
        HDLog(@"没有选中的支付方式");
        self.confirmButton.enabled = NO;
        return;
    }
    // 当前支付工具有营销，且营销可用
    if (currentChoosePaymentMethod.currentActivity && currentChoosePaymentMethod.currentActivity.fulfill == HDPaymentActivityStateAvailable) {
        actuallyPaidAmount = [actuallyPaidAmount minus:currentChoosePaymentMethod.currentActivity.discountAmt];
    }

    if ([actuallyPaidAmount.cent isEqualToString:self.viewModel.payableAmount.cent] && [actuallyPaidAmount.cy isEqualToString:self.viewModel.payableAmount.cy]) {
        // 没有优惠 or 门槛没达到 or 没有活动
        self.actuallyPaidAmount = actuallyPaidAmount;
        self.payableAmount = nil;
    } else {
        // 实付用优惠后金额
        self.actuallyPaidAmount = actuallyPaidAmount;
        // 应付用原金额
        self.payableAmount = self.viewModel.payableAmount;
    }
    self.selectedPaymentMethod = currentChoosePaymentMethod;
    self.confirmButton.enabled = YES;
    [self.view setNeedsUpdateConstraints];
}

- (void)_checkPaymentState {
    HDLog(@"查询支付结果");
    HDLog(@"轮询时长%ld秒", self.abaPayLoadingTime);
    HDLog(@"发起支付时间%ld", self.currentPayTime);
    @HDWeakify(self);
    [self.viewModel queryOrderPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);

        if (rspModel.payState == SAPaymentStatePayed) { //支付完成
            HDLog(@"请求成功,支付完成");
            [self.hud hideAnimated:NO];
            [self paymentUnknowWithTips:nil errorType:HDCheckStandPayResultErrorTypeStatusUnknown];

        } else if (rspModel.payState == SAPaymentStatePayFail || rspModel.payState == SAPaymentStateClosed) { //支付失败、支付关闭
            HDLog(@"请求成功，支付失败、支付关闭，取消loading");
            [self.hud hideAnimated:NO];
            [self showRepaymentShortAlert];

        } else {
            HDLog(@"请求成功，支付非确定的结果，判断是否继续轮询还是取消loading");
            NSInteger now = time(NULL);
            HDLog(@"当前时间%ld", now);
            if (now - self.currentPayTime >= self.abaPayLoadingTime) {
                HDLog(@"请求成功,超过轮询时间，取消loading");
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_checkPaymentState) object:nil];
                [self.hud hideAnimated:NO];
                [self showRepaymentShortAlert];
            } else {
                HDLog(@"请求成功,还在轮询时间内，重新请求");
                [self performSelector:@selector(_checkPaymentState) withObject:nil afterDelay:2];
            }
            
        }
        
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        NSInteger now = time(NULL);
        HDLog(@"当前时间%ld", now);
        if (now - self.currentPayTime >= self.abaPayLoadingTime) {
            HDLog(@"请求失败,超过轮询时间，取消loading");
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_checkPaymentState) object:nil];
            [self.hud hideAnimated:NO];
            [self showRepaymentShortAlert];
            
        } else {
            HDLog(@"请求失败,还在轮询时间内，重新请求");
            [self performSelector:@selector(_checkPaymentState) withObject:nil afterDelay:2];
            
        }
        
    }];
}


#pragma mark - Notification
- (void)appDidReceivedWechatPayResult:(NSNotification *)notification {
    // 取出返回数据
    PayResp *resp = notification.object;
    HDCheckStandWechatPayResultResp *resultResp = HDCheckStandWechatPayResultResp.new;
    resultResp.errCode = resp.errCode;
    resultResp.errStr = resp.errStr;
    resultResp.returnKey = resp.returnKey;
    resultResp.type = resp.type;

    if (resultResp.errCode == 0) {
        // FIXME: 临时处理，支付成功的单缓存起来，解决详情页支付状态获取不及时用户可能重复发起支付问题
        NSMutableArray<NSString *> *successPayedOrderNoList = [SACacheManager.shared objectPublicForKey:kCacheKeyCheckStandSuccessPayedOrderNoList];
        if (HDIsArrayEmpty(successPayedOrderNoList)) {
            successPayedOrderNoList = [NSMutableArray array];
        }
        // 保存订单号
        if ([successPayedOrderNoList containsObject:self.viewModel.orderNo]) {
            NSUInteger index = [successPayedOrderNoList indexOfObject:self.viewModel.orderNo];
            [successPayedOrderNoList replaceObjectAtIndex:index withObject:self.viewModel.orderNo];
        } else {
            [successPayedOrderNoList addObject:self.viewModel.orderNo];
        }
        // 保存
        [SACacheManager.shared setPublicObject:successPayedOrderNoList forKey:kCacheKeyCheckStandSuccessPayedOrderNoList];


        // 1.获取aba轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        HDLog(@"ABA支付，轮询等待时间 = %ld", loadingTime);
        // 2.轮询等待时间大于0时
        if (loadingTime > 0) {
            HDLog(@"需要轮询");
            self.abaPayLoadingTime = loadingTime;
            self.currentPayTime = time(NULL);

            //轮询调用
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud = [HDTips showLoading:SALocalizedString(@"top_up_to_be_paid", @"等待支付结果") inView:self.view];
                [self _checkPaymentState];
            });

        } else {
            // 支付成功
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentSuccess:)]) {
                [self.checkStand.resultDelegate checkStandViewController:self.checkStand paymentSuccess:resultResp];
            }
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        }
    } else if (resultResp.errCode == -2) {
        // 支付取消
        [self hideContainerViewAndDismissCheckStandFinshed:^{
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerUserClosedCheckStand:)]) {
                [self.checkStand.resultDelegate checkStandViewControllerUserClosedCheckStand:self.checkStand];
            }
        }];
    } else {
        // 支付失败
        if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentFail:)]) {
            [self.checkStand.resultDelegate checkStandViewController:self.checkStand paymentFail:resultResp];
        }
    }
}

- (void)appDidReceivePrinceBankPayResult:(NSNotification *)notification {
    NSString *status = notification.object;
    if (HDIsStringNotEmpty(status) && [status isEqualToString:@"1"]) {
        // 支付成功

        // 1.获取aba轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        HDLog(@"ABA支付，轮询等待时间 = %ld", loadingTime);
        // 2.轮询等待时间大于0时
        if (loadingTime > 0) {
            HDLog(@"需要轮询");
            self.abaPayLoadingTime = loadingTime;
            self.currentPayTime = time(NULL);

            //轮询调用
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud = [HDTips showLoading:SALocalizedString(@"top_up_to_be_paid", @"等待支付结果") inView:self.view];
                [self _checkPaymentState];
            });

        } else {
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentSuccess:)]) {
                [self.checkStand.resultDelegate checkStandViewController:self.checkStand paymentSuccess:nil];
            }
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        }
    } else {
        // 支付取消
        [self hideContainerViewAndDismissCheckStandFinshed:^{
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerUserClosedCheckStand:)]) {
                [self.checkStand.resultDelegate checkStandViewControllerUserClosedCheckStand:self.checkStand];
            }
        }];
    }
}

- (void)appDidReceiveHuiOnePayResult:(NSNotification *)notification {
    HDLog(@"汇旺支付回调了[%@]", self);
    /// code=5000&msg=[object Object]
    /// code=5001&msg=用户中途取消
    /// code=5005&msg=正在处理中，支付结果未知，请查询商户订单列表中订单的支付状态

    NSInteger code = [notification.object integerValue];

    if (code == 5005 || code == 5000) { //正在处理中
        // 1.获取aba轮询等待时间
        NSInteger loadingTime = [[SAAppSwitchManager.shared switchForKey:SAAppSwitchABAPayLoadingTime] integerValue];
        HDLog(@"ABA支付，轮询等待时间 = %ld", loadingTime);
        // 2.轮询等待时间大于0时
        if (loadingTime > 0) {
            HDLog(@"需要轮询");
            self.abaPayLoadingTime = loadingTime;
            self.currentPayTime = time(NULL);

            //轮询调用
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud = [HDTips showLoading:SALocalizedString(@"top_up_to_be_paid", @"等待支付结果") inView:self.view];
                [self _checkPaymentState];
            });

        } else {
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewController:paymentSuccess:)]) {
                [self.checkStand.resultDelegate checkStandViewController:self.checkStand paymentSuccess:nil];
            }
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        }
    } else {
        // 支付取消
        [self hideContainerViewAndDismissCheckStandFinshed:^{
            if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerUserClosedCheckStand:)]) {
                [self.checkStand.resultDelegate checkStandViewControllerUserClosedCheckStand:self.checkStand];
            }
        }];
    }

    [LKDataRecord.shared traceEvent:@"@DEBUG" name:@"收到汇旺回调" parameters:@{@"returnCode": @(code), @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]} SPM:nil];
}

#pragma mark - setter
- (void)setPayableAmount:(SAMoneyModel *)payableAmount {
    _payableAmount = payableAmount;
    if (payableAmount) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[payableAmount thousandSeparatorAmount]];
        [str addAttributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold],
            NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#ADB6C8"],
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: [UIColor hd_colorWithHexString:@"#ADB6C8"]
        }
                     range:NSMakeRange(0, payableAmount.thousandSeparatorAmount.length)];

        self.payableAmountLabel.attributedText = str;

    } else {
        self.payableAmountLabel.text = @"";
    }

    [self.view setNeedsUpdateConstraints];
}

- (void)setActuallyPaidAmount:(SAMoneyModel *)actuallyPaidAmount {
    _actuallyPaidAmount = actuallyPaidAmount;

    if (actuallyPaidAmount) {
        NSString *text = [actuallyPaidAmount thousandSeparatorAmount];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold], NSForegroundColorAttributeName: HDAppTheme.color.sa_C1} range:NSMakeRange(0, 1)];
        [str addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:35 weight:UIFontWeightSemibold], NSForegroundColorAttributeName: HDAppTheme.color.sa_C1}
                     range:NSMakeRange(1, text.length - 1)];

        self.actuallyPaidAmountLabel.attributedText = str;

    } else {
        self.actuallyPaidAmountLabel.text = @"";
    }
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - override
- (void)clickOnBackBarButtonItem {
    if (self.choosePaymentMethodHandler) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    // 提示是否放弃支付
    @HDWeakify(self);
    [NAT showAlertWithMessage:SALocalizedString(@"ALERT_MSG_CANCEL_TRANSATION", @"是否放弃本次交易?") confirmButtonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];

            @HDStrongify(self);
            [self hideContainerViewAndDismissCheckStandFinshed:^{
                if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerUserClosedCheckStand:)]) {
                    [self.checkStand.resultDelegate checkStandViewControllerUserClosedCheckStand:self.checkStand];
                }
            }];
        }
        cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
}

- (void)logMessageString:(NSString *)message, ... {
#ifdef DEBUG
    HDLog(@"[%.4fs]%@", [[NSDate new] timeIntervalSince1970] - self.startTime, message);
#endif
}

#pragma mark - lazy load
/** @lazy actualPaidAmount */
- (SALabel *)actuallyPaidAmountLabel {
    if (!_actuallyPaidAmountLabel) {
        _actuallyPaidAmountLabel = [[SALabel alloc] init];
        _actuallyPaidAmountLabel.textAlignment = NSTextAlignmentCenter;
        _actuallyPaidAmountLabel.text = @"--.--";
    }
    return _actuallyPaidAmountLabel;
}

/** @lazy payableAmountLabel */
- (SALabel *)payableAmountLabel {
    if (!_payableAmountLabel) {
        _payableAmountLabel = [[SALabel alloc] init];
        _payableAmountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _payableAmountLabel;
}
/** @lazy scrollerView */
- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] init];
        _scrollerView.backgroundColor = UIColor.clearColor;
    }
    return _scrollerView;
}

/** @lazy onlineContainer */
- (UIView *)onlineContainer {
    if (!_onlineContainer) {
        _onlineContainer = [[UIView alloc] init];
        _onlineContainer.backgroundColor = UIColor.whiteColor;
        _onlineContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
        _onlineContainer.hidden = YES;
        SAPaymentMethodContainerTitleView *titleView = SAPaymentMethodContainerTitleView.new;
        titleView.title = SALocalizedString(@"support_online_payment", @"Pay Online");
        [_onlineContainer addSubview:titleView];
    }
    return _onlineContainer;
}

/** @lazy onlineContainer */
- (UIView *)offlineContainer {
    if (!_offlineContainer) {
        _offlineContainer = [[UIView alloc] init];
        _offlineContainer.backgroundColor = UIColor.whiteColor;
        _offlineContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
        _offlineContainer.hidden = YES;
        SAPaymentMethodContainerTitleView *titleView = SAPaymentMethodContainerTitleView.new;
        titleView.title = SALocalizedString(@"support_offline_payment", @"Offline payment");
        [_offlineContainer addSubview:titleView];
    }
    return _offlineContainer;
}

- (UIView *)qrCodePayContainer {
    if (!_qrCodePayContainer) {
        _qrCodePayContainer = [[UIView alloc] init];
        _qrCodePayContainer.backgroundColor = UIColor.whiteColor;
        _qrCodePayContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
        _qrCodePayContainer.hidden = YES;
        SAPaymentMethodContainerTitleView *titleView = SAPaymentMethodContainerTitleView.new;
        titleView.title = SALocalizedString(@"pay_khqr_Support_Scan_QR_Payment", @"支持扫码付款");
        [_qrCodePayContainer addSubview:titleView];
    }
    return _qrCodePayContainer;
}

- (SAPaymentTipView *)maintenanceTipsContainer {
    if (!_maintenanceTipsContainer) {
        _maintenanceTipsContainer = SAPaymentTipView.new;
        _maintenanceTipsContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
        _maintenanceTipsContainer.hidden = YES;
    }
    return _maintenanceTipsContainer;
}

/** @lazy confirmButton */
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmButton setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [_confirmButton addTarget:self action:@selector(clickedOnConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

/** @lazy viewModel */
- (HDCheckStandChoosePaymentMethodViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HDCheckStandChoosePaymentMethodViewModel alloc] init];
        _viewModel.merchantNo = self.parameters[@"merchantNo"];
        _viewModel.supportedPaymentMethod = self.parameters[@"supportedPaymentMethods"];

        _viewModel.payableAmount = self.parameters[@"payableAmount"];
        _viewModel.storeNo = self.parameters[@"storeNo"];
        _viewModel.businessLine = self.parameters[@"businessLine"];
        _viewModel.goods = self.parameters[@"goods"];
        _viewModel.lastChoosedMethod = self.parameters[@"selectedPaymentMethod"];
        _viewModel.orderNo = self.parameters[@"orderNo"];
        _viewModel.outPayOrderNo = self.parameters[@"outPayOrderNo"];
    }
    return _viewModel;
}

- (HDAnnouncementView *)announcementView {
    if (!_announcementView) {
        _announcementView = [[HDAnnouncementView alloc] init];
        _announcementView.hidden = YES;
    }
    return _announcementView;
}

@end

//
//  SAAvailablePaymentMethodViewController.m
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAChoosePaymentMethodViewController.h"
#import "HDCheckStandChoosePaymentMethodViewModel.h"
#import "HDCheckStandPaymentMethodView.h"
#import "HDPaymentMethodType.h"
#import "SAChooseActivityAlertView.h"
#import "SAMoneyModel.h"
#import "SAOperationButton.h"
#import "SAPayHelper.h"
#import "SAPaymentActivityModel.h"
#import "SAPaymentMethodContainerTitleView.h"
#import "SAPaymentToolsActivityModel.h"
#import "SAWalletManager.h"
#import "WXApiManager.h"
#import <HDUIKit/HDAnnouncementView.h>
#import "SAPaymentTipsActionSheetView.h"
#import "SAPaymentTipView.h"
#import "HDCheckstandQRCodePayViewController.h"


@interface SAChoosePaymentMethodViewController ()
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
/// 是否已经展示过选择QRCode扫码提示
@property (nonatomic) BOOL showQRCodeTips;

@end


@implementation SAChoosePaymentMethodViewController

- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.view addSubview:self.announcementView];
    [self.view addSubview:self.actuallyPaidAmountLabel];
    [self.view addSubview:self.payableAmountLabel];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.onlineContainer];
    [self.scrollView addSubview:self.offlineContainer];
    [self.scrollView addSubview:self.qrCodePayContainer];
    [self.scrollView addSubview:self.maintenanceTipsContainer];
    [self.view addSubview:self.confirmButton];
}

- (void)hd_setupNavigation {
    [self setBoldTitle:SALocalizedString(@"order_choose_payment_method_title", @"选择支付方式")];
    //    [self setHd_statusBarStyle:UIStatusBarStyleDefault];
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
        [self generateUI];
    }];

    self.actuallyPaidAmount = self.viewModel.payableAmount;
    [self.viewModel initialize];
}

- (void)updateViewConstraints {
    if (!self.announcementView.isHidden) {
        [self.announcementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.width.centerX.equalTo(self.view);
            make.height.mas_equalTo(kRealHeight(42));
        }];
    }

    [self.actuallyPaidAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.view.mas_right).offset(-HDAppTheme.value.padding.right);
        if (!self.announcementView.isHidden) {
            make.top.equalTo(self.announcementView.mas_bottom).offset(kRealHeight(20));
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealHeight(20));
        }
        make.height.mas_equalTo(kRealHeight(50));
    }];

    if (!self.payableAmountLabel.isHidden) {
        [self.payableAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.view.mas_right).offset(-HDAppTheme.value.padding.right);
            make.top.equalTo(self.actuallyPaidAmountLabel.mas_bottom).offset(kRealHeight(5));
        }];
    }

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.view.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kRealHeight(10) - kiPhoneXSeriesSafeBottomHeight);
        make.height.mas_equalTo(kRealHeight(50));
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.view.mas_right).offset(-HDAppTheme.value.padding.right);
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

#pragma mark - DATA
- (void)getNewData {
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
            if(!model.isShow) return;
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
        if (!self.offlineContainer.hidden) {
            self.maintenanceTipsContainer.isOnlyOnline = YES;
        }
    }


    [self adjustPayableAmount];

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
        //        alertView.detailText = @"需要使用Bakong App或者支持KH的银行App，扫描生成的KHQR二维码来完成付款";
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

    if (self.choosedPaymentMethodHandler) {
        HDPaymentMethodType *paymentMethod = HDPaymentMethodType.new;
        paymentMethod.method = self.selectedPaymentMethod.paymentMethod;
        paymentMethod.toolCode = [self.selectedPaymentMethod.toolCode copy];
        if (self.selectedPaymentMethod.currentActivity) {
            paymentMethod.ruleNo = self.selectedPaymentMethod.currentActivity.ruleNo;
        }
        self.choosedPaymentMethodHandler(paymentMethod, self.selectedPaymentMethod.currentActivity.discountAmt);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickedOnPaymentMethodView:(HDCheckStandPaymentMethodView *)view {
    if ([view.model.toolCode isEqualToString:HDCheckStandPaymentToolsBalance] && !view.model.isUsable) {
        /// 未开通,去开通钱包  /  已注册未激活
        if (self.viewModel.userWallet
            && (!self.viewModel.userWallet.walletCreated || (self.viewModel.userWallet.walletCreated && [self.viewModel.userWallet.accountStatus isEqualToString:PNWAlletAccountStatusNotActive]))) {
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
- (void)showActivitysChooseViewWithCurrentView:(HDCheckStandPaymentMethodView *)view model:(HDCheckStandPaymentMethodCellModel *)model {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.contentHorizontalEdgeMargin = 0;

    NSMutableParagraphStyle *ParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    ParagraphStyle.lineHeightMultiple = 1;
    ParagraphStyle.lineSpacing = 0;
    ParagraphStyle.paragraphSpacing = 0;
    ParagraphStyle.paragraphSpacingBefore = 0;

    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"checksd_choose_coupon", @"Choose discount") attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold],
        NSForegroundColorAttributeName: HDAppTheme.color.G1,
        NSParagraphStyleAttributeName: ParagraphStyle
    }];

    [title appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[@" | " stringByAppendingString:model.text] attributes:@{
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
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
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
        _viewModel.isPre = YES; //是否为预选
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

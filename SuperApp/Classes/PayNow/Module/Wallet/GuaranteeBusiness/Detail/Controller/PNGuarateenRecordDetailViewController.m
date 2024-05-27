//
//  PNGuarateenRecordDetailViewController.m
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenRecordDetailViewController.h"
#import "HDCheckStandViewController.h"
#import "PNAlertInputView.h"
#import "PNComfrimSubmitAlertView.h"
#import "PNGuarateenComfirmPayRspModel.h"
#import "PNGuarateenDetailAttachmentView.h"
#import "PNGuarateenDetailBottomView.h"
#import "PNGuarateenDetailDTO.h"
#import "PNGuarateenDetailModel.h"
#import "PNGuarateenShareManager.h"
#import "PNGuarateenStepView.h"
#import "PNInfoView.h"
#import "SAMoneyModel.h"
#import "SAOrderDTO.h"
#import "SAPayResultViewController.h"
#import "SAQueryOrderInfoRspModel.h"
#import "UIImage+HDKitCore.h"


@interface PNGuarateenRecordDetailViewController () <HDCheckStandViewControllerDelegate>
@property (nonatomic, strong) UIImageView *topBgImgView;
@property (nonatomic, strong) PNGuarateenStepView *stepView;

@property (nonatomic, strong) UIView *bgView0;
@property (nonatomic, strong) PNInfoView *refundReasonInfoView;

@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) PNInfoView *buyerAccountInfoView;
@property (nonatomic, strong) PNInfoView *buyerNameInfoview;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) PNInfoView *salerAccountInfoView;
@property (nonatomic, strong) PNInfoView *salerNameInfoView;

@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) PNInfoView *amountInfoView;
@property (nonatomic, strong) PNInfoView *serviceAmountInfoView;
@property (nonatomic, strong) PNInfoView *bodyInfoView;
@property (nonatomic, strong) PNGuarateenDetailAttachmentView *attachmentView;

@property (nonatomic, strong) UIView *bgView3;
@property (nonatomic, strong) PNInfoView *orderNoInfoView;
@property (nonatomic, strong) PNInfoView *createTimeInfoView;
@property (nonatomic, strong) PNInfoView *completeTimeInfoView;

@property (nonatomic, strong) SALabel *bottomTipsLabel;

@property (nonatomic, strong) PNGuarateenDetailBottomView *bottomView;

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) PNGuarateenDetailDTO *detailDTO;
@property (nonatomic, strong) PNGuarateenDetailModel *detailModel;

@property (nonatomic, strong) SAOrderDTO *orderDTO;
@property (nonatomic, copy) NSString *aggregateOrderNo;

@property (nonatomic, strong) HDUIButton *navBtn;
@end


@implementation PNGuarateenRecordDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeMiddleVC];
}

- (void)removeMiddleVC {
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [newArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"PNGuaranteeInitViewController")] || [obj isKindOfClass:NSClassFromString(@"PNGuaranteeSalerInitViewController")] ||
            [obj isKindOfClass:NSClassFromString(@"PNGuaranteeBuyerViewController")]) {
            [newArr removeObject:obj];
        }
    }];

    [self.navigationController setViewControllers:newArr animated:YES];
}

- (void)hd_bindViewModel {
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"trans_details", @"交易详情");
}

- (void)hd_getNewData {
    [self getData];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.view addSubview:self.topBgImgView];

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.view addSubview:self.bottomView];

    [self.scrollViewContainer addSubview:self.stepView];

    [self.scrollViewContainer addSubview:self.bgView0];
    [self.scrollViewContainer addSubview:self.bgView1];
    [self.scrollViewContainer addSubview:self.bgView2];
    [self.scrollViewContainer addSubview:self.bgView3];

    [self.bgView0 addSubview:self.refundReasonInfoView];

    [self.bgView1 addSubview:self.buyerAccountInfoView];
    [self.bgView1 addSubview:self.buyerNameInfoview];
    [self.bgView1 addSubview:self.line1];
    [self.bgView1 addSubview:self.salerAccountInfoView];
    [self.bgView1 addSubview:self.salerNameInfoView];

    [self.bgView2 addSubview:self.amountInfoView];
    [self.bgView2 addSubview:self.serviceAmountInfoView];
    [self.bgView2 addSubview:self.bodyInfoView];
    [self.bgView2 addSubview:self.attachmentView];

    [self.bgView3 addSubview:self.orderNoInfoView];
    [self.bgView3 addSubview:self.createTimeInfoView];
    [self.bgView3 addSubview:self.completeTimeInfoView];

    [self.scrollViewContainer addSubview:self.bottomTipsLabel];
}

- (void)updateViewConstraints {
    [self.topBgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kRealWidth(240)));
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        if (!self.bottomView.hidden) {
            make.bottom.equalTo(self.bottomView.mas_top);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    if (!self.bottomView.hidden) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    void (^setSubViewConstraints)(UIView *) = ^(UIView *parentView) {
        NSMutableArray *subTempArray = [NSMutableArray arrayWithArray:parentView.subviews];
        NSMutableArray *subVisableInfoViews = [NSMutableArray arrayWithCapacity:subTempArray.count];
        for (UIView *itemView in subTempArray) {
            itemView.isHidden ?: [subVisableInfoViews addObject:itemView];
        }

        UIView *lastInfoView;
        for (UIView *infoView in subVisableInfoViews) {
            [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (lastInfoView) {
                    make.top.equalTo(lastInfoView.mas_bottom);
                } else {
                    make.top.equalTo(parentView.mas_top).offset(kRealWidth(4));
                }

                if (infoView.tag == 100) { //线条
                    make.height.equalTo(@(PixelOne));
                }

                make.left.right.equalTo(parentView);
                if (infoView == subVisableInfoViews.lastObject) {
                    make.bottom.equalTo(parentView).offset(-kRealWidth(4));
                }
            }];
            lastInfoView = infoView;
        }
    };

    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.scrollViewContainer.subviews];
    NSMutableArray *visableInfoViews = [NSMutableArray arrayWithCapacity:tempArr.count];
    for (UIView *itemView in tempArr) {
        itemView.isHidden ?: [visableInfoViews addObject:itemView];
    }

    UIView *lastInfoView;
    for (UIView *itemView in visableInfoViews) {
        [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.equalTo(self.scrollViewContainer.mas_top);
            }
            make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
            make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
            if (itemView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }

            if (itemView.tag == 10) {
                make.height.equalTo(@(kRealWidth(100)));
            }
        }];

        setSubViewConstraints(itemView);

        lastInfoView = itemView;
    }

    [super updateViewConstraints];
}

- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.detailDTO getGuarateenRecordDetail:self.orderNo success:^(PNGuarateenDetailModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        self.detailModel = rspModel;
        [self setData];

        if (rspModel.originator.code.integerValue == 11 && rspModel.flowStep == 1) {
            self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)setData {
    [self.stepView refreshView:self.detailModel.flowSplit flowStep:self.detailModel.flowStep];

    if (WJIsStringNotEmpty(self.detailModel.operationDesc)) {
        self.bgView0.hidden = NO;

        if ([self.detailModel.status.code isEqualToString:@"15"]) {
            self.refundReasonInfoView.model.keyText = PNLocalizedString(@"gBjyExDd", @"退款原因");
        } else if ([self.detailModel.status.code isEqualToString:@"16"]) {
            self.refundReasonInfoView.model.keyText = PNLocalizedString(@"pn_Reason_to_refuse", @"拒绝原因");
        } else if ([self.detailModel.status.code isEqualToString:@"17"]) {
            self.refundReasonInfoView.model.keyText = PNLocalizedString(@"UO1OiBbu", @"申诉原因");
        } else if ([self.detailModel.status.code isEqualToString:@"18"]) {
            self.refundReasonInfoView.model.keyText = PNLocalizedString(@"trFCVqZg", @"驳回原因");
        } else {
            self.bgView0.hidden = YES;
        }

        self.refundReasonInfoView.model.valueText = self.detailModel.operationDesc;
        [self.refundReasonInfoView setNeedsUpdateContent];
    } else {
        self.bgView0.hidden = YES;
    }

    if (self.detailModel.originator.code.integerValue == 11) {
        if (WJIsStringNotEmpty(self.detailModel.userMobile)) {
            self.salerAccountInfoView.model.valueText = self.detailModel.userMobile;
            [self.salerAccountInfoView setNeedsUpdateContent];
            self.salerAccountInfoView.hidden = NO;
        } else {
            self.salerAccountInfoView.hidden = YES;
        }

        if (WJIsStringNotEmpty(self.detailModel.userName)) {
            self.salerNameInfoView.model.valueText = self.detailModel.userName ?: @"";
            [self.salerNameInfoView setNeedsUpdateContent];
            self.salerNameInfoView.hidden = NO;
        } else {
            self.salerNameInfoView.hidden = YES;
        }

        if (WJIsStringNotEmpty(self.detailModel.traderMobile)) {
            self.buyerAccountInfoView.model.valueText = self.detailModel.traderMobile ?: @"";
            [self.buyerAccountInfoView setNeedsUpdateContent];
            self.buyerAccountInfoView.hidden = NO;
        } else {
            self.buyerAccountInfoView.hidden = YES;
        }

        if (WJIsStringNotEmpty(self.detailModel.traderName)) {
            self.buyerNameInfoview.model.valueText = self.detailModel.traderName ?: @"";
            [self.buyerNameInfoview setNeedsUpdateContent];
            self.buyerNameInfoview.hidden = NO;
        } else {
            self.buyerNameInfoview.hidden = YES;
        }
    } else {
        ///我是买方
        if (WJIsStringNotEmpty(self.detailModel.traderMobile)) {
            self.salerAccountInfoView.model.valueText = self.detailModel.traderMobile ?: @"";
            [self.salerAccountInfoView setNeedsUpdateContent];
            self.salerAccountInfoView.hidden = NO;
        } else {
            self.salerAccountInfoView.hidden = YES;
        }

        if (WJIsStringNotEmpty(self.detailModel.traderName)) {
            self.salerNameInfoView.model.valueText = self.detailModel.traderName ?: @"";
            [self.salerNameInfoView setNeedsUpdateContent];
            self.salerNameInfoView.hidden = NO;
        } else {
            self.salerNameInfoView.hidden = YES;
        }

        if (WJIsStringNotEmpty(self.detailModel.userMobile)) {
            self.buyerAccountInfoView.model.valueText = self.detailModel.userMobile ?: @"";
            [self.buyerAccountInfoView setNeedsUpdateContent];
            self.buyerAccountInfoView.hidden = NO;
        } else {
            self.buyerAccountInfoView.hidden = YES;
        }

        if (WJIsStringNotEmpty(self.detailModel.userName)) {
            self.buyerNameInfoview.model.valueText = self.detailModel.userName ?: @"";
            [self.buyerNameInfoview setNeedsUpdateContent];
            self.buyerNameInfoview.hidden = NO;
        } else {
            self.buyerNameInfoview.hidden = YES;
        }
    }

    if ((WJIsStringEmpty(self.detailModel.traderMobile) && WJIsStringEmpty(self.detailModel.traderName))
        || (WJIsStringEmpty(self.detailModel.userMobile) && WJIsStringEmpty(self.detailModel.userName))) {
        self.line1.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    } else {
        self.line1.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }

    self.amountInfoView.model.valueText = self.detailModel.amtStr;
    [self.amountInfoView setNeedsUpdateContent];

    self.serviceAmountInfoView.model.valueText = self.detailModel.feeAmtStr;
    [self.serviceAmountInfoView setNeedsUpdateContent];

    self.bodyInfoView.model.valueText = self.detailModel.body;
    [self.bodyInfoView setNeedsUpdateContent];

    if (!WJIsArrayEmpty(self.detailModel.attachment.images)) {
        self.attachmentView.hidden = NO;
        self.attachmentView.images = self.detailModel.attachment.images;
    } else {
        self.attachmentView.hidden = YES;
    }

    self.orderNoInfoView.model.valueText = self.detailModel.orderNo;
    [self.orderNoInfoView setNeedsUpdateContent];

    self.createTimeInfoView.model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:self.detailModel.createTime.doubleValue / 1000]];
    [self.createTimeInfoView setNeedsUpdateContent];

    if (WJIsStringNotEmpty(self.detailModel.completeTime) && self.detailModel.completeTime.floatValue > 0) {
        self.completeTimeInfoView.model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm"
                                                                             withDate:[NSDate dateWithTimeIntervalSince1970:self.detailModel.completeTime.doubleValue / 1000]];
        [self.completeTimeInfoView setNeedsUpdateContent];
        self.completeTimeInfoView.hidden = NO;
    } else {
        self.completeTimeInfoView.hidden = YES;
    }

    if (WJIsArrayEmpty(self.detailModel.nextActions)) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.dataSource = [NSMutableArray arrayWithArray:self.detailModel.nextActions];
        self.bottomView.hidden = NO;
    }

    if (self.detailModel.status.code.integerValue == PNGuarateenStatus_PENDING && [self.buyerAccountInfoView.model.valueText isEqualToString:VipayUser.shareInstance.loginName]) {
        self.bottomTipsLabel.hidden = NO;
        self.bottomTipsLabel.text =
            [NSString stringWithFormat:PNLocalizedString(@"ytEuVxQM", @"说明：买方付款成功后资金会暂存平台，%zd天后买方没有确认完成交易，系统会自动完成交易把资金结算给卖方，并且无法再申请退款！"),
                                       self.detailModel.expiredDays];
    } else {
        self.bottomTipsLabel.hidden = YES;
    }

    [self.view setNeedsUpdateConstraints];
}

- (void)preAsk:(NSString *)action {
    NSArray *norArray = @[
        PNGuarateenActionStatus_CONFIRM,
        PNGuarateenActionStatus_CANCEL,
        PNGuarateenActionStatus_COMPLETE,
        PNGuarateenActionStatus_REFUND_CANCEL,
        PNGuarateenActionStatus_APPEAL_CANCEL,
        PNGuarateenActionStatus_REFUND_PASS
    ];
    NSArray *inputDescArray = @[PNGuarateenActionStatus_REJECT, PNGuarateenActionStatus_REFUND_APPLY, PNGuarateenActionStatus_REFUND_APPEAL, PNGuarateenActionStatus_REFUND_REJECT];

    if ([norArray containsObject:action]) {
        NSString *msg = @"";
        if ([action isEqualToString:PNGuarateenActionStatus_CONFIRM]) {
            msg = PNLocalizedString(@"5Xom1HTl", @"您确认要接受本次交易吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_CANCEL]) {
            msg = PNLocalizedString(@"TIjulPsM", @"您确认要取消本次交易吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_COMPLETE]) {
            msg = PNLocalizedString(@"c8rxkqps", @"确认完成交易后，平台会把本次交易的款项打到卖方的账户，并且无法再申请退款，您确认要完成本次交易吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_REFUND_CANCEL]) {
            msg = PNLocalizedString(@"pJsMjwJQ", @"您确认要取消退款吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_APPEAL_CANCEL]) {
            msg = PNLocalizedString(@"KVdIDTdI", @"您确认要取消申诉吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_REFUND_PASS]) {
            msg = PNLocalizedString(@"qGAYU3Rq", @"您确认要同意退款吗？");
        }

        [NAT showAlertWithMessage:msg confirmButtonTitle:PNLocalizedString(@"pn_confirm", @"确认") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            [self doOrderAction:action operationDesc:@""];
        } cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];

    } else if ([inputDescArray containsObject:action]) {
        NSString *msg = @"";
        if ([action isEqualToString:PNGuarateenActionStatus_REJECT]) {
            msg = PNLocalizedString(@"misbAFoq", @"您确认要拒绝本次交易吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_REFUND_APPLY]) {
            msg = PNLocalizedString(@"bT6z62lC", @"您确认要申请退款吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_REFUND_REJECT]) {
            msg = PNLocalizedString(@"RjMXLmyp", @"您确认要拒绝退款吗？");
        } else if ([action isEqualToString:PNGuarateenActionStatus_REFUND_APPEAL]) {
            msg = PNLocalizedString(@"Ve4FnhgG", @"您确认要向平台申诉吗？");
        }

        PNAlertInputViewConfig *config = [PNAlertInputViewConfig defulatConfig];
        config.style = PNAlertInputStyle_textView;
        config.title = msg;
        config.textViewPlaceholder = PNLocalizedString(@"Mw5WkG3Q", @"请输入原因，必填项");
        config.cancelButtonTitle = PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消");
        config.doneButtonTitle = PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定");

        @HDWeakify(self);
        config.cancelHandler = ^(PNAlertInputView *_Nonnull alertView) {
            [alertView dismiss];
        };

        config.doneHandler = ^(NSString *_Nonnull inputText, PNAlertInputView *_Nonnull alertView) {
            HDLog(@"%@", inputText);
            @HDStrongify(self);
            if (WJIsStringEmpty(inputText)) {
                [NAT showToastWithTitle:PNLocalizedString(@"ulP6Dlwt", @"请输入原因") content:nil type:HDTopToastTypeError];
            } else {
                [self doOrderAction:action operationDesc:inputText];
                [alertView dismiss];
            }
        };

        PNAlertInputView *alert = [[PNAlertInputView alloc] initAlertWithConfig:config];
        [alert show];
    }
}

- (void)doOrderAction:(NSString *)action operationDesc:(NSString *)operationDesc {
    [self showloading];

    @HDWeakify(self);
    [self.detailDTO orderAction:self.orderNo action:action operationDesc:operationDesc success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self getData];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)payAction {
    [self showloading];

    @HDWeakify(self);
    [self.detailDTO buildOrderPayment:self.orderNo success:^(PNGuarateenBuildOrderPaymentRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        PNComfrimSubmitAlertView *alert = [[PNComfrimSubmitAlertView alloc] initWithBalanceModel:rspModel];

        @HDWeakify(self);
        alert.comfrimBlock = ^{
            @HDStrongify(self);
            [self comfrimToPay];
        };
        [alert show];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)comfrimToPay {
    [self showloading];
    @HDWeakify(self);
    [self.detailDTO comfirmOrderPayment:self.orderNo success:^(PNGuarateenComfirmPayRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.aggregateOrderNo = rspModel.aggregateOrderNo;
        [self openCashRegisterWithModel:rspModel.aggregateOrderNo outPayOrderNo:rspModel.outPayOrderNo totalAmount:rspModel.actualPayAmount];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark 打开收银台
///打开收银台
- (void)openCashRegisterWithModel:(NSString *)aggregateOrderNo outPayOrderNo:(NSString *)outPayOrderNo totalAmount:(SAMoneyModel *)totalAmount {
    @HDWeakify(self);
    [self.orderDTO queryOrderInfoWithOrderNo:aggregateOrderNo outPayOrderNo:outPayOrderNo success:^(SAQueryOrderInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        if (rspModel) {
            HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
            buildModel.orderNo = aggregateOrderNo;
            buildModel.storeNo = rspModel.storeId;
            buildModel.merchantNo = rspModel.merchantNo;
            buildModel.payableAmount = totalAmount;
            buildModel.businessLine = SAClientTypeBillPayment;
            HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
            checkStandVC.resultDelegate = self;
            [self presentViewController:checkStandVC animated:YES completion:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

// 线上支付结果页
- (void)navigationToOnlineResultPageWithParams {
    NSMutableDictionary *resultPageParams = [NSMutableDictionary dictionary];
    resultPageParams[@"businessLine"] = SAClientTypeBillPayment;
    resultPageParams[@"orderNo"] = self.aggregateOrderNo;
    resultPageParams[@"pageLabel"] = @"online_payment_result";

    @HDWeakify(self);
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        BOOL result = NO;
        UIViewController *viewContr;
        for (UIViewController *itemVC in vc.navigationController.viewControllers) {
            if ([itemVC isKindOfClass:NSClassFromString(@"PNGuaranteeListViewController")]) {
                result = YES;
                viewContr = itemVC;
                break;
            }
        }
        if (result && viewContr) {
            [vc.navigationController popToViewController:viewContr animated:YES];
        } else {
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }
    };

    void (^doneClickBlock)(UIViewController *) = ^(UIViewController *vc) {
        BOOL result = NO;
        UIViewController *viewContr;
        for (UIViewController *itemVC in vc.navigationController.viewControllers) {
            if ([itemVC isKindOfClass:NSClassFromString(@"PNGuaranteeListViewController")]) {
                result = YES;
                viewContr = itemVC;
                break;
            }
        }
        if (result && viewContr) {
            [vc.navigationController popToViewController:viewContr animated:NO];
        } else {
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }
    };

    resultPageParams[@"orderClickBlock"] = orderDetailBlock;
    resultPageParams[@"doneClickBlock"] = doneClickBlock;

    SAPayResultViewController *vc = [[SAPayResultViewController alloc] initWithRouteParameters:resultPageParams];
    [self.navigationController pushViewController:vc animated:YES removeSpecClass:self.class onlyOnce:YES];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self navigationToOnlineResultPageWithParams];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToOnlineResultPageWithParams];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToOnlineResultPageWithParams];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:^{
    }];
}

#pragma mark
- (UIImageView *)topBgImgView {
    if (!_topBgImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage hd_imageWithColor:HDAppTheme.PayNowColor.mainThemeColor];
        _topBgImgView = imageView;
    }
    return _topBgImgView;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.keyColor = HDAppTheme.PayNowColor.c999999;
    model.keyFont = HDAppTheme.PayNowFont.standard14;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.lineWidth = 0;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    return model;
}

- (UIView *)bgView0 {
    if (!_bgView0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hidden = YES;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        _bgView0 = view;
    }
    return _bgView0;
}

- (UIView *)bgView1 {
    if (!_bgView1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hidden = NO;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        _bgView1 = view;
    }
    return _bgView1;
}

- (UIView *)bgView2 {
    if (!_bgView2) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hidden = NO;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        _bgView2 = view;
    }
    return _bgView2;
}

- (UIView *)bgView3 {
    if (!_bgView3) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hidden = NO;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        _bgView3 = view;
    }
    return _bgView3;
}

- (PNInfoView *)refundReasonInfoView {
    if (!_refundReasonInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"gBjyExDd", @"退款原因")];

        view.model = model;
        _refundReasonInfoView = view;
    }
    return _refundReasonInfoView;
}

- (PNInfoView *)buyerAccountInfoView {
    if (!_buyerAccountInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"CACs1qJ5", @"买方账号")];

        view.model = model;
        _buyerAccountInfoView = view;
    }
    return _buyerAccountInfoView;
}

- (PNInfoView *)buyerNameInfoview {
    if (!_buyerNameInfoview) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"IhnSFBbR", @"买方姓名")];

        view.model = model;
        _buyerNameInfoview = view;
    }
    return _buyerNameInfoview;
}

- (UIView *)line1 {
    if (!_line1) {
        UIView *view = [[UIView alloc] init];
        view.tag = 100;
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;

        _line1 = view;
    }
    return _line1;
}

- (PNInfoView *)salerAccountInfoView {
    if (!_salerAccountInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"XtRppmEO", @"卖方账号")];

        view.model = model;
        _salerAccountInfoView = view;
    }
    return _salerAccountInfoView;
}

- (PNInfoView *)salerNameInfoView {
    if (!_salerNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"9kTb2wdH", @"卖方姓名")];

        view.model = model;
        _salerNameInfoView = view;
    }
    return _salerNameInfoView;
}

- (PNInfoView *)amountInfoView {
    if (!_amountInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"kwCIcL1x", @"金额")];

        view.model = model;
        _amountInfoView = view;
    }
    return _amountInfoView;
}

- (PNInfoView *)serviceAmountInfoView {
    if (!_serviceAmountInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"IVm6l92o", @"服务费")];

        view.model = model;
        _serviceAmountInfoView = view;
    }
    return _serviceAmountInfoView;
}

- (PNInfoView *)bodyInfoView {
    if (!_bodyInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Vd1QTGmu", @"交易内容")];
        model.valueNumbersOfLines = 1;
        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        model.enableTapRecognizer = YES;

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [NAT showAlertWithTitle:PNLocalizedString(@"Vd1QTGmu", @"交易内容") message:self.detailModel.body buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE           ", @"确定")
                            handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                [alertView dismiss];
                            }];
        };

        view.model = model;
        _bodyInfoView = view;
    }
    return _bodyInfoView;
}

- (PNGuarateenDetailAttachmentView *)attachmentView {
    if (!_attachmentView) {
        _attachmentView = [[PNGuarateenDetailAttachmentView alloc] init];
        _attachmentView.hidden = YES;
    }
    return _attachmentView;
}

- (PNInfoView *)orderNoInfoView {
    if (!_orderNoInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号")];

        view.model = model;
        _orderNoInfoView = view;
    }
    return _orderNoInfoView;
}

- (PNInfoView *)createTimeInfoView {
    if (!_createTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间")];

        view.model = model;
        _createTimeInfoView = view;
    }
    return _createTimeInfoView;
}

- (PNInfoView *)completeTimeInfoView {
    if (!_completeTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"lM0ikRQ8", @"交易完成时间")];

        view.model = model;
        _completeTimeInfoView = view;
    }
    return _completeTimeInfoView;
}

- (PNGuarateenDetailDTO *)detailDTO {
    if (!_detailDTO) {
        _detailDTO = [[PNGuarateenDetailDTO alloc] init];
    }
    return _detailDTO;
}

- (SAOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[SAOrderDTO alloc] init];
    }
    return _orderDTO;
}

- (PNGuarateenStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNGuarateenStepView alloc] init];
        _stepView.tag = 10;
    }
    return _stepView;
}

- (SALabel *)bottomTipsLabel {
    if (!_bottomTipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        label.hidden = YES;
        _bottomTipsLabel = label;
    }
    return _bottomTipsLabel;
}

- (PNGuarateenDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PNGuarateenDetailBottomView alloc] init];
        _bottomView.hidden = YES;
        @HDWeakify(self);
        _bottomView.btnClickBlock = ^(PNGuarateenNextActionModel *_Nonnull model) {
            @HDStrongify(self);
            if (model) {
                if (model.type == 10) { /// 状态流转
                    [self preAsk:model.action.code];
                } else { /// 付款
                    [self payAction];
                }
            }
        };
    }
    return _bottomView;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_SHARE", @"分享") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [PNGuarateenShareManager.sharedInstance shareGuarateenWithModel:self.detailModel];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

@end

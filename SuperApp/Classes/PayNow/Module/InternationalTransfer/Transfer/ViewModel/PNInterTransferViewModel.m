//
//  PNInterTransferViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferViewModel.h"
#import "NSDate+SAExtension.h"
#import "NSString+matchs.h"
#import "PNAlertInputView.h"
#import "PNInterTransferAmountCell.h"
#import "PNInterTransferCreateOrderModel.h"
#import "PNInterTransferDTO.h"
#import "PNInterTransferFeeRateAlertView.h"
#import "PNInterTransferLimitController.h"
#import "PNInterTransferPayerInfoModel.h"
#import "PNInterTransferRateController.h"
#import "PNInterTransferReciverModel.h"
#import "PNNeedInputInviteCodeRspModel.h"
#import "PNRspModel.h"
#import "PNSingleSelectedAlertView.h"
#import "SAInfoViewModel.h"
#import "VipayUser.h"
#import "PNBindMarketInfoAlertView.h"
#import "PNMarketingDTO.h"
#import "PNCheckMarketingRspModel.h"

//转账目的tag
static NSString *const kPurposeConfigTag = @"kPurposeConfigTag";
//资金来源tag
static NSString *const kSourceFundConfigTag = @"kSourceFundConfigTag";
/// 预计到账金额
static NSString *const kExchangeAmount = @"k_exchangeAmount";
/// 手续费
static NSString *const kServiceCharge = @"k_Service_Charge";


@interface PNInterTransferViewModel ()
///
@property (strong, nonatomic) PNInterTransferDTO *transDTO;
/// 其它转账目的配置项
@property (strong, nonatomic) PNTransferFormConfig *otherPurposeConfig;
/// 其它金额来源配置项
@property (strong, nonatomic) PNTransferFormConfig *otherSourceConfig;

@property (nonatomic, strong) PNMarketingDTO *marketingDTO;
@end


@implementation PNInterTransferViewModel

#pragma mark 第一步
#pragma mark 开通页面相关
#pragma mark -初始化转账开通页面数据
- (void)initTransferOpenData {
    [self.transOpenDataArr removeAllObjects];
    // 我的账号
    PNTransferFormConfig *config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
    config.valueText = [VipayUser shareInstance].loginName;
    config.onlyShow = YES;
    [self.transOpenDataArr addObject:config];

    // 出生国家
    config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"jipl0KUj", @"出生国家");
    config.valueText = PNLocalizedString(@"SMSpgXLZ", @"中国");
    config.editType = PNSTransferFormValueEditTypeDrop;
    @HDWeakify(self);
    config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        @HDStrongify(self);
        [self showCountryOfBirthAlertView:targetConfig];
    };
    [self.transOpenDataArr addObject:config];

    // 到国家
    config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"yjCLRkV6", @"到国家");
    config.valueText = PNLocalizedString(@"SMSpgXLZ", @"中国");
    config.editType = PNSTransferFormValueEditTypeDrop;
    config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        @HDStrongify(self);
        [self showToCountryAlertView:targetConfig];
    };
    [self.transOpenDataArr addObject:config];

    // 服务商
    config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"MRizy1WE", @"服务商");
    config.valueText = @"Thunes";
    config.editType = PNSTransferFormValueEditTypeDrop;
    config.rightTipText = PNLocalizedString(@"O7btTqFy", @"转账汇率");
    config.rightTipImageStr = @"pn_rate_tip";
    config.lineHeight = 0;
    config.rightTipClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        @HDStrongify(self);
        [self showFeeRateAlertView];
    };
    config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        @HDStrongify(self);
        [self showPartnerAlertView:targetConfig];
    };
    [self.transOpenDataArr addObject:config];
}

- (void)checkNeedInviateCode:(void (^)(BOOL isSuccess))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.transDTO checkNeedInputInvitationCode:^(PNNeedInputInviteCodeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        if (!rspModel.status) {
            !completion ?: completion(NO);
        } else {
            if (WJIsStringNotEmpty(rspModel.inviteCode)) {
                self.inviteCode = rspModel.inviteCode.uppercaseString;
                [self initTransferAmountData];
                self.transAmountVcRefrehData = !self.transAmountVcRefrehData;
                !completion ?: completion(NO);
            } else {
                if (WJIsStringEmpty(rspModel.inviteCode)) {
                    !completion ?: completion(YES);
                    [self alertInputView];
                }
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(NO);
    }];
}

/// 校验&绑定激活码
- (void)bindInviateCode:(NSString *)inviteCode completion:(void (^)(BOOL isSuccess))completion {
    [self.transDTO bindingInviteCode:inviteCode success:^(PNRspModel *_Nonnull rspModel) {
        !completion ?: completion(YES);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        !completion ?: completion(NO);
    }];
}

/// 弹出输入邀请码框
- (void)alertInputView {
    PNAlertInputViewConfig *config = [PNAlertInputViewConfig defulatConfig];
    config.title = PNLocalizedString(@"pn_input_invite_code", @"请输入邀请码");
    config.subTitle = [NSString stringWithFormat:@"%@\n%@",
                                                 PNLocalizedString(@"pn_invite_code_tips", @"这是您在大象APP的首笔国际转账交易，输入您好友的邀请码，将获得现金奖励"),
                                                 PNLocalizedString(@"pn_your_friend_invite_code", @"您好友邀请码：")];
    config.cancelButtonTitle = PNLocalizedString(@"pn_continue_transfer", @"继续转账");
    config.doneButtonTitle = PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定");

    @HDWeakify(self);
    config.cancelHandler = ^(PNAlertInputView *_Nonnull alertView) {
        HDLog(@"点击取消了");
        [alertView dismiss];
    };

    config.doneHandler = ^(NSString *_Nonnull inputText, PNAlertInputView *_Nonnull alertView) {
        HDLog(@"%@", inputText);
        @HDStrongify(self);
        if (WJIsStringNotEmpty(inputText)) {
            [alertView showloading];
            NSString *inviteCodeStr = inputText.uppercaseString;
            [self bindInviateCode:inviteCodeStr completion:^(BOOL isSuccess) {
                [alertView dismissLoading];
                if (isSuccess) {
                    self.inviteCode = inviteCodeStr;
                    [self initTransferAmountData];
                    self.transAmountVcRefrehData = !self.transAmountVcRefrehData;
                    [alertView dismiss];
                } else {
                    [alertView clearText];
                }
            }];
        }
    };

    PNAlertInputView *alert = [[PNAlertInputView alloc] initAlertWithConfig:config];
    [alert show];
}

/// 检查是否绑定了推广专员
- (void)checkIsBind {
    [self.view showloading];
    @HDWeakify(self);
    [self.marketingDTO isBinded:^(PNCheckMarketingRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (rspModel.needPop) {
            [self alertInputBindMarketing];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
/// 弹窗 绑定推广专员
- (void)alertInputBindMarketing {
    PNBindMarketingInfoAlertConfig *config = [PNBindMarketingInfoAlertConfig defulatConfig];
    config.title = PNLocalizedString(@"SOimxbv0", @"绑定推广专员");
    config.cancelButtonTitle = PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消");
    config.doneButtonTitle = PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定");


    @HDWeakify(self);
    config.cancelHandler = ^(PNBindMarketInfoAlertView *_Nonnull alertView) {
        HDLog(@"点击取消了");
        [alertView dismiss];
    };

    config.doneHandler = ^(NSString *_Nonnull inputText, PNBindMarketInfoAlertView *_Nonnull alertView) {
        HDLog(@"%@", inputText);
        if (WJIsStringNotEmpty(inputText)) {
            [alertView showloading];
//            NSString *inviteCodeStr = inputText.uppercaseString;
            [alertView dismiss];
        }
    };


    PNBindMarketInfoAlertView *alert = [[PNBindMarketInfoAlertView alloc] initAlertWithConfig:config];
    [alert show];
}

#pragma mark -请求费率以及服务费数据
- (void)queryRateFeeAndServiceChargeCompletion:(void (^)(void))completion {
    [KeyWindow showloading];
    @HDWeakify(self);
    [self.transDTO queryRateFeeWithChannel:self.channel success:^(PNInterTransferRateFeeModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [KeyWindow dismissLoading];
        self.feeModel = rspModel;
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [KeyWindow dismissLoading];
    }];
}
#pragma mark -出生国家弹窗
- (void)showCountryOfBirthAlertView:(PNTransferFormConfig *)config {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = PNLocalizedString(@"SMSpgXLZ", @"中国");
    model.isSelected = YES;
    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:@[model] title:PNLocalizedString(@"jipl0KUj", @"出生国家")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.openVcRefrehData = !self.openVcRefrehData;
    };
    [alertView show];
}

#pragma mark -到国家弹窗
- (void)showToCountryAlertView:(PNTransferFormConfig *)config {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = PNLocalizedString(@"SMSpgXLZ", @"中国");
    model.isSelected = YES;
    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:@[model] title:PNLocalizedString(@"yjCLRkV6", @"到国家")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.openVcRefrehData = !self.openVcRefrehData;
    };
    [alertView show];
}

#pragma mark -服务商弹窗
- (void)showPartnerAlertView:(PNTransferFormConfig *)config {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = @"Thunes";
    model.isSelected = YES;
    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:@[model] title:PNLocalizedString(@"MRizy1WE", @"服务商")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.openVcRefrehData = !self.openVcRefrehData;
    };
    [alertView show];
}

#pragma mark -弹窗费率
- (void)showFeeRateAlertView {
    @HDWeakify(self);
    void (^showAlert)(void) = ^(void) {
        @HDStrongify(self);
        PNInterTransferFeeRateAlertView *alertView = [[PNInterTransferFeeRateAlertView alloc] initWithFeeModel:self.feeModel];
        [alertView show];
    };

    //测试要求不要缓存  每次重新加载
    //    if (HDIsObjectNil(self.feeModel)) {
    [self queryRateFeeAndServiceChargeCompletion:^{
        showAlert();
    }];
    //    }else{
    //        showAlert();
    //    }
}

#pragma mark -开通国际转账
- (void)openInterTransferAccountCompletion:(void (^)(void))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.transDTO openInterTransferAccount:self.reciverModel.reciverId channel:self.channel success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion();
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
#pragma mark 【一】 转账金额页面相关
#pragma mark -初始化转账金额页面数据
- (void)initTransferAmountData {
    [self.transferAmountDataArr removeAllObjects];

    HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
    NSMutableArray *temp = [NSMutableArray array];

    // 我的账号
    PNTransferFormConfig *config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
    config.valueText = [VipayUser shareInstance].loginName;
    config.onlyShow = YES;
    [temp addObject:config];

    // 到国家
    config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"yjCLRkV6", @"到国家");
    config.valueText = PNLocalizedString(@"SMSpgXLZ", @"中国");
    config.editType = PNSTransferFormValueEditTypeDrop;
    @HDWeakify(self);
    config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
        @HDStrongify(self);
        [self showToCountryAlertView:targetConfig];
    };
    [temp addObject:config];

    if (WJIsStringNotEmpty(self.inviteCode)) {
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"pn_invite_code", @"邀请码");
        config.valueText = self.inviteCode;
        config.onlyShow = YES;
        [temp addObject:config];
    }

    sectionModel.list = temp;
    [self.transferAmountDataArr addObject:sectionModel];

    // 1.金额相关section
    sectionModel = HDTableViewSectionModel.new;
    temp = [NSMutableArray array];

    //转账金额
    PNInterTransferAmountCellModel *cellModel = [[PNInterTransferAmountCellModel alloc] init];
    cellModel.keyText = PNLocalizedString(@"transfer_amount", @"转账金额");
    cellModel.descriptionText = !HDIsObjectNil(self.quotaAndRateModel.singleAmount) ?
                                    [NSString stringWithFormat:@"%@<=%@", PNLocalizedString(@"Th0QKAI6", @"转账单笔限额"), self.quotaAndRateModel.singleAmount.thousandSeparatorAmount] :
                                    @"";
    cellModel.canEdit = YES;
    cellModel.textFieldRightIconImage = [UIImage imageNamed:@"pn_trans_usd_logo"];
    cellModel.isBecomeFirstResponder = YES;
    cellModel.valueText = self.sourceAmount;
    cellModel.rightBtnImage = [UIImage imageNamed:@"pn_interTransfer_limit_icon"];
    cellModel.rightBtnTitle = PNLocalizedString(@"pn_inter_transfer_limit", @"转账限额");
    cellModel.rightBtnTitleFont = HDAppTheme.PayNowFont.standard12;
    cellModel.rightBtnTitleColor = HDAppTheme.PayNowColor.c333333;

    cellModel.endEditingBlock = ^{
        @HDStrongify(self);
        [self getFee];
    };

    cellModel.rightBtnClickBlock = ^(NSString *_Nonnull tag) {
        PNInterTransferLimitController *vc = [[PNInterTransferLimitController alloc] initWithRouteParameters:@{
            @"channel": @(self.channel),
        }];
        [SAWindowManager navigateToViewController:vc];
    };

    cellModel.valueChangedCallBack = ^(NSString *_Nonnull text) {
        @HDStrongify(self);
        self.sourceAmount = text;
        if (HDIsStringNotEmpty(text) && [text matches:REGEX_AMOUNT] && text.doubleValue > 0) {
            [self calculateExchangeAmount:text];
        } else {
            [self calculateExchangeAmount:@""];
        }
        [self checkTransferAmountContinueBtnEabled];
        //        if ([text floatValue] > [self.quotaAndRateModel.balance.amount floatValue]) {
        //            [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_BALANCE_NO_ENOUGHT", @"账户余额不足") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *
        //            _Nonnull alertView, HDAlertViewButton * _Nonnull button) {
        //                self.exchangeAmount = @"";
        //                [self updateExchangeAmount];
        //                [alertView dismiss];
        //            }];
        //        }else if ([text floatValue] > [self.quotaAndRateModel.singleAmount.amount floatValue]){
        //            [NAT showAlertWithMessage:PNLocalizedString(@"ZmgMEII0", @"交易余额超限") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView * _Nonnull alertView,
        //            HDAlertViewButton * _Nonnull button) {
        //                self.exchangeAmount = @"";
        //                [self updateExchangeAmount];
        //                [alertView dismiss];
        //            }];
        //        }else{
    };
    [temp addObject:cellModel];

    //转账汇率
    config = PNTransferFormConfig.new;
    config.keyText = PNLocalizedString(@"O7btTqFy", @"转账汇率");
    config.valueText = HDIsStringNotEmpty(self.quotaAndRateModel.rate) ? self.quotaAndRateModel.rate : @"";
    config.onlyShow = YES;
    [temp addObject:config];

    //转账手续费
    cellModel = [[PNInterTransferAmountCellModel alloc] init];
    cellModel.tag = kServiceCharge;
    cellModel.keyText = PNLocalizedString(@"pn_charge", @"手续费");
    cellModel.canEdit = NO;
    cellModel.textFieldRightIconImage = [UIImage imageNamed:@"pn_trans_usd_logo"];
    cellModel.valueColor = HDAppTheme.PayNowColor.c333333;
    cellModel.valueText = self.serviceCharge;
    cellModel.rightBtnImage = [UIImage imageNamed:@"pn_interTransfer_charge_icon"];
    cellModel.rightBtnTitle = PNLocalizedString(@"pn_fee_charge", @"收费标准");
    cellModel.rightBtnTitleFont = HDAppTheme.PayNowFont.standard12;
    cellModel.rightBtnTitleColor = HDAppTheme.PayNowColor.c333333;

    cellModel.rightBtnClickBlock = ^(NSString *_Nonnull tag) {
        PNInterTransferRateController *vc = [[PNInterTransferRateController alloc] initWithRouteParameters:@{
            @"channel": @(self.channel),
        }];
        [SAWindowManager navigateToViewController:vc];
    };

    [temp addObject:cellModel];

    //预计到账金额
    cellModel = [[PNInterTransferAmountCellModel alloc] init];
    cellModel.tag = kExchangeAmount;
    cellModel.keyText = PNLocalizedString(@"JWRpnuek", @"预计到账金额");
    cellModel.descriptionText = PNLocalizedString(@"BiUtrIb3", @"注：本金额为预估金额，实际以到账金额为准");
    cellModel.canEdit = NO;
    cellModel.textFieldRightIconImage = [UIImage imageNamed:@"pn_trans_cny_logo"];
    cellModel.valueText = self.exchangeAmount;
    [temp addObject:cellModel];

    sectionModel.list = temp;
    [self.transferAmountDataArr addObject:sectionModel];

    // 1.收款人相关section、
    sectionModel = HDTableViewSectionModel.new;
    sectionModel.headerModel = HDTableHeaderFootViewModel.new;
    sectionModel.headerModel.title = PNLocalizedString(@"mKw25x8s", @"收款人信息");

    if (HDIsObjectNil(self.reciverModel)) {
        //收款人选择
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"uVVJeonR", @"收款账户信息");
        config.valuePlaceHold = PNLocalizedString(@"please_select", @"请选择");
        config.editType = PNSTransferFormValueEditTypeJump;

        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            [self chooseReciverInfo];
        };
        sectionModel.list = @[config];
    } else {
        sectionModel.list = @[self.reciverModel];
    }

    [self.transferAmountDataArr addObject:sectionModel];
    [self checkTransferAmountContinueBtnEabled];
}
#pragma mark -计算转账兑换金额
- (void)calculateExchangeAmount:(NSString *)sourceAmount {
    if (HDIsStringEmpty(sourceAmount)) {
        self.exchangeAmount = @"";
    } else {
        NSDecimalNumber *source = [NSDecimalNumber decimalNumberWithString:sourceAmount];
        NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithString:self.quotaAndRateModel.rate];

        NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2.0f raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                                  raiseOnDivideByZero:YES];

        NSDecimalNumber *result = [source decimalNumberByMultiplyingBy:rate withBehavior:handle];
        NSString *resultStr = [NSString stringWithFormat:@"%0.2f", result.doubleValue];
        self.exchangeAmount = resultStr;
        HDLog(@"计算汇率之后的%@", resultStr);
    }
    [self updateExchangeAmount];
}
/// 获取手续费
- (void)getFee {
    if (HDIsStringEmpty(self.sourceAmount)) {
        self.serviceCharge = @"";
    } else {
        [self.view showloading];
        @HDWeakify(self);
        [self.transDTO queryFeeWithAmount:self.sourceAmount channel:self.channel success:^(NSString *charge) {
            @HDStrongify(self);
            [self.view dismissLoading];
            if (WJIsStringEmpty(charge)) {
                self.serviceCharge = @"";
            } else {
                self.serviceCharge = charge;
            }
            [self updateServiceCharge];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}
/// 更新预计到账金额
- (void)updateExchangeAmount {
    for (HDTableViewSectionModel *sectionModel in self.transferAmountDataArr) {
        for (id modelObject in sectionModel.list) {
            if ([modelObject isKindOfClass:PNInterTransferAmountCellModel.class]) {
                PNInterTransferAmountCellModel *cellModel = modelObject;
                if ([cellModel.tag isEqualToString:kExchangeAmount]) {
                    cellModel.valueText = self.exchangeAmount;
                    self.transExchangeAmountRrfreshData = !self.transExchangeAmountRrfreshData;
                    break;
                }
            }
        }
    }
}

/// 更新手续费
- (void)updateServiceCharge {
    for (HDTableViewSectionModel *sectionModel in self.transferAmountDataArr) {
        for (id modelObject in sectionModel.list) {
            if ([modelObject isKindOfClass:PNInterTransferAmountCellModel.class]) {
                PNInterTransferAmountCellModel *cellModel = modelObject;
                if ([cellModel.tag isEqualToString:kServiceCharge]) {
                    cellModel.valueText = self.serviceCharge;
                    self.chargeRrfreshData = !self.chargeRrfreshData;
                    break;
                }
            }
        }
    }
}
#pragma mark -选择收款人
- (void)chooseReciverInfo {
    @HDWeakify(self);
    void (^callBack)(PNInterTransferReciverModel *) = ^(PNInterTransferReciverModel *reciverModel) {
        @HDStrongify(self);
        [self updateReciverItem:reciverModel];
    };
    [HDMediator.sharedInstance navigaveToInternationalTransferReciverInfoListWithChannelVC:@{
        @"chooseReciver": @(1),
        @"callBack": callBack,
        @"channel": @(self.channel),
    }];
}

#pragma mark -更新显示收款人列表
- (void)updateReciverItem:(PNInterTransferReciverModel *)reciverModel {
    self.reciverModel = reciverModel;
    [self checkTransferAmountContinueBtnEabled];
    HDTableViewSectionModel *sectionModel = self.transferAmountDataArr.lastObject;
    sectionModel.list = @[reciverModel];
    self.transAmountVcRefrehData = !self.transAmountVcRefrehData;
}
#pragma mark -请求转账额度以及费率
- (void)queryQuotaAndExchangeRateNeedLoading:(BOOL)needLoading completion:(void (^)(BOOL))completion {
    if (needLoading) {
        [self.view showloading];
    }
    @HDWeakify(self);
    [self.transDTO queryQuotaAndExchangeRateSuccess:^(PNInterTransferQuotaAndRateModel *_Nonnull quotaModel) {
        @HDStrongify(self);
        if (needLoading) {
            [self.view dismissLoading];
        }
        self.quotaAndRateModel = quotaModel;
        //重新刷新数据
        [self initTransferAmountData];
        self.getExchangeRateRefreshData = !self.getExchangeRateRefreshData;

        !completion ?: completion(YES);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        if (needLoading) {
            [self.view dismissLoading];
        }
        !completion ?: completion(NO);
    }];
}

///校验转账金额页面按钮是否可以点击
- (void)checkTransferAmountContinueBtnEabled {
    if (!HDIsObjectNil(self.reciverModel) && HDIsStringNotEmpty(self.sourceAmount) && HDIsStringNotEmpty(self.exchangeAmount) && !HDIsObjectNil(self.quotaAndRateModel)) {
        self.amountContinueBtnEnabled = YES;
    } else {
        self.amountContinueBtnEnabled = NO;
    }
}

#pragma mark
#pragma mark 【二】付款人信息相关
#pragma mark -初始化转账付款人信息页面数据
- (void)initPayerInfoData {
    [self.payerInfoDataArr removeAllObjects];

    if (self.channel == PNInterTransferThunesChannel_Wechat) {
        // 1.付款人信息相关section
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"payer_info", @"付款人信息");

        NSMutableArray *temp = [NSMutableArray array];

        // 我的账号
        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        config.valueText = [VipayUser shareInstance].loginName;
        config.onlyShow = YES;
        [temp addObject:config];

        //  转出国家
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"lPbT4NY1", @"转出国家");
        config.valueText = PNLocalizedString(@"country", @"柬埔寨");
        config.onlyShow = YES;
        [temp addObject:config];

        // 现住地址
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"ylaEdUhR", @"现住地址");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.showKeyStar = YES;
        config.valueText = self.payerInfoModel.address;
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.payerInfoModel.address = targetConfig.valueText;
            [self checkPayerContinueBtnEabled];
        };
        [temp addObject:config];

        // 交易日期
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"qVCl1o8O", @"交易日期");
        config.valueText = [[NSDate date] stringWithFormatStr:@"dd/MM/yyyy"];
        config.onlyShow = YES;
        [temp addObject:config];

        //转账目的
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
        config.showKeyStar = YES;
        config.valuePlaceHold = PNLocalizedString(@"please_select", @"请选择");
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.associateString = kPurposeConfigTag;
        config.valueText = self.purposeName;
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            [self showPurposeRemittanceAlertView:targetConfig];
        };
        [temp addObject:config];

        //其它目的
        if (HDIsStringNotEmpty(self.otherPurposeRemittance)) {
            [temp addObject:self.otherPurposeConfig];
        }

        sectionModel.list = temp;
        [self.payerInfoDataArr addObject:sectionModel];
    } else {
        // 1.付款人信息相关section
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"payer_info", @"付款人信息");

        NSMutableArray *temp = [NSMutableArray array];

        // 我的账号
        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        config.valueText = [VipayUser shareInstance].loginName;
        config.onlyShow = YES;
        [temp addObject:config];

        //  转出国家
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"lPbT4NY1", @"转出国家");
        config.valueText = PNLocalizedString(@"country", @"柬埔寨");
        config.onlyShow = YES;
        [temp addObject:config];

        // 现住地址
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"ylaEdUhR", @"现住地址");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.showKeyStar = YES;
        config.valueText = self.payerInfoModel.address;
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.payerInfoModel.address = targetConfig.valueText;
            [self checkPayerContinueBtnEabled];
        };
        [temp addObject:config];

        // 交易日期
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"qVCl1o8O", @"交易日期");
        config.valueText = [[NSDate date] stringWithFormatStr:@"dd/MM/yyyy"];
        config.onlyShow = YES;
        [temp addObject:config];

        //转账目的
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
        config.showKeyStar = YES;
        config.valuePlaceHold = PNLocalizedString(@"please_select", @"请选择");
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.associateString = kPurposeConfigTag;
        config.valueText = self.purposeName;
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            [self showPurposeRemittanceAlertView:targetConfig];
        };
        [temp addObject:config];

        //其它目的
        if (HDIsStringNotEmpty(self.otherPurposeRemittance)) {
            [temp addObject:self.otherPurposeConfig];
        }

        //资金来源
        config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"73IrNw1L", @"资金来源");
        config.showKeyStar = YES;
        config.valuePlaceHold = PNLocalizedString(@"please_select", @"请选择");
        config.editType = PNSTransferFormValueEditTypeDrop;
        config.associateString = kSourceFundConfigTag;
        config.valueText = self.sourceName;
        config.valueContainerClickCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            [self showSourceFundAlertView:targetConfig];
        };
        [temp addObject:config];

        //其它来源
        if (HDIsStringNotEmpty(self.otherSourceOfFund)) {
            [temp addObject:self.otherSourceConfig];
        }

        sectionModel.list = temp;
        [self.payerInfoDataArr addObject:sectionModel];
    }
    [self checkPayerContinueBtnEabled];
}
#pragma mark -选择转账目的弹窗
- (void)showPurposeRemittanceAlertView:(PNTransferFormConfig *)config {
    NSMutableArray *array = [NSMutableArray array];
    for (PNPurposeRemittanceModel *pModel in self.payerInfoModel.purposeRemittanceInfoList) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        model.name = pModel.purposeName;
        model.itemId = pModel.purposeId;
        if ([self.purposeId isEqualToString:model.itemId]) {
            model.isSelected = YES;
        }
        [array addObject:model];
    }
    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:array title:PNLocalizedString(@"C3InKk2b", @"转账目的")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.purposeId = model.itemId;
        self.purposeName = model.name;
        [self checkPurposeRemittanceSelected];
    };
    [alertView show];
}

/// 检查转账目的选项  如果选了其它 就要展示其它选项
- (void)checkPurposeRemittanceSelected {
    __block NSString *purposeCode;
    [self.payerInfoModel.purposeRemittanceInfoList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PNPurposeRemittanceModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.purposeId isEqualToString:self.purposeId]) {
            purposeCode = obj.purposeCode;
            *stop = YES;
        }
    }];
    HDTableViewSectionModel *sectionModel = self.payerInfoDataArr.lastObject;
    __block NSInteger index; //转账目的的位置
    [sectionModel.list enumerateObjectsUsingBlock:^(PNTransferFormConfig *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.associateString isEqualToString:kPurposeConfigTag]) {
            index = idx;
            *stop = YES;
        }
    }];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:sectionModel.list];
    //选择了其它选项
    if ([purposeCode.uppercaseString isEqualToString:@"OTHER"]) {
        if (![temp containsObject:self.otherPurposeConfig]) {
            [temp insertObject:self.otherPurposeConfig atIndex:index + 1];
            sectionModel.list = temp;
        }
    } else {
        self.otherPurposeRemittance = @"";
        if ([temp containsObject:self.otherPurposeConfig]) {
            [temp removeObject:self.otherPurposeConfig];
            sectionModel.list = temp;
        }
    }
    self.payerInfoVcRefrehData = !self.payerInfoVcRefrehData;
    [self checkPayerContinueBtnEabled];
}

///是否选了其它目的
- (BOOL)hasContainOtherPurposeConfig {
    HDTableViewSectionModel *sectionModel = self.payerInfoDataArr.lastObject;
    return [sectionModel.list containsObject:self.otherPurposeConfig];
}

///是否选了其它来源
- (BOOL)hasContainOtherSourceFundConfig {
    HDTableViewSectionModel *sectionModel = self.payerInfoDataArr.lastObject;
    return [sectionModel.list containsObject:self.otherSourceConfig];
}

#pragma mark -选择资金来源弹窗
- (void)showSourceFundAlertView:(PNTransferFormConfig *)config {
    NSMutableArray *array = [NSMutableArray array];
    for (PNSourceFundModel *pModel in self.payerInfoModel.sourceFundInfoList) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        model.name = pModel.sourceName;
        model.itemId = pModel.sourceId;
        if ([self.sourceId isEqualToString:model.itemId]) {
            model.isSelected = YES;
        }
        [array addObject:model];
    }
    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:array title:PNLocalizedString(@"73IrNw1L", @"资金来源")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        config.valueText = model.name;
        self.sourceId = model.itemId;
        self.sourceName = model.name;
        [self checkSourceFundSelected];
    };
    [alertView show];
}

/// 检查资金来源选项  如果选了其它 就要展示其它选项
- (void)checkSourceFundSelected {
    __block NSString *sourceFundCode;
    [self.payerInfoModel.sourceFundInfoList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PNSourceFundModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.sourceId isEqualToString:self.sourceId]) {
            sourceFundCode = obj.sourceCode;
            *stop = YES;
        }
    }];

    HDTableViewSectionModel *sectionModel = self.payerInfoDataArr.lastObject;
    __block NSInteger index; //转账目的的位置
    [sectionModel.list enumerateObjectsUsingBlock:^(PNTransferFormConfig *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.associateString isEqualToString:kSourceFundConfigTag]) {
            index = idx;
            *stop = YES;
        }
    }];

    NSMutableArray *temp = [NSMutableArray arrayWithArray:sectionModel.list];
    //选择了其它选项
    if ([sourceFundCode.uppercaseString isEqualToString:@"OTHER"]) {
        if (![temp containsObject:self.otherSourceConfig]) {
            [temp insertObject:self.otherSourceConfig atIndex:index + 1];
            sectionModel.list = temp;
        }
    } else {
        self.otherSourceOfFund = @"";
        if ([temp containsObject:self.otherSourceConfig]) {
            [temp removeObject:self.otherSourceConfig];
            sectionModel.list = temp;
        }
    }
    self.payerInfoVcRefrehData = !self.payerInfoVcRefrehData;
    [self checkPayerContinueBtnEabled];
}

#pragma mark -查询付款人信息
- (void)queryPayerInfoCompletion:(void (^)(BOOL))completion {
    [KeyWindow showloading];
    @HDWeakify(self);
    [self.transDTO queryPayerInfoWithPayOutAmount:self.sourceAmount currency:@"USD" msisdn:self.reciverModel.msisdn channel:self.channel
        success:^(PNInterTransferPayerInfoModel *_Nonnull payerInfoModel) {
            @HDStrongify(self);
            [KeyWindow dismissLoading];
            self.payerInfoModel = payerInfoModel;
            !completion ?: completion(YES);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            [KeyWindow dismissLoading];

            if (WJIsObjectNil(rspModel)) {
                [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
            } else {
                if ([rspModel.code isEqualToString:@"FX10005"] || [rspModel.code isEqualToString:@"FX10008"]) { //超过风控限制
                    [NAT showAlertWithMessage:rspModel.msg confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
                        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                            [alertView dismiss];
                        }
                        cancelButtonTitle:PNLocalizedString(@"pn_view", @"查看说明") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                            [alertView dismiss];
                            PNInterTransferLimitController *vc = [[PNInterTransferLimitController alloc] initWithRouteParameters:@{
                                @"channel": @(self.channel),
                            }];
                            [SAWindowManager navigateToViewController:vc];
                        }];
                } else {
                    [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                          [alertView dismiss];
                                      }];
                }
            }

            !completion ?: completion(NO);
        }];
}

///校验转账金额页面按钮是否可以点击
- (void)checkPayerContinueBtnEabled {
    if (self.channel == PNInterTransferThunesChannel_Wechat) {
        if (!HDIsObjectNil(self.payerInfoModel) && HDIsStringNotEmpty(self.purposeId) && self.agreementCoolcashTerms && HDIsStringNotEmpty(self.payerInfoModel.address)) {
            if ([self hasContainOtherPurposeConfig] && HDIsStringEmpty(self.otherPurposeRemittance)) {
                self.payerContinueBtnEnabled = NO;
            } else {
                self.payerContinueBtnEnabled = YES;
            }
        } else {
            self.payerContinueBtnEnabled = NO;
        }
    } else {
        if (!HDIsObjectNil(self.payerInfoModel) && HDIsStringNotEmpty(self.purposeId) && HDIsStringNotEmpty(self.sourceId) && self.agreementCoolcashTerms
            && HDIsStringNotEmpty(self.payerInfoModel.address)) {
            if ([self hasContainOtherPurposeConfig] && HDIsStringEmpty(self.otherPurposeRemittance)) {
                self.payerContinueBtnEnabled = NO;
            } else if ([self hasContainOtherSourceFundConfig] && HDIsStringEmpty(self.otherSourceOfFund)) {
                self.payerContinueBtnEnabled = NO;
            } else {
                self.payerContinueBtnEnabled = YES;
            }
        } else {
            self.payerContinueBtnEnabled = NO;
        }
    }
}

#pragma mark -反洗钱校验并创建订单
- (void)amlAnalyzeVerificationAndCreateOrderCompletion:(void (^)(BOOL))completion {
    [KeyWindow showloading];
    @HDWeakify(self);
    [self amlAnalyzeVerificationCompletion:^(BOOL isSucess) {
        @HDStrongify(self);
        if (isSucess) {
            [self createOrderCompletion:^(BOOL isSucess) {
                [KeyWindow dismissLoading];
                !completion ?: completion(isSucess);
            }];
        } else {
            [KeyWindow dismissLoading];
            !completion ?: completion(NO);
        }
    }];
}

/// 反洗钱校验
- (void)amlAnalyzeVerificationCompletion:(void (^)(BOOL))completion {
    [self.transDTO amlAnalyzeVerificationWithReciverName:[NSString stringWithFormat:@"%@ %@", self.reciverModel.lastName, self.reciverModel.firstName]
        idType:[NSString stringWithFormat:@"%ld", self.reciverModel.idType]
        receiverID:self.reciverModel.reciverId success:^{
            !completion ?: completion(YES);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            !completion ?: completion(NO);
        }];
}

/// 创建订单
- (void)createOrderCompletion:(void (^)(BOOL))completion {
    PNInterTransferCreateOrderModel *createModel = [[PNInterTransferCreateOrderModel alloc] init];
    createModel.payoutCountry = PNLocalizedString(@"country", @"柬埔寨");
    createModel.quotationId = self.payerInfoModel.quotationId;
    createModel.beneficiaryId = self.reciverModel.reciverId;
    createModel.serverType = @(2);
    createModel.address = self.payerInfoModel.address;
    createModel.purposeRemittanceId = self.purposeId;
    createModel.otherPurposeRemittance = self.otherPurposeRemittance;
    createModel.sourceFundId = self.sourceId;
    createModel.otherSourceOfFund = self.otherSourceOfFund;
    createModel.inviteCode = self.inviteCode;
    @HDWeakify(self);
    [self.transDTO createOrderWithCreateModel:createModel channel:self.channel success:^(PNInterTransferConfirmInfoModel *_Nonnull confirmModel) {
        @HDStrongify(self);
        self.confirmModel = confirmModel;
        !completion ?: completion(YES);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        if (WJIsObjectNil(rspModel)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
        } else {
            if ([rspModel.code isEqualToString:@"FX10005"] || [rspModel.code isEqualToString:@"FX10008"]) { //超过风控限制
                [NAT showAlertWithMessage:rspModel.msg confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                } cancelButtonTitle:PNLocalizedString(@"pn_view", @"查看说明") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                    PNInterTransferLimitController *vc = [[PNInterTransferLimitController alloc] initWithRouteParameters:@{
                        @"channel": @(self.channel),
                    }];
                    [SAWindowManager navigateToViewController:vc];
                }];
            } else {
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            }
        }

        !completion ?: completion(NO);
    }];
}

#pragma mark
#pragma mark 【三】提交页面相关
#pragma mark -初始化确认信息页面数据
- (void)initTransferConfirmData {
    if (self.channel == PNInterTransferThunesChannel_Wechat) {
        [self.transConfirmDataArr removeAllObjects];
        // 1.我的账号相关section
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;

        NSMutableArray *temp = [NSMutableArray array];

        SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        infoModel.valueText = self.confirmModel.account;
        [temp addObject:infoModel];

        if (WJIsStringNotEmpty(self.confirmModel.inviteCode)) {
            SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"pn_invite_code", @"邀请码");
            infoModel.valueText = self.confirmModel.inviteCode;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"qVCl1o8O", @"交易日期");
        infoModel.valueText = self.confirmModel.translationDate;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
        infoModel.valueText = self.confirmModel.transferReason;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.transConfirmDataArr addObject:sectionModel];

        //收款人信息
        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"mKw25x8s", @"收款人信息");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"EflnCwt2", @"手机号");
        infoModel.valueText = self.confirmModel.mobile;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_type", @"证件类型");
        infoModel.valueText = self.confirmModel.idType;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_number", @"证件号");
        infoModel.valueText = self.confirmModel.idCode;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pn_full_name", @"姓名");
        infoModel.valueText = self.confirmModel.fullName;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.transConfirmDataArr addObject:sectionModel];

        //转账金额
        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"transfer_amount", @"转账金额");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"transfer_amount", @"转账金额");
        infoModel.valueText = self.confirmModel.payoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        if (!HDIsObjectNil(self.confirmModel.serviceCharge)) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"cB3e7LW6", @"转账服务费");
            infoModel.valueText = self.confirmModel.serviceCharge.thousandSeparatorAmount;
            [temp addObject:infoModel];
        }

        if (!HDIsObjectNil(self.confirmModel.promotion)) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"d1q6xTQ3", @"营销减免");
            infoModel.valueText = self.confirmModel.promotion.thousandSeparatorAmount;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"O7btTqFy", @"转账汇率");
        infoModel.valueText = self.confirmModel.exchangeRate;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"JWRpnuek", @"预计到账金额");
        infoModel.valueText = self.confirmModel.receiverAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"detail_total_amount", @"支付金额");
        infoModel.valueFont = [HDAppTheme.PayNowFont fontSemibold:24];
        infoModel.valueColor = HDAppTheme.PayNowColor.mainThemeColor;
        infoModel.valueText = self.confirmModel.totalPayoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.transConfirmDataArr addObject:sectionModel];

    } else {
        [self.transConfirmDataArr removeAllObjects];
        // 1.我的账号相关section
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;

        NSMutableArray *temp = [NSMutableArray array];

        SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        infoModel.valueText = self.confirmModel.account;
        [temp addObject:infoModel];

        if (WJIsStringNotEmpty(self.confirmModel.inviteCode)) {
            SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"pn_invite_code", @"邀请码");
            infoModel.valueText = self.confirmModel.inviteCode;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"qVCl1o8O", @"交易日期");
        infoModel.valueText = self.confirmModel.translationDate;
        [temp addObject:infoModel];

        //    infoModel = [self getDefaultInfoViewModel];
        //    infoModel.keyText = PNLocalizedString(@"jipl0KUj", @"出生国家");
        //    infoModel.valueText = self.confirmModel.senderPayoutCountryOfBirth;
        //    [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
        infoModel.valueText = self.confirmModel.transferReason;
        [temp addObject:infoModel];

        if (self.channel == PNInterTransferThunesChannel_Alipay) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"73IrNw1L", @"资金来源");
            infoModel.valueText = self.confirmModel.sourceOfFund;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"lYXV87bl", @"与转账人关系");
        infoModel.valueText = self.confirmModel.relation;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.transConfirmDataArr addObject:sectionModel];

        //收款人信息
        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"mKw25x8s", @"收款人信息");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"EflnCwt2", @"手机号");
        infoModel.valueText = self.confirmModel.mobile;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_type", @"证件类型");
        infoModel.valueText = self.confirmModel.idType;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_number", @"证件号");
        infoModel.valueText = self.confirmModel.idCode;
        [temp addObject:infoModel];

        //    infoModel = [self getDefaultInfoViewModel];
        //    infoModel.keyText = PNLocalizedString(@"info_email", @"邮箱");
        //    infoModel.valueText = self.confirmModel.email;
        //    [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"UNzSjgTY", @"名");
        infoModel.valueText = self.confirmModel.firstName;
        [temp addObject:infoModel];

        //    infoModel = [self getDefaultInfoViewModel];
        //    infoModel.keyText = PNLocalizedString(@"OwjdGw1x", @"中间名");
        //    infoModel.valueText = self.confirmModel.middleName;
        //    [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"TF_TITLE_LAST_NAME", @"姓");
        infoModel.valueText = self.confirmModel.lastName;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Suw8Q4KU", @"国家");
        infoModel.valueText = self.confirmModel.nationality;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"MAOLJbCr", @"省");
        infoModel.valueText = self.confirmModel.province;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"WFLBHUE4", @"城市");
        infoModel.valueText = self.confirmModel.city;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"LQPsLBJh", @"地址");
        infoModel.valueText = self.confirmModel.address;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.transConfirmDataArr addObject:sectionModel];

        /*
         //尽职调查
         sectionModel = HDTableViewSectionModel.new;
         sectionModel.headerModel = HDTableHeaderFootViewModel.new;
         sectionModel.headerModel.title = PNLocalizedString(@"XiS0f25N", @"客户尽职调查");

         temp = [NSMutableArray array];

         infoModel = [self getDefaultInfoViewModel];
         infoModel.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
         infoModel.valueText = self.confirmModel.transferReason;
         [temp addObject:infoModel];

         infoModel = [self getDefaultInfoViewModel];
         infoModel.keyText = PNLocalizedString(@"73IrNw1L", @"资金来源");
         infoModel.valueText = self.confirmModel.sourceOfFund;
         [temp addObject:infoModel];

         infoModel = [self getDefaultInfoViewModel];
         infoModel.keyText = PNLocalizedString(@"lYXV87bl", @"与转账人关系");
         infoModel.valueText = self.confirmModel.relation;
         [temp addObject:infoModel];

         sectionModel.list = temp;
         [self.transConfirmDataArr addObject:sectionModel];
         */
        //转账金额
        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"transfer_amount", @"转账金额");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"transfer_amount", @"转账金额");
        infoModel.valueText = self.confirmModel.payoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        if (!HDIsObjectNil(self.confirmModel.serviceCharge)) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"cB3e7LW6", @"转账服务费");
            infoModel.valueText = self.confirmModel.serviceCharge.thousandSeparatorAmount;
            [temp addObject:infoModel];
        }

        if (!HDIsObjectNil(self.confirmModel.promotion)) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"d1q6xTQ3", @"营销减免");
            infoModel.valueText = self.confirmModel.promotion.thousandSeparatorAmount;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"O7btTqFy", @"转账汇率");
        infoModel.valueText = self.confirmModel.exchangeRate;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"JWRpnuek", @"预计到账金额");
        infoModel.valueText = self.confirmModel.receiverAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"detail_total_amount", @"支付金额");
        infoModel.valueFont = [HDAppTheme.PayNowFont fontSemibold:24];
        infoModel.valueColor = HDAppTheme.PayNowColor.mainThemeColor;
        infoModel.valueText = self.confirmModel.totalPayoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.transConfirmDataArr addObject:sectionModel];
    }
}

#pragma mark
- (SAInfoViewModel *)getDefaultInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = [HDAppTheme.PayNowFont fontBold:12];
    infoModel.keyColor = HDAppTheme.PayNowColor.c333333;
    infoModel.valueFont = HDAppTheme.PayNowFont.standard12;
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(17), kRealWidth(12), kRealWidth(17), kRealWidth(12));
    return infoModel;
}

/** @lazy transOpenDataArr */
- (NSMutableArray<PNTransferFormConfig *> *)transOpenDataArr {
    if (!_transOpenDataArr) {
        _transOpenDataArr = [NSMutableArray array];
    }
    return _transOpenDataArr;
}

/** @lazy transferAmountDataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)transferAmountDataArr {
    if (!_transferAmountDataArr) {
        _transferAmountDataArr = [NSMutableArray array];
    }
    return _transferAmountDataArr;
}

/** @lazy payerInfoDataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)payerInfoDataArr {
    if (!_payerInfoDataArr) {
        _payerInfoDataArr = [NSMutableArray array];
    }
    return _payerInfoDataArr;
}

/** @lazy transConfirmDataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)transConfirmDataArr {
    if (!_transConfirmDataArr) {
        _transConfirmDataArr = [NSMutableArray array];
    }
    return _transConfirmDataArr;
}

/** @lazy transDto */
- (PNInterTransferDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNInterTransferDTO alloc] init];
    }
    return _transDTO;
}

/** @lazy otherPurposeConfig */
- (PNTransferFormConfig *)otherPurposeConfig {
    if (!_otherPurposeConfig) {
        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"30T5DG3Q", @"其它目的");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.showKeyStar = YES;
        config.valueText = self.otherPurposeRemittance;
        config.keyFont = HDAppTheme.PayNowFont.standard12;
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.otherPurposeRemittance = targetConfig.valueText;
            [self checkPayerContinueBtnEabled];
        };
        _otherPurposeConfig = config;
    }
    return _otherPurposeConfig;
}

/** @lazy otherSourceConfig */
- (PNTransferFormConfig *)otherSourceConfig {
    if (!_otherSourceConfig) {
        PNTransferFormConfig *config = PNTransferFormConfig.new;
        config.keyText = PNLocalizedString(@"O8X45dkA", @"其它来源");
        config.valuePlaceHold = PNLocalizedString(@"please_enter", @"请输入");
        config.editType = PNSTransferFormValueEditTypeEnter;
        config.showKeyStar = YES;
        config.valueText = self.otherSourceOfFund;
        config.keyFont = HDAppTheme.PayNowFont.standard12;
        @HDWeakify(self);
        config.valueChangedCallBack = ^(PNTransferFormConfig *_Nonnull targetConfig) {
            @HDStrongify(self);
            self.otherSourceOfFund = targetConfig.valueText;
            [self checkPayerContinueBtnEabled];
        };
        _otherSourceConfig = config;
    }
    return _otherSourceConfig;
}

- (PNMarketingDTO *)marketingDTO {
    if (!_marketingDTO) {
        _marketingDTO = [[PNMarketingDTO alloc] init];
    }
    return _marketingDTO;
}
@end

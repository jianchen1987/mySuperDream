//
//  TNWithdrawBindViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawBindViewController.h"
#import "SAMoneyModel.h"
#import "TNWithdrawBindDTO.h"
#import "TNWithdrawBindItemView.h"
#import "TNWithdrawConfirmAlertView.h"
#import "TNWithdrawItemAlertView.h"
#import <UIImage+HDKitCore.h>


@interface TNWithdrawBindViewController ()
@property (nonatomic, strong) HDUIButton *postButton;
@property (nonatomic, strong) TNWithdrawBindItemView *payWayItemView; //提现方式

@property (nonatomic, strong) TNWithdrawBindItemView *bankNameItemView;        //银行名称
@property (nonatomic, strong) TNWithdrawBindItemView *bankAccountItemView;     //银行账号
@property (nonatomic, strong) TNWithdrawBindItemView *bankAccountNameItemView; //开户名

@property (nonatomic, strong) TNWithdrawBindItemView *payCompanyItemView;     //支付公司
@property (nonatomic, strong) TNWithdrawBindItemView *payAccountItemView;     //支付账号
@property (nonatomic, strong) TNWithdrawBindItemView *payAccountNameItemView; //支付账户名称
@property (strong, nonatomic) UIStackView *containStackView;                  ///<  容器

@property (strong, nonatomic) TNWithdrawBindDTO *bindDto;                   ///<
@property (strong, nonatomic) NSArray<TNWithdrawBindModel *> *paymentArr;   ///<  支付方式数组
@property (strong, nonatomic) TNWithdrawBindRequestModel *bindRequestModel; ///< 提现申请入参模型
@property (strong, nonatomic) SAMoneyModel *amount;                         ///<  提现金额
@property (nonatomic, assign) BOOL hasBindAccount;                          ///<  是否有绑定的提现账户

@property (nonatomic, copy) NSString *firstName; ///<姓
@property (nonatomic, copy) NSString *lastName;  ///<名
/// 刷新上个页面回调
@property (nonatomic, copy) void (^refreshCallBack)(void);
@end


@implementation TNWithdrawBindViewController
- (id)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.amount = parameters[@"amount"];
        self.refreshCallBack = parameters[@"callBack"];
    }
    return self;
}

#pragma mark -数据
- (void)hd_bindViewModel {
    [self getBindAccountData];
}

/// 获取用户绑定的支付方式
- (void)getBindAccountData {
    [self removePlaceHolder];
    [self showloading];
    @HDWeakify(self);
    [self.bindDto queryBindPayAcountSuccess:^(TNWithdrawBindRequestModel *model) {
        @HDStrongify(self);
        if (!HDIsObjectNil(model) && HDIsStringNotEmpty(model.settlementType)) {
            [self dismissLoading];
            self.bindRequestModel = model;
            self.bindRequestModel.amount = self.amount;
            self.hasBindAccount = YES;
            [self showConfirWithDrawAlertView];
        } else {
            [self getPaymentsData];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if ([rspModel.code isEqualToString:@"10000"]) {
            //用户未绑定
            [self getPaymentsData];
        } else {
            [self dismissLoading];
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
            @HDWeakify(self);
            [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
                @HDStrongify(self);
                [self getBindAccountData];
            }];
        }
    }];
}

/// 获取提现支付方式 数据
- (void)getPaymentsData {
    @HDWeakify(self);
    [self.bindDto queryPaymentWaySuccess:^(NSArray<TNWithdrawBindModel *> *payArr) {
        @HDStrongify(self);
        [self dismissLoading];
        self.paymentArr = payArr;
        self.payWayItemView.text = TNLocalizedString(@"3fE8sWJ3", @"银行");
        [self updateUIByPayMethod:TNPaymentWayCodeBank];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark -刷新数据
- (void)updateUIByPayMethod:(TNPaymentWayCode)payWayCode {
    self.bindRequestModel.settlementType = payWayCode;
    self.bindRequestModel.account = @"";
    self.bindRequestModel.accountHolder = @"";
    self.bindRequestModel.paymentType = @"";

    self.bankNameItemView.text = @"";
    self.bankAccountItemView.text = @"";
    self.bankAccountNameItemView.text = @"";
    self.bankAccountNameItemView.rightText = @"";

    self.payCompanyItemView.text = @"";
    self.payAccountItemView.text = @"";
    self.payAccountNameItemView.text = @"";

    self.firstName = @"";
    self.lastName = @"";
    if ([payWayCode isEqualToString:TNPaymentWayCodeBank]) {
        self.bankNameItemView.hidden = NO;
        self.bankAccountItemView.hidden = NO;
        self.bankAccountNameItemView.hidden = NO;

        self.payCompanyItemView.hidden = YES;
        self.payAccountItemView.hidden = YES;
        self.payAccountNameItemView.hidden = YES;
    } else if ([payWayCode isEqualToString:TNPaymentWayCodeThird]) {
        self.bankNameItemView.hidden = YES;
        self.bankAccountItemView.hidden = YES;
        self.bankAccountNameItemView.hidden = YES;

        self.payCompanyItemView.hidden = NO;
        self.payAccountItemView.hidden = NO;
        self.payAccountNameItemView.hidden = NO;
    }
}

#pragma mark -提现确认弹窗
- (void)showConfirWithDrawAlertView {
    TNWithdrawConfirmAlertView *alertView = [[TNWithdrawConfirmAlertView alloc] initWithWithDrawModel:self.bindRequestModel];
    @HDWeakify(self);
    alertView.dismissCallBack = ^{
        @HDStrongify(self);
        if (self.hasBindAccount) {
            //如果有了绑定账户  弹窗消失的时候  就是返回上个页面
            [self dismissAnimated:YES completion:nil];
        }
    };
    alertView.postWithDrawCallBack = ^{
        @HDStrongify(self);
        !self.refreshCallBack ?: self.refreshCallBack();
        [self dismissAnimated:YES completion:nil];
    };
    [alertView show];
}
#pragma mark -弹出选择框
- (void)showPayMethodOrCompanyAlertViewByType:(TNWithdrawItemAlertType)alertType {
    TNWithdrawItemConfig *config = [[TNWithdrawItemConfig alloc] init];
    config.type = alertType;
    if (alertType == TNWithdrawItemAlertTypeMethed) {
        //提现方式
        config.title = TNLocalizedString(@"Slt2FyKd", @"请选择提现方式");
        config.dataArr = [self getWithDrawMethodArr];
        if (HDIsStringNotEmpty(self.bindRequestModel.settlementType)) {
            for (TNWithdrawItemModel *model in config.dataArr) {
                if ([model.ID isEqualToString:self.bindRequestModel.settlementType]) {
                    model.isSelected = YES;
                    break;
                }
            }
        }
    } else if (alertType == TNWithdrawItemAlertTypeBank) {
        //银行名称
        config.title = TNLocalizedString(@"2Nz7aYdD", @"请选择银行");
        config.dataArr = [self getPayCompanyArrByMethod:TNPaymentWayCodeBank];
        if (HDIsStringNotEmpty(self.bindRequestModel.paymentType)) {
            for (TNWithdrawItemModel *model in config.dataArr) {
                if ([model.name isEqualToString:self.bindRequestModel.paymentType]) {
                    model.isSelected = YES;
                    break;
                }
            }
        }
    } else if (alertType == TNWithdrawItemAlertTypePayCompany) {
        //支付公司名称
        config.title = TNLocalizedString(@"ky2TZs7Q", @"请选择支付公司");
        config.dataArr = [self getPayCompanyArrByMethod:TNPaymentWayCodeThird];
        if (HDIsStringNotEmpty(self.bindRequestModel.paymentType)) {
            for (TNWithdrawItemModel *model in config.dataArr) {
                if ([model.name isEqualToString:self.bindRequestModel.paymentType]) {
                    model.isSelected = YES;
                    break;
                }
            }
        }
    }

    TNWithdrawItemAlertView *alertView = [[TNWithdrawItemAlertView alloc] initAlertViewWithConfig:config];
    @HDWeakify(self);
    alertView.confirmClickCallBack = ^(TNWithdrawItemModel *model) {
        @HDStrongify(self);
        if (alertType == TNWithdrawItemAlertTypeMethed) {
            //提现方式
            self.payWayItemView.text = model.name;
            [self updateUIByPayMethod:model.ID];
        } else if (alertType == TNWithdrawItemAlertTypeBank) {
            //银行名称
            self.bindRequestModel.paymentType = model.name;
            self.bankNameItemView.text = model.name;
        } else if (alertType == TNWithdrawItemAlertTypePayCompany) {
            //支付公司名称
            self.bindRequestModel.paymentType = model.name;
            self.payCompanyItemView.text = model.name;
        }
        //按钮是否可以点击
        [self checkConfirmBtnEnable];
    };
    [alertView show];
}

//验证确认按钮是否可以点击
- (void)checkConfirmBtnEnable {
    BOOL enable = NO;
    if ([self.bindRequestModel.settlementType isEqualToString:TNPaymentWayCodeBank]) {
        if (HDIsStringNotEmpty(self.bindRequestModel.settlementType) && HDIsStringNotEmpty(self.bindRequestModel.paymentType) && HDIsStringNotEmpty(self.bindRequestModel.account)
            && (HDIsStringNotEmpty(self.bindRequestModel.paymentType) && (HDIsStringNotEmpty(self.firstName) && HDIsStringNotEmpty(self.lastName)))) {
            self.bindRequestModel.accountHolder = [NSString stringWithFormat:@"%@%@", self.lastName, self.firstName];
            enable = YES;
        }
    } else if ([self.bindRequestModel.settlementType isEqualToString:TNPaymentWayCodeThird]) {
        if (HDIsStringNotEmpty(self.bindRequestModel.settlementType) && HDIsStringNotEmpty(self.bindRequestModel.paymentType) && HDIsStringNotEmpty(self.bindRequestModel.account)
            && (HDIsStringNotEmpty(self.bindRequestModel.paymentType) && HDIsStringNotEmpty(self.bindRequestModel.accountHolder))) {
            enable = YES;
        }
    }
    self.postButton.enabled = enable;
    if (enable) {
        self.postButton.backgroundColor = HDAppTheme.TinhNowColor.C1;
    } else {
        self.postButton.backgroundColor = HexColor(0xD6DBE8);
    }
}
#pragma mark -UI
- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.containStackView];
    [self.containStackView addArrangedSubview:self.payWayItemView];
    [self.containStackView addArrangedSubview:self.bankNameItemView];
    [self.containStackView addArrangedSubview:self.bankAccountItemView];
    [self.containStackView addArrangedSubview:self.bankAccountNameItemView];
    [self.containStackView addArrangedSubview:self.payCompanyItemView];
    [self.containStackView addArrangedSubview:self.payAccountItemView];
    [self.containStackView addArrangedSubview:self.payAccountNameItemView];

    [self.view addSubview:self.postButton];
    self.hd_needMoveView = self.scrollViewContainer;
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.postButton.mas_top).offset(kRealWidth(-10));
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.containStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.scrollViewContainer);
        //        make.bottom.equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.postButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(kRealWidth(45)));
        if (iPhoneXSeries) {
            make.bottom.equalTo(@(-kiPhoneXSeriesSafeBottomHeight));
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"NwmaxbJT", @"提现");
}

#pragma mark
- (NSArray<TNWithdrawItemModel *> *)getWithDrawMethodArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (TNWithdrawBindModel *model in self.paymentArr) {
        if ([model.paymentWay isEqualToString:TNPaymentWayCodeBank]) {
            TNWithdrawItemModel *item = [[TNWithdrawItemModel alloc] init];
            item.name = TNLocalizedString(@"3fE8sWJ3", @"银行");
            item.ID = TNPaymentWayCodeBank;
            item.localImageName = @"tn_drawCash_bank";
            [arr addObject:item];
        } else if ([model.paymentWay isEqualToString:TNPaymentWayCodeThird]) {
            TNWithdrawItemModel *item = [[TNWithdrawItemModel alloc] init];
            item.name = TNLocalizedString(@"mCPxonSi", @"第三方支付");
            item.ID = TNPaymentWayCodeThird;
            item.localImageName = @"tn_drawCash_other";
            [arr addObject:item];
        }
    }
    return arr;
}

- (NSArray<TNWithdrawItemModel *> *)getPayCompanyArrByMethod:(TNPaymentWayCode)payMethod {
    NSMutableArray *arr = [NSMutableArray array];
    TNWithdrawBindModel *targetModel;
    for (TNWithdrawBindModel *model in self.paymentArr) {
        if ([payMethod isEqualToString:model.paymentWay]) {
            targetModel = model;
            break;
        }
    }
    if (!HDIsArrayEmpty(targetModel.paymentCompanyRespDTOList)) {
        for (TNWithdrawPayCompanyModel *model in targetModel.paymentCompanyRespDTOList) {
            TNWithdrawItemModel *item = [[TNWithdrawItemModel alloc] init];
            item.name = model.companyName;
            [arr addObject:item];
        }
    }
    return arr;
}

/** @lazy stackView */
- (UIStackView *)containStackView {
    if (!_containStackView) {
        _containStackView = [[UIStackView alloc] init];
        _containStackView.axis = UILayoutConstraintAxisVertical;
        _containStackView.spacing = 0;
    }
    return _containStackView;
}
#pragma mark
- (HDUIButton *)postButton {
    if (!_postButton) {
        _postButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _postButton.adjustsButtonWhenHighlighted = NO;
        [_postButton setTitle:TNLocalizedString(@"tn_button_submit", @"提交") forState:UIControlStateNormal];
        [_postButton setTitleColor:HDAppTheme.TinhNowColor.cFFFFFF forState:UIControlStateNormal];
        [_postButton setBackgroundImage:[UIImage hd_imageWithColor:HDAppTheme.TinhNowColor.cD6DBE8] forState:UIControlStateDisabled];
        [_postButton setBackgroundImage:[UIImage hd_imageWithColor:HDAppTheme.TinhNowColor.cFF8F1A] forState:UIControlStateNormal];
        _postButton.backgroundColor = HexColor(0xD6DBE8);
        _postButton.enabled = NO;
        [_postButton addTarget:self action:@selector(showConfirWithDrawAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

- (TNWithdrawBindItemView *)payWayItemView {
    if (!_payWayItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_Alert text:nil title:TNLocalizedString(@"cri3B0so", @"提现方式")
                                                                        placeholder:TNLocalizedString(@"tn_please_select", @"请选择")
                                                                          rightText:nil
                                                                   rightPlaceholder:nil];
        _payWayItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _payWayItemView.itemClickCallBack = ^{
            @HDStrongify(self);
            [self showPayMethodOrCompanyAlertViewByType:TNWithdrawItemAlertTypeMethed];
        };
    }
    return _payWayItemView;
}
- (TNWithdrawBindItemView *)bankNameItemView {
    if (!_bankNameItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_Alert text:nil title:TNLocalizedString(@"LKipPAAx", @"银行名称")
                                                                        placeholder:TNLocalizedString(@"tn_please_select", @"请选择")
                                                                          rightText:nil
                                                                   rightPlaceholder:nil];
        _bankNameItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _bankNameItemView.itemClickCallBack = ^{
            @HDStrongify(self);
            [self showPayMethodOrCompanyAlertViewByType:TNWithdrawItemAlertTypeBank];
        };
        _bankNameItemView.hidden = YES;
    }
    return _bankNameItemView;
}

- (TNWithdrawBindItemView *)payCompanyItemView {
    if (!_payCompanyItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_Alert text:nil title:TNLocalizedString(@"jHQMjV9F", @"支付公司")
                                                                        placeholder:TNLocalizedString(@"tn_please_select", @"请选择")
                                                                          rightText:nil
                                                                   rightPlaceholder:nil];
        _payCompanyItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _payCompanyItemView.itemClickCallBack = ^{
            @HDStrongify(self);
            [self showPayMethodOrCompanyAlertViewByType:TNWithdrawItemAlertTypePayCompany];
        };
        _payCompanyItemView.hidden = YES;
    }
    return _payCompanyItemView;
}

- (TNWithdrawBindItemView *)bankAccountItemView {
    if (!_bankAccountItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_Input text:nil title:TNLocalizedString(@"3VeQVX4G", @"银行账号")
                                                                        placeholder:TNLocalizedString(@"QIndNZKy", @"请填写银行账号")
                                                                          rightText:nil
                                                                   rightPlaceholder:nil];
        _bankAccountItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _bankAccountItemView.itemTextDidChangeCallBack = ^(NSString *_Nonnull text) {
            @HDStrongify(self);
            self.bindRequestModel.account = text;
            //按钮是否可以点击
            [self checkConfirmBtnEnable];
        };
        _bankAccountItemView.hidden = YES;
    }
    return _bankAccountItemView;
}
- (TNWithdrawBindItemView *)bankAccountNameItemView {
    if (!_bankAccountNameItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_DoubleInput text:nil title:TNLocalizedString(@"mJzP2nCp", @"开户名")
                                                                        placeholder:TNLocalizedString(@"RYq526RH", @"名字")
                                                                          rightText:nil
                                                                   rightPlaceholder:TNLocalizedString(@"QccMJkwF", @"姓")];
        _bankAccountNameItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _bankAccountNameItemView.itemTextDidChangeCallBack = ^(NSString *_Nonnull text) {
            @HDStrongify(self);
            self.firstName = text;
            //按钮是否可以点击
            [self checkConfirmBtnEnable];
        };
        _bankAccountNameItemView.itemRightTextDidChangeCallBack = ^(NSString *_Nonnull text) {
            @HDStrongify(self);
            self.lastName = text;
            //按钮是否可以点击
            [self checkConfirmBtnEnable];
        };
        _bankAccountNameItemView.hidden = YES;
    }
    return _bankAccountNameItemView;
}
- (TNWithdrawBindItemView *)payAccountItemView {
    if (!_payAccountItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_Input text:nil title:TNLocalizedString(@"lcFUhF8n", @"支付账号")
                                                                        placeholder:TNLocalizedString(@"g1fQaiVM", @"请填写支付账号")
                                                                          rightText:nil
                                                                   rightPlaceholder:nil];
        _payAccountItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _payAccountItemView.itemTextDidChangeCallBack = ^(NSString *_Nonnull text) {
            @HDStrongify(self);
            self.bindRequestModel.account = text;
            //按钮是否可以点击
            [self checkConfirmBtnEnable];
        };
        _payAccountItemView.hidden = YES;
    }
    return _payAccountItemView;
}
- (TNWithdrawBindItemView *)payAccountNameItemView {
    if (!_payAccountNameItemView) {
        TNWithdrawBindItemConfig *config = [TNWithdrawBindItemConfig configWithType:TNWithdrawBindItemViewType_Input text:nil title:TNLocalizedString(@"2AysvA4L", @"账户名称")
                                                                        placeholder:TNLocalizedString(@"o3CU6pLB", @"请填写支付账户名称")
                                                                          rightText:nil
                                                                   rightPlaceholder:nil];
        _payAccountNameItemView = [TNWithdrawBindItemView itemViewWithConfig:config];
        @HDWeakify(self);
        _payAccountNameItemView.itemTextDidChangeCallBack = ^(NSString *_Nonnull text) {
            @HDStrongify(self);
            self.bindRequestModel.accountHolder = text;
            //按钮是否可以点击
            [self checkConfirmBtnEnable];
        };
        _payAccountNameItemView.hidden = YES;
    }
    return _payAccountNameItemView;
}

/** @lazy bindDto */
- (TNWithdrawBindDTO *)bindDto {
    if (!_bindDto) {
        _bindDto = [[TNWithdrawBindDTO alloc] init];
    }
    return _bindDto;
}

/** @lazy bindRequestModel */
- (TNWithdrawBindRequestModel *)bindRequestModel {
    if (!_bindRequestModel) {
        _bindRequestModel = [[TNWithdrawBindRequestModel alloc] init];
        _bindRequestModel.amount = self.amount;
    }
    return _bindRequestModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PNMSStoreOperatorAddOrEditView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorAddOrEditView.h"
#import "PNInfoSwitchView.h"
#import "PNInfoView.h"
#import "PNInputItemView.h"
#import "PNMSStoreManagerViewModel.h"
#import "PNMSStoreOperatorInfoModel.h"
#import "PNMSStoreOperatorRoleView.h"


@interface PNMSStoreOperatorAddOrEditView () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@property (nonatomic, strong) PNInfoView *storeNameInfoView;
@property (nonatomic, strong) PNInputItemView *accountInputView;
@property (nonatomic, strong) PNInputItemView *nameInputView;
@property (nonatomic, strong) PNInfoSwitchView *storePower;
@property (nonatomic, strong) PNMSStoreOperatorRoleView *roleView;
@property (nonatomic, strong) PNOperationButton *saveBtn;
@end


@implementation PNMSStoreOperatorAddOrEditView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.storeNameInfoView];
    [self.scrollViewContainer addSubview:self.roleView];
    [self.scrollViewContainer addSubview:self.accountInputView];
    [self.scrollViewContainer addSubview:self.nameInputView];
    [self.scrollViewContainer addSubview:self.storePower];

    [self addSubview:self.saveBtn];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.storeOperatorInfoModel)) {
            PNMSStoreOperatorInfoModel *model = self.viewModel.storeOperatorInfoModel;
            self.storeNameInfoView.model.valueText = model.storeName;

            [self.storeNameInfoView setNeedsUpdateContent];

            NSString *mobileStr = model.operatorMobile;
            mobileStr = [mobileStr stringByReplacingOccurrencesOfString:@"8550" withString:@""];
            self.accountInputView.model.value = mobileStr;
            if (WJIsStringEmpty(model.storeOperatorId)) {
                self.accountInputView.model.enabled = YES;
            } else {
                self.accountInputView.model.enabled = NO;
            }
            [self.accountInputView update];

            self.nameInputView.model.value = model.userName;
            [self.nameInputView update];

            if (VipayUser.shareInstance.role == PNMSRoleType_STORE_MANAGER) {
                if (model.role == PNMSRoleType_STORE_MANAGER) {
                    self.roleView.showDataArray = @[@(PNMSRoleType_STORE_MANAGER)];
                }

                if (model.role == PNMSRoleType_STORE_STAFF) {
                    self.roleView.showDataArray = @[@(PNMSRoleType_STORE_STAFF)];
                }

                self.roleView.userInteractionEnabled = self.viewModel.canEidt;
            } else {
                self.roleView.showDataArray = @[@(PNMSRoleType_STORE_MANAGER), @(PNMSRoleType_STORE_STAFF)];
                self.roleView.userInteractionEnabled = YES;
            }
            self.roleView.role = model.role;

            if (model.role == PNMSRoleType_STORE_MANAGER) {
                self.storePower.model.switchValue = YES;
                model.storeDataQueryPower = YES;
                self.storePower.model.enable = NO;
                [self.storePower update];
            } else {
                self.storePower.model.enable = YES;

                if (WJIsStringNotEmpty(model.storeOperatorId)) {
                    if ([model.permissionList containsObject:@(PNMSPermissionType_STORE_DATA_QUERY)]) {
                        self.storePower.model.switchValue = YES;
                    } else {
                        self.storePower.model.switchValue = NO;
                    }
                    self.storePower.model.enable = self.viewModel.canEidt;
                    [self.storePower update];
                }

                [self.storePower update];
            }

            [self ruleLimit];
        }
    }];

    if (WJIsStringNotEmpty(self.viewModel.storeOperatorId)) {
        [self.viewModel getStoreOperatorDetail];
    } else {
        ///新增
        if (VipayUser.shareInstance.role == PNMSRoleType_STORE_MANAGER) {
            self.roleView.showDataArray = @[@(PNMSRoleType_STORE_STAFF)];
        } else {
            self.roleView.showDataArray = @[@(PNMSRoleType_STORE_MANAGER), @(PNMSRoleType_STORE_STAFF)];
        }
    }
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        if (self.viewModel.canEidt) {
            make.bottom.equalTo(self.saveBtn.mas_top);
        } else {
            make.bottom.equalTo(self);
        }
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.storeNameInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
    }];

    [self.roleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.storeNameInfoView.mas_bottom);
    }];

    [self.accountInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.roleView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(82)));
    }];

    [self.nameInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountInputView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(52)));
    }];

    [self.storePower mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameInputView.mas_bottom).offset(kRealWidth(8));
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.mas_equalTo(self.scrollViewContainer);
    }];

    if (self.viewModel.canEidt) {
        [self.saveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(20));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    self.viewModel.storeOperatorInfoModel.operatorMobile = self.accountInputView.model.value;
    if (WJIsStringNotEmpty(self.viewModel.storeOperatorInfoModel.operatorMobile) && self.viewModel.isSuccess && self.viewModel.storeOperatorInfoModel.role > 0) {
        self.saveBtn.enabled = YES;
    } else {
        self.saveBtn.enabled = NO;
    }
}

#pragma mark PNInputItemViewDelegate
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)pn_textFieldShouldEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
    return YES;
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField view:(nonnull PNInputItemView *)view {
    [self ruleLimit];
}

- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(nonnull PNInputItemView *)view {
    self.viewModel.isSuccess = NO;
    [self ruleLimit];
    if (WJIsStringNotEmpty(self.accountInputView.model.value)) {
        [self.viewModel getCoolCashAccountName];
    }
}

#pragma mark
- (PNMSStoreOperatorRoleView *)roleView {
    if (!_roleView) {
        _roleView = [[PNMSStoreOperatorRoleView alloc] init];
        //        _roleView.role = self.viewModel.storeOperatorInfoModel.role;
        @HDWeakify(self);
        _roleView.selectBlock = ^(PNMSRoleType role) {
            @HDStrongify(self);
            self.viewModel.storeOperatorInfoModel.role = role;

            if (role == PNMSRoleType_STORE_MANAGER) {
                self.storePower.model.switchValue = YES;
                self.viewModel.storeOperatorInfoModel.storeDataQueryPower = YES;
                self.storePower.model.enable = NO;
                [self.storePower update];
            } else {
                self.storePower.model.switchValue = NO;
                self.viewModel.storeOperatorInfoModel.storeDataQueryPower = NO;
                self.storePower.model.enable = YES;
                [self.storePower update];
            }
            [self ruleLimit];
        };
    }
    return _roleView;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.keyFont = HDAppTheme.PayNowFont.standard14B;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.rightButtonaAlignKey = YES;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(12), kRealWidth(16));
    return model;
}

- (PNInfoView *)storeNameInfoView {
    if (!_storeNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_name", @"门店名称")];
        model.valueText = self.viewModel.storeOperatorInfoModel.storeName;
        view.model = model;
        _storeNameInfoView = view;
    }
    return _storeNameInfoView;
}

- (PNInputItemView *)accountInputView {
    if (!_accountInputView) {
        _accountInputView = [[PNInputItemView alloc] init];
        _accountInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.title = PNLocalizedString(@"pn_coolcash_wallet", @"CoolCash钱包账号");
        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.bottomLineHeight = PixelOne;
        model.style = PNInputStypeRow_Two;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        model.leftLabelString = @"8550";
        model.valueAlignment = NSTextAlignmentLeft;
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.enabled = WJIsStringEmpty(self.viewModel.storeOperatorInfoModel.accountNo) ? YES : NO;

        _accountInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];

        kb.inputSource = _accountInputView.textFiled;
        _accountInputView.textFiled.inputView = kb;
    }
    return _accountInputView;
}

- (PNInputItemView *)nameInputView {
    if (!_nameInputView) {
        _nameInputView = [[PNInputItemView alloc] init];
        _nameInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];
        model.titleFont = HDAppTheme.PayNowFont.standard14B;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.title = PNLocalizedString(@"pn_full_name_2", @"姓名");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.fixWhenInputSpace = YES;
        model.isUppercaseString = YES;
        model.canInputMoreSpace = NO;
        model.bottomLineHeight = 0;
        model.enabled = NO;
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        _nameInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable theme:theme];

        kb.inputSource = _nameInputView.textFiled;
        _nameInputView.textFiled.inputView = kb;
    }
    return _nameInputView;
}

- (PNInfoSwitchModel *)defaultSwitchModel:(NSString *)title subTitle:(NSString *)subTitle {
    PNInfoSwitchModel *model = [[PNInfoSwitchModel alloc] init];
    model.title = title;
    model.subTitle = subTitle;
    return model;
}

- (PNInfoSwitchView *)storePower {
    if (!_storePower) {
        PNInfoSwitchView *sv = [[PNInfoSwitchView alloc] init];
        PNInfoSwitchModel *model = [self defaultSwitchModel:PNLocalizedString(@"pn_Store_data_query_permission", @"门店数据查询权限")
                                                   subTitle:PNLocalizedString(@"pn_Open_to_check_store_receiving_data", @"启用后可以查询本门店的收款数据")];
        model.switchValue = NO;
        model.valueBlock = ^(BOOL switchValue) {
            self.viewModel.storeOperatorInfoModel.storeDataQueryPower = switchValue;
        };
        sv.model = model;

        _storePower = sv;
    }
    return _storePower;
}

- (PNOperationButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _saveBtn.enabled = NO;
        [_saveBtn setTitle:PNLocalizedString(@"5nm3J7mD", @"保存") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_saveBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewModel saveOrUpdateStoreOperator];
        }];
    }
    return _saveBtn;
}
@end

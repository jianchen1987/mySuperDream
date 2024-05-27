//
//  TransAccountVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTransAccountViewController.h"
#import "HDPayeeInfoModel.h"
#import "PNTransAmountViewController.h"
#import "PNTransListDTO.h"


@interface PNTransAccountViewController () <HDUITextFieldDelegate>
@property (nonatomic, strong) SALabel *titleLB;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HDUITextField *inputTF;
@property (nonatomic, strong) SALabel *tipLB;
@property (nonatomic, strong) SAOperationButton *nextBtn;
@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) PNTransListDTO *transDTO;

//银行
@property (nonatomic, strong) UIImageView *bankImg;
@property (nonatomic, strong) SALabel *bankLB;
@end


@implementation PNTransAccountViewController
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.bankImg];
    [self.view addSubview:self.bankLB];
    [self.view addSubview:self.titleLB];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.inputTF];
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.nextBtn];
}

- (BOOL)hd_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 0) {
        self.nextBtn.enabled = YES;
    }
    return YES;
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    //    [self getAcountInfo];
}

- (void)getAcountInfo {
    NSString *payeeNo = nil;
    if (![[self.inputTF.validInputText substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        payeeNo = [NSString stringWithFormat:@"8550%@", self.inputTF.validInputText]; //补零
    } else {
        payeeNo = [NSString stringWithFormat:@"855%@", self.inputTF.validInputText];
    }

    [self showloading];
    @HDWeakify(self);

    if (self.pageType == PNTradeSubTradeTypeToBakong) {
        NSDictionary *dic = @{@"payeeMp": self.inputTF.validInputText, @"retry_forbidden": @"true"};

        [self.transDTO getPayeeInfo:dic bizType:PNTransferTypePersonalToBaKong success:^(HDPayeeInfoModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];
            HDPayeeInfoModel *payeeInfo = rspModel;
            if ([payeeInfo.frozen isEqualToString:@"true"]) {
                [NAT showAlertWithMessage:PNLocalizedString(@"account_is_blocked", @"该账户被冻结！") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismissCompletion:nil];
                                  }];
            } else {
                PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
                vc.pageType = self.pageType;
                payeeInfo.payeeLoginName = payeeInfo.phone;
                vc.payeeInfo = payeeInfo;
                vc.payeeBankName = payeeInfo.bankName.length > 0 ? payeeInfo.bankName : @"Bakong";
                [SAWindowManager navigateToViewController:vc parameters:@{}];
            }
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    } else {
        NSDictionary *dic = @{@"payeeMobile": payeeNo};

        [self.transDTO getPayeeInfo:dic bizType:PNTransferTypeToCoolcash success:^(HDPayeeInfoModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];
            HDPayeeInfoModel *payeeInfo = rspModel;
            PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
            payeeInfo.payeeLoginName = payeeNo;
            vc.pageType = self.pageType;
            vc.payeeInfo = payeeInfo;
            [SAWindowManager navigateToViewController:vc parameters:@{}];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.bankImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealHeight(10));
        make.left.right.equalTo(self.view).offset(kRealWidth(15));
    }];
    [self.bankLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankImg);
        make.left.equalTo(self.bankImg.mas_right).offset(kRealWidth(8));
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankImg.mas_bottom).offset(kRealHeight(20));
        make.left.right.equalTo(self.view).offset(kRealWidth(15));
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(10));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.inputTF.mas_bottom).offset(20);
    }];
    [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(kRealHeight(10));
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealHeight(50));
    }];
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
    }];
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealHeight(50));
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealHeight(50));
    }];
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
    HDUITextFieldConfig *config = [self.inputTF getCurrentConfig];
    if (_pageType == PNTradeSubTradeTypeToBakong) {
        self.boldTitle = PNLocalizedString(@"view_title_transfer_input_bakong", @"输入bakong账号");
        config.placeholder = PNLocalizedString(@"Enter_phone_number", @"请输入手机号或账户ID");
        config.leftLabelString = @"";
        config.maxInputLength = 100;
        config.keyboardType = UIKeyboardTypeDefault;
        __weak __typeof(self) weakSelf = self;
        self.inputTF.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ruleLimit];
        };
    } else {
        self.boldTitle = PNLocalizedString(@"view_title_transfer_input_acc", @"输入CoolCash账号");
        config.placeholder = PNLocalizedString(@"TF_PLACEHOLDER_INPUT_PHOTO_NUMBER", @"请输入手机号码");
        config.leftLabelString = @"+855(0)";
        config.maxInputLength = 9;
        config.shouldSeparatedTextWithSymbol = YES;
        config.separatedFormat = @"xx-xxx-xxxx";
        config.characterSetString = kCharacterSetStringNumber;
        __weak __typeof(self) weakSelf = self;
        self.inputTF.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (text.length <= 1) {
                if ([text hasPrefix:@"0"]) {
                    [strongSelf.inputTF updateConfigWithDict:@{@"separatedFormat": @"xxx-xxx-xxxx", @"maxInputLength": @10}];
                } else {
                    [strongSelf.inputTF updateConfigWithDict:@{@"separatedFormat": @"xx-xxx-xxxx", @"maxInputLength": @9}];
                }
            }
            [strongSelf ruleLimit];
        };
    }

    [self.inputTF setConfig:config];
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

- (void)nextTap {
    [self getAcountInfo];
}

#pragma mark - 按钮点亮限制
- (void)ruleLimit {
    if (WJIsStringNotEmpty(self.inputTF.validInputText)) {
        [self.nextBtn setEnabled:YES];
    } else {
        [self.nextBtn setEnabled:NO];
    }
}

#pragma mark
- (SALabel *)titleLB {
    if (!_titleLB) {
        _titleLB = SALabel.new;
        _titleLB.text = PNLocalizedString(@"Opposite_account", @"");
        _titleLB.font = [HDAppTheme.font forSize:14];
        ;
        _titleLB.textColor = HDAppTheme.PayNowColor.c9599A2;
    }
    return _titleLB;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (HDUITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"phone_number", @"") leftLabelString:@""];
        HDUITextFieldConfig *config = [_inputTF getCurrentConfig];
        config.leftLabelString = @"+855(0)";
        config.floatingText = @"";
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.font = HDAppTheme.font.standard2;
        config.textColor = HDAppTheme.color.G1;
        config.bottomLineNormalHeight = 0;
        config.placeholderFont = [HDAppTheme.font boldForSize:17];
        config.placeholderColor = HDAppTheme.PayNowColor.placeholderColor;
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.leftLabelFont = [HDAppTheme.font boldForSize:18];
        [_inputTF setConfig:config];
        __weak __typeof(self) weakSelf = self;
        _inputTF.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ruleLimit];
        };
    }
    return _inputTF;
}

- (SALabel *)tipLB {
    if (!_tipLB) {
        _tipLB = SALabel.new;
        _tipLB.text = PNLocalizedString(@"Please_check_account", @"");
        _tipLB.font = [HDAppTheme.font forSize:12];
        _tipLB.numberOfLines = 0;
        _tipLB.textColor = HDAppTheme.PayNowColor.c9599A2;
    }
    return _tipLB;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:PNLocalizedString(@"confirm_next", @"下一步") forState:UIControlStateNormal];
        button.enabled = NO;
        button.titleLabel.font = [HDAppTheme.font boldForSize:15];
        [button addTarget:self action:@selector(nextTap) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn = button;
    }
    return _nextBtn;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"Limit_description", @"") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowWalletLimitVC:@{}];
        }];
        _navBtn = button;
    }
    return _navBtn;
}

- (UIImageView *)bankImg {
    if (!_bankImg) {
        _bankImg = UIImageView.new;
    }
    return _bankImg;
}

- (SALabel *)bankLB {
    if (!_bankLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:15];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        _bankLB = label;
    }
    return _bankLB;
}

- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}
@end

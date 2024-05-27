//
//  bankCardInputVC.m
//  ViPay
//
//  Created by Quin on 2021/8/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNBankCardInputViewController.h"
#import "HDAppTheme.h"
#import "HDPayeeInfoModel.h"
#import "PNTransAmountViewController.h"
#import "PNTransListDTO.h"
#import "SAAppEnvManager.h"
#import "SAOperationButton.h"
#import "SATalkingData.h"
#import <HDVendorKit/HDWebImageManager.h>
#import <Masonry/Masonry.h>


@interface PNBankCardInputViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) UIView *lineview1;
@property (nonatomic, strong) UIImageView *iconImageView; ///< 图标
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *accountTitleLabel;
@property (nonatomic, strong) UITextField *accountTextField;

@property (nonatomic, strong) SAOperationButton *nextStepBT;
@property (nonatomic, strong) HDPayeeInfoModel *payeeInfo;
@property (nonatomic, strong) PNTransListDTO *transferDTO;
@end


@implementation PNBankCardInputViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"acleda_number_card_title_account", @"输入银行账号");
}

- (void)hd_setupViews {
    [SATalkingData trackEvent:@"转账_输入账号_进入"];
    [SATalkingData trackEventDurationStart:@"转账_输入账号_时长"];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.bankNameLabel];
    [self.view addSubview:self.lineview];
    [self.view addSubview:self.lineview1];
    [self.view addSubview:self.accountTitleLabel];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.nextStepBT];

    [self.view setNeedsUpdateConstraints];

    NSString *logoURLStr = [NSString stringWithFormat:@"%@/files/files/app/%@", SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer, _model.logo];
    HDLog(@"%@", logoURLStr);
    [HDWebImageManager setImageWithURL:logoURLStr placeholderImage:[UIImage imageNamed:@"toBank1"] imageView:self.iconImageView];

    _bankNameLabel.text = _model.bin;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.accountTextField becomeFirstResponder];
    });
}

- (void)updateViewConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealHeight(60));
        make.left.mas_equalTo(kRealWidth(15));
        make.width.height.mas_equalTo(kRealWidth(35));
    }];

    [self.bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(0);
        make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(15));
    }];

    [self.lineview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(1);
    }];

    [self.accountTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineview.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.iconImageView.mas_left).offset(0);
    }];

    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTitleLabel.mas_bottom).offset(kRealWidth(20));
        make.left.mas_equalTo(kRealWidth(40));
        make.right.mas_equalTo(-kRealWidth(40));
        make.height.mas_equalTo(kRealWidth(50));
    }];

    [self.lineview1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
        make.height.mas_equalTo(PixelOne);
    }];

    [self.nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).offset(-2 * kRealWidth(25));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kRealWidth(45));
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [super updateViewConstraints];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.nextStepBT.enabled = YES;
    } else {
        self.nextStepBT.enabled = NO;
    }
}

#pragma mark - event response
- (void)clickedNextBtn {
    [SATalkingData trackEventDurationEnd:@"转账_输入账号_时长"];

    NSDictionary *dict = @{@"bankAccount": self.accountTextField.text ?: @"", @"bankCode": self.model.participantCode ?: @""};

    [self showloading];
    @HDWeakify(self);
    [self.transferDTO getPayeeInfo:dict bizType:PNTransferTypePersonalToBank success:^(HDPayeeInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        HDPayeeInfoModel *payeeInfo = rspModel;
        PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
        vc.pageType = PNTradeSubTradeTypeToBank;
        vc.payeeBankName = self.model.bin; //银行名称
        vc.logo = self.model.logo;
        payeeInfo.participantCode = self.model.participantCode;
        payeeInfo.payeeLoginName = payeeInfo.account;
        vc.payeeInfo = payeeInfo;
        [SAWindowManager navigateToViewController:vc parameters:@{}];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)bankNameLabel {
    if (!_bankNameLabel) {
        _bankNameLabel = UILabel.new;
    }
    return _bankNameLabel;
}

- (UIView *)lineview {
    if (!_lineview) {
        _lineview = UIView.new;
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineview;
}

- (UIView *)lineview1 {
    if (!_lineview1) {
        _lineview1 = UIView.new;
        _lineview1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineview1;
}

- (UILabel *)accountTitleLabel {
    if (!_accountTitleLabel) {
        _accountTitleLabel = UILabel.new;
        _accountTitleLabel.font = [HDAppTheme.font standard3];
        _accountTitleLabel.textColor = [HDAppTheme.color G1];
        _accountTitleLabel.text = PNLocalizedString(@"Receiver_account_number", @"收款人账号");
    }
    return _accountTitleLabel;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = UITextField.new;
        _accountTextField.delegate = self;
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        _accountTextField.placeholder = PNLocalizedString(@"Enter_receiver_account_number", @"输入收款人账号");
    }
    return _accountTextField;
}

- (SAOperationButton *)nextStepBT {
    if (!_nextStepBT) {
        _nextStepBT = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextStepBT setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:UIControlStateNormal];
        [_nextStepBT addTarget:self action:@selector(clickedNextBtn) forControlEvents:UIControlEventTouchUpInside];
        _nextStepBT.normalBackgroundColor = [UIColor hd_colorWithHexString:@"#FD7127"];
        _nextStepBT.disableBackgroundColor = [UIColor hd_colorWithHexString:@"#EFB795"];
        _nextStepBT.enabled = NO;
    }
    return _nextStepBT;
}

- (PNTransListDTO *)transferDTO {
    if (!_transferDTO) {
        _transferDTO = [[PNTransListDTO alloc] init];
    }
    return _transferDTO;
}
@end

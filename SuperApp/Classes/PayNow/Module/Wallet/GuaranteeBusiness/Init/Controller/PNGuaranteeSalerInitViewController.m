//
//  PNGuaranteeSalerInitViewController.m
//  SuperApp
//  我是卖方
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuaranteeSalerInitViewController.h"
#import "NSMutableAttributedString+Highlight.h"
#import "NSString+HD_Util.h"
#import "NSString+matchs.h"
#import "PNBottomView.h"
#import "PNGuarateenBuildModel.h"
#import "PNGuarateenDetailModel.h"
#import "PNGuarateenInitDTO.h"
#import "PNGuarateenShareManager.h"
#import "PNGuarateenUploadImageViewController.h"
#import "PNInfoView.h"
#import "PNInputItemView.h"
#import "PNInputTextView.h"
#import "PNSingleSelectedAlertView.h"
#import "SASocialShareView.h"


@interface PNGuaranteeSalerInitViewController () <PNInputItemViewDelegate>
@property (nonatomic, strong) PNInfoView *currencyInfoView;
@property (nonatomic, strong) PNInputItemView *amountInputView;
@property (nonatomic, strong) PNInputTextView *inputTextView;
@property (nonatomic, strong) PNInfoView *enclosureInfoView;
@property (nonatomic, strong) PNBottomView *bottomView;
@property (nonatomic, strong) HDUIButton *agreementBtn;
@property (nonatomic, strong) YYLabel *agreementLabel;
@property (nonatomic, strong) PNGuarateenInitDTO *buildDTO;
@property (nonatomic, strong) PNGuarateenBuildModel *buildModel;

@property (nonatomic, copy) PNCurrencyType currency;
@end


@implementation PNGuaranteeSalerInitViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.currency = PNCurrencyTypeUSD;
        self.buildModel = [[PNGuarateenBuildModel alloc] init];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"aEvpZcFf", @"发起交易");
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.currencyInfoView];
    [self.scrollViewContainer addSubview:self.amountInputView];
    [self.scrollViewContainer addSubview:self.inputTextView];
    [self.scrollViewContainer addSubview:self.enclosureInfoView];

    [self.view addSubview:self.agreementBtn];
    [self.view addSubview:self.agreementLabel];

    [self.view addSubview:self.bottomView];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.agreementBtn.mas_top);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.agreementBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.agreementBtn.imageView.image.size);
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.agreementLabel.mas_top).offset(-kRealWidth(3));
    }];

    [self.agreementLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreementBtn.mas_right).offset(kRealWidth(4));
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-kRealWidth(8));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];

    [self.currencyInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(8));
    }];

    [self.amountInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.currencyInfoView.mas_bottom);
    }];

    [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.amountInputView.mas_bottom);
    }];

    [self.enclosureInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.inputTextView.mas_bottom);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view {
    [self ruleLimit];
}

#pragma mark
- (void)buildOrder {
    [self showloading];

    self.buildModel.body = self.inputTextView.currentText;
    self.buildModel.amt = self.amountInputView.model.value;
    self.buildModel.cy = self.currency;

    self.buildModel.originator = 11;
    self.buildModel.userMobile = VipayUser.shareInstance.loginName;
    self.buildModel.userName = [NSString stringWithFormat:@"%@ %@", VipayUser.shareInstance.lastName ?: @"", VipayUser.shareInstance.firstName ?: @""];
    self.buildModel.action = @"BUILD";

    NSDictionary *dict = [self.buildModel yy_modelToJSONObject];

    @HDWeakify(self);
    [self.buildDTO buildOrder:dict success:^(PNGuarateenDetailModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        [[HDMediator sharedInstance] navigaveToPayNowGuaranteenRecordDetailVC:@{
            @"orderNo": rspModel.orderNo,
        }];

        [PNGuarateenShareManager.sharedInstance shareGuarateenWithModel:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (void)ruleLimit {
    NSString *amountStr = self.amountInputView.model.value;
    if (self.agreementBtn.selected && WJIsStringNotEmpty(amountStr) && [self checkAmount:amountStr] && [amountStr matches:REGEX_AMOUNT] && WJIsStringNotEmpty(self.inputTextView.currentText)) {
        [self.bottomView setBtnEnable:YES];
    } else {
        [self.bottomView setBtnEnable:NO];
    }
}

- (BOOL)checkAmount:(NSString *)amountStr {
    /// USD 0.01 - 999999.99
    double amount = amountStr.doubleValue;
    if (amount <= 0) {
        return NO;
    } else {
        if ([self.currency isEqualToString:PNCurrencyTypeUSD]) {
            if (amount >= 0.01 && amount <= 999999.99) {
                return YES;
            }
        } else if ([self.currency isEqualToString:PNCurrencyTypeKHR]) {
            if (amount >= 0.01 && amount <= 999999999) {
                return YES;
            }
        }
        return NO;
    }
}

#pragma mark
- (void)handleCurrency {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = PNCurrencyTypeUSD;
    model.itemId = PNCurrencyTypeUSD;
    if ([self.currency isEqualToString:PNCurrencyTypeUSD]) {
        model.isSelected = YES;
    }

    PNSingleSelectedModel *model2 = [[PNSingleSelectedModel alloc] init];
    model2.name = PNCurrencyTypeKHR;
    model2.itemId = PNCurrencyTypeKHR;
    if ([self.currency isEqualToString:PNCurrencyTypeKHR]) {
        model2.isSelected = YES;
    }

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:@[model, model2] title:PNLocalizedString(@"select_currency", @"币种")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        self.currency = model.itemId;
        self.currencyInfoView.model.valueText = self.currency;
        [self.currencyInfoView setNeedsUpdateContent];

        self.amountInputView.model.value = @"";
        [self.amountInputView update];
        [self ruleLimit];

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        HDKeyBoard *kb;
        theme.enterpriseText = @"";
        if (self.currency == PNCurrencyTypeKHR) {
            kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];
        } else {
            kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];
        }

        kb.inputSource = self.amountInputView.textFiled;
        self.amountInputView.textFiled.inputView = kb;
    };
    [alertView show];
}

- (void)uploadImage {
    void (^completion)(NSArray *) = ^(NSArray *imageUrls) {
        PNGuarateenAttachmentModel *model = [PNGuarateenAttachmentModel alloc];
        model.images = imageUrls;
        self.buildModel.attachment = model;
        if (WJIsArrayEmpty(self.buildModel.attachment.images)) {
            self.enclosureInfoView.model.valueText = PNLocalizedString(@"GufDlQOK", @"未上传");
        } else {
            self.enclosureInfoView.model.valueText = PNLocalizedString(@"Uploaded", @"已上传");
        }
        [self.enclosureInfoView setNeedsUpdateContent];
    };

    PNGuarateenUploadImageViewController *vc = [[PNGuarateenUploadImageViewController alloc] initWithRouteParameters:@{
        @"imageURLs": self.buildModel.attachment.images,
        @"completion": completion,
    }];
    [SAWindowManager navigateToViewController:vc];
}

#pragma mark
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.keyFont = HDAppTheme.PayNowFont.standard14M;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.lineWidth = 1;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.valueNumbersOfLines = 0;
    model.enableTapRecognizer = YES;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
    return model;
}

- (NSMutableAttributedString *)setTitleHighLight:(NSString *)title {
    NSString *higStr = @"*";
    NSString *allStr = [NSString stringWithFormat:@"%@%@", higStr, title];
    return [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14M highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                              norFont:HDAppTheme.PayNowFont.standard14M
                                             norColor:HDAppTheme.PayNowColor.c333333];
}

- (PNInfoView *)currencyInfoView {
    if (!_currencyInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:@""];
        model.valueText = PNCurrencyTypeUSD;

        model.attrKey = [self setTitleHighLight:PNLocalizedString(@"select_currency", @"币种")];

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handleCurrency];
        };

        view.model = model;
        _currencyInfoView = view;
    }
    return _currencyInfoView;
}

- (PNInputItemView *)amountInputView {
    if (!_amountInputView) {
        _amountInputView = [[PNInputItemView alloc] init];
        _amountInputView.delegate = self;
        PNInputItemModel *model = [[PNInputItemModel alloc] init];

        model.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        model.keyboardType = UIKeyboardTypeASCIICapable;
        model.bottomLineHeight = PixelOne;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        model.valueFont = HDAppTheme.PayNowFont.standard14;
        model.valueColor = HDAppTheme.PayNowColor.c333333;

        model.attributedTitle = [self setTitleHighLight:PNLocalizedString(@"kwCIcL1x", @"金额")];

        _amountInputView.model = model;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _amountInputView.textFiled;
        _amountInputView.textFiled.inputView = kb;
    }
    return _amountInputView;
}

- (PNInputTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[PNInputTextView alloc] init];

        @HDWeakify(self);
        _inputTextView.textViewDidChangeBlock = ^(NSString *_Nonnull inputText) {
            @HDStrongify(self);
            [self ruleLimit];
        };
    }
    return _inputTextView;
}

- (PNInfoView *)enclosureInfoView {
    if (!_enclosureInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"iU6StRW0", @"附件")];
        model.valueText = PNLocalizedString(@"GufDlQOK", @"未上传");

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self uploadImage];
        };

        view.model = model;
        _enclosureInfoView = view;
    }
    return _enclosureInfoView;
}

- (PNBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PNBottomView alloc] initWithTitle:PNLocalizedString(@"8zF0Ua7I", @"确认发起交易并分享")];
        [_bottomView setBtnEnable:NO];

        @HDWeakify(self);
        _bottomView.btnClickBlock = ^{
            @HDStrongify(self);
            [self buildOrder];
        };
    }
    return _bottomView;
}

- (HDUIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[HDUIButton alloc] init];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_unselect"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_selected"] forState:UIControlStateSelected];
        @HDWeakify(self);
        [_agreementBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            [self ruleLimit];
        }];
    }
    return _agreementBtn;
}

- (YYLabel *)agreementLabel {
    if (!_agreementLabel) {
        _agreementLabel = [[YYLabel alloc] init];
        _agreementLabel.font = [HDAppTheme.PayNowFont fontMedium:12];
        _agreementLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(12) - kRealWidth(12) - kRealWidth(5) - kRealWidth(self.agreementBtn.imageView.image.size.width);
        [self setProtocolText];
    }
    return _agreementLabel;
}

//设置协议文本
- (void)setProtocolText {
    NSString *h1 = PNLocalizedString(@"Bq9M3FIV", @"担保交易协议");
    NSString *postStr = [NSString stringWithFormat:@"%@", PNLocalizedString(@"L6ddPIex", @"本人已阅读并同意")];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:postStr];
    NSMutableAttributedString *highlightText = [[NSMutableAttributedString alloc] initWithString:h1];
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:[UIColor hd_colorWithHexString:@"#0A84FF"] backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
                                      vc.url = kGuarateen_url;
                                      [SAWindowManager navigateToViewController:vc parameters:@{}];
                                  }];

    [text appendAttributedString:highlightText];

    self.agreementLabel.attributedText = text;
    [self.agreementLabel sizeToFit];
}

- (PNGuarateenInitDTO *)buildDTO {
    if (!_buildDTO) {
        _buildDTO = [[PNGuarateenInitDTO alloc] init];
    }
    return _buildDTO;
}

@end

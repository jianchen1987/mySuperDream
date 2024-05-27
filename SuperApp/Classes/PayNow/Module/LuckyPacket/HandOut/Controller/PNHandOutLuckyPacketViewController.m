//
//  PNHandOutLuckyPacketViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNHandOutLuckyPacketViewController.h"
#import "PNHandOutViewModel.h"
#import "PNNorPacketView.h"
#import "PNPacketPayPasswordAlertView.h"
#import "PNPwdPacketView.h"
#import "PNRspModel.h"
#import "PayHDPaymentProcessingHUD.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAShareWebpageObject.h"
#import "SATelegramShareManager.h"


@interface PNHandOutLuckyPacketViewController () <PNPacketPayPasswordAlertViewDelegate>
@property (nonatomic, strong) UIImageView *imageBgView;
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) PNNorPacketView *norContentView;
@property (nonatomic, strong) PNPwdPacketView *pwdContentView;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) PayHDPaymentProcessingHUD *processingHUD; ///< 付款中 HUD
@end


@implementation PNHandOutLuckyPacketViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.model = [[PNHandOutModel alloc] init];
        self.viewModel.model.cy = PNCurrencyTypeKHR;

        /// 10 普通红包  11 口令红包
        self.viewModel.currentPacketType = [[self.parameters objectForKey:@"type"] integerValue];
        self.viewModel.model.packetType = self.viewModel.currentPacketType;
        self.viewModel.model.grantObject = PNPacketGrantObject_Non;
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_send_red_packet", @"发红包");
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.imageBgView];
    [self.view addSubview:self.norContentView];
    [self.view addSubview:self.pwdContentView];
    [self.view addSubview:self.tipsLabel];

    [self setShowView];
}

- (void)setShowView {
    if (self.viewModel.currentPacketType == PNPacketType_Password) {
        self.pwdContentView.hidden = NO;
        self.norContentView.hidden = YES;
    } else {
        self.pwdContentView.hidden = YES;
        self.norContentView.hidden = NO;
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    [self.KVOController hd_observe:self.viewModel keyPath:@"currentPacketType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self setShowView];
    }];

    [self.viewModel getData];
}

- (void)updateViewConstraints {
    [self.imageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.size.mas_equalTo(self.imageBgView.image.size);
    }];

    if (!self.norContentView.hidden) {
        [self.norContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(self.tipsLabel.mas_top).offset(-kRealWidth(8));
        }];
    }

    if (!self.pwdContentView.hidden) {
        [self.pwdContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(self.tipsLabel.mas_top).offset(-kRealWidth(8));
        }];
    }

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kRealWidth(16));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)orderBuild {
    self.viewModel.packetId = @"";

    [self.viewModel orderBuildLuckyPacket:^(PNPacketBuildRspModel *_Nonnull rspModel, PNCashToolsRspModel *_Nonnull cashToolsModel) {
        self.viewModel.packetId = rspModel.packetId;
        PNPacketPayPasswordAlertViewModel *model = [[PNPacketPayPasswordAlertViewModel alloc] init];
        PNPacketPayPasswordAlertView *alert = [[PNPacketPayPasswordAlertView alloc] init];

        if (cashToolsModel.methodPayment.count > 0) {
            PNCashToolsMethodPaymentItemModel *firstModel = cashToolsModel.methodPayment.firstObject;
            if (firstModel.biz == 1) {
                model.businessObj = firstModel;
                model.subTitleAtt = [self buildTipsText:firstModel view:alert];
            }
        }

        alert.model = model;
        alert.pwdDelegate = self;
        [alert show];
    }];
}

//设置文本
- (NSMutableAttributedString *)buildTipsText:(PNCashToolsMethodPaymentItemModel *)model view:(PNPacketPayPasswordAlertView *)view {
    NSString *h1 = PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消");
    NSString *postStr = [NSString stringWithFormat:PNLocalizedString(@"pn_can_exchang_usd_to_khr", @"KHR账户余额不足，从USD账户兑换$%@到KHR账户，兑换汇率为  $1=៛%@。"),
                                                   [PNCommonUtils fenToyuan:[PNCommonUtils yuanTofen:[NSString stringWithFormat:@"%@", model.amount]]],
                                                   model.rate];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:postStr];
    text.yy_color = HDAppTheme.PayNowColor.c999999;
    text.yy_font = HDAppTheme.PayNowFont.standard11;

    NSMutableAttributedString *highlightText = [[NSMutableAttributedString alloc] initWithString:h1];
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:[UIColor hd_colorWithHexString:@"#0085FF"] backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      [view dismiss];

                                      [NAT showAlertWithMessage:PNLocalizedString(@"pn_tips_balance_insufficient", @"账户余额不足，请重新输入红包金额")
                                                    buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                        [alertView dismiss];
                                                    }];
                                  }];
    [text appendAttributedString:highlightText];

    return text;
}

#pragma mark
- (void)pwd_textFieldDidFinishedEditing:(NSString *)text businessObj:(id)businessObj view:(PNPacketPayPasswordAlertView *)passwordAlertView {
    @HDWeakify(self);
    [self.viewModel cashAccept:self.viewModel.buildModel.tradeNo pwd:text methodPayment:businessObj view:passwordAlertView completion:^(NSString *_Nonnull tradeNo, PNTransType tradeType) {
        @HDStrongify(self);
        [passwordAlertView dismiss];
        [self.navigationController popViewControllerAnimated:YES];

        if (self.viewModel.model.grantObject == PNPacketGrantObject_Out) {
            NSString *shareURL = [NSString stringWithFormat:@"%@?%@", kPacket_share_tg, self.viewModel.packetId];
            NSString *titleStr = [NSString stringWithFormat:PNLocalizedString(@"pn_packet_share_content", @"我发了%zd个红包，快来抢啊，先到先得，下载大象APP查看领取记录"), self.viewModel.model.qty];

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@\n%@", shareURL, titleStr];
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_success", @"复制成功") type:HDTopToastTypeSuccess];

            SAShareWebpageObject *webObj = SAShareWebpageObject.new;
            webObj.webpageUrl = shareURL;
            webObj.title = titleStr;
            [SATelegramShareManager.sharedManager sendShare:webObj completion:^(BOOL success) {
                HDLog(@"%@", success ? @"分享成功" : @"分享失败");
            }];
        } else if (self.viewModel.model.grantObject == PNPacketGrantObject_In) {
            //            [HDMediator.sharedInstance navigaveToOpenPacketVC:@{
            //                @"packetId": self.viewModel.packetId,
            //            }];
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_red_packet_has_been_send", @"红包已发出") type:HDTopToastTypeSuccess];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [PayHDPaymentProcessingHUD hideFor:passwordAlertView];
        NSString *code = rspModel.code;
        NSString *reason = rspModel.msg;
        if ([code containsString:@"V1087"]) {
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_REINPUT", @"重新输入") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [passwordAlertView clearText];

                [alertView dismiss];
            }];
        } else if ([code containsString:@"V1007"]) {
            [PayPassWordTip showPayPassWordTipViewToView:passwordAlertView IconImgName:@"" Detail:reason CancelBtnText:@"" SureBtnText:@"" SureCallBack:^{
                HDLog(@"确定");
                [passwordAlertView clearText];
            } CancelCallBack:^{
                [passwordAlertView dismiss];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
                    [SAWindowManager.visibleViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                };
                params[@"completion"] = completion;
                void (^clickedRememberBlock)(void) = ^{
                    // 校验旧密码修改密码
                    params[@"actionType"] = @(5);
                    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
                };
                params[@"clickedRememberBlock"] = clickedRememberBlock;
                void (^clickedForgetBlock)(void) = ^{
                    [HDMediator.sharedInstance navigaveToPayNowPasswordContactUSVC:params];
                };
                params[@"clickedForgetBlock"] = clickedForgetBlock;
                SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
                [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            }];
        } else if ([code containsString:@"V1015"]) { //密码错误
            [PayPassWordTip showPayPassWordTipViewToView:passwordAlertView IconImgName:@""
                Detail:[NSString stringWithFormat:@"%@ %d %@", PNLocalizedString(@"enter_the_rest", @""), [PNCommonUtils getnum:reason], PNLocalizedString(@"Times", @"")]
                CancelBtnText:@""
                SureBtnText:@"" SureCallBack:^{
                    [passwordAlertView clearText];
                } CancelCallBack:^{
                    [passwordAlertView dismiss];

                    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                    void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
                        [SAWindowManager.visibleViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                    };
                    params[@"completion"] = completion;
                    void (^clickedRememberBlock)(void) = ^{
                        // 校验旧密码修改密码
                        params[@"actionType"] = @(5);
                        [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
                    };
                    params[@"clickedRememberBlock"] = clickedRememberBlock;
                    void (^clickedForgetBlock)(void) = ^{
                        [HDMediator.sharedInstance navigaveToPayNowPasswordContactUSVC:params];
                    };
                    params[@"clickedForgetBlock"] = clickedForgetBlock;
                    SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
                    [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
                }];
        } else {
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                [passwordAlertView dismiss];
            }];
        }
    }];
}

#pragma mark
- (UIImageView *)imageBgView {
    if (!_imageBgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_packet_bg"];
        _imageBgView = imageView;
    }
    return _imageBgView;
}

- (PNNorPacketView *)norContentView {
    if (!_norContentView) {
        _norContentView = [[PNNorPacketView alloc] initWithViewModel:self.viewModel];
        _norContentView.hidden = YES;

        @HDWeakify(self);
        _norContentView.handOutBtnClickBlock = ^{
            @HDStrongify(self);
            [self orderBuild];
        };
    }
    return _norContentView;
}

- (PNPwdPacketView *)pwdContentView {
    if (!_pwdContentView) {
        _pwdContentView = [[PNPwdPacketView alloc] initWithViewModel:self.viewModel];
        _pwdContentView.hidden = YES;

        @HDWeakify(self);
        _pwdContentView.handOutBtnClickBlock = ^{
            @HDStrongify(self);
            [self orderBuild];
        };
    }
    return _pwdContentView;
}

- (PNHandOutViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNHandOutViewModel.new);
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"pn_not_open_will_be_refunded", @"未领取的红包，将于24小时后退回到WOWNOW钱包");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

@end

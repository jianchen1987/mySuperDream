//
//  SAAudioCallAccountController.m
//  SuperApp
//
//  Created by Chaos on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACallAccountController.h"
#import "SAChangeCountryEntryView.h"
#import "SAImDelegateManager.h"
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>


@interface SACallAccountController ()
/// 选择国家
@property (nonatomic, strong) SAChangeCountryEntryView *changeCountryEntryView;
/// 帐号输入框
@property (nonatomic, strong) HDUITextField *accountTextField;
/// 拨打语音电话
@property (nonatomic, strong) SAOperationButton *callBTN;

@property (nonatomic, strong) UITextField *tf;
@end


@implementation SACallAccountController

- (void)hd_setupViews {
    self.boldTitle = SALocalizedString(@"cPbPQyvH", @"语音视频通话测试页面");
    [self.view addSubview:self.changeCountryEntryView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.callBTN];
    [self.view addSubview:self.tf];
    [self.callBTN setFollowKeyBoardConfigEnable:YES margin:30 refView:self.accountTextField distanceToRefViewBottom:20];
}

- (void)updateViewConstraints {
    [self.changeCountryEntryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(HDAppTheme.value.padding.left);
        make.height.mas_equalTo(kRealWidth(29));
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(30));
    }];

    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.changeCountryEntryView);
        make.left.equalTo(self.changeCountryEntryView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.view).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(kRealWidth(55));
    }];


    [self.tf mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTextField);
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20);
    }];

    [self.callBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kRealWidth(30) - kiPhoneXSeriesSafeBottomHeight);
        make.centerX.mas_equalTo(self.view);
        make.width.equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
    }];
    [super updateViewConstraints];
}

- (void)hd_languageDidChanged {
    [self.callBTN setTitle:SALocalizedString(@"uFOxSJZG", @"拨打电话") forState:UIControlStateNormal];
    [self.accountTextField updateConfigWithDict:@{@"placeholder": SALocalizedString(@"placeholder_input_phone_number", @"输入手机号码")}];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedCallBTNHandler {
    if (self.tf.text.length) {
        NSArray *ops = [self.tf.text componentsSeparatedByString:@","];
        [HDMediator.sharedInstance navigaveToAudioCallViewController:@{@"ops": ops}];
    }

    //    NSString *phoneNumber = self.accountTextField.validInputText;
    //    NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
    //    if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
    //        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    //    }
    //    NSString *loginName = [NSString stringWithFormat:@"%@%@", countryCode, phoneNumber];
    //
    //    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];
    //    HDActionSheetViewButton *audioBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"qZQ0QU8C", @"语音通话")
    //                                                                            type:HDActionSheetViewButtonTypeCustom
    //                                                                         handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
    //                                                                             [sheetView dismiss];
    //                                                                             if ([self checkPersmissionWithMediaTypes:@[ AVMediaTypeAudio ]]) {
    //                                                                                 [HDMediator.sharedInstance navigaveToAudioCallViewController:@{@"phone" : loginName}];
    //                                                                             }
    //                                                                         }];
    ////    HDActionSheetViewButton *videoBTN = [HDActionSheetViewButton buttonWithTitle:SALocalizedString(@"6xqiPBRj", @"视频通话")
    ////                                                                            type:HDActionSheetViewButtonTypeCustom
    ////                                                                         handler:^(HDActionSheetView *_Nonnull alertView, HDActionSheetViewButton *_Nonnull button) {
    ////                                                                             [sheetView dismiss];
    ////                                                                             if ([self checkPersmissionWithMediaTypes:@[ AVMediaTypeAudio, AVMediaTypeVideo ]]) {
    ////                                                                                 [HDMediator.sharedInstance navigaveToVideoCallViewController:@{@"phone" : loginName}];
    ////                                                                             }
    ////                                                                         }];
    //    [sheetView addButtons:@[ audioBTN,
    ////                             videoBTN
    //                          ]];
    //    [sheetView show];
}

#pragma mark - private methods
- (void)fixCallBTNState {
    //    SACountryModel *model = self.changeCountryEntryView.currentCountryModel;
    //    BOOL isValid = model.isPhoneNumberValidBlock ? model.isPhoneNumberValidBlock(self.accountTextField.validInputText) : true;
    //    self.callBTN.enabled = isValid;
}
/// 检查权限
- (BOOL)checkPersmissionWithMediaTypes:(NSArray<AVMediaType> *)mediaTypes {
    for (AVMediaType mediaType in mediaTypes) {
        if (![self checkPersmissionWithMediaType:mediaType]) {
            return false;
        }
    }
    return true;
}
- (BOOL)checkPersmissionWithMediaType:(AVMediaType)mediaType {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    // 有权限
    if (authStatus == AVAuthorizationStatusAuthorized) {
        return true;
    }
    // 已禁止权限，用户选择是否去开启
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        // 弹窗提示
        [NAT showAlertWithTitle:nil message:SALocalizedString(@"8emVvEwy", @"没有麦克风或相机权限，无法进行通话") confirmButtonTitle:SALocalizedString(@"O3N3zScm", @"去开启")
            confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                [HDSystemCapabilityUtil openAppSystemSettingPage];
            }
            cancelButtonTitle:SALocalizedString(@"cancel", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
        return false;
    }
    return true;
}

#pragma mark - lazy load
- (SAChangeCountryEntryView *)changeCountryEntryView {
    if (!_changeCountryEntryView) {
        _changeCountryEntryView = SAChangeCountryEntryView.new;
        @HDWeakify(self);
        _changeCountryEntryView.choosedCountryBlock = ^(SACountryModel *_Nonnull model) {
            @HDStrongify(self);
            // 清空
            [self.accountTextField setTextFieldText:@""];
            [self.accountTextField updateConfigWithDict:@{@"separatedFormat": model.phoneNumberFormat, @"maxInputLength": @(model.maximumDigits)}];
        };
    }
    return _changeCountryEntryView;
}

- (HDUITextField *)accountTextField {
    if (!_accountTextField) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"placeholder_input_phone_number", @"输入手机号码") leftLabelString:nil];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        if (@available(iOS 11.0, *)) {
            config.font = HDAppTheme.font.standard2;
            config.placeholderFont = HDAppTheme.font.standard2;
        } else {
            config.font = HDAppTheme.font.standard3;
            config.placeholderFont = HDAppTheme.font.standard3;
        }
        config.textColor = HDAppTheme.color.G1;
        config.shouldSeparatedTextWithSymbol = YES;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumber;

        config.maxInputLength = self.changeCountryEntryView.currentCountryModel.maximumDigits;
        config.separatedFormat = self.changeCountryEntryView.currentCountryModel.phoneNumberFormat;
        [textField setConfig:config];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self fixCallBTNState];
            if (text.length <= 1) {
                SACountryModel *model = self.changeCountryEntryView.currentCountryModel;
                if ([text hasPrefix:@"0"]) {
                    [self.accountTextField updateConfigWithDict:@{@"separatedFormat": model.zeroPrefixPhoneNumberFormat, @"maxInputLength": @(model.maximumDigits)}];

                } else {
                    [self.accountTextField updateConfigWithDict:@{@"separatedFormat": model.phoneNumberFormat, @"maxInputLength": @(model.maximumDigits)}];
                }
            }
        };
        _accountTextField = textField;
    }
    return _accountTextField;
}

- (SAOperationButton *)callBTN {
    if (!_callBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        button.enabled = YES;
        [button addTarget:self action:@selector(clickedCallBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _callBTN = button;
    }
    return _callBTN;
}

- (UITextField *)tf {
    if (!_tf) {
        _tf = UITextField.new;
        _tf.backgroundColor = UIColor.orangeColor;
        _tf.borderStyle = UITextBorderStyleRoundedRect;
        _tf.text = @"1280423934434238464";
    }
    return _tf;
}

@end

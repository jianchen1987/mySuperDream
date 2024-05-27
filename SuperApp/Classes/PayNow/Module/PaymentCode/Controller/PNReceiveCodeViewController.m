//
//  PNReceiveCodeViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNReceiveCodeViewController.h"
#import "HDGenQRCodeRspModel.h"
#import "PNAlertWebView.h"
#import "PNCommonUtils.h"
#import "PNPaymentCodeViewModel.h"
#import "PNQRCodeModel.h"
#import "PNReceiveCodeView.h"
#import "PNSaveQRCodeImageView.h"
#import "PNWalletLimitModel.h"
#import "SAMoneyModel.h"
#import "SAWriteDateReadableModel.h"
#import "VipayUser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <BakongKHQR/BakongKHQR.h>
#import <Photos/Photos.h>
#import "HDSystemCapabilityUtil.h"


@interface PNReceiveCodeViewController ()
@property (nonatomic, strong) PNPaymentCodeViewModel *viewModel;
@property (nonatomic, strong) PNReceiveCodeView *contentView;
@property (nonatomic, strong) PNSaveQRCodeImageView *downView; //用于截图

@property (nonatomic, strong) NSString *amount;  //金额
@property (nonatomic, assign) NSString *curency; //币种

@property (nonatomic, strong) PNQRCodeModel *saveQRCodeModel;
@property (nonatomic, strong) PNQRCodeModel *downQRCodeModel;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) NSInteger currentActionType; //记录当前的操作类型
@end


@implementation PNReceiveCodeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setScreenBrightnessToMax];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self revertScreenBrightnessToOrigin];
}

- (void)setScreenBrightnessToMax {
    [HDSystemCapabilityUtil graduallySetBrightness:0.9];
}

- (void)revertScreenBrightnessToOrigin {
    [HDSystemCapabilityUtil graduallyResumeBrightness];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self setScreenBrightnessToMax];
}

- (void)appWillResignActive:(NSNotification *)notification {
    [self revertScreenBrightnessToOrigin];
}

- (void)hd_setupViews {
    [HDSystemCapabilityUtil saveDefaultBrightness];
    [self registerNotification];
    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.view addSubview:self.downView];
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Collection_code", @"二维码收款");
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)hd_bindViewModel {
    self.isFirst = YES;
    [self.viewModel hd_bindView:self.contentView];

    [self getQRCodeWithAmount:@"0" currency:PNCurrencyTypeUSD];
}

#pragma mark
- (void)getMerchantQRCode:(NSString *)currency {
    NSString *amount = @"0";
    @HDWeakify(self);
    [self.viewModel genQRCodeByLoginName:[VipayUser shareInstance].loginName Amount:amount Currency:currency success:^(HDGenQRCodeRspModel *rspModel) {
        HDLog(@"收款码 codeURL: %@", rspModel.qrData);
        @HDStrongify(self);
        NSString *qrData = rspModel.qrData;

        self.downQRCodeModel.qrCode = qrData;

        /// 判断空就解析，取出 payeeName 对应的值
        if (WJIsStringEmpty(self.downQRCodeModel.payeeName)) {
            KHQRResponse *response = [BakongKHQR verify:qrData];
            if (response.data != nil) {
                CRCValidation *crcValidation = (CRCValidation *)response.data;
                HDLog(@"valid: %d", crcValidation.valid);
                if (crcValidation.valid == 1) { // bakong
                    KHQRResponse *decodeResponse = [BakongKHQR decode:qrData];
                    KHQRDecodeData *decodeData = (KHQRDecodeData *)decodeResponse.data;
                    [decodeData printAll];

                    self.downQRCodeModel.payeeName = decodeData.merchantName;
                }
            }
        }

        self.downQRCodeModel.amount = amount;
        self.downQRCodeModel.currency = currency;

        [self reSetDownQRCodeView];
        HDLog(@"进入了 商家码保存");
        [self downQRCode];
    }];
}

- (void)getQRCodeWithAmount:(NSString *)amount currency:(NSString *)currency {
    @HDWeakify(self);
    [self.viewModel genQRCodeByLoginName:[VipayUser shareInstance].loginName Amount:amount Currency:currency success:^(HDGenQRCodeRspModel *rspModel) {
        HDLog(@"收款码 codeURL: %@", rspModel.qrData);
        @HDStrongify(self);
        NSString *qrData = rspModel.qrData;

        self.saveQRCodeModel.qrCode = qrData;
        //        rspModel.isHideSaveBtn = NO;
        self.saveQRCodeModel.isHideSaveBtn = rspModel.isHideSaveBtn;

        /// 判断空就解析，取出 payeeName 对应的值
        if (WJIsStringEmpty(self.saveQRCodeModel.payeeName)) {
            KHQRResponse *response = [BakongKHQR verify:qrData];
            if (response.data != nil) {
                CRCValidation *crcValidation = (CRCValidation *)response.data;
                HDLog(@"valid: %d", crcValidation.valid);
                if (crcValidation.valid == 1) { // bakong
                    KHQRResponse *decodeResponse = [BakongKHQR decode:qrData];
                    KHQRDecodeData *decodeData = (KHQRDecodeData *)decodeResponse.data;
                    [decodeData printAll];

                    self.saveQRCodeModel.payeeName = decodeData.merchantName;
                }
            }
        }

        self.saveQRCodeModel.amount = amount;
        self.saveQRCodeModel.currency = currency;

        self.contentView.model = self.saveQRCodeModel;

        if (self.isFirst) {
            [self.viewModel getLimitList:^(NSArray *_Nonnull list) {
                PNUserLevel userLevel = VipayUser.shareInstance.accountLevel;

                for (PNWalletLimitModel *item in list) {
                    if (item.bizType == PNLimitTypeDeposit) {
                        NSString *limitMoneyStr = @"";

                        if (userLevel == PNUserLevelNormal) {
                            limitMoneyStr = [NSString stringWithFormat:@"%zd", (NSInteger)(item.classicsLevel.doubleValue * 100)];
                        } else if (userLevel == PNUserLevelAdvanced) {
                            limitMoneyStr = [NSString stringWithFormat:@"%zd", (NSInteger)(item.seniorLevel.doubleValue * 100)];
                        } else if (userLevel == PNUserLevelHonour) {
                            limitMoneyStr = [NSString stringWithFormat:@"%zd", (NSInteger)(item.enjoyLevel.doubleValue * 100)];
                        }
                        [self setMoney:limitMoneyStr currency:item.currency];
                    }
                }
                self.contentView.model = self.saveQRCodeModel;
                self.isFirst = NO;
            }];
        }
    }];
}

- (void)setMoney:(NSString *)amount currency:(NSString *)currency {
    SAMoneyModel *moneyModel = [[SAMoneyModel alloc] initWithAmount:amount currency:currency];
    if ([currency isEqualToString:PNCurrencyTypeUSD]) {
        self.saveQRCodeModel.usdLimit = moneyModel;
    } else {
        self.saveQRCodeModel.khrLimit = moneyModel;
    }
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.downView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (void)reSetDownQRCodeView {
    self.downView.model = self.downQRCodeModel;
}

/// 保存二维码之前的检查
- (void)preCheck {
    PNAccountLevelUpgradeStatus status = VipayUser.shareInstance.upgradeStatus;
    PNUserLevel level = VipayUser.shareInstance.accountLevel;
    if (level == PNUserLevelNormal
        && (status != PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING && status != PNAccountLevelUpgradeStatus_SENIOR_UPGRADING && status != PNAccountLevelUpgradeStatus_APPROVALING)) {
        [NAT showAlertWithMessage:PNLocalizedString(@"save_tips_level", @"该功能仅向已提交KYC认证的用户开放，如需使用请升级您的账户等级。")
            confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{@"needCall": @(YES)}];
                [alertView dismiss];
            }
            cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
    } else {
        BOOL isShowMore = YES;

        NSNumber *tempData = [SACacheManager.shared objectForKey:kSaveDisclaimerAlertTips type:SACacheTypeDocumentNotPublic];
        if (!WJIsObjectNil(tempData)) {
            isShowMore = [tempData doubleValue];
        }

        if (isShowMore) {
            PNAlertWebView *alertView = [[PNAlertWebView alloc] initAlertWithURL:[PNCommonUtils getURLWithName:@"Disclaimer"] title:PNLocalizedString(@"disclaimer", @"免责声明")];
            [alertView show];

            @HDWeakify(self);
            alertView.rightBtnClickBlock = ^{
                @HDStrongify(self);
                [self handleSelectCurrency];
            };
        } else {
            [self handleSelectCurrency];
        }
    }
}

- (void)handleSelectCurrency {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") config:nil];

    @HDWeakify(self);
    // clang-format off
    HDActionSheetViewButton *khrBTN = [HDActionSheetViewButton buttonWithTitle:PNCurrencyTypeKHR type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        @HDStrongify(self);
        [self getMerchantQRCode:PNCurrencyTypeKHR];
    }];
    HDActionSheetViewButton *usdBTN = [HDActionSheetViewButton buttonWithTitle:PNCurrencyTypeUSD type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        @HDStrongify(self);
        [self getMerchantQRCode:PNCurrencyTypeUSD];
    }];
    // clang-format on
    [sheetView addButtons:@[usdBTN, khrBTN]];
    [sheetView show];
}

/// 下载商家码
- (void)downQRCode {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentActionType = 1;
                UIImage *img = [self imageWithUIView:self.downView];

                UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_CAMERA_AUTHORI", @"WOWNOW 没有权限访问您的相册，请允许。") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            });
        }
    }];
}

/// 保存二维码[带金额]
- (void)saveQRCode {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentActionType = 0;
                UIImage *img = [self imageWithUIView:self.contentView.bgView];
                UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_CAMERA_AUTHORI", @"WOWNOW 没有权限访问您的相册，请允许。") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            });
        }
    }];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"";
    if (!error) {
        if (self.currentActionType == 0) {
            message = PNLocalizedString(@"save_qr_code_success", @"保存二维码成功");
        } else if (self.currentActionType == 1) {
            message = PNLocalizedString(@"down_recevie_qr_code_success", @"下载收款二维码成功");
        }
        [NAT showToastWithTitle:nil content:message type:HDTopToastTypeSuccess];
    } else {
        message = [error description];
        HDLog(@"message is %@", message);
        message = PNLocalizedString(@"ALERT_MSG_SAVE_FAILURE", @"保存失败");
        [NAT showToastWithTitle:nil content:message type:HDTopToastTypeError];
    }
}

/// view转成image
- (UIImage *)imageWithUIView:(UIView *)view {
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *data = UIImagePNGRepresentation(image);
    UIImage *aImage = [UIImage imageWithData:data];

    return aImage;
}

#pragma mark
- (PNPaymentCodeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNPaymentCodeViewModel alloc] init];
    }
    return _viewModel;
}

- (PNReceiveCodeView *)contentView {
    if (!_contentView) {
        _contentView = [[PNReceiveCodeView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _contentView.setAmountBlock = ^{
            @HDStrongify(self);

            @HDWeakify(self);
            void (^completion)(NSString *, NSString *) = ^(NSString *amount, NSString *currency) {
                @HDStrongify(self);
                [self getQRCodeWithAmount:amount currency:currency];
            };

            [HDMediator.sharedInstance navigaveToPayNowSetReceiveAmountVC:@{@"callback": completion, @"type": @(1)}];
        };

        _contentView.saveQRCodeBlock = ^{
            @HDStrongify(self);
            [self saveQRCode];
        };

        _contentView.downQRCodeBlock = ^{
            @HDStrongify(self);
            [self preCheck];
        };
    }
    return _contentView;
}

- (PNSaveQRCodeImageView *)downView {
    if (!_downView) {
        _downView = [[PNSaveQRCodeImageView alloc] init];
    }
    return _downView;
}

- (PNQRCodeModel *)saveQRCodeModel {
    if (!_saveQRCodeModel) {
        _saveQRCodeModel = [[PNQRCodeModel alloc] init];
    }
    return _saveQRCodeModel;
}

- (PNQRCodeModel *)downQRCodeModel {
    if (!_downQRCodeModel) {
        _downQRCodeModel = [[PNQRCodeModel alloc] init];
    }
    return _downQRCodeModel;
}
@end

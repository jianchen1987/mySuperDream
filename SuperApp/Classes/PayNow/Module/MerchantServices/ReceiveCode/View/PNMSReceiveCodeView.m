//
//  PNMSReceiveCodeView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSReceiveCodeView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNCommonUtils.h"
#import "PNMSQRCodeView.h"
#import "PNMSReceiveCodeRspModel.h"
#import "PNMSReceiveCodeViewModel.h"
#import "PNQRCodeModel.h"
#import "UIImage+PNExtension.h"
#import <BakongKHQR/BakongKHQR.h>


@interface PNMSReceiveCodeView ()
@property (nonatomic, strong) PNMSQRCodeView *qrCodeView;
/// 保存裁剪view
@property (nonatomic, strong) PNMSQRCodeView *cropView;

@property (nonatomic, strong) UIView *centerBgView;
@property (nonatomic, strong) HDUIButton *setMoneyButton;
@property (nonatomic, strong) UIView *line2; //设置金额 和 保存二维码 之间的那条线
@property (nonatomic, strong) HDUIButton *saveQRCodeButton;

@property (nonatomic, strong) PNMSReceiveCodeViewModel *viewModel;

@property (nonatomic, strong) PNQRCodeModel *model;
@property (nonatomic, strong) PNOperationButton *uploadVoucherBtn;

@end


@implementation PNMSReceiveCodeView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    self.viewModel.amount = @"0";
    self.viewModel.currency = PNCurrencyTypeUSD;

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.qrCodeRspModel)) {
            self.qrCodeView.model = self.viewModel.qrCodeRspModel;
            self.cropView.model = self.viewModel.qrCodeRspModel;
        }
    }];

    [self.viewModel startTimerToGetQRCode];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.qrCodeView];

    [self.scrollViewContainer addSubview:self.centerBgView];
    [self.centerBgView addSubview:self.setMoneyButton];
    [self.centerBgView addSubview:self.saveQRCodeButton];
    [self.centerBgView addSubview:self.line2];
    [self.scrollViewContainer addSubview:self.uploadVoucherBtn];

    [self addSubview:self.cropView];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.width.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.qrCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(20));
    }];

    [self.centerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.qrCodeView.mas_bottom).offset(kRealWidth(15));
        if (self.uploadVoucherBtn.hidden) {
            make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(kRealWidth(-15));
        }
    }];

    [self.setMoneyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerBgView.mas_left);
        make.right.mas_equalTo(self.centerBgView.mas_centerX).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.centerBgView.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.centerBgView.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.saveQRCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerBgView.mas_centerX).offset(kRealWidth(5));
        make.right.mas_equalTo(self.centerBgView.mas_right);
        make.centerY.mas_equalTo(self.setMoneyButton.mas_centerY);
    }];

    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(1));
        make.height.equalTo(@(20));
        make.center.equalTo(self.centerBgView);
    }];

    if (!self.uploadVoucherBtn.hidden) {
        [self.uploadVoucherBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.centerBgView.mas_bottom).offset(kRealWidth(30));
            make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
            make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(kRealWidth(-15));
        }];
    }

    [self.cropView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(kScreenHeight + 100));
    }];
    [super updateConstraints];
}

#pragma mark
#pragma mark 保存二维码
/// 保存r二维码[带金额]
- (void)saveQRCode {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [self imageWithUIView:self.cropView];
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

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"";
    if (!error) {
        message = PNLocalizedString(@"save_qr_code_success", @"保存二维码成功");
        [NAT showToastWithTitle:nil content:message type:HDTopToastTypeSuccess];
    } else {
        message = [error description];
        HDLog(@"message is %@", message);
        message = PNLocalizedString(@"ALERT_MSG_SAVE_FAILURE", @"保存失败");
        [NAT showToastWithTitle:nil content:message type:HDTopToastTypeError];
    }
}

#pragma mark
- (HDUIButton *)setMoneyButton {
    if (!_setMoneyButton) {
        _setMoneyButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_setMoneyButton setTitle:PNLocalizedString(@"set_amount", @"设置金额") forState:0];
        [_setMoneyButton setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        _setMoneyButton.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_setMoneyButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);

            @HDWeakify(self);
            void (^completion)(NSString *, NSString *) = ^(NSString *amount, NSString *currency) {
                @HDStrongify(self);
                self.viewModel.amount = amount;
                self.viewModel.currency = currency;

                [self.viewModel genQRCode];
            };

            [HDMediator.sharedInstance navigaveToPayNowSetReceiveAmountVC:@{@"callback": completion, @"type": @(2)}];
        }];
    }
    return _setMoneyButton;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line2;
}

- (HDUIButton *)saveQRCodeButton {
    if (!_saveQRCodeButton) {
        _saveQRCodeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_saveQRCodeButton setTitle:PNLocalizedString(@"save_qr_code", @"保存二维码") forState:0];
        [_saveQRCodeButton setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        _saveQRCodeButton.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_saveQRCodeButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self saveQRCode];
        }];
    }
    return _saveQRCodeButton;
}

- (UIView *)centerBgView {
    if (!_centerBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _centerBgView = view;
    }
    return _centerBgView;
}

- (PNQRCodeModel *)model {
    if (!_model) {
        _model = [[PNQRCodeModel alloc] init];
    }
    return _model;
}

- (PNMSQRCodeView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[PNMSQRCodeView alloc] initWithViewModel:self.viewModel];
    }
    return _qrCodeView;
}

- (PNMSQRCodeView *)cropView {
    if (!_cropView) {
        _cropView = [[PNMSQRCodeView alloc] initWithViewModel:self.viewModel];
    }
    return _cropView;
}

- (PNOperationButton *)uploadVoucherBtn {
    if (!_uploadVoucherBtn) {
        _uploadVoucherBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_uploadVoucherBtn setTitle:PNLocalizedString(@"pn_Upload_voucher", @"上传凭证") forState:UIControlStateNormal];
        _uploadVoucherBtn.hidden = self.viewModel.type == PNMSReceiveCodeType_StoreOperator ? NO : YES;
        [_uploadVoucherBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesVoucherListVC:@{}];
        }];
    }
    return _uploadVoucherBtn;
}

@end

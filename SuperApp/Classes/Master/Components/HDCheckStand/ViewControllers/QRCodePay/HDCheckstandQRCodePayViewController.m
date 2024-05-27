//
//  HDCheckstandQRCodePayViewController.m
//  SuperApp
//
//  Created by Tia on 2023/5/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "HDCheckstandQRCodePayViewController.h"
#import "UIImage+PNExtension.h"
#import "NSDate+SAExtension.h"


@interface HDCheckstandQRCodePayViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) UIImageView *qrCodeView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) SALabel *timeLabel;
@property (nonatomic, strong) UIImageView *codeBottomView;


@property (nonatomic, strong) UILabel *tipsOneLabel;
@property (nonatomic, strong) UILabel *tipsOneDetailLabel;
@property (nonatomic, strong) UILabel *tipsTwoLabel;
@property (nonatomic, strong) UILabel *tipsTwoDetailLabel;

@property (nonatomic, strong) UIButton *downloadBTN;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UILabel *tipsDetailLabel;


@end


@implementation HDCheckstandQRCodePayViewController

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.topView];
    [self.topView addSubview:self.iconView];

    [self.topView addSubview:self.codeView];

    [self.codeView addSubview:self.shopLabel];
    [self.codeView addSubview:self.qrCodeView];
    [self.codeView addSubview:self.moneyLabel];
    [self.codeView addSubview:self.timeLabel];
    [self.codeView addSubview:self.codeBottomView];

    [self.topView addSubview:self.downloadBTN];

    [self.topView addSubview:self.tipsOneLabel];
    [self.topView addSubview:self.tipsOneDetailLabel];

    [self.topView addSubview:self.tipsTwoLabel];
    [self.topView addSubview:self.tipsTwoDetailLabel];
    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.scrollViewContainer addSubview:self.tipsDetailLabel];

    self.hd_interactivePopDisabled = YES;
    self.hd_fullScreenPopDisabled = YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"pay_khqr_KHQR​_Scan_Pay", @"KHQR扫码支付");
}

- (void)updateViewConstraints {
    CGFloat margin = 16;

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.top.mas_equalTo(margin);
    }];

    [self.codeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(margin);
        make.left.right.equalTo(self.downloadBTN);
        make.bottom.equalTo(self.tipsOneLabel.mas_top).offset(-12);
    }];

    [self.shopLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeView);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.height.mas_greaterThanOrEqualTo(24);
    }];

    [self.qrCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(186, 186));
        make.centerX.equalTo(self.codeView);
        make.top.equalTo(self.shopLabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(self.moneyLabel.mas_top).offset(-12);
    }];

    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeView);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-12);
        make.height.mas_equalTo(43);
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeView);
        make.bottom.mas_equalTo(-30);
    }];

    [self.codeBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.codeView);
    }];

    [self.downloadBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.right.mas_equalTo(-12);
        make.height.mas_equalTo(44);
    }];


    [self.tipsTwoDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.right.equalTo(self.downloadBTN);
        make.bottom.equalTo(self.downloadBTN.mas_top).offset(-12);
    }];

    [self.tipsTwoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.top.equalTo(self.tipsTwoDetailLabel);
        make.left.equalTo(self.downloadBTN);
    }];

    [self.tipsOneDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tipsTwoDetailLabel);
        make.bottom.equalTo(self.tipsTwoLabel.mas_top).offset(-5);
    }];

    [self.tipsOneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsTwoLabel);
        make.size.equalTo(self.tipsTwoLabel);
        make.top.equalTo(self.tipsOneDetailLabel);
    }];


    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.top.equalTo(self.topView.mas_bottom).offset(margin);
        make.height.mas_equalTo(20);
    }];

    [self.tipsDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(6);
        make.bottom.equalTo(self.scrollViewContainer).offset(-20);
    }];

    [super updateViewConstraints];
}


#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    !self.closeByUser ?: self.closeByUser();
}

#pragma mark - private method
- (void)_downloadQRCode {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [self imageWithUIView:self.topView height:CGRectGetMinY(self.tipsOneLabel.frame)];
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
- (UIImage *)imageWithUIView:(UIView *)view height:(CGFloat)height {
    CGSize s = view.bounds.size;
    s.height = height;
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

#pragma mark - setter
- (void)setModel:(HDCheckStandQRCodePayDetailRspModel *)model {
    _model = model;
    self.qrCodeView.image = [UIImage imageQRCodeContent:model.qrData withSize:186];
    self.shopLabel.text = model.merchantName;
    self.moneyLabel.text = model.actualPayAmount.thousandSeparatorAmount;
    ;
    self.timeLabel.text =
        [NSString stringWithFormat:@"%@:%@",
                                   SALocalizedString(@"pay_khqr_Payment_failed", @"支付失效"),
                                   [[[NSDate dateWithTimeIntervalSince1970:model.createTime / 1000.0] dateByAddingTimeInterval:model.timeOut * 60] stringWithFormatStr:@"dd/MM/yyyy HH:mm"]];
}

#pragma mark - lazy load
- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
        _topView.backgroundColor = HDAppTheme.color.sa_C1;
        _topView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _topView;
}


- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_khqr_logo"]];
    }
    return _iconView;
}

- (UIView *)codeView {
    if (!_codeView) {
        _codeView = UIView.new;
        _codeView.backgroundColor = UIColor.whiteColor;
        _codeView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _codeView;
}

- (UILabel *)shopLabel {
    if (!_shopLabel) {
        _shopLabel = UILabel.new;
        _shopLabel.textAlignment = NSTextAlignmentCenter;
        _shopLabel.font = HDAppTheme.font.sa_standard16SB;
        _shopLabel.textColor = HDAppTheme.color.sa_C333;
        _shopLabel.numberOfLines = 2;
        _shopLabel.hd_lineSpace = 5;
        //        _shopLabel.text = @"藤原豆腐店";
    }
    return _shopLabel;
}

- (UIImageView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = UIImageView.new;
    }
    return _qrCodeView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = UILabel.new;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
        _moneyLabel.textColor = HDAppTheme.color.sa_C333;
        //        _moneyLabel.text = @"$5.21";
    }
    return _moneyLabel;
}

- (SALabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = SALabel.new;
        _timeLabel.textColor = HDAppTheme.color.sa_C666;
        _timeLabel.backgroundColor = HDAppTheme.color.sa_backgroundColor;
        _timeLabel.font = HDAppTheme.font.sa_standard14;
        _timeLabel.hd_edgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        //        _timeLabel.text = @"支付失效:10/03/2023 12:34";
        _timeLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height / 2.0];
        };
    }
    return _timeLabel;
}

- (UIImageView *)codeBottomView {
    if (!_codeBottomView) {
        _codeBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_khqr_bg"]];
    }
    return _codeBottomView;
}


- (UILabel *)tipsOneLabel {
    if (!_tipsOneLabel) {
        UILabel *l = UILabel.new;
        l.textColor = UIColor.whiteColor;
        l.font = [HDAppTheme.font sa_fontDINBold:10];
        l.layer.borderWidth = 1;
        l.layer.borderColor = UIColor.whiteColor.CGColor;
        l.layer.cornerRadius = 7;
        l.textAlignment = NSTextAlignmentCenter;
        l.text = @"1";
        _tipsOneLabel = l;
    }
    return _tipsOneLabel;
}

- (UILabel *)tipsOneDetailLabel {
    if (!_tipsOneDetailLabel) {
        UILabel *l = UILabel.new;
        l.textColor = UIColor.whiteColor;
        l.font = HDAppTheme.font.sa_standard12;
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        l.text = SALocalizedString(@"pay_khqr_step1", @"下载KHQR付款码到手机相册");
        _tipsOneDetailLabel = l;
    }
    return _tipsOneDetailLabel;
}


- (UILabel *)tipsTwoLabel {
    if (!_tipsTwoLabel) {
        UILabel *l = UILabel.new;
        l.textColor = UIColor.whiteColor;
        l.font = [HDAppTheme.font sa_fontDINBold:10];
        l.layer.borderWidth = 1;
        l.layer.borderColor = UIColor.whiteColor.CGColor;
        l.layer.cornerRadius = 7;
        l.textAlignment = NSTextAlignmentCenter;
        l.text = @"2";
        _tipsTwoLabel = l;
    }
    return _tipsTwoLabel;
}


- (UILabel *)tipsTwoDetailLabel {
    if (!_tipsTwoDetailLabel) {
        UILabel *l = UILabel.new;
        l.textColor = UIColor.whiteColor;
        l.font = HDAppTheme.font.sa_standard12;
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        l.text = SALocalizedString(@"pay_khqr_step2", @"打开Bakong App或支持KHQR的银行App，扫描该付款码");
        _tipsTwoDetailLabel = l;
    }
    return _tipsTwoDetailLabel;
}

- (UIButton *)downloadBTN {
    if (!_downloadBTN) {
        _downloadBTN = UIButton.new;
        [_downloadBTN setTitle:SALocalizedString(@"pay_khqr_Download_KHQR_payment_code", @"下载KHQR付款码") forState:UIControlStateNormal];
        [_downloadBTN setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        _downloadBTN.titleLabel.font = HDAppTheme.font.sa_standard16B;
        _downloadBTN.backgroundColor = UIColor.whiteColor;
        _downloadBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        @HDWeakify(self);
        [_downloadBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self _downloadQRCode];
        }];
    }
    return _downloadBTN;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.new;
        _tipsLabel.text = SALocalizedString(@"pay_khqr_Payment_Reminder", @"支付提示");
        _tipsLabel.font = HDAppTheme.font.sa_standard14SB;
        _tipsLabel.textColor = HDAppTheme.color.sa_C333;
    }
    return _tipsLabel;
}

- (UILabel *)tipsDetailLabel {
    if (!_tipsDetailLabel) {
        _tipsDetailLabel = UILabel.new;
        _tipsDetailLabel.font = HDAppTheme.font.sa_standard12;
        _tipsDetailLabel.textColor = HDAppTheme.color.sa_C666;
        _tipsDetailLabel.numberOfLines = 0;
        _tipsDetailLabel.hd_lineSpace = 5;
        _tipsDetailLabel.text =
            [NSString stringWithFormat:@"%@\n%@\n%@",
                                       SALocalizedString(@"pay_khqr_tip2", @"1. 扫码完成付款后，请等待支付结果。不要多次扫码，避免出现重复支付。如发生重复支付，多付款项原路退回。"),
                                       SALocalizedString(@"pay_khqr_tip3", @"2. 请在支付失效时间之前完成扫码付款。如支付失效后付款，款项自动原路退回，订单失效无法履行。"),
                                       SALocalizedString(@"pay_khqr_tip4", @"3. 如发生退款，款项原路退回，请注意查看付款银行APP的通知")];
    }
    return _tipsDetailLabel;
}

@end

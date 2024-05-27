//
//  PNApartmentResultViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentResultViewController.h"


@interface PNApartmentResultViewController ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, assign) PNApartmentPaymentResultType type;
@property (nonatomic, strong) HDUIButton *addBtn;
@end


@implementation PNApartmentResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.type = [[parameters objectForKey:@"type"] integerValue];
    }
    return self;
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self goBack];
}

- (void)goBack {
    BOOL result = NO;
    UIViewController *viewContr;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"PNApartmentListViewController")]) {
            result = YES;
            viewContr = vc;
            break;
        }
    }
    if (result && viewContr) {
        [self.navigationController popToViewController:viewContr animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Rent_bill", @"公寓缴费");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
    self.hd_backButtonImage = [UIImage imageNamed:@""];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.iconImgView];
    [self.view addSubview:self.statusLabel];
}

- (void)updateViewConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(24));
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(24));
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(20));
    }];

    [super updateViewConstraints];
}


#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_bind_success"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.textAlignment = NSTextAlignmentCenter;
        NSString *str = @"";
        if (self.type == PNApartmentPaymentResultType_RejectSuccess) {
            str = PNLocalizedString(@"pn_reject_success", @"拒绝成功");
        } else if (self.type == PNApartmentPaymentResultType_UploadSuccess) {
            str = PNLocalizedString(@"pn_Succeed_to_upload_voucher", @"缴费凭证上传成功");
        }
        label.text = str;
        _statusLabel = label;
    }
    return _statusLabel;
}


- (HDUIButton *)addBtn {
    if (!_addBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self goBack];
        }];

        _addBtn = button;
    }
    return _addBtn;
}
@end

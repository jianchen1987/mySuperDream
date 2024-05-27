//
//  SASetPhoneViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SASetPhoneViewController.h"
#import "SASetPhoneBindViewController.h"
#import "LKDataRecord.h"


@interface SASetPhoneViewController ()
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *tipsLabel;
/// 取消按钮
@property (nonatomic, strong) SAOperationButton *cancelBTN;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *submitBTN;

@end


@implementation SASetPhoneViewController

- (void)hd_setupViews {
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.submitBTN];
    [self.view addSubview:self.cancelBTN];

    NSString *text = self.parameters[@"text"];
    if (HDIsStringNotEmpty(text)) {
        self.tipsLabel.text = text;
    }

    [LKDataRecord.shared tracePVEvent:@"BindPhonePageView" parameters:nil SPM:nil];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"login_new2_Phone Setting", @"设置手机");
    self.hd_interactivePopDisabled = YES;
}

- (void)updateViewConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 140));
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(4);
        make.centerX.mas_equalTo(0);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.equalTo(self.iconView.mas_bottom).offset(12);
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(48);
    }];

    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.submitBTN);
        make.top.equalTo(self.submitBTN.mas_bottom).offset(12);
    }];

    [super updateViewConstraints];
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    !self.cancelBindBlock ?: self.cancelBindBlock();
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    _text = text;
    if (HDIsStringNotEmpty(text)) {
        self.tipsLabel.text = text;
    } else {
        self.tipsLabel.text = @"";
    }
}

#pragma mark - lazy load
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_setPhone_bg"]];
    }
    return _iconView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *label = UILabel.new;
        label.numberOfLines = 0;
        label.hd_lineSpace = 5;
        label.textColor = UIColor.sa_C333;
        label.font = HDAppTheme.font.sa_standard14;
        label.textAlignment = NSTextAlignmentCenter;
        //        label.text = @"您将使用的xxx功能，需要您设置手机号码。\n请放心，手机号码经加密保护，不会对外泄露。";
        _tipsLabel = label;
    }
    return _tipsLabel;
}


- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16B;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            SASetPhoneBindViewController *vc = SASetPhoneBindViewController.new;
            vc.bindSuccessBlock = self.bindSuccessBlock;
            [self.navigationController pushViewController:vc animated:YES];

            [LKDataRecord.shared traceClickEvent:@"BindPhonePageConfirmButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SASetPhoneViewController" area:@"" node:@""]];
        }];
        _submitBTN = button;
    }
    return _submitBTN;
}

- (SAOperationButton *)cancelBTN {
    if (!_cancelBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];

        [button setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16B;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self hd_backItemClick:nil];

            [LKDataRecord.shared traceClickEvent:@"BindPhonePageCancelButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SASetPhoneViewController" area:@"" node:@""]];
        }];
        _cancelBTN = button;
    }
    return _cancelBTN;
}


@end

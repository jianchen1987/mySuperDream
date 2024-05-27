//
//  PNMSUploadVoucherResultViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSUploadVoucherResultViewController.h"
#import "PNMVoucherDetailViewController.h"


@interface PNMSUploadVoucherResultViewController ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) PNOperationButton *detailBtn;
@property (nonatomic, strong) HDUIButton *navBtn;

@property (nonatomic, assign) NSString *voucherId;
@end


@implementation PNMSUploadVoucherResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.voucherId = [parameters objectForKey:@"id"];
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.hd_navLeftBarButtonItems = @[];
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
}

- (void)hd_setupViews {
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.detailBtn];
}

- (void)updateViewConstraints {
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(20));
        make.size.mas_equalTo(self.imgView.image.size);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(kRealWidth(20));
    }];

    [self.detailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(36));
    }];
    [super updateViewConstraints];
}

#pragma mark
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"pn_bind_success"];
    }
    return _imgView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"pn_upload_success", @"上传成功");
        _statusLabel = label;
    }
    return _statusLabel;
}

- (PNOperationButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_detailBtn setTitle:PNLocalizedString(@"pn_check_detail", @"查看记录") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_detailBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            PNMVoucherDetailViewController *vc = [[PNMVoucherDetailViewController alloc] initWithRouteParameters:@{
                @"id": self.voucherId,
            }];
            NSMutableArray *newVCArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            for (NSInteger i = newVCArr.count - 1; i >= 0; i--) {
                UIViewController *vc = newVCArr[i];
                if ([vc isKindOfClass:self.class]) {
                    [newVCArr removeObject:vc];
                    break;
                }
            }
            [newVCArr addObject:vc];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController setViewControllers:newVCArr animated:YES];
        }];
    }
    return _detailBtn;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];

        _navBtn = button;
    }
    return _navBtn;
}
@end

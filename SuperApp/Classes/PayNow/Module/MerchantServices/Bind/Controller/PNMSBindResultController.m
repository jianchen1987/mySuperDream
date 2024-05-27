//
//  PNMSBindResultController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBindResultController.h"
#import "PNMSStepView.h"


@interface PNMSBindResultController ()
@property (nonatomic, strong) PNMSStepView *stepView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *messageLabel;
@property (nonatomic, strong) HDUIButton *enterBtn; ///< 进入商户
@end


@implementation PNMSBindResultController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ms_bind_merchant_services", @"关联商户");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.stepView];
    [self.view addSubview:self.iconImgView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.enterBtn];
}

- (void)updateViewConstraints {
    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(@(self.iconImgView.image.size));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.stepView.mas_bottom).offset(kRealWidth(24));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(24));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-24));
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(24));
    }];

    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(24));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-24));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.enterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(24));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-24));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(kRealWidth(24) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNMSStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNMSStepView alloc] init];
        _stepView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        [_stepView layoutIfNeeded];

        NSMutableArray<PNMSStepItemModel *> *list = [NSMutableArray arrayWithCapacity:3];
        PNMSStepItemModel *model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_1_hight_pre"];
        model.titleStr = PNLocalizedString(@"ms_input_merchant_id", @"输入商户ID");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_2_hight_pre"];
        model.titleStr = PNLocalizedString(@"ms_verify_merchant_info", @"验证商户信息");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_3_hight"];
        model.titleStr = PNLocalizedString(@"ms_bind_success_tips", @"关联成功");
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, 0, 0);
        model.titleFont = HDAppTheme.PayNowFont.standard12M;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        [list addObject:model];

        [_stepView setModelList:list step:2];
    }
    return _stepView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_bind_success"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = [HDAppTheme.PayNowFont fontSemibold:16];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"ms_bind_success", @"商户号关联成功！");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)messageLabel {
    if (!_messageLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"ms_bind_success_congratulations", @"恭喜您，商户号关联成功。");
        _messageLabel = label;
    }
    return _messageLabel;
}

- (HDUIButton *)enterBtn {
    if (!_enterBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"ms_enter_mserchant_services", @"进入商户服务") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"%@", self.navigationController.viewControllers);

            NSMutableArray<UIViewController *> *controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [controllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                /// 反着来寻找到 钱包主页
                if ([obj isMemberOfClass:NSClassFromString(@"PNWalletController")]) {
                    *stop = YES;
                } else {
                    [controllers removeObject:obj];
                }
            }];
            self.navigationController.viewControllers = [NSArray arrayWithArray:controllers];

            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesHomeVC:@{}];
        }];
        _enterBtn = button;
    }

    return _enterBtn;
}

@end

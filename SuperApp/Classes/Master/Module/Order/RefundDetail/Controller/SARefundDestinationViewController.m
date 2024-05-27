//
//  SARefundDestinationViewController.m
//  SuperApp
//
//  Created by Tia on 2022/5/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARefundDestinationViewController.h"
#import "SAInfoView.h"


@interface SARefundDestinationViewController ()

@property (nonatomic, strong) SALabel *tipLB;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) SALabel *sectionLB;

@property (nonatomic, strong) SAInfoView *channelView;

@property (nonatomic, strong) SAInfoView *accountView;

@property (nonatomic, strong) SAInfoView *personView;

@end


@implementation SARefundDestinationViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.view.backgroundColor = [HDAppTheme.color normalBackground];

    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.infoView];

    [self.infoView addSubview:self.sectionLB];
    [self.infoView addSubview:self.channelView];
    [self.infoView addSubview:self.accountView];
    [self.infoView addSubview:self.personView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"where_refund_goes", @"钱款去向");
}

- (void)updateViewConstraints {
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(15));
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(15));
        make.left.mas_equalTo(self.tipLB);
        make.right.mas_equalTo(self.tipLB);
    }];

    [self.sectionLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kRealWidth(15));
    }];

    UIView *lastView = nil;
    for (UIView *view in self.infoView.subviews) {
        if ([view isKindOfClass:SAInfoView.class]) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!lastView) {
                    make.top.equalTo(self.sectionLB.mas_bottom).offset(kRealHeight(5));
                } else {
                    make.top.equalTo(lastView.mas_bottom);
                }
                make.left.right.equalTo(self.infoView);
                if (view == self.infoView.subviews.lastObject) {
                    make.bottom.equalTo(self.infoView.mas_bottom);
                }
            }];
            lastView = view;
        }
    }
    [super updateViewConstraints];
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - lazy load
- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *l = SALabel.new;
        l.font = [HDAppTheme.font standard4];
        l.textColor = [HDAppTheme.color G1];
        l.numberOfLines = 0;
        l.text = SALocalizedString(@"check_refund_tip", @"退款金额已转账到以下账号，请前往支付渠道/银行查看");
        _tipLB = l;
    }
    return _tipLB;
}

- (UIView *)infoView {
    if (!_infoView) {
        UIView *view = UIView.new;
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        _infoView = view;
    }
    return _infoView;
}

- (SALabel *)sectionLB {
    if (!_sectionLB) {
        SALabel *l = SALabel.new;
        l.font = [HDAppTheme.font standard3Bold];
        l.textColor = [HDAppTheme.color G1];
        l.numberOfLines = 0;
        l.text = SALocalizedString(@"refund_receiver_info_receiver", @"收款人");
        _sectionLB = l;
    }
    return _sectionLB;
}

- (SAInfoView *)channelView {
    if (!_channelView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_receiver_info_channel", @"收款渠道");
        model.keyColor = HDAppTheme.color.G2;
        model.keyFont = HDAppTheme.font.standard4Bold;
        model.valueText = self.parameters[@"paymentChannel"];
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = HDAppTheme.font.standard4;
        view.model = model;
        _channelView = view;
    }
    return _channelView;
}

- (SAInfoView *)accountView {
    if (!_accountView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_receiver_info_account", @"收款账号");
        model.keyColor = HDAppTheme.color.G2;
        model.keyFont = HDAppTheme.font.standard4Bold;
        model.valueText = self.parameters[@"receiveAccount"];
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = HDAppTheme.font.standard4;
        view.model = model;
        _accountView = view;
    }
    return _accountView;
}

- (SAInfoView *)personView {
    if (!_personView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"refund_receiver_info_receiver", @"收款人");
        model.keyColor = HDAppTheme.color.G2;
        model.keyFont = HDAppTheme.font.standard4Bold;
        model.valueText = self.parameters[@"receiveName"];
        model.valueColor = HDAppTheme.color.G1;
        model.valueFont = HDAppTheme.font.standard4;
        model.lineWidth = 0;
        view.model = model;
        _personView = view;
    }
    return _personView;
}

@end

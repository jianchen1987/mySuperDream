//
//  WMOrderDetailContactPhoneView.m
//  SuperApp
//
//  Created by VanJay on 2020/7/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailContactPersonView.h"
#import "SACacheManager.h"
#import "SAContactPhoneModel.h"
#import "SAGeneralUtil.h"
#import "SAImageLeftFillButton.h"
#import "WMOrderDetailContactPhoneView.h"
#import "WMOrderDetailRiderModel.h"
#import "SAApolloManager.h"


@interface WMOrderDetailContactPersonView ()
/// 容器
@property (nonatomic, strong) UIStackView *containerView;
/// 商户
@property (nonatomic, strong) HDUIButton *contactMerchantBTN;
/// 骑手
@property (nonatomic, strong) HDUIButton *contactRiderBTN;
/// 客服
@property (nonatomic, strong) HDUIButton *contactCallCenterBTN;
/// 客服号码数组
@property (nonatomic, strong) NSArray<SAContactPhoneModel *> *callCenterNumbers;

@end


@implementation WMOrderDetailContactPersonView

- (void)hd_setupViews {
    [self initData];
    [self addSubview:self.containerView];
    [self.containerView addArrangedSubview:self.contactRiderBTN];
    [self.containerView addArrangedSubview:self.contactMerchantBTN];
    [self.containerView addArrangedSubview:self.contactCallCenterBTN];

    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.centerX.equalTo(self);
        make.top.bottom.equalTo(self);
    }];
}

- (void)initData {
    NSArray<SAContactPhoneModel *> *callCenter = [NSArray yy_modelArrayWithClass:SAContactPhoneModel.class json:[SAApolloManager getApolloConfigForKey:ApolloConfigKeyCallCenter]];
    self.callCenterNumbers = [callCenter hd_filterWithBlock:^BOOL(SAContactPhoneModel *_Nonnull item) {
        return [item.name isEqualToString:SAContactPhoneNameCallCenter];
    }];
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    if (HDIsStringEmpty(self.merchantNumber)) {
        self.contactMerchantBTN.hidden = true;
    }
    if (HDIsObjectNil(self.rider)) {
        self.contactRiderBTN.hidden = true;
    }
    self.frame = (CGRect){0, 0, CGRectGetWidth(self.frame), 120};
}

#pragma mark - event response
- (void)clickedContactBTNHandler:(UIButton *)btn {
    !self.clickedPersonBlock ?: self.clickedPersonBlock();

    NSString *title = @"";
    NSArray *phoneList = @[];

    if (btn == self.contactRiderBTN) {
        [self openRiderIM];
        return;
    } else if (btn == self.contactMerchantBTN) {
        title = WMLocalizedString(@"XTfuTkU1", @"Contact merchant");
        phoneList = @[self.merchantNumber];
    } else {
        title = WMLocalizedString(@"suvJBCPM", @"Contact customer service");
        phoneList = self.callCenterNumbers;
    }

    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.contentHorizontalEdgeMargin = 0;
    config.title = title;
    config.titleColor = HDAppTheme.color.G1;
    config.titleFont = HDAppTheme.font.standard2Bold;
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.textAlignment = HDCustomViewActionViewTextAlignmentCenter;
    config.needTopSepLine = true;
    const CGFloat width = kScreenWidth - 2 * config.contentHorizontalEdgeMargin;
    WMOrderDetailContactPhoneView *view = [[WMOrderDetailContactPhoneView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    view.phoneList = phoneList;
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
    @HDWeakify(actionView);
    view.clickedPhoneNumberBlock = ^(NSString *_Nonnull phoneNumber) {
        @HDStrongify(actionView);
        [actionView dismiss];
        !self.clickedPhoneNumberBlock ?: self.clickedPhoneNumberBlock(phoneNumber);
    };
    [actionView show];
}

#pragma mark - private methods
- (void)openRiderIM {
    NSDictionary *dict = @{
        @"operatorType": @(9),
        @"operatorNo": self.rider.riderNo ?: @"",
        @"prepareSendTxt": [NSString stringWithFormat:WMLocalizedString(@"NyF6Fg39", @"我想咨询订单号：%@"), self.orderNo],
        @"phoneNo": self.rider.riderPhone ?: @"",
        @"scene": SAChatSceneTypeYumNowDelivery
    };
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}

#pragma mark - lazy load
- (UIStackView *)containerView {
    if (!_containerView) {
        _containerView = UIStackView.new;
        _containerView.axis = UILayoutConstraintAxisHorizontal;
        _containerView.distribution = UIStackViewDistributionFillEqually;
        _containerView.spacing = 10;
        _containerView.alignment = UIStackViewAlignmentFill;
    }
    return _containerView;
}

- (HDUIButton *)contactRiderBTN {
    if (!_contactRiderBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:WMLocalizedString(@"xTPtslzD", @"联系骑手") forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"contact_rider"] forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.standard3;
        btn.imagePosition = HDUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 7;
        [btn addTarget:self action:@selector(clickedContactBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _contactRiderBTN = btn;
    }
    return _contactRiderBTN;
}

- (HDUIButton *)contactMerchantBTN {
    if (!_contactMerchantBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:WMLocalizedString(@"XTfuTkU1", @"致电商家") forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.standard3;
        [btn setImage:[UIImage imageNamed:@"contact_merchant"] forState:UIControlStateNormal];
        btn.imagePosition = HDUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 7;
        [btn addTarget:self action:@selector(clickedContactBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _contactMerchantBTN = btn;
    }
    return _contactMerchantBTN;
}

- (HDUIButton *)contactCallCenterBTN {
    if (!_contactCallCenterBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:WMLocalizedString(@"suvJBCPM", @"联系客服") forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.font.standard3;
        [btn setImage:[UIImage imageNamed:@"contact_call_center"] forState:UIControlStateNormal];
        btn.imagePosition = HDUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 7;
        [btn addTarget:self action:@selector(clickedContactBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _contactCallCenterBTN = btn;
    }
    return _contactCallCenterBTN;
}

@end

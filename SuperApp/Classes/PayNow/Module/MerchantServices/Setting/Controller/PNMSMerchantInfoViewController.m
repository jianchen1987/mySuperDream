//
//  PNMSMerchantInfoViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNMSMerchantInfoViewController.h"
#import "PNInfoView.h"
#import "PNMSBaseInfoModel.h"
#import "PNMSHomeDTO.h"


@interface PNMSMerchantInfoViewController ()
@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, strong) PNMSHomeDTO *homeDTO;

@property (nonatomic, strong) PNInfoView *merchantNoInfoView;
@property (nonatomic, strong) PNInfoView *merchantNameInfoView;
@property (nonatomic, strong) PNInfoView *statusInfoView;
@property (nonatomic, strong) PNInfoView *addressInfoView;
@property (nonatomic, strong) PNInfoView *phoneInfoView;
@property (nonatomic, strong) PNInfoView *emailInfoView;
@end


@implementation PNMSMerchantInfoViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.merchantNo = [parameters objectForKey:@"merchantNo"];
        HDLog(@"merchantNo: %@", self.merchantNo);
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.merchantNoInfoView];
    [self.scrollViewContainer addSubview:self.merchantNameInfoView];
    [self.scrollViewContainer addSubview:self.statusInfoView];
    [self.scrollViewContainer addSubview:self.addressInfoView];
    [self.scrollViewContainer addSubview:self.phoneInfoView];
    [self.scrollViewContainer addSubview:self.emailInfoView];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ms_merchant_info", @"商户信息");
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(8));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<PNInfoView *> *visableInfoViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(PNInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    PNInfoView *lastInfoView;
    for (PNInfoView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
            make.left.equalTo(self.scrollViewContainer);
            make.right.equalTo(self.scrollViewContainer);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.homeDTO getMerchantServicesBaseInfo:^(PNMSBaseInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self setData:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)setData:(PNMSBaseInfoModel *)model {
    self.merchantNoInfoView.model.valueText = model.merchantNo;
    [self.merchantNoInfoView setNeedsUpdateContent];

    self.merchantNameInfoView.model.valueText = model.merchantName;
    [self.merchantNameInfoView setNeedsUpdateContent];

    self.statusInfoView.model.valueText = [PNCommonUtils getMerchantInfoStatus:model.merStatus];
    [self.statusInfoView setNeedsUpdateContent];

    self.addressInfoView.model.valueText = model.addressGlobal;
    [self.addressInfoView setNeedsUpdateContent];

    self.phoneInfoView.model.valueText = model.merMobile;
    [self.phoneInfoView setNeedsUpdateContent];

    self.emailInfoView.model.valueText = model.email;
    [self.emailInfoView setNeedsUpdateContent];
}

#pragma mark
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard15M;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
    return model;
}

- (PNInfoView *)merchantNoInfoView {
    if (!_merchantNoInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_merchant_id_2", @"商户号")];
        view.model = model;
        _merchantNoInfoView = view;
    }
    return _merchantNoInfoView;
}

- (PNInfoView *)merchantNameInfoView {
    if (!_merchantNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"ms_merchant_name", @"商户名称")];
        view.model = model;
        _merchantNameInfoView = view;
    }
    return _merchantNameInfoView;
}

- (PNInfoView *)statusInfoView {
    if (!_statusInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Status", @"状态")];
        view.model = model;
        _statusInfoView = view;
    }
    return _statusInfoView;
}

- (PNInfoView *)addressInfoView {
    if (!_addressInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"LQPsLBJh", @"地址")];
        view.model = model;
        _addressInfoView = view;
    }
    return _addressInfoView;
}

- (PNInfoView *)phoneInfoView {
    if (!_phoneInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"EflnCwt2", @"手机号")];
        view.model = model;
        _phoneInfoView = view;
    }
    return _phoneInfoView;
}

- (PNInfoView *)emailInfoView {
    if (!_emailInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_email", @"邮箱")];
        view.model = model;
        _emailInfoView = view;
    }
    return _emailInfoView;
}

- (PNMSHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = [[PNMSHomeDTO alloc] init];
    }
    return _homeDTO;
}

@end

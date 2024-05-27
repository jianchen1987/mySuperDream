//
//  PNMSReceiveCodeViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSReceiveCodeViewController.h"
#import "HDSystemCapabilityUtil.h"
#import "PNMSReceiveCodeView.h"
#import "PNMSReceiveCodeViewModel.h"


@interface PNMSReceiveCodeViewController ()
@property (nonatomic, strong) PNMSReceiveCodeViewModel *viewModel;
@property (nonatomic, strong) PNMSReceiveCodeView *contentView;
@end


@implementation PNMSReceiveCodeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [_viewModel cancelTimer];
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

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        // 有些进入需要传key并且必须有值，不然接口可能会报错

        NSArray *keyArray = parameters.allKeys;

        self.viewModel.storeOperatorInfoModel = [[PNMSStoreOperatorInfoModel alloc] init];

        // 店员码 这两个是必传 - 【当查看别人的】
        self.viewModel.storeOperatorInfoModel.operatorName = [parameters objectForKey:@"operatorName"];
        self.viewModel.storeOperatorInfoModel.operatorMobile = [parameters objectForKey:@"operatorMobile"];

        if ([keyArray containsObject:@"storeNo"]) {
            self.viewModel.storeOperatorInfoModel.storeNo = [parameters objectForKey:@"storeNo"];
        } else {
            self.viewModel.storeOperatorInfoModel.storeNo = VipayUser.shareInstance.storeNo;
        }

        if ([keyArray containsObject:@"storeName"]) {
            self.viewModel.storeOperatorInfoModel.storeName = [parameters objectForKey:@"storeName"];
        } else {
            self.viewModel.storeOperatorInfoModel.storeName = VipayUser.shareInstance.storeName;
        }

        self.viewModel.storeOperatorInfoModel.merchantNo = VipayUser.shareInstance.merchantNo;
        self.viewModel.storeOperatorInfoModel.merchantName = VipayUser.shareInstance.merchantName;

        PNMSRoleType roleType = VipayUser.shareInstance.role;
        if (roleType == PNMSRoleType_STORE_MANAGER) {
            if ([keyArray containsObject:@"operatorName"] && [keyArray containsObject:@"operatorMobile"]) {
                self.viewModel.type = PNMSReceiveCodeType_StoreOperator;
            } else {
                self.viewModel.type = PNMSReceiveCodeType_Store;
            }
        } else if (roleType == PNMSRoleType_STORE_STAFF) {
            self.viewModel.type = PNMSReceiveCodeType_StoreOperator;

            self.viewModel.storeOperatorInfoModel.operatorName = [NSString stringWithFormat:@"%@ %@", VipayUser.shareInstance.lastName, VipayUser.shareInstance.firstName];
            self.viewModel.storeOperatorInfoModel.operatorMobile = VipayUser.shareInstance.loginName;
        } else {
            self.viewModel.type = PNMSReceiveCodeType_Merchant;

            if ([keyArray containsObject:@"storeNo"] && [keyArray containsObject:@"storeName"]) {
                self.viewModel.type = PNMSReceiveCodeType_Store;

                if ([keyArray containsObject:@"operatorName"] && [keyArray containsObject:@"operatorMobile"]) {
                    self.viewModel.type = PNMSReceiveCodeType_StoreOperator;
                }
            }
        }
    }
    return self;
}

- (void)hd_setupNavigation {
    if (self.viewModel.type == PNMSReceiveCodeType_Merchant) {
        self.boldTitle = PNLocalizedString(@"pn_Merchant_KHQR", @"商户收款码");
    } else if (self.viewModel.type == PNMSReceiveCodeType_Store) {
        self.boldTitle = PNLocalizedString(@"pn_Store_receiving_KHQR", @"门店收款码");
    } else if (self.viewModel.type == PNMSReceiveCodeType_StoreOperator) {
        self.boldTitle = PNLocalizedString(@"pn_Staff_receiving_QR", @"店员收款码");
    } else {
        self.boldTitle = PNLocalizedString(@"Collection_code", @"二维码收款");
    }
}

- (void)hd_setupViews {
    [HDSystemCapabilityUtil saveDefaultBrightness];
    [self registerNotification];
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSReceiveCodeView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSReceiveCodeView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSReceiveCodeViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSReceiveCodeViewModel.new);
}

@end

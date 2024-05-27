//
//  WMOrderSubmitV2ViewController.m
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitV2ViewController.h"
#import "WMOrderSubmitV2View.h"
#import "WMOrderSubmitV2ViewModel.h"
#import "LKDataRecord.h"


@interface WMOrderSubmitV2ViewController ()
/// 内容
@property (nonatomic, strong) WMOrderSubmitV2View *contentView;
/// VM
@property (nonatomic, strong) WMOrderSubmitV2ViewModel *viewModel;
@end


@implementation WMOrderSubmitV2ViewController
- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_submit", @"确认订单");
    self.hd_navTitleColor = HDAppTheme.WMColor.B3;
    self.hd_navigationBar.backgroundColor = HDAppTheme.WMColor.bg3;
    self.hd_backButtonImage = [UIImage imageNamed:@"yn_home_back"];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = -2;
    self.view.backgroundColor = HDAppTheme.WMColor.bgGray;
    [self.view addSubview:self.contentView];

    self.hd_needMoveView = self.contentView;
    [self getNewData];

    ///计算页面停留时长
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", NSDate.date.timeIntervalSince1970] forKey:@"WMOrderSubmitV2ViewControllerTime"];
    self.viewModel.pageSource = [WMManage.shareInstance currentCompleteSource:self includeSelf:NO];
    
    HDLog(@"测试链路:%@", self.viewModel.source);
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)getNewData {
    [self.viewModel getInitializedData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentView.willAppeal = YES;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

#pragma mark - lazy load

- (WMOrderSubmitV2View *)contentView {
    return _contentView ?: ({ _contentView = [[WMOrderSubmitV2View alloc] initWithViewModel:self.viewModel]; });
}

- (WMOrderSubmitV2ViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMOrderSubmitV2ViewModel alloc] init];
        _viewModel.productList = [self.parameters objectForKey:@"productList"];
        _viewModel.storeItem = [self.parameters objectForKey:@"storeItem"];
        _viewModel.from = [[self.parameters objectForKey:@"from"] integerValue];

        _viewModel.funnel = [self.parameters objectForKey:@"funnel"];
        _viewModel.bannerId = [self.parameters objectForKey:@"bannerId"];
        _viewModel.bannerLocation = [self.parameters objectForKey:@"bannerLocation"];
        _viewModel.bannerTitle = [self.parameters objectForKey:@"bannerTitle"];
        _viewModel.source = [self.parameters objectForKey:@"source"];
        _viewModel.associatedId = [self.parameters objectForKey:@"associatedId"];

        _viewModel.plateId = [self.parameters objectForKey:@"plateId"];
        _viewModel.topicPageId = [self.parameters objectForKey:@"topicPageId"];
        _viewModel.collectType = [self.parameters objectForKey:@"collectType"];
        _viewModel.collectContent = [self.parameters objectForKey:@"collectContent"];
        _viewModel.searchId = [self.parameters objectForKey:@"searchId"];

        _viewModel.payFlag = [self.parameters objectForKey:@"payFlag"];
        _viewModel.shareCode = [self.parameters objectForKey:@"shareCode"];
        //是否到店自取
        _viewModel.pickUpStatus = [[self.parameters objectForKey:@"pickUpStatus"] boolValue];
    }
    return _viewModel;
}

- (void)dealloc {
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    NSTimeInterval oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WMOrderSubmitV2ViewControllerTime"] doubleValue];
    if (currentTime > oldTime) {
        [LKDataRecord.shared traceEvent:@"takeawayPageResidenceTime"
                                   name:@"takeawayPageResidenceTime"
                             parameters:@{
            @"storeNo": self.viewModel.storeItem.storeNo,
            @"type": @"submitOrderPage",
            @"pageSource": self.viewModel.pageSource,
            @"plateId": WMManage.shareInstance.plateId,
            @"time": @(currentTime - oldTime).stringValue
        }
                                    SPM:[LKSPM SPMWithPage:@"WMOrderSubmitV2ViewController" area:@"" node:@""]];
    }
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeOther;
}
@end

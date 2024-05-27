//
//  WMStoreDetailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailViewController.h"
#import "LKDataRecord.h"
#import "SAMessageButton.h"
#import "SANotificationConst.h"
#import "SATalkingData.h"
#import "WMCNStoreDetailView.h"
#import "WMCNStoreDetailViewModel.h"
#import "WMStoreDetailView.h"
#import "WMStoreDetailViewModel.h"


@interface WMStoreDetailViewController ()
/// 内容
@property (nonatomic, strong) WMStoreDetailBaseView *contentView;
/// VM
@property (nonatomic, strong) WMStoreDetailViewModel *viewModel;

@end


@implementation WMStoreDetailViewController
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];

    self.clientType = SAClientTypeYumNow;
    self.miniumGetNewDataDuration = 0;
    [self getNewData];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getNewData) name:kNotificationNameReloadStoreDetail object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reGetShoppingCartItems) name:kNotificationNameReloadStoreShoppingCart object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reGetShoppingCartItems) name:kNotificationNameOrderSubmitSuccess object:nil];

    if (self.viewModel.plateId) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
            @"type": self.viewModel.collectType,
            @"plateId": self.viewModel.plateId,
            @"content": @[self.viewModel.productId ?: self.viewModel.storeNo]
            
        }];
        if (self.viewModel.topicPageId) {
            mdic[@"topicPageId"] = self.viewModel.topicPageId;
        }
        [LKDataRecord.shared traceEvent:@"intoStore" name:@"intoStore" parameters:mdic SPM:[LKSPM SPMWithPage:@"WMStoreDetailViewController" area:@"" node:@""]];
    }
    self.viewModel.pageSource = [WMManage.shareInstance currentCompleteSource:self includeSelf:NO];
    HDLog(@"测试链路:%@", self.viewModel.source);
    [LKDataRecord traceYumNowEvent:@"store_detail_pv" name:@"外卖门店PV" ext:@{
        @"source" : self.viewModel.source,
        @"associatedId" : self.viewModel.associatedId,
        @"storeNo" : self.viewModel.storeNo
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ///计算页面停留时长
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", NSDate.date.timeIntervalSince1970] forKey:@"WMStoreDetailViewControllerTime"];
    

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    NSTimeInterval oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WMStoreDetailViewControllerTime"] doubleValue];
    if (currentTime > oldTime) {
        [LKDataRecord.shared traceEvent:@"takeawayPageResidenceTime" name:@"takeawayPageResidenceTime" parameters:@{
            @"storeNo": self.viewModel.storeNo,
            @"type": @"storePagePlaceOrder",
            @"pageSource": self.viewModel.pageSource,
            @"plateId": WMManage.shareInstance.plateId,
            @"activityNo": self.viewModel.plateId,
            @"time": @(currentTime - oldTime).stringValue
        }
                                    SPM:[LKSPM SPMWithPage:@"WMStoreDetailViewController" area:@"" node:@""]];
    }
    
    //暂停播放器
    if(self.contentView.player.isPlaying) {
        [self.contentView.player pauseForUser];
    }
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)getNewData {
    [self.viewModel getInitializedData];
}

- (void)hd_getNewData {
    // 触发消息更新
    [super hd_getNewData];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark - NSNotification
- (void)reGetShoppingCartItems {
    self.viewModel.needShowRequiredPriceChangeToast = true;
    [self.viewModel reGetShoppingCartItems];
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - override
- (BOOL)allowContinuousBePushed {
    return YES;
}

#pragma mark - private methods
// 重置viewModel参数
- (void)resetViewModelParameters {
    _viewModel.storeName = [self.parameters objectForKey:@"storeName"];
    _viewModel.storeNo = [self.parameters objectForKey:@"storeNo"];
    _viewModel.menuId = [self.parameters objectForKey:@"menuId"];
    _viewModel.productId = [self.parameters objectForKey:@"productId"];
    _viewModel.onceAgainOrderNo = [self.parameters objectForKey:@"onceAgainOrderNo"];
    _viewModel.isFromOnceAgain = HDIsStringNotEmpty(self.viewModel.onceAgainOrderNo);
    // 埋点参数
    _viewModel.source = [self.parameters objectForKey:@"source"];
    _viewModel.associatedId = [self.parameters objectForKey:@"associatedId"];

    _viewModel.plateId = [self.parameters objectForKey:@"plateId"];
    _viewModel.collectType = [self.parameters objectForKey:@"collectType"];
    _viewModel.collectContent = [self.parameters objectForKey:@"collectContent"];
    _viewModel.topicPageId = [self.parameters objectForKey:@"topicPageId"];
    _viewModel.searchId = [self.parameters objectForKey:@"searchId"];

    _viewModel.payFlag = [self.parameters objectForKey:@"payFlag"];
    _viewModel.shareCode = [self.parameters objectForKey:@"shareCode"];
}

#pragma mark - setter
- (void)setParameters:(NSDictionary<NSString *, id> *)parameters {
    [super setParameters:parameters];
    if (self.viewModel.hasGotInitializedData) {
        // 应用外打开门店页，需要根据对应门店号重新刷新数据
        [self resetViewModelParameters];
        [self getNewData];
    }
}

#pragma mark - lazy load
- (WMStoreDetailBaseView *)contentView {
    if (!_contentView) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            _contentView = [[WMCNStoreDetailView alloc] initWithViewModel:self.viewModel];
        } else {
            _contentView = [[WMStoreDetailView alloc] initWithViewModel:self.viewModel];
        }
    }
    return _contentView;
}

- (WMStoreDetailViewModel *)viewModel {
    if (!_viewModel) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            _viewModel = [[WMCNStoreDetailViewModel alloc] init];
        } else {
            _viewModel = [[WMStoreDetailViewModel alloc] init];
        }
        [self resetViewModelParameters];
    }
    return _viewModel;
}

- (NSString *)storeNo {
    return self.viewModel.storeNo;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeStoreDetail;
}
@end

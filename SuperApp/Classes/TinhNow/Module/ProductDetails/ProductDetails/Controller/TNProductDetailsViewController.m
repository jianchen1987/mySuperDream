//
//  TNSectionTableViewSceneViewController.m
//  SuperApp
//  普通商品详情 和 砍价商品详情 共用一个界面
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailsViewController.h"
#import "SATalkingData.h"
#import "TNBargainSuspendWindow.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductDetailsView.h"
#import "TNProductDetailsViewModel.h"


@interface TNProductDetailsViewController ()
/// 内容
@property (nonatomic, strong) TNProductDetailsView *contentView;
/// VM
@property (nonatomic, strong) TNProductDetailsViewModel *viewModel;
/// 商铺id
@property (nonatomic, copy) NSString *storeId;
/// 接受H5 带过来的参数key = f, f == buyNow
@property (nonatomic, copy) NSString *fValue;

@end


@implementation TNProductDetailsViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.viewModel.originParameters = parameters;

    NSString *productId = [parameters objectForKey:@"productId"];
    NSString *storeId = [parameters objectForKey:@"storeId"];
    NSString *shareCode = [parameters objectForKey:@"sc"];
    NSString *fValue = [parameters objectForKey:@"f"];
    NSString *funnel = parameters[@"funnel"]; //埋点
    NSString *sp = [parameters objectForKey:@"sp"];
    NSString *sn = [parameters objectForKey:@"sn"]; //商品编码
    NSString *channel = [parameters objectForKey:@"channel"];
    NSString *salesType = [parameters objectForKey:@"tab"]; //单买还是批量tab
    //是否来自选品中心
    NSString *isFromProductCenter = parameters[@"isFromProductCenter"];
    ///选品店铺的商品模型   用于加入或取消销售回传
    self.viewModel.sellerProductModel = parameters[@"sellerProductModel"];
    ///选品店铺 回调
    self.viewModel.addOrCancelSellerProductCallBack = parameters[@"addOrCancelSellerProductCallBack"];
    if (!HDIsObjectNil(productId) && HDIsStringNotEmpty(productId)) {
        self.viewModel.productId = productId;
    }

    // 图片搜索 只有sn 查询商品详情
    if (HDIsStringNotEmpty(sn)) {
        self.viewModel.sn = sn;
        self.viewModel.channel = channel;
    }

    if (HDIsStringNotEmpty(isFromProductCenter)) {
        self.viewModel.isFromProductCenter = [isFromProductCenter boolValue];
    }

    if (HDIsStringNotEmpty(sp)) {
        self.viewModel.sp = sp;
    }

    if (!HDIsObjectNil(storeId) && HDIsStringNotEmpty(productId)) {
        self.storeId = storeId;
    }

    if (HDIsStringNotEmpty(funnel)) {
        self.viewModel.funnel = funnel;
    }

    {
        if (!HDIsObjectNil(shareCode) && HDIsStringNotEmpty(shareCode)) {
            self.viewModel.shareCode = shareCode;
        }
        if (!HDIsObjectNil(fValue) && HDIsStringNotEmpty(fValue)) {
            self.fValue = fValue;
            self.viewModel.fValue = fValue;
        }
    }

    if (self.viewModel.isFromProductCenter == NO && HDIsStringNotEmpty(self.viewModel.sp)) {
        //第三方微店 标记vip用
        self.viewModel.supplierId = sp;
    }

    //    // 用户是卖家 进入的所有详情都是选品的详情  add by v2.9.4
    //    if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
    //        self.viewModel.isFromProductCenter = YES;
    //    }

    if (HDIsStringNotEmpty(salesType)) {
        self.viewModel.salesType = salesType;

    } else {
        ///默认展示单买tab
        self.viewModel.salesType = TNSalesTypeSingle;
    }

    self.viewModel.source = [self.parameters objectForKey:@"source"];
    self.viewModel.associatedId = [self.parameters objectForKey:@"associatedId"];

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.contentView.player vc_viewWillDisappear];
    //商品曝光埋点
    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:nil];
}
#pragma mark -

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentView.player vc_viewDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.contentView.player vc_viewDidDisappear];
    //更新选品店铺商品数据
    if (self.navigationController == nil && !HDIsObjectNil(self.viewModel.sellerProductModel)) {
        !self.viewModel.addOrCancelSellerProductCallBack ?: self.viewModel.addOrCancelSellerProductCallBack(self.viewModel.sellerProductModel);
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

//页面埋点
- (void)trackingPage {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    if (HDIsStringNotEmpty(self.viewModel.productId)) {
        properties[@"productId"] = self.viewModel.productId;
    }
    if (HDIsStringNotEmpty(self.viewModel.sn)) {
        properties[@"sn"] = self.viewModel.sn;
    }
    NSArray *pageNameArray = [[TNGlobalData trackingPageEventMap] objectForKey:NSStringFromClass([self class])];
    NSString *pageName = pageNameArray.firstObject;
    if (HDIsStringNotEmpty(self.viewModel.supplierId)) {
        properties[@"buyerId"] = self.viewModel.supplierId;
        pageName = pageNameArray[1];
    }
    [TNEventTrackingInstance trackPage:pageName properties:properties];
}
#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.centerX.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (TNProductDetailsView *)contentView {
    if (!_contentView) {
        _contentView = [[TNProductDetailsView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (TNProductDetailsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNProductDetailsViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark
- (BOOL)allowContinuousBePushed {
    return YES;
}

@end

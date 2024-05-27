//
//  WMStoreProductDetailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailViewController.h"
#import "WMStoreProductDetailView.h"
#import "WMStoreProductDetailViewModel.h"
#import "LKDataRecord.h"

@interface WMStoreProductDetailViewController ()
/// 内容
@property (nonatomic, strong) WMStoreProductDetailView *contentView;
/// VM
@property (nonatomic, strong) WMStoreProductDetailViewModel *viewModel;
@end


@implementation WMStoreProductDetailViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

- (BOOL)needLogin {
    return false;
}

- (void)getNewData {
    [self.viewModel getInitializedData];
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];

    self.miniumGetNewDataDuration = 0;
    [self getNewData];
    
    [LKDataRecord traceYumNowEvent:@"product_detail_pv" name:@"外卖商品PV" ext:@{
        @"source" : self.viewModel.source,
        @"associatedId" : self.viewModel.associatedId,
        @"storeNo" : self.viewModel.storeNo,
        @"goodsId" : self.viewModel.goodsId
    }];
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"StoreProductDetail", @"商品详情");
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    if (self.viewModel.hasGotInitializedData) {
        [self.viewModel reGetShoppingCartItems];
    }
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (WMStoreProductDetailView *)contentView {
    return _contentView ?: ({ _contentView = [[WMStoreProductDetailView alloc] initWithViewModel:self.viewModel]; });
}

- (WMStoreProductDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMStoreProductDetailViewModel alloc] init];
        _viewModel.storeNo = [self.parameters objectForKey:@"storeNo"];
        _viewModel.goodsId = [self.parameters objectForKey:@"goodsId"];
        _viewModel.availableBestSaleCount = [[self.parameters objectForKey:@"availableBestSaleCount"] integerValue];
        
        _viewModel.source = [self.parameters objectForKey:@"source"];
        _viewModel.associatedId = [self.parameters objectForKey:@"associatedId"];

        _viewModel.plateId = [self.parameters objectForKey:@"plateId"];
        _viewModel.searchId = [self.parameters objectForKey:@"searchId"];
        _viewModel.topicPageId = [self.parameters objectForKey:@"topicPageId"];
        _viewModel.collectType = [self.parameters objectForKey:@"collectType"];
        _viewModel.collectContent = [self.parameters objectForKey:@"collectContent"];

        _viewModel.payFlag = [self.parameters objectForKey:@"payFlag"];
        _viewModel.shareCode = [self.parameters objectForKey:@"shareCode"];
    }
    return _viewModel;
}
@end

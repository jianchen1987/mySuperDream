//
//  TNMicroShopViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopViewController.h"
#import "TNMenuNavView.h"
#import "TNMicroShopView.h"
#import "TNMicroShopViewModel.h"
#import "TNShareManager.h"


@interface TNMicroShopViewController ()
/// 内容视图
@property (strong, nonatomic) TNMicroShopView *contentView;
/// viewModel
@property (strong, nonatomic) TNMicroShopViewModel *viewModel;
/// 记录是否加载过
@property (nonatomic, assign) BOOL hadLoad;
@end


@implementation TNMicroShopViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.hadLoad && [TNGlobalData shared].seller.isNeedRefreshMicroShop) {
        [self.contentView reloadData];
        [TNGlobalData shared].seller.isNeedRefreshMicroShop = NO;
    }
}
// 页面埋点
- (void)trackingPage {
    [TNEventTrackingInstance trackPage:@"buyer" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId}];
}
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
    self.hadLoad = YES;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_more_my_shop_tips", @"我的微店");
    HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"tinhnow-black-share-new"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
}
- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self dismissAnimated:YES completion:nil];
}
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)shareClick {
    if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
        TNShareModel *shareModel = [[TNShareModel alloc] init];
        shareModel.shareImage = [TNGlobalData shared].seller.supplierImage;
        shareModel.shareTitle = [TNGlobalData shared].seller.nickName;
        shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
        shareModel.shareLink = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingFormat:@"%@%@", kTinhNowMicroShop, [TNGlobalData shared].seller.supplierId];
        [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];

        //分享微店埋点
        [TNEventTrackingInstance trackEvent:@"share" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"type": @"4"}];
    }
}
/** @lazy contentView */
- (TNMicroShopView *)contentView {
    if (!_contentView) {
        _contentView = [[TNMicroShopView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}
/** @lazy viewModel */
- (TNMicroShopViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNMicroShopViewModel alloc] init];
    }
    return _viewModel;
}
//- (TNMenuNavView *)navBarView {
//    if (!_navBarView) {
//        _navBarView = [[TNMenuNavView alloc] init];
//        _navBarView.leftImage = @"tn_back_image_new";
//        _navBarView.title = TNLocalizedString(@"tn_more_my_shop_tips", @"我的微店");
//        _navBarView.leftImageInset = 15.0f;
//        @HDWeakify(self);
//        _navBarView.clickedLeftViewBlock = ^{
//            @HDStrongify(self);
//            [self.parentViewController.navigationController popViewControllerAnimated:YES];
//        };
//        _navBarView.rightImage = @"tinhnow-black-share-new";
//        _navBarView.rightImageInset = 15.0f;
//        _navBarView.clickedRightViewBlock = ^{
//            if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
//                TNShareModel *shareModel = [[TNShareModel alloc] init];
//                shareModel.shareImage = [TNGlobalData shared].seller.supplierImage;
//                shareModel.shareTitle = [TNGlobalData shared].seller.nickName;
//                shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
//                shareModel.shareLink = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingFormat:@"%@%@", kTinhNowMicroShop, [TNGlobalData shared].seller.supplierId];
//                [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
//            }
//        };
//
//        [_navBarView updateConstraintsAfterSetInfo];
//    }
//    return _navBarView;
//}
@end

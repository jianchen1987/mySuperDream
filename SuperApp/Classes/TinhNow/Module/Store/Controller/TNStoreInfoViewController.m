//
//  TNStoreInfoViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreInfoViewController.h"
#import "SATalkingData.h"
#import "SAWindowManager.h"
#import "TNCustomTabBarView.h"
#import "TNIMManagerHander.h"
#import "TNIMManger.h"
#import "TNSellerSearchViewModel.h"
#import "TNShareManager.h"
#import "TNShoppingCartEntryWindow.h"
#import "TNStoreCategoryView.h"
#import "TNStoreHomeView.h"
#import "TNStoreTabBarView.h"
#import "TNStoreViewModel.h"


@interface TNStoreInfoViewController () <HDSearchBarDelegate>
/// searchBar
@property (nonatomic, strong) HDSearchBar *searchBar;
/// 店铺首页视图
@property (strong, nonatomic) TNStoreHomeView *homeView;
/// 店铺分类视图
@property (strong, nonatomic) TNStoreCategoryView *categoryView;
/// storeviewmodel
@property (nonatomic, strong) TNStoreViewModel *storeViewModel;
/// bottomView
//@property (nonatomic, strong) TNStoreTabBarView *bottomView;
@property (strong, nonatomic) TNCustomTabBarView *tabBarView; ///<

@end


@implementation TNStoreInfoViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    NSString *storeNo = [parameters objectForKey:@"storeNo"];
    NSString *funnel = parameters[@"funnel"]; //埋点
    NSString *isFromProductCenter = parameters[@"isFromProductCenter"];
    NSString *sp = parameters[@"sp"];
    if (HDIsStringNotEmpty(funnel)) {
        self.storeViewModel.funnel = funnel;
    }
    if (HDIsStringNotEmpty(isFromProductCenter)) {
        self.storeViewModel.isFromProductCenter = [isFromProductCenter boolValue];
    }
    if (HDIsStringNotEmpty(sp)) {
        self.storeViewModel.sp = sp;
    }
    if (HDIsStringNotEmpty(storeNo)) {
        self.storeViewModel.storeNo = storeNo;
    }

    self.storeViewModel.source = [self.parameters objectForKey:@"source"];
    self.storeViewModel.associatedId = [self.parameters objectForKey:@"associatedId"];

    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[TNShoppingCartEntryWindow sharedInstance] show];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TNShoppingCartEntryWindow sharedInstance] dismiss];
    //滚动浏览埋点
    [self.storeViewModel trackScrollProductsExposure];
}
- (void)hd_setupViews {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
    [self.view addSubview:self.searchBar];
    //    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.homeView];
    [self.view addSubview:self.tabBarView];
}
// 页面埋点
- (void)trackingPage {
    [TNEventTrackingInstance trackPage:@"store_home" properties:@{@"storeId": self.storeViewModel.storeNo}];
}

- (void)hd_bindViewModel {
    self.storeViewModel.view = self.view;
    @HDWeakify(self);
    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        [self.KVOController hd_observe:self.storeViewModel keyPath:@"microShopInfo" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.tabBarView.hidden = NO;
        }];
    } else {
        [self.KVOController hd_observe:self.storeViewModel keyPath:@"storeInfo" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            self.tabBarView.hidden = NO;
            [SATalkingData trackEvent:[self.storeViewModel.trackPrefixName stringByAppendingString:@"进入店铺主页"]];
        }];
    }
}
- (void)updateViewConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height);
        make.height.mas_equalTo(44);
    }];
    [self.homeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.equalTo(self.tabBarView.mas_top);
    }];
    if (self.categoryView != nil) {
        [self.categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom);
            make.bottom.equalTo(self.tabBarView.mas_top);
        }];
    }
    [self.tabBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mas_bottomLayoutGuideTop).offset(-kRealWidth(50));
    }];

    [super updateViewConstraints];
}
#pragma mark 获取商户客服列表
- (void)getCustomerList:(NSString *)storeNo {
    [self.view showloading];
    @HDWeakify(self);
    [[TNIMManger shared] getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            HDLog(@"%@", imModel);
            [self openIMViewControllerWithOperatorNo:imModel.operatorNo storeNo:storeNo];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}
#pragma mark 进入客服页面
- (void)openIMViewControllerWithOperatorNo:(NSString *)operatorNo storeNo:(NSString *)storeNo {
    NSDictionary *dict = @{@"operatorType": @(8), @"operatorNo": operatorNo ?: @"", @"storeNo": storeNo ?: @"", @"scene": SAChatSceneTypeTinhNowConsult};
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}
#pragma mark - 点击搜索
- (void)clickedSearchHandler {
    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeNormal) {
        if (HDIsStringEmpty(self.storeViewModel.storeNo)) {
            return;
        }
        [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:@{@"storeNo": self.storeViewModel.storeNo}];
    } else if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
        if (HDIsStringEmpty(self.storeViewModel.storeNo)) {
            return;
        }
        [[HDMediator sharedInstance]
            navigaveToTinhNowSellerSearchViewController:@{@"type": @(TNMicroShopProductSearchTypeNone), @"sp": self.storeViewModel.sp, @"storeNo": self.storeViewModel.storeNo}];
    } else {
        if (HDIsStringEmpty(self.storeViewModel.sp)) {
            return;
        }
        [[HDMediator sharedInstance] navigaveToTinhNowSellerSearchViewController:@{@"type": @(TNMicroShopProductSearchTypeUser), @"sp": self.storeViewModel.sp}];
    }
}
///创建分类视图
- (void)createCategoryView {
    self.categoryView = [[TNStoreCategoryView alloc] initWithViewModel:self.storeViewModel];
    [self.view addSubview:self.categoryView];
    [self.categoryView layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
}
#pragma mark - HDSearchBarDelegate
- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    if (self.storeViewModel.storeViewShowType == TNStoreViewShowTypeMicroShop) {
        if (HDIsObjectNil(self.storeViewModel.microShopInfo)) {
            return;
        }
        TNShareModel *shareModel = [[TNShareModel alloc] init];
        shareModel.shareImage = self.storeViewModel.microShopInfo.supplierImage;
        shareModel.shareTitle = self.storeViewModel.microShopInfo.nickName;
        shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
        shareModel.shareLink = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingFormat:@"%@%@", kTinhNowMicroShop, self.storeViewModel.microShopInfo.supplierId];
        shareModel.sourceId = self.storeViewModel.microShopInfo.supplierId;
        [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
    } else {
        if (!self.storeViewModel.storeInfo) {
            return;
        }
        TNShareModel *shareModel = [[TNShareModel alloc] init];
        shareModel.shareImage = self.storeViewModel.storeInfo.logo;
        shareModel.shareTitle = self.storeViewModel.storeInfo.name.desc;
        shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
        shareModel.shareLink = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingFormat:@"%@%@", kTinhNowStoreHomePage, self.storeViewModel.storeInfo.storeNo];
        shareModel.sourceId = self.storeViewModel.storeInfo.storeNo;
        [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
        [TNEventTrackingInstance trackEvent:@"share" properties:@{@"storeId": self.storeViewModel.storeInfo.storeNo}];
    }
}

//设置底部tab数据
- (NSArray<TNCustomTabBarItem *> *)getCustomTabBarItemArr {
    NSMutableArray *arr = [NSMutableArray array];
    TNCustomTabBarItem *item = [TNCustomTabBarItem itemWithTitle:TNLocalizedString(@"tn_tabbar_home_title", @"首页") unSelectImageName:@"tn_store_tab_index_unselected"
                                                 selectImageName:@"tn_store_tab_index_selected"
                                                   unSelectColor:HDAppTheme.TinhNowColor.G3
                                                     selectColor:HDAppTheme.TinhNowColor.C1
                                                            font:HDAppTheme.TinhNowFont.standard12];
    [arr addObject:item];

    item = [TNCustomTabBarItem itemWithTitle:TNLocalizedString(@"tn_tabbar_category_title", @"分类") unSelectImageName:@"tn_store_tab_category_unselected"
                             selectImageName:@"tn_store_tab_category_selected"
                               unSelectColor:HDAppTheme.TinhNowColor.G3
                                 selectColor:HDAppTheme.TinhNowColor.C1
                                        font:HDAppTheme.TinhNowFont.standard12];
    [arr addObject:item];

    if (self.storeViewModel.storeViewShowType != TNStoreViewShowTypeMicroShop) {
        //用户进入的微店 没有客服
        item = [TNCustomTabBarItem itemWithTitle:TNLocalizedString(@"tn_product_customer", @"客服") unSelectImageName:@"tn_store_tab_customer" selectImageName:nil
                                   unSelectColor:HDAppTheme.TinhNowColor.G3
                                     selectColor:HDAppTheme.TinhNowColor.C1
                                            font:HDAppTheme.TinhNowFont.standard12];
        [arr addObject:item];
    }

    return arr;
}
/** @lazy tabBarView */
- (TNCustomTabBarView *)tabBarView {
    if (!_tabBarView) {
        TNCustomTabBarConfig *config = [[TNCustomTabBarConfig alloc] init];
        config.tabBarItems = [self getCustomTabBarItemArr];
        _tabBarView = [TNCustomTabBarView tabBarViewWithConfig:config];
        _tabBarView.hidden = YES;
        _tabBarView.selectedIndex = 0;
        @HDWeakify(self);
        _tabBarView.tabBarItemClickCallBack = ^(NSInteger index) {
            @HDStrongify(self);
            switch (index) {
                case 0: {
                    self.homeView.hidden = NO;
                    self.categoryView.hidden = YES;
                    [[TNShoppingCartEntryWindow sharedInstance] show];
                } break;
                case 1: {
                    self.homeView.hidden = YES;
                    if (self.categoryView) {
                        self.categoryView.hidden = NO;
                    } else {
                        [self createCategoryView];
                    }
                    [[TNShoppingCartEntryWindow sharedInstance] dismiss];
                    [SATalkingData trackEvent:[self.storeViewModel.trackPrefixName stringByAppendingString:@"店铺主页_点击分类"]];

                    //点击店铺分类
                    [TNEventTrackingInstance trackEvent:@"category" properties:@{@"storeId": self.storeViewModel.storeNo, @"type": @"2"}];
                } break;
                case 2: {
                    [SATalkingData trackEvent:[self.storeViewModel.trackPrefixName stringByAppendingString:@"店铺主页_点击客服"]];
                    //点击客服
                    [TNEventTrackingInstance trackEvent:@"store_im" properties:@{@"storeId": self.storeViewModel.storeNo}];
                    [self getCustomerList:self.storeViewModel.storeNo];
                } break;

                default:
                    break;
            }
        };
    }
    return _tabBarView;
}
/** @lazy viewmodel */
- (TNStoreViewModel *)storeViewModel {
    if (!_storeViewModel) {
        _storeViewModel = [[TNStoreViewModel alloc] init];
    }
    return _storeViewModel;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.showBottomShadow = NO;
        [_searchBar setLeftButtonImage:[UIImage imageNamed:@"tn_back_image_new"]];
        [_searchBar setShowLeftButton:true animated:true];
        _searchBar.textFieldHeight = 34;
        _searchBar.placeHolder = TNLocalizedString(@"tn_page_store_search_title", @"Search");
        _searchBar.borderColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:1.0];
        _searchBar.placeholderColor = HDAppTheme.TinhNowColor.G3;
        if (self.storeViewModel.storeViewShowType != TNStoreViewShowTypeSellerToAdd) {
            [_searchBar setRightButtonImage:[UIImage imageNamed:@"tinhnow-black-share-new"]];
            [_searchBar setShowRightButton:YES animated:NO];
        }
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSearchHandler)];
        [_searchBar.textField addGestureRecognizer:recognizer];
    }
    return _searchBar;
}

/** @lazy homeView */
- (TNStoreHomeView *)homeView {
    if (!_homeView) {
        _homeView = [[TNStoreHomeView alloc] initWithViewModel:self.storeViewModel];
        @HDWeakify(self);
        _homeView.moreCategoryClickCallback = ^{
            @HDStrongify(self);
            self.tabBarView.selectedIndex = 1;
            //            [self.bottomView sendActiconClickType:TNStoreTabBarViewItemClickTypeCategory];
        };
    }
    return _homeView;
}
///** @lazy categoryView */
//- (TNStoreCategoryView *)categoryView {
//    if (!_categoryView) {
//        _categoryView = [[TNStoreCategoryView alloc] initWithViewModel:self.storeViewModel];
//        _categoryView.hidden = YES;
//    }
//    return _categoryView;
//}
#pragma mark - navgationBarConfig
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}
@end

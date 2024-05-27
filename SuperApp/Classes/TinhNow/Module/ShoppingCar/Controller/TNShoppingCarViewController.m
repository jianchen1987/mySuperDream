
//
//  WMShoppingCartViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCarViewController.h"
#import "SAAppEnvConfig.h"
#import "SAAppEnvManager.h"
#import "SAOrderNotLoginView.h"
#import "SATableView.h"
#import "TNBatchShopCarView.h"
#import "TNExplanationAlertView.h"
#import "TNProductDTO.h"
#import "TNProductPurchaseTypeModel.h"
#import "TNQueryUserShoppingCarRspModel.h"
#import "TNShopCarTabView.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarDTO.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNShoppingCartTableViewCell+Skeleton.h"
#import "TNShoppingCartTableViewCell.h"
#import "TNSingleShopCarView.h"
#import "TNStoreInfoViewController.h"


@interface TNShoppingCarViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// tab栏目
@property (strong, nonatomic) TNShopCarTabView *tabView;
/// 数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;
/// dto
@property (nonatomic, strong) TNProductDTO *productDTO;
///单买 批量购买说明
@property (strong, nonatomic) TNProductPurchaseTypeModel *purchaseTypeModel;
/// 默认选中单买还是批量
@property (nonatomic, copy) TNSalesType salesType;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// 删除按钮
@property (strong, nonatomic) HDUIButton *deleteButton;
@end


@implementation TNShoppingCarViewController
- (void)dealloc {
    self.shopCarDataCenter.hasUpdateBatchTotalCount = NO;
    self.shopCarDataCenter.hasUpdateSingleTotalCount = NO;

    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    //订单再次购买的 skuIds
    [TNShoppingCar share].reBuySkuIds = [parameters objectForKey:@"skuIds"];
    self.salesType = [parameters objectForKey:@"tab"];
    if (HDIsStringEmpty(self.salesType)) {
        self.salesType = TNSalesTypeSingle;
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_product_cart", @"购物车");
    self.hd_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleteButton];
}
- (void)hd_setupViews {
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
    [self.categoryTitleView addSubview:self.tabView];
    [self.view addSubview:self.notSignInView];

    [self.tabView setCurrentSalesType:self.salesType];

    [self setCurrentCategorySelectIndexWithDefaultIndex:YES];

    @HDWeakify(self);
    self.tabView.toggleCallBack = ^(TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        self.salesType = salesType;
        [self setCurrentCategorySelectIndexWithDefaultIndex:NO];
    };
    self.tabView.buyQustionCallBack = ^(TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        [self showBuyQuestionAlertView:salesType];
    };

    [self queryUserShoppingTotalCount];
    [self.tabView updateSingleCount:self.shopCarDataCenter.singleTotalCount];
    [self.tabView updateBatchCount:self.shopCarDataCenter.batchTotalCount];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
}
/// 点击删除
- (void)onClickDeleteShopCar {
    id<HDCategoryListContentViewDelegate> targetView = self.listContainerView.validListDict[@(self.categoryTitleView.selectedIndex)];
    if ([targetView isKindOfClass:[TNSingleShopCarView class]]) {
        TNSingleShopCarView *singleView = (TNSingleShopCarView *)targetView;
        [singleView onDeleteShopCarProducts];
    } else if ([targetView isKindOfClass:[TNBatchShopCarView class]]) {
        TNBatchShopCarView *batchView = (TNBatchShopCarView *)targetView;
        [batchView onDeleteShopCarProducts];
    }
}
///请求购物车总数
- (void)queryUserShoppingTotalCount {
    if ([SAUser hasSignedIn]) {
        [self.shopCarDataCenter queryUserShoppingTotalCountSuccess:nil failure:nil];
    }
}
#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
}
//设置当前列表选中位置
- (void)setCurrentCategorySelectIndexWithDefaultIndex:(BOOL)isNeedSetDefaultIndex {
    if ([self.salesType isEqualToString:TNSalesTypeSingle]) {
        if (isNeedSetDefaultIndex) {
            self.categoryTitleView.defaultSelectedIndex = 0;
            [self.listContainerView setDefaultSelectedIndex:0];
        } else {
            if (self.categoryTitleView.selectedIndex != 0) {
                [self.categoryTitleView selectItemAtIndex:0];
                [self.listContainerView didClickSelectedItemAtIndex:0];
            }
        }

    } else if ([self.salesType isEqualToString:TNSalesTypeBatch]) {
        if (isNeedSetDefaultIndex) {
            self.categoryTitleView.defaultSelectedIndex = 1;
            [self.listContainerView setDefaultSelectedIndex:1];
        } else {
            if (self.categoryTitleView.selectedIndex != 1) {
                [self.categoryTitleView selectItemAtIndex:1];
                [self.listContainerView didClickSelectedItemAtIndex:1];
            }
        }
    }
}
#pragma mark - 展示单买 批量购买 疑问按钮
- (void)showBuyQuestionAlertView:(TNSalesType)buyType {
    @HDWeakify(self);
    void (^showAlert)(void) = ^void {
        @HDStrongify(self);
        NSString *title = [buyType isEqualToString:TNSalesTypeSingle] ? TNLocalizedString(@"6jak19x8", @"单买") : TNLocalizedString(@"d6Te2ndf", @"批量");
        NSString *content = [buyType isEqualToString:TNSalesTypeSingle] ? self.purchaseTypeModel.singlePrice : self.purchaseTypeModel.batchPrice;

        TNExplanationAlertView *alertView = [[TNExplanationAlertView alloc] initWithTitle:title content:content];
        [alertView show];
    };
    if (!HDIsObjectNil(self.purchaseTypeModel)) {
        showAlert();
    } else {
        [self.view showloading];

        [self.productDTO queryBuyPurchaseTypeSuccess:^(TNProductPurchaseTypeModel *_Nonnull model) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.purchaseTypeModel = model;
            showAlert();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"singleTotalCount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tabView updateSingleCount:self.shopCarDataCenter.singleTotalCount];
    }];
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"batchTotalCount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tabView updateBatchCount:self.shopCarDataCenter.batchTotalCount];
    }];
}
- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.tabView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.categoryTitleView);
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        TNSingleShopCarView *singleView = [[TNSingleShopCarView alloc] init];
        return singleView;
    } else {
        TNBatchShopCarView *batchView = [[TNBatchShopCarView alloc] init];
        return batchView;
    }
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return 2;
}

- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.titles = @[@"", @""];
        _categoryTitleView.delegate = self;
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.cellWidth = kScreenWidth / 2;
        _categoryTitleView.cellSpacing = 0;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
}
/** @lazy  */
- (TNShopCarTabView *)tabView {
    if (!_tabView) {
        _tabView = [[TNShopCarTabView alloc] init];
    }
    return _tabView;
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}
/** @lazy productDTO */
- (TNProductDTO *)productDTO {
    if (!_productDTO) {
        _productDTO = [[TNProductDTO alloc] init];
    }
    return _productDTO;
}
- (SAOrderNotLoginView *)notSignInView {
    if (!_notSignInView) {
        _notSignInView = SAOrderNotLoginView.new;
        _notSignInView.hidden = SAUser.hasSignedIn;
        _notSignInView.clickedSignInSignUpBTNBlock = ^{
            [SAWindowManager switchWindowToLoginViewController];
        };
    }
    return _notSignInView;
}
/** @lazy deleteButton */
- (HDUIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[HDUIButton alloc] init];
        [_deleteButton setTitle:TNLocalizedString(@"tn_delete", @"删除") forState:UIControlStateNormal];
        [_deleteButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = HDAppTheme.TinhNowFont.standard13;
        [_deleteButton addTarget:self action:@selector(onClickDeleteShopCar) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
@end

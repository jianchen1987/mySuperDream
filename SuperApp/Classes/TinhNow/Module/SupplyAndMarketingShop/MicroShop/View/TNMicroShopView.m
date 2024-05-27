//
//  TNMicroShopView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopView.h"
#import "TNMarkupPriceSettingAlertView.h"
#import "TNMicroShopLeftCategoryView.h"
#import "TNMicroShopRightProductsView.h"
#import "TNMicroShopViewModel.h"


@interface TNMicroShopView ()
/// 店铺信息视图
@property (strong, nonatomic) UIView *shopInfoView;
/// 店铺图片
@property (strong, nonatomic) UIImageView *shopImageView;
/// 店铺名称
@property (strong, nonatomic) UILabel *shopNameLabel;
/// 店铺号
@property (strong, nonatomic) UILabel *shopNoLabel;
/// 荣誉标识
@property (strong, nonatomic) UIImageView *honorLogoImageView;
/// 加价按钮
@property (strong, nonatomic) HDUIButton *markUpPriceButton;
/// 选品按钮
@property (strong, nonatomic) HDUIButton *selectionProductButton;
/// searchBar
@property (nonatomic, strong) HDSearchBar *searchBar;

///容器
@property (strong, nonatomic) TNView *containerView;
/// 左边分类视图
@property (strong, nonatomic) TNMicroShopLeftCategoryView *leftView;
/// 右边商品视图
@property (strong, nonatomic) TNMicroShopRightProductsView *rightView;
/// viewModel
@property (strong, nonatomic) TNMicroShopViewModel *viewModel;

@end


@implementation TNMicroShopView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.shopInfoView];
    [self.shopInfoView addSubview:self.shopImageView];
    [self.shopInfoView addSubview:self.shopNameLabel];
    [self.shopInfoView addSubview:self.shopNoLabel];
    [self.shopInfoView addSubview:self.honorLogoImageView];
    [self addSubview:self.selectionProductButton];
    [self addSubview:self.markUpPriceButton];
    [self addSubview:self.searchBar];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.leftView];
    [self.containerView addSubview:self.rightView];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    @HDWeakify(self);
    self.viewModel.failGetNewDataCallback = ^{
        @HDStrongify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            [self loadData];
        }];
    };

    [self loadData];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(self.viewModel.categoryList)) {
            [self.viewModel.categoryList insertObject:[self.viewModel getDefaultCategoryModel] atIndex:0];
            self.leftView.dataArr = self.viewModel.categoryList;
        } else {
            [self showNoDataPlacehold];
        }
    }];
}
- (void)loadData {
    [self.containerView removePlaceHolder];
    if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId) && [[TNGlobalData shared].seller.loginName isEqualToString:[SAUser shared].loginName]) {
        [self updateShopInfoData];
        [self getCategoryDataAndProductsData];
        //也重新拉取最新的店铺数据
        @HDWeakify(self);
        [self.viewModel getMyMicroShopInfoComplete:^{
            @HDStrongify(self);
            [self updateShopInfoData];
        }];
    } else {
        @HDWeakify(self);
        [self.viewModel getMyMicroShopInfoComplete:^{
            @HDStrongify(self);
            [self updateShopInfoData];
            [self getCategoryDataAndProductsData];
        }];
    }
}
#pragma mark -public method
- (void)reloadData {
    [self loadData];
}
//获取分类和商品数据
- (void)getCategoryDataAndProductsData {
    //获取加价策略 数据
    [self.viewModel getSellerPricePolicyData];
    [self.viewModel.categoryList removeAllObjects];
    [self.viewModel.categoryList insertObject:[self.viewModel getDefaultCategoryModel] atIndex:0];
    self.leftView.dataArr = self.viewModel.categoryList;
    //拉取全部分类
    [self.viewModel getProductsNewData:YES];
    [self.viewModel getMicroShopCategoryData];
}
//加载无数据视图
- (void)showNoDataPlacehold;
{
    UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
    model.backgroundColor = [UIColor whiteColor];
    model.title = SALocalizedString(@"no_data", @"暂无数据");
    model.image = @"tn_seller_no_data";
    [self.containerView showPlaceHolder:model NeedRefrenshBtn:NO refrenshCallBack:nil];
}
///刷新店铺数据
- (void)updateShopInfoData {
    if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierImage)) {
        [HDWebImageManager setImageWithURL:[TNGlobalData shared].seller.supplierImage placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(50, 50)] imageView:self.shopImageView];
    } else {
        self.shopImageView.image = [UIImage imageNamed:@"tn_microshop_defalut"];
    }

    self.shopNameLabel.text = [TNGlobalData shared].seller.nickName;
    self.shopNoLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"wkqZNwOl", @"微店号"), [TNGlobalData shared].seller.supplierId];
    self.honorLogoImageView.hidden = ![TNGlobalData shared].seller.isHonor;
}
- (void)updateConstraints {
    [self.shopInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    [self.shopImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopInfoView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.shopInfoView.mas_bottom).offset(-kRealWidth(15));
        make.left.equalTo(self.shopInfoView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
    }];
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopImageView.mas_top);
        make.left.equalTo(self.shopImageView.mas_right).offset(kRealWidth(10));
        if (self.honorLogoImageView.isHidden) {
            make.right.lessThanOrEqualTo(self.shopInfoView.mas_right).offset(-kRealWidth(15));
        }
    }];
    if (!self.honorLogoImageView.isHidden) {
        [self.honorLogoImageView sizeToFit];
        [self.honorLogoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.shopNameLabel.mas_centerY);
            make.right.lessThanOrEqualTo(self.shopInfoView.mas_right).offset(-kRealWidth(15));
            make.left.equalTo(self.shopNameLabel.mas_right).offset(kRealWidth(10));
        }];
        [self.honorLogoImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.shopNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    [self.shopNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.shopImageView.mas_bottom).offset(-kRealWidth(1));
        make.leading.equalTo(self.shopNameLabel.mas_leading);
        make.right.equalTo(self.shopInfoView.mas_right).offset(-kRealWidth(15));
    }];

    [self.selectionProductButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopInfoView.mas_bottom).offset(kRealWidth(5));
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.width.equalTo(self.markUpPriceButton.mas_width);
        make.height.mas_equalTo(kRealWidth(35));
    }];

    [self.markUpPriceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectionProductButton.mas_right).offset(kRealWidth(25));
        make.centerY.equalTo(self.selectionProductButton);
        make.height.equalTo(self.selectionProductButton.mas_height);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectionProductButton.mas_bottom).offset(kRealWidth(5));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(55));
    }];

    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.containerView);
        make.width.mas_equalTo(kRealWidth(80));
    }];
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftView.mas_top);
        make.left.equalTo(self.leftView.mas_right);
        make.right.bottom.equalTo(self.containerView);
    }];
    [super updateConstraints];
}
#pragma mark - 点击搜索
- (void)clickedSearchHandler {
    [[HDMediator sharedInstance] navigaveToTinhNowSellerSearchViewController:@{@"type": @(TNMicroShopProductSearchTypeSeller), @"sp": [TNGlobalData shared].seller.supplierId}];
}
/** @lazy shopInfoView */
- (UIView *)shopInfoView {
    if (!_shopInfoView) {
        _shopInfoView = [[UIView alloc] init];
    }
    return _shopInfoView;
}
/** @lazy shopImageView */
- (UIImageView *)shopImageView {
    if (!_shopImageView) {
        _shopImageView = [[UIImageView alloc] init];
        _shopImageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(50, 50)];
    }
    return _shopImageView;
}
/** @lazy shopNameLabel */
- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _shopNameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:17];
        _shopNameLabel.text = @"--";
    }
    return _shopNameLabel;
}
/** @lazy shopNoLabel */
- (UILabel *)shopNoLabel {
    if (!_shopNoLabel) {
        _shopNoLabel = [[UILabel alloc] init];
        _shopNoLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _shopNoLabel.font = HDAppTheme.TinhNowFont.standard12;
        _shopNoLabel.text = @"--";
    }
    return _shopNoLabel;
}
/** @lazy markUpPriceButton */
- (HDUIButton *)markUpPriceButton {
    if (!_markUpPriceButton) {
        _markUpPriceButton = [[HDUIButton alloc] init];
        _markUpPriceButton.backgroundColor = [UIColor whiteColor];
        _markUpPriceButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_markUpPriceButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        [_markUpPriceButton setImage:[UIImage imageNamed:@"tn_seller_price_proxy"] forState:UIControlStateNormal];
        _markUpPriceButton.spacingBetweenImageAndTitle = 5;
        [_markUpPriceButton setTitle:TNLocalizedString(@"GDhE2k66", @"加价设置") forState:UIControlStateNormal];
        _markUpPriceButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18 borderWidth:1 borderColor:HDAppTheme.TinhNowColor.C1];
        };
        [_markUpPriceButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
                TNMarkupPriceSettingConfig *config = [TNMarkupPriceSettingConfig defaultConfig];
                TNMarkupPriceSettingAlertView *alertView = [[TNMarkupPriceSettingAlertView alloc] initAlertViewWithConfig:config];
                [alertView show];
            }
        }];
    }
    return _markUpPriceButton;
}
/** @lazy selectionProductButton */
- (HDUIButton *)selectionProductButton {
    if (!_selectionProductButton) {
        _selectionProductButton = [[HDUIButton alloc] init];
        _selectionProductButton.backgroundColor = [UIColor whiteColor];
        _selectionProductButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_selectionProductButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        [_selectionProductButton setImage:[UIImage imageNamed:@"tn_selection_product"] forState:UIControlStateNormal];
        [_selectionProductButton setTitle:TNLocalizedString(@"4pFeIHa1", @"我要选品") forState:UIControlStateNormal];
        _selectionProductButton.spacingBetweenImageAndTitle = 5;
        _selectionProductButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18 borderWidth:1 borderColor:HDAppTheme.TinhNowColor.C1];
        };
        @HDWeakify(self);
        [_selectionProductButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (HDIsStringNotEmpty([TNGlobalData shared].seller.supplierId)) {
                [[HDMediator sharedInstance] navigaveToTinhNowProductCenterViewController:@{}];
                //我要选品埋点
                [TNEventTrackingInstance trackEvent:@"buyer_list_product"
                                         properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"categoryId": self.viewModel.searchSortFilterModel.categoryId}];
            }
        }];
    }
    return _selectionProductButton;
}
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        [_searchBar disableTextField];
        _searchBar.showBottomShadow = NO;
        [_searchBar setShowLeftButton:NO animated:NO];
        _searchBar.textFieldHeight = 34;
        _searchBar.placeHolder = TNLocalizedString(@"zhf9RwCh", @"搜索店铺商品");
        _searchBar.placeholderColor = HDAppTheme.TinhNowColor.G3;
        [_searchBar setShowRightButton:NO animated:NO];
        _searchBar.textFont = HDAppTheme.TinhNowFont.standard14;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSearchHandler)];
        [_searchBar addGestureRecognizer:recognizer];
    }
    return _searchBar;
}
/** @lazy leftView */
- (TNMicroShopLeftCategoryView *)leftView {
    if (!_leftView) {
        _leftView = [[TNMicroShopLeftCategoryView alloc] init];
        @HDWeakify(self);
        _leftView.categoryClickCallBack = ^(TNFirstLevelCategoryModel *_Nonnull model) {
            @HDStrongify(self);
            self.viewModel.searchSortFilterModel.categoryId = model.categoryId;
            [self.viewModel getProductsNewData:YES];
            //切换分类埋点
            [TNEventTrackingInstance trackEvent:@"switch_category" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId, @"type": @"4", @"categoryId": model.categoryId}];
        };
    }
    return _leftView;
}
/** @lazy rightView */
- (TNMicroShopRightProductsView *)rightView {
    if (!_rightView) {
        _rightView = [[TNMicroShopRightProductsView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _rightView.deleteAllProductsCallBack = ^{
            @HDStrongify(self);
            //分类id置空
            self.viewModel.searchSortFilterModel.categoryId = @"";
            [self loadData];
        };
    }
    return _rightView;
}
/** @lazy containerView */
- (TNView *)containerView {
    if (!_containerView) {
        _containerView = [[TNView alloc] init];
    }
    return _containerView;
}
/** @lazy honorLogoImageView */
- (UIImageView *)honorLogoImageView {
    if (!_honorLogoImageView) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", @"tn_highquality_store", [TNMultiLanguageManager currentLanguage]];
        _honorLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        _honorLogoImageView.hidden = YES;
    }
    return _honorLogoImageView;
}
@end

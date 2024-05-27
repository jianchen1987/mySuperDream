//
//  TNSectionTableViewSceneView.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailsView.h"
#import "LKDataRecord.h"
#import "NSString+extend.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "SJAttributesFactory.h"
#import "SJDeviceVolumeAndBrightnessManager.h"
#import "SJFloatSmallViewController.h"
#import "TNBargainSelectGoodsView.h"
#import "TNBargainSuspendWindow.h"
#import "TNBargainTipsView.h"
#import "TNBargainViewModel.h"
#import "TNCustomerServiceView.h"
#import "TNDeliverFlowModel.h"
#import "TNGlobalData.h"
#import "TNIMManger.h"
#import "TNInsetInfoTableViewCell.h"
#import "TNItemModel.h"
#import "TNPhoneActionAlertView.h"
#import "TNPopMenuCell.h"
#import "TNProductBannerCell.h"
#import "TNProductBaseInfoCell.h"
#import "TNProductBatchBuyPriceCell.h"
#import "TNProductBatchToggleCell.h"
#import "TNProductBuyTipsView.h"
#import "TNProductDeliveryInfoViewController.h"
#import "TNProductDetailBottomView.h"
#import "TNProductDetailCardCell.h"
#import "TNProductDetailExpressCell.h"
#import "TNProductDetailPublicImgCell.h"
#import "TNProductDetailRecommendCell.h"
#import "TNProductDetailServiceCell.h"
#import "TNProductDetailSkeletonCell.h"
#import "TNProductDetailsActivityCell.h"
#import "TNProductDetailsBargainBottomView.h"
#import "TNProductDetailsIntroTableViewCell.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductDetailsStoreCell.h"
#import "TNProductDetailsViewModel.h"
#import "TNProductNavigationBarView.h"
#import "TNProductReviewTableViewCell.h"
#import "TNProductSaleRegionAlertView.h"
#import "TNProductSaleRegionModel.h"
#import "TNProductSepcInfoModel.h"
#import "TNProductServiceAlertView.h"
#import "TNProductServiceInfoModel.h"
#import "TNProductSingleBuyPriceCell.h"
#import "TNShareManager.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNSingleVideoCollectionViewCell.h"
#import "TNSkuSpecModel.h"
#import "TNSpecificationSelectAlertView.h"
#import "TNTool.h"
#import "UIView+NAT.h"
#import "UIView+SJAnimationAdded.h"
#import "YBPopupMenu.h"
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>
#import <MessageUI/MessageUI.h>

#define kTableHeaderHeight 45
#define kTableFooterSpace kRealWidth(8)

static SJEdgeControlButtonItemTag TNEdgeControlBottomMuteButtonItemTag = 101; //声音按钮
static SJEdgeControlButtonItemTag TNEdgeControlCenterPlayButtonItemTag = 102; //播放按钮


@interface TNProductDetailsView () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>
/// VM
@property (nonatomic, strong) TNProductDetailsViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 底部视图
@property (nonatomic, strong) TNProductDetailBottomView *bottomView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
///< iPhoneX 系列底部填充
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;
/// 商品详情导航栏
@property (strong, nonatomic) TNProductNavigationBarView *customNaviBar;
/// pop 的数据源
@property (nonatomic, strong) NSArray<TNPopMenuCellModel *> *menuDataSourceArray;
///
@property (nonatomic, strong) NSMutableArray *navTitleSectionArray;

/// 播放器
@property (strong, nonatomic) SJVideoPlayer *player;
/// 播放器视图的位置  记录一次
@property (nonatomic, assign) CGFloat playerMaxY;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNProductDetailsView

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
}
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self addSubview:self.tableView];
    [self addSubview:self.customNaviBar];
    [self.customNaviBar hiddenShareAndMoreBtn];
    [self addSubview:self.bottomView];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];

    //请求详情数据
    [self.viewModel queryNomalProductDetailsData];
    @HDWeakify(self);
    self.viewModel.failGetProductDetaulDataCallBack = ^(SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //商品失效或者下架 需要展示回到首页错误视图
        BOOL showGoBackHome = [rspModel.code isEqualToString:@"TN1004"] || [rspModel.code isEqualToString:@"TN1003"];
        self.dataSource = [NSArray array];
        UIViewPlaceholderViewModel *placeholderViewModel = UIViewPlaceholderViewModel.new;
        placeholderViewModel.needRefreshBtn = YES;
        @HDWeakify(self);
        placeholderViewModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            if (showGoBackHome) {
                [[HDMediator sharedInstance] navigaveToTinhNowController:nil]; //进入电商主页
            } else {
                [self.viewModel queryNomalProductDetailsData];
            }
        };
        if (showGoBackHome) {
            placeholderViewModel.image = @"tinhnow_product_fail_bg";
            placeholderViewModel.title = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"network_error", @"网络开小差啦");
            placeholderViewModel.refreshBtnTitle = TNLocalizedString(@"tn_back_home", @"返回首页");
        } else {
            placeholderViewModel.image = @"placeholder_network_error";
            placeholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
            placeholderViewModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        }
        self.tableView.placeholderViewModel = placeholderViewModel;
        [self.tableView failGetNewData];
        self.bottomView.hidden = YES;
        [self.customNaviBar hiddenShareAndMoreBtn];

        if (!showGoBackHome && HDIsStringNotEmpty(rspModel.msg)) {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataSource = [NSArray arrayWithArray:self.viewModel.dataSource];
        self.customNaviBar.titleArr = [self getNavTitleArray];
        [self setNavTitleSection];
        [self.tableView successGetNewDataWithNoMoreData:YES];
        self.bottomView.hidden = NO;
        [self.customNaviBar showMoreBtn];
        //埋点
        if (HDIsStringNotEmpty(self.viewModel.funnel) && [self.viewModel.funnel containsString:@"商品专题"]) {
            [SATalkingData trackEvent:[self.viewModel.funnel stringByAppendingString:@"进入商品详情"]];
        } else {
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"进入商品详情"]];
        }
        //浏览商品埋点
        [self trackOnViewItem];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"reloadData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];

    //拿到详情数据再去拉取数据  因为图搜没有sn
    [self.KVOController hd_observe:self.viewModel keyPath:@"productId" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self requestRecommandAndReviewData];
    }];
}
#pragma mark -登录成功通知
- (void)userLoginSuccessHandler {
    [self.viewModel queryNomalProductDetailsData];
}
///请求推荐 评论数据
- (void)requestRecommandAndReviewData {
    @HDWeakify(self);
    //请求评论数据
    [self.viewModel queryReviewDataComplete:^(NSIndexPath *_Nonnull indexPath) {
        @HDStrongify(self);
        [self reloadTableViewSectionCell:indexPath];
    }];

    //请求店铺推荐数据
    [self.viewModel queryStoreHotProductRecommendComplete:^(NSIndexPath *_Nonnull indexPath) {
        @HDStrongify(self);
        [self reloadTableViewSectionCell:indexPath];
    }];

    //请求新品推荐数据
    [self.viewModel queryNewProductRecommendComplete:^(NSIndexPath *_Nonnull indexPath) {
        @HDStrongify(self);
        self.customNaviBar.titleArr = [self getNavTitleArray];
        [self setNavTitleSection];
        [self reloadTableViewSectionCell:indexPath];
    }];
}
///刷新cell
- (void)reloadTableViewSectionCell:(NSIndexPath *)indexPath {
    if (!HDIsArrayEmpty(self.dataSource) && !HDIsObjectNil(indexPath) && self.dataSource.count > indexPath.section) {
        [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}
/// 联系商家 - 电话
- (void)makePhoneCall {
    [HDSystemCapabilityUtil makePhoneCall:self.viewModel.productDetailsModel.storePhone];
}

/// 联系平台
- (void)showPlatform {
    TNCustomerServiceView *view = [[TNCustomerServiceView alloc] init];

    view.dataSource = [view getTinhnowDefaultPlatform];
    [view layoutyImmediately];
    TNPhoneActionAlertView *actionView = [[TNPhoneActionAlertView alloc] initWithContentView:view];
    [actionView show];
}

/// 返回主页
- (void)goBackToHome {
    [[HDMediator sharedInstance] navigaveToTinhNowController:@{}];
}
- (void)goToSearchPage {
    [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击搜索框"]];
    [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:nil];
}
/// 浏览商品埋点
- (void)trackOnViewItem {
    [TalkingData onViewItem:self.viewModel.productDetailsModel.productId category:@"" name:self.viewModel.productDetailsModel.name unitPrice:[self.viewModel.productDetailsModel.price.cent intValue]];
}
#pragma mark - 商品分享
- (void)shareProduct {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    if (!HDIsArrayEmpty(self.viewModel.productDetailsModel.productImages)) {
        TNImageModel *model = self.viewModel.productDetailsModel.productImages.firstObject;
        shareModel.shareImage = model.thumbnail;
    }
    shareModel.shareTitle = self.viewModel.productDetailsModel.name;
    shareModel.shareContent = [NSString stringWithFormat:TNLocalizedString(@"tn_share_good_detail_desc", @"优惠价 %@"), self.viewModel.productDetailsModel.price.thousandSeparatorAmount];
    //拼接单买还是批量
    NSString *shareLink = [NSString stringWithFormat:@"%@&tab=%@", self.viewModel.productDetailsModel.shareUrl, self.viewModel.salesType];
    shareModel.shareLink = shareLink;
    shareModel.sourceId = self.viewModel.productDetailsModel.productId;
    shareModel.trackPrefixName = self.viewModel.trackPrefixName; //埋点前缀
    TNSocialShareProductDetailModel *priceModel = [[TNSocialShareProductDetailModel alloc] init];
    priceModel.price = self.viewModel.productDetailsModel.price;
    priceModel.marketPrice = self.viewModel.productDetailsModel.marketPrice;
    priceModel.showDiscount = self.viewModel.productDetailsModel.showDisCount;
    shareModel.productDetailModel = priceModel;
    [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
    [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击分享"]];

    [TNEventTrackingInstance trackEvent:@"share" properties:@{@"productId": self.viewModel.productId, @"type": @"1"}];
}

#pragma mark - 立即购买 或者加购点击
- (void)buyNowOrAddToCart:(TNProductBuyType)buyType {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    if (self.viewModel.productDetailsModel.showStoreTips) {
        TNProductBuyTipsView *tipsView =
            [[TNProductBuyTipsView alloc] initTipsType:buyType storeNo:self.viewModel.productDetailsModel.storeNo storePhone:self.viewModel.productDetailsModel.storePhone
                                                  tips:self.viewModel.productDetailsModel.storeProductInfo.storeTips
                                                 title:self.viewModel.productDetailsModel.name
                                               content:self.viewModel.productDetailsModel.price.thousandSeparatorAmount
                                                 image:self.viewModel.productDetailsModel.productImages.count > 0 ? self.viewModel.productDetailsModel.productImages.firstObject.thumbnail : @""];
        @HDWeakify(self);
        tipsView.doneClickCallBack = ^{
            @HDStrongify(self);
            if ([self.viewModel.salesType isEqualToString:TNSalesTypeBatch]) {
                [self showWholesaleSpecAlertView:buyType];
            } else {
                [self showSkuSpecAlertView:buyType];
            }
        };
        [tipsView show];
    } else {
        if ([self.viewModel.salesType isEqualToString:TNSalesTypeBatch]) {
            [self showWholesaleSpecAlertView:buyType];
        } else {
            [self showSkuSpecAlertView:buyType];
        }
    }
}

#pragma mark -零售规格弹窗
- (void)showSkuSpecAlertView:(TNProductBuyType)buyType {
    TNSpecificationSelectAlertView *specView = [[TNSpecificationSelectAlertView alloc] initWithSpecType:TNSpecificationTypeSingle
                                                                                              specModel:[TNSkuSpecModel modelWithGoodDetailModel:self.viewModel.productDetailsModel]
                                                                                                buyType:buyType];

    @HDWeakify(self);
    specView.buyNowCallBack = ^(TNItemModel *_Nonnull itemModel, TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        [self buyNowWithItemModel:itemModel];
        [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击选择SKU"]];
    };
    specView.addToCartCallBack = ^(TNItemModel *_Nonnull itemModel, TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        [self addProductIntoShoppingCartWithItemMoel:itemModel];
        [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击选择SKU"]];
    };
    [specView show];
}
#pragma mark -批发规格规格弹窗
- (void)showWholesaleSpecAlertView:(TNProductBuyType)buyType {
    TNSpecificationSelectAlertView *specView = [[TNSpecificationSelectAlertView alloc] initWithSpecType:TNSpecificationTypeBatch
                                                                                              specModel:[TNSkuSpecModel modelWithGoodDetailModel:self.viewModel.productDetailsModel]
                                                                                                buyType:buyType];
    @HDWeakify(self);
    specView.buyNowCallBack = ^(TNItemModel *_Nonnull item, TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        [self wholesaleBuyNowWithItem:item];
    };
    specView.addToCartCallBack = ^(TNItemModel *_Nonnull item, TNSalesType _Nonnull salesType) {
        @HDStrongify(self);
        [self addProductIntoShoppingCartWithItemMoel:item];
    };
    [specView show];
}
#pragma mark -批发立即购买
- (void)wholesaleBuyNowWithItem:(TNItemModel *)itemModel {
    TNShoppingCarStoreModel *storeModel = TNShoppingCarStoreModel.new;
    storeModel.storeNo = self.viewModel.productDetailsModel.storeNo;
    storeModel.storeName = self.viewModel.productDetailsModel.storeName;
    storeModel.salesType = TNSalesTypeBatch;
    storeModel.type = self.viewModel.productDetailsModel.storeType;
    NSInteger totalPrice = 0;
    SACurrencyType cy = self.viewModel.productDetailsModel.price.cy;
    NSMutableArray *carItemArr = [NSMutableArray array];
    // sku数组
    NSMutableArray *skuIds = [NSMutableArray array];
    for (TNItemSkuModel *skuModel in itemModel.skuList) {
        TNShoppingCarItemModel *shopCarItem = TNShoppingCarItemModel.new;
        shopCarItem.goodsId = itemModel.goodsId;
        shopCarItem.goodsName = itemModel.goodName;
        shopCarItem.goodsSkuId = skuModel.goodsSkuId;
        shopCarItem.quantity = skuModel.addDelta;
        shopCarItem.shareCode = itemModel.shareCode;
        shopCarItem.picture = skuModel.thumbnail;
        shopCarItem.salePrice = skuModel.salePrice;
        shopCarItem.goodsSkuName = skuModel.properties;
        shopCarItem.weight = skuModel.weight;
        shopCarItem.productType = self.viewModel.productDetailsModel.type;
        shopCarItem.freightSetting = self.viewModel.productDetailsModel.freightSetting;
        shopCarItem.sp = itemModel.sp;
        [carItemArr addObject:shopCarItem];
        totalPrice += [skuModel.salePrice.cent integerValue] * [skuModel.addDelta integerValue];

        [skuIds addObject:skuModel.goodsSkuId];
    }
    storeModel.totalPrice = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%ld", totalPrice] currency:cy];
    storeModel.selectedItems = carItemArr;
    @HDWeakify(self);
    void (^callBack)(void) = ^{
        @HDStrongify(self);
        //请求详情数据
        [self.viewModel queryNomalProductDetailsData];
    };
    [[HDMediator sharedInstance] navigaveToTinhNowOrderSubmitViewController:@{
        @"shoppingCarStoreModel": storeModel,
        @"funnel": HDIsStringNotEmpty(self.viewModel.funnel) ? self.viewModel.funnel : @"",
        @"source": self.viewModel.source,
        @"associatedId": self.viewModel.associatedId,
        @"callBack": callBack
    }];

    //埋点
    [TNEventTrackingInstance trackEvent:@"detail_buy_now" properties:@{@"productId": self.viewModel.productId, @"skuId": skuIds}];
}
#pragma mark -加入购物车
- (void)addProductIntoShoppingCartWithItemMoel:(TNItemModel *)itemModel {
    //    NSString *imageUrl;
    //    if(!HDIsArrayEmpty(self.viewModel.productDetailsModel.productImages)){
    //        imageUrl = self.viewModel.productDetailsModel.productImages.firstObject.medium;
    //    }
    //    [TNTool startAddProductToCartAnimationWithImage:imageUrl startPoint:CGPointMake(kScreenWidth/2
    //                                                                                    , kScreenWidth/2) endPoint:self.bottomView.getCartButtonPoint inView:UIApplication.sharedApplication.keyWindow
    //                                                                                    completion:^{
    //        HDLog(@"动画结束了");
    //        [self.bottomView cartButtonBeginShake];
    //    }];
    //
    //    return;
    //判断限购商品
    if (!self.viewModel.productDetailsModel.isBuyLimitGood) {
        [NAT showAlertWithMessage:[NSString stringWithFormat:TNLocalizedString(@"tn_limit_goods_tips", @"商品限购%ld件，把机会留给其他人吧"), self.viewModel.productDetailsModel.maxLimit]
                      buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                          [alertView dismiss];
                      }];
        return;
    }
    [self showloading];
    @HDWeakify(self);
    [[TNShoppingCar share] addItemToShoppingCarWithItem:itemModel success:^(TNAddItemToShoppingCarRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        NSString *imageUrl;
        if (!HDIsArrayEmpty(self.viewModel.productDetailsModel.productImages)) {
            imageUrl = self.viewModel.productDetailsModel.productImages.firstObject.medium;
        }
        [TNTool startAddProductToCartAnimationWithImage:imageUrl
                                             startPoint:CGPointMake(kScreenWidth / 2, kScreenWidth / 2)
                                               endPoint:self.bottomView.getCartButtonPoint
                                                 inView:UIApplication.sharedApplication.keyWindow completion:^{
                                                     HDLog(@"动画结束了");
                                                     [self.bottomView cartButtonBeginShake];
                                                     [HDTips showWithText:TNLocalizedString(@"tn_add_cart_success", @"添加购物车成功") inView:self hideAfterDelay:3];
                                                 }];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [HDTips showWithText:TNLocalizedString(@"tn_add_cart_fail", @"添加购物车失败") inView:self hideAfterDelay:3];
    }];

    //埋点
    NSArray *skuIds = [itemModel.skuList mapObjectsUsingBlock:^id _Nonnull(TNItemSkuModel *_Nonnull obj, NSUInteger idx) {
        return obj.goodsSkuId;
    }];
    [TNEventTrackingInstance trackEvent:@"add_cart" properties:@{@"productId": self.viewModel.productId, @"skuId": skuIds}];
}
#pragma mark -零售立即购买
- (void)buyNowWithItemModel:(TNItemModel *)itemModel {
    //判断限购商品
    if (!self.viewModel.productDetailsModel.isBuyLimitGood) {
        [NAT showAlertWithMessage:[NSString stringWithFormat:TNLocalizedString(@"tn_limit_goods_tips", @"商品限购%ld件，把机会留给其他人吧"), self.viewModel.productDetailsModel.maxLimit]
                      buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                          [alertView dismiss];
                      }];
        return;
    }

    TNShoppingCarStoreModel *storeModel = TNShoppingCarStoreModel.new;
    storeModel.storeNo = self.viewModel.productDetailsModel.storeNo;
    storeModel.storeName = self.viewModel.productDetailsModel.storeName;
    storeModel.salesType = TNSalesTypeSingle;
    storeModel.type = self.viewModel.productDetailsModel.storeType;
    NSInteger totalPrice = 0;
    SACurrencyType cy = self.viewModel.productDetailsModel.price.cy;
    NSMutableArray *carItemArr = [NSMutableArray array];
    // sku数组
    NSMutableArray *skuIds = [NSMutableArray array];
    for (TNItemSkuModel *skuModel in itemModel.skuList) {
        TNShoppingCarItemModel *shopCarItem = TNShoppingCarItemModel.new;
        shopCarItem.goodsId = itemModel.goodsId;
        shopCarItem.goodsName = itemModel.goodName;
        shopCarItem.goodsSkuId = skuModel.goodsSkuId;
        shopCarItem.quantity = skuModel.addDelta;
        shopCarItem.shareCode = itemModel.shareCode;
        shopCarItem.picture = skuModel.thumbnail;
        shopCarItem.salePrice = skuModel.salePrice;
        shopCarItem.goodsSkuName = skuModel.properties;
        shopCarItem.weight = skuModel.weight;
        shopCarItem.productType = self.viewModel.productDetailsModel.type;
        shopCarItem.freightSetting = self.viewModel.productDetailsModel.freightSetting;
        shopCarItem.sp = itemModel.sp;
        [carItemArr addObject:shopCarItem];
        totalPrice += [skuModel.salePrice.cent integerValue] * [skuModel.addDelta integerValue];

        [skuIds addObject:skuModel.goodsSkuId];
    }
    storeModel.totalPrice = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%ld", totalPrice] currency:cy];
    storeModel.selectedItems = carItemArr;
    @HDWeakify(self);
    void (^callBack)(void) = ^{
        @HDStrongify(self);
        //请求详情数据
        [self.viewModel queryNomalProductDetailsData];
    };
    [[HDMediator sharedInstance] navigaveToTinhNowOrderSubmitViewController:@{
        @"shoppingCarStoreModel": storeModel,
        @"funnel": HDIsStringNotEmpty(self.viewModel.funnel) ? self.viewModel.funnel : @"",
        @"source": self.viewModel.source,
        @"associatedId": self.viewModel.associatedId,
        @"callBack": callBack
    }];
    //埋点
    [TNEventTrackingInstance trackEvent:@"detail_buy_now" properties:@{@"productId": self.viewModel.productId, @"skuId": skuIds}];
}

/// MARK: pop弹窗右上角
- (void)showPopMenu:(HDUIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:self.menuDataSourceArray icons:self.menuDataSourceArray menuWidth:[self getMaxWidth] otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = (id)self;
        popupMenu.itemHeight = 50.f;
        popupMenu.cornerRadius = 8.f;
    }];
}

//获取显示的内容 调整pop 的宽度 （不同语种 不一样）
- (CGFloat)getMaxWidth {
    __block CGFloat width = 0;
    [self.menuDataSourceArray enumerateObjectsUsingBlock:^(TNPopMenuCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *str = obj.title;
        CGSize strSize = [str boundingAllRectWithSize:CGSizeMake(MAXFLOAT, 20.f) font:HDAppTheme.TinhNowFont.standard14];
        if (width < strSize.width) {
            width = strSize.width;
        }
    }];

    width = width + 60.f;
    return width;
}

/// MARK: 获取商户客服列表
- (void)getCustomerList:(NSString *)storeNo {
    [self showloading];
    @HDWeakify(self);
    [[TNIMManger shared] getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        @HDStrongify(self);
        [self dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            [self openIMViewControllerWithOperatorNo:imModel.operatorNo storeNo:storeNo];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}

- (void)openIMViewControllerWithOperatorNo:(NSString *)operatorNo storeNo:(NSString *)storeNo {
    NSString *imageUrl = self.viewModel.productDetailsModel.productImages.count > 0 ? self.viewModel.productDetailsModel.productImages.firstObject.thumbnail : @"";

    NSDictionary *extensionJsonDict = @{
        @"type": @"productDetails",
        @"value": [self.viewModel.originParameters yy_modelToJSONString],
        @"businessLine": SAClientTypeTinhNow,
    };

    NSDictionary *cardDict = @{
        @"title": self.viewModel.productDetailsModel.name ?: @"",
        @"content": self.viewModel.productDetailsModel.price.thousandSeparatorAmount ?: @"",
        @"imageUrl": imageUrl,
        @"link": self.viewModel.productDetailsModel.shareUrl ?: @"",
        @"extensionJson": [extensionJsonDict yy_modelToJSONString],
    };
    NSString *cardJsonStr = [cardDict yy_modelToJSONString];
    NSDictionary *dict = @{@"operatorType": @(8), @"operatorNo": operatorNo ?: @"", @"storeNo": storeNo ?: @"", @"card": cardJsonStr, @"scene": SAChatSceneTypeTinhNowConsult};
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    TNPopMenuCellModel *model = self.menuDataSourceArray[index];
    if (model.type == TNPopMenuTypeHome) {
        [self goBackToHome];
    } else if (model.type == TNPopMenuTypeContactPlatform) {
        [self showPlatform];
    } else if (model.type == TNPopMenuTypeContactMerchant) {
        [self makePhoneCall];
    } else if (model.type == TNPopMenuTypeSearch) {
        [self goToSearchPage];
    }
}

- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index {
    TNPopMenuCell *cell = [TNPopMenuCell cellWithTableView:ybPopupMenu.tableView];
    cell.model = self.menuDataSourceArray[index];

    return cell;
}

#pragma mark -
#pragma mark - 发短信
- (void)sendMessage {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = @[[self.viewModel.productDetailsModel.storePhone filterCambodiaPhoneNum]];
        //            controller.body = @"";
        controller.messageComposeDelegate = self;
        [self.viewController presentViewController:controller animated:YES completion:nil];
    } else {
        // @"该设备不支持短信功能"
        [NAT showToastWithTitle:nil content:TNLocalizedString(@"tn_no_authority", @"权限不足") type:HDTopToastTypeError];
    }
}
// MFMessageComposeViewController delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultCancelled) {
        HDLog(@"取消发送");
    } else if (result == MessageComposeResultSent) {
        HDLog(@"发送成功");
    } else if (result == MessageComposeResultFailed) {
        HDLog(@"发送失败");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 播放器相关
#pragma mark 设置播放器默认配置
//有时间 重写播放器控制层
- (void)setUpVideoPlayer {
    //设置颜色
    SJVideoPlayer.update(^(SJVideoPlayerConfigurations *_Nonnull configs) {
        configs.resources.progressThumbSize = 10;
        configs.resources.progressThumbColor = [UIColor whiteColor];
        configs.resources.progressTraceColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.bottomIndicatorTraceColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.backImage = [UIImage imageNamed:@"tn_video_close_big"];
        configs.resources.floatSmallViewCloseImage = [UIImage imageNamed:@"tn_video_close"];
        configs.resources.playFailedButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.noNetworkButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;
        configs.localizedStrings.reload = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        configs.localizedStrings.playbackFailedPrompt = @"";
        configs.localizedStrings.noNetworkPrompt = SALocalizedString(@"network_error", @"网络开小差啦");
    });

    _player.onlyUsedFitOnScreen = YES;
    _player.resumePlaybackWhenScrollAppeared = NO;
    _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = NO;
    if (@available(iOS 14.0, *)) {
        _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    } else {
        // Fallback on earlier versions
    }

    //设置占位图图片样式
    _player.presentView.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    //默认静音播放
    _player.muted = YES;
    //设置小窗样式
    SJFloatSmallViewController *floatSmallViewController = (SJFloatSmallViewController *)_player.floatSmallViewController;
    floatSmallViewController.layoutPosition = SJFloatViewLayoutPositionTopRight;
    floatSmallViewController.layoutInsets = UIEdgeInsetsMake(kNavigationBarH - kStatusBarH, 12, 20, 12);
    floatSmallViewController.layoutSize = CGSizeMake(kRealWidth(120), kRealWidth(120));
    floatSmallViewController.floatView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };

    //删除原有的播放  放大按钮
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Play];
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];

    //当前时间
    SJEdgeControlButtonItem *currentTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_CurrentTime];
    currentTimeItem.insets = SJEdgeInsetsMake(15, 0);
    [_player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_Progress withItemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    SJEdgeControlButtonItem *durationTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    durationTimeItem.insets = SJEdgeInsetsMake(0, 60);

    //声音按钮固定在底部控制层
    __block HDUIButton *muteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [muteBtn setImage:[UIImage imageNamed:@"tn_video_mute"] forState:UIControlStateNormal];
    [muteBtn setImage:[UIImage imageNamed:@"tn_video_unmute"] forState:UIControlStateSelected];
    muteBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    [muteBtn addTarget:self action:@selector(muteClick) forControlEvents:UIControlEventTouchUpInside];
    muteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [muteBtn sizeToFit];
    [_player.defaultEdgeControlLayer.controlView addSubview:muteBtn];
    [muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view);
        make.right.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view.mas_right).offset(-15);
    }];
    muteBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };

    //小窗添加一个是否禁音按钮
    __block SJEdgeControlButtonItem *muteItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"tn_video_mute"] target:self action:@selector(muteClick)
                                                                                           tag:TNEdgeControlBottomMuteButtonItemTag];
    SJEdgeControlButtonItem *fillItem = [[SJEdgeControlButtonItem alloc] initWithTag:200];
    fillItem.fill = YES;
    _player.defaultFloatSmallViewControlLayer.bottomHeight = 35;
    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:fillItem];
    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:muteItem];

    //静音回调
    @HDWeakify(self);
    _player.playbackObserver.mutedDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        muteBtn.selected = !player.isMuted;
        if (player.isMuted) {
            muteItem.image = [UIImage imageNamed:@"tn_video_mute"];
        } else {
            muteItem.image = [UIImage imageNamed:@"tn_video_unmute"];
        }
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
        }
    };

    //添加 中间播放按钮
    [_player.defaultEdgeControlLayer.centerAdapter removeItemForTag:SJEdgeControlLayerCenterItem_Replay];

    SJEdgeControlButtonItem *playItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"tn_product_video_play"] target:self action:@selector(playClick)
                                                                                   tag:TNEdgeControlCenterPlayButtonItemTag];
    playItem.hidden = YES;
    [_player.defaultEdgeControlLayer.centerAdapter addItem:playItem];
    [_player.defaultEdgeControlLayer.centerAdapter reload];

    //播放完毕事件回调
    _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self.player.presentView showPlaceholderAnimated:YES];
        [self setPlayItemHidden:NO];
    };

    //全屏回调
    _player.fitOnScreenObserver.fitOnScreenWillBeginExeBlock = ^(id<SJFitOnScreenManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isFitOnScreen) {
            //进入全屏就打开声音
            if (self.player.isMuted) {
                self.player.muted = NO;
            }
        } else {
            if (self.tableView.contentOffset.y > self.playerMaxY) { //这种情况是浮窗进入大屏  再放小的情况  这个时候 暂停视频
                [self.player pauseForUser];
            }
        }
    };

    _player.gestureControl.supportedGestureTypes = SJPlayerGestureTypeMask_SingleTap | SJPlayerGestureTypeMask_Pan;
    //单击事件回调
    _player.gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl> _Nonnull control, CGPoint location) {
        @HDStrongify(self);
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.floatSmallViewController dismissFloatView];
            [self.player setFitOnScreen:YES animated:YES];
        } else {
            if (!self.player.isFitOnScreen) {
                [self.player setFitOnScreen:YES animated:YES];
            } else {
                if (self.player.controlLayerAppearManager.isAppeared) {
                    [self.player controlLayerNeedDisappear];
                } else {
                    [self.player controlLayerNeedAppear];
                }
            }
        }
    };
    _player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ^(id<SJControlLayerAppearManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isAppeared) {
            if (self.player.isFitOnScreen) {
                [self setPlayItemHidden:NO];
            } else {
                [self setPlayItemHidden:self.player.isPlaying];
            }
        } else {
            [self setPlayItemHidden:self.player.isPlaying];
        }
    };
    _player.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self showPlayItemImage:self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused];
        if (self.player.isPlaying && !self.player.isFitOnScreen) {
            [self setPlayItemHidden:YES];
        }
        //全屏状态下  如果播放后 控制层不在 马上隐藏播放按钮
        if (self.player.isPlaying && self.player.isFitOnScreen && !self.player.controlLayerAppeared) {
            [self setPlayItemHidden:YES];
        }
        if (self.player.isPaused) {
            [self setPlayItemHidden:NO];
        }
    };
}
- (void)setPlayItemHidden:(BOOL)hidden {
    SJEdgeControlButtonItem *playitem = [_player.defaultEdgeControlLayer.centerAdapter itemForTag:TNEdgeControlCenterPlayButtonItemTag];
    playitem.hidden = hidden;
    [self.player.defaultEdgeControlLayer.centerAdapter reload];
}
//设置播放图片
- (void)showPlayItemImage:(BOOL)isPlaying {
    SJEdgeControlButtonItem *playItem = [_player.defaultEdgeControlLayer.centerAdapter itemForTag:TNEdgeControlCenterPlayButtonItemTag];
    if (isPlaying) {
        playItem.image = [UIImage imageNamed:@"tn_video_pause"];
    } else {
        playItem.image = [UIImage imageNamed:@"tn_product_video_play"];
    }
    [self.player.defaultEdgeControlLayer.centerAdapter reload];

    if (isPlaying && !self.player.presentView.isPlaceholderImageViewHidden) {
        [self.player.presentView hiddenPlaceholderAnimated:YES];
    }
}

#pragma mark 静音按钮点击
- (void)muteClick {
    _player.muted = !_player.isMuted;
}
#pragma mark 播放按钮点击
- (void)playClick {
    //放大状态下
    if (self.player.isPlaying) {
        [self.player pauseForUser];
    } else {
        if (!self.player.presentView.isPlaceholderImageViewHidden) {
            [self.player.presentView hiddenPlaceholderAnimated:YES];
        }
        if (self.player.isPlaybackFinished) {
            [self.player replay];
        } else {
            [self.player play];
        }
    }
}
#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    //更新alpha显示
    [self.customNaviBar updateUIWithScrollViewOffsetY:offsetY];

    if (self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused || self.player.floatSmallViewController.isAppeared) {
        if (self.playerMaxY <= 0) {
            self.playerMaxY = CGRectGetMaxY(self.player.presentView.frame);
        }
        if (offsetY > self.playerMaxY) {
            CGPoint scrollVelocity = [scrollView.panGestureRecognizer translationInView:self];
            if (!self.player.floatSmallViewController.isAppeared && !self.player.isFitOnScreen && scrollVelocity.y < 0 && !self.player.isFitOnScreen) { //大屏和向上滑都不触发显示小屏
                [self.player.floatSmallViewController showFloatView];
            }
        } else {
            if (self.player.floatSmallViewController.isAppeared) {
                [self.player.floatSmallViewController dismissFloatView];
            }
        }
    }

    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        // HDLog(@"不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理");
        return;
    }

    //更新 标题栏移动位置
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, offsetY + self.customNaviBar.hd_height + kStatusBarH)];
    if (indexPath) {
        NSInteger section = indexPath.section;
        [self setIndex:section];
    }
}

- (void)setIndex:(NSInteger)section {
    if ([self.navTitleSectionArray containsObject:@(section)]) {
        NSInteger index = [self getIndexWithSection:section];
        if (index != [self.customNaviBar currentTitleIndex]) {
            [self.customNaviBar updateSectionViewSelectedItemWithIndex:index];
        }
    }
}

//获取在数组中存在第几个index
- (NSInteger)getIndexWithSection:(NSInteger)section {
    __block NSInteger index = 0;
    [self.viewModel.titleArr enumerateObjectsUsingBlock:^(TNProductNavTitleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.section == section) {
            index = idx;
            *stop = YES;
        }
    }];

    return index;
}
///滚动到指定section
- (void)scrollerToSectionWithIndex:(NSInteger)index {
    TNProductNavTitleModel *model = self.viewModel.titleArr[index];
    if (model.section >= self.dataSource.count) {
        return;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:model.section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //    CGRect rect = [self.tableView rectForSection:model.section];
    //    [self.tableView setContentOffset:CGPointMake(0, rect.origin.y) animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        //便宜
        CGFloat offsetY = self.tableView.contentOffset.y;
        CGFloat space = self.dataSource.count * kTableFooterSpace + kiPhoneXSeriesSafeBottomHeight;
        if (index == 0) {
            space = 0;
        }
        [self.tableView setContentOffset:CGPointMake(0, offsetY - space) animated:NO];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return nil;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return nil;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNProductSaleRegionCellModel.class]) {
        TNInsetInfoTableViewCell *cell =
            [TNInsetInfoTableViewCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"TNProductSaleRegionCellModel section %ld  row %ld", indexPath.section, indexPath.row]];
        SAInfoViewModel *trueModel = (TNProductSaleRegionCellModel *)model;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAInfoViewModel.class]) {
        TNInsetInfoTableViewCell *cell = [TNInsetInfoTableViewCell cellWithTableView:tableView
                                                                          identifier:[NSString stringWithFormat:@"SAInfoViewModel section %ld  row %ld", indexPath.section, indexPath.row]];
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailCardCellModel.class]) {
        TNProductDetailCardCell *cell = [TNProductDetailCardCell cellWithTableView:tableView];
        TNProductDetailCardCellModel *trueModel = (TNProductDetailCardCellModel *)model;
        cell.model = trueModel;
        @HDWeakify(self);
        cell.webViewHeightCallBack = ^{
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{
                [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
            }];
        };
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = (SANoDataCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductReviewTableViewCellModel.class]) {
        TNProductReviewTableViewCell *cell = [TNProductReviewTableViewCell cellWithTableView:tableView];
        cell.model = (TNProductReviewTableViewCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailsStoreCellModel.class]) {
        TNProductDetailsStoreCell *cell = [TNProductDetailsStoreCell cellWithTableView:tableView];
        cell.model = (TNProductDetailsStoreCellModel *)model;
        @HDWeakify(self);
        cell.customerServiceButtonClickedHander = ^(NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_联系客服"] label:@"" parameters:@{@"渠道": @"在线客服"}];
            [self getCustomerList:storeNo];
        };
        cell.phoneButtonClickedHander = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_联系客服"] label:@"" parameters:@{@"渠道": @"电话"}];
            [self makePhoneCall];
        };
        cell.smsButtonClickedHander = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_联系客服"] label:@"" parameters:@{@"渠道": @"SMS"}];
            [self sendMessage];
        };
        cell.reloadStoreCellCallBack = ^{
            @HDStrongify(self);
            CGFloat offsetY = self.tableView.contentOffset.y;
            [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
            [self.tableView setContentOffset:CGPointMake(0, offsetY)];
        };
        return cell;
    } else if ([model isKindOfClass:TNProductDetailsActivityCellModel.class]) {
        TNProductDetailsActivityCell *cell = [TNProductDetailsActivityCell cellWithTableView:tableView];
        cell.model = ((TNProductDetailsActivityCellModel *)model).model;
        return cell;
    } else if ([model isKindOfClass:TNDeliverFlowModel.class]) {
        TNProductDetailExpressCell *cell = [TNProductDetailExpressCell cellWithTableView:tableView];
        cell.model = (TNDeliverFlowModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailServiceCellModel.class]) {
        TNProductDetailServiceCell *cell = [TNProductDetailServiceCell cellWithTableView:tableView];
        cell.model = (TNProductDetailServiceCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailPublicImgCellModel.class]) {
        TNProductDetailPublicImgCell *cell = [TNProductDetailPublicImgCell cellWithTableView:tableView];
        cell.model = (TNProductDetailPublicImgCellModel *)model;
        @HDWeakify(self);
        cell.getImageViewHeightCallBack = ^{ //刷新table 展开高度
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    } else if ([model isKindOfClass:TNProductBannerCellModel.class]) {
        TNProductBannerCell *cell = [TNProductBannerCell cellWithTableView:tableView];
        cell.model = (TNProductBannerCellModel *)model;
        @HDWeakify(self);
        cell.videoTapClick = ^(HDCyclePagerView *_Nonnull pagerView, NSIndexPath *_Nonnull indexPath, TNSingleVideoCollectionViewCellModel *model) {
            @HDStrongify(self);
            [self.player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageUrl]];
            SJPlayModel *playModel = [SJPlayModel playModelWithCollectionView:pagerView.collectionView indexPath:indexPath superviewSelector:NSSelectorFromString(@"videoContentView")];
            self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:model.videoUrl] playModel:playModel];
            HDReachability *reachability = [HDReachability reachabilityForInternetConnection];
            if (reachability.currentReachabilityStatus == ReachableViaWWAN) {
                [HDTips showWithText:TNLocalizedString(@"tn_video_play_tip", @"您正在使用非WiFi播放，请注意手机流量消耗") hideAfterDelay:3];
            }
            [self.player play];
        };
        cell.pagerViewChangePage = ^(NSInteger index) {
            @HDStrongify(self);
            if (index == 0) {
                self.player.floatSmallViewController.enabled = YES;
            } else {
                self.player.floatSmallViewController.enabled = NO;
            }
        };
        cell.scrollerToRecommendSection = ^{
            @HDStrongify(self);
            if (HDIsArrayEmpty(self.viewModel.titleArr)) {
                return;
            }
            [self setIndex:self.dataSource.count - 1];
            //滚动到最后
            [self scrollerToSectionWithIndex:self.viewModel.titleArr.count - 1];
        };
        return cell;
    } else if ([model isKindOfClass:TNProductBaseInfoCellModel.class]) {
        TNProductBaseInfoCell *cell = [TNProductBaseInfoCell cellWithTableView:tableView];
        cell.model = (TNProductBaseInfoCellModel *)model;
        @HDWeakify(self);
        cell.shareClickCallBack = ^{
            @HDStrongify(self);
            [self shareProduct];
        };
        return cell;
    } else if ([model isKindOfClass:TNProductBatchToggleCellModel.class]) {
        TNProductBatchToggleCell *cell = [TNProductBatchToggleCell cellWithTableView:tableView];
        cell.model = (TNProductBatchToggleCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductSingleBuyPriceCellModel.class]) {
        TNProductSingleBuyPriceCell *cell = [TNProductSingleBuyPriceCell cellWithTableView:tableView];
        cell.model = (TNProductSingleBuyPriceCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductBatchBuyPriceCellModel.class]) {
        TNProductBatchBuyPriceCell *cell = [TNProductBatchBuyPriceCell cellWithTableView:tableView];
        cell.model = (TNProductBatchBuyPriceCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailRecommendCellModel.class]) {
        TNProductDetailRecommendCell *cell = [TNProductDetailRecommendCell cellWithTableView:tableView];
        cell.model = (TNProductDetailRecommendCellModel *)model;
        @HDWeakify(self);
        cell.reloadSectionCallBack = ^{
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{
                [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
            }];
        };
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return nil;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (!sectionModel.headerModel)
        return nil;
    if (!HDIsObjectNil(sectionModel.commonHeaderModel)) {
        UILabel *label = [[UILabel alloc] init];
        label.text = sectionModel.headerModel.title;
        label.font = [HDAppTheme.TinhNowFont fontMedium:15];
        label.textColor = HDAppTheme.TinhNowColor.G1;
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.headerModel) {
        if (!HDIsObjectNil(sectionModel.commonHeaderModel)) {
            if (!HDIsArrayEmpty(sectionModel.list)) {
                return kTableHeaderHeight;
            }
        }
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kTableFooterSpace;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0 && indexPath.section != self.dataSource.count - 1) {
        [self setCornerRadiusForSectionCell:cell indexPath:indexPath tableView:tableView needSetAlone:NO];
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNProductDetailServiceCellModel.class]) {
        TNProductServiceAlertView *alertView = [[TNProductServiceAlertView alloc] initWithDataArr:self.viewModel.productDetailsModel.servicesGuaranteeList];
        [alertView show];

    } else if ([model isKindOfClass:TNProductReviewTableViewCellModel.class]) {
        TNProductReviewTableViewCellModel *cellModel = (TNProductReviewTableViewCellModel *)model;
        if (cellModel.totalReviews > 0) { //大于1
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击商品评价"]];
            [HDMediator.sharedInstance navigaveToTinhNowProductReviewDetailsViewController:@{@"productId": self.viewModel.productDetailsModel.productId}];
        }
    } else if ([model isKindOfClass:TNProductDetailsActivityCellModel.class]) {
        TNProductDetailsActivityCellModel *cellModel = model;
        TNProductActivityModel *acModel = cellModel.model;
        if (acModel) {
            NSInteger type = acModel.type;
            if (type == 0) {
                [[HDMediator sharedInstance] navigaveTinhNowBargainProductDetailViewController:@{@"activityId": acModel.activityId}];
            }

            //            else {
            //                NSString *pintuanURL = [NSString stringWithFormat:@"%@/h5/group-buying/goods-detail?activityId=%@&goodsId=%@&productId=%@",
            //                SAAppEnvManager.sharedInstance.appEnvConfig.tinhNowHost, acModel.activityId, acModel.goodsId, acModel.productId]; [SAWindowManager openUrl:pintuanURL withParameters:nil];
            //            }
        }
    } else if ([model isKindOfClass:TNProductSaleRegionCellModel.class]) {
        TNProductSaleRegionModel *sRmodel = ((TNProductSaleRegionCellModel *)model).saleRegionModel;
        if ([self.viewModel.productDetailsModel.type isEqualToString:TNGoodsTypeOverseas]) {
            //海外购订单
            TNProductDeliveryInfoViewController *vc = [[TNProductDeliveryInfoViewController alloc]
                initWithRouteParameters:@{@"storeId": self.viewModel.productDetailsModel.storeNo, @"region": ((TNProductSaleRegionCellModel *)model).valueText}];
            [SAWindowManager navigateToViewController:vc parameters:@{}];
        } else { //其它订单  如果不是配送至全国  就显示配送地点信息弹窗
            if (self.viewModel.productDetailsModel.canOpenMap) {
                //商品可以查看配送区域的
                [HDMediator.sharedInstance navigaveToTinhNowDeliveryAreaMapViewController:@{@"addressModel": [TNGlobalData shared].orderAdress}];
            } else {
                if (sRmodel.regionType == TNRegionTypeSpecifiedArea) { // 显示配送区域
                    NSString *showStr = sRmodel.regionNames ?: @"";

                    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
                    config.buttonTitle = TNLocalizedString(@"tn_completed", @"完成");
                    config.buttonBgColor = HDAppTheme.TinhNowColor.C1;
                    config.buttonTitleFont = HDAppTheme.TinhNowFont.standard17B;
                    config.buttonTitleColor = UIColor.whiteColor;
                    config.iPhoneXFillViewBgColor = HDAppTheme.TinhNowColor.C1;

                    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
                    TNProductSaleRegionAlertView *view = [[TNProductSaleRegionAlertView alloc] initWithFrame:CGRectMake(0, 0, width, 10.f) data:showStr];
                    [view layoutyImmediately];
                    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
                    [actionView show];
                }
            }
        }
        [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击配送信息"]];

    } else if ([model isKindOfClass:TNProductSepcInfoModel.class]) {
        //规格选择点击
        [self buyNowOrAddToCart:TNProductBuyTypeAddCart];
    } else if ([model isKindOfClass:TNProductDetailPublicImgCellModel.class]) {
        TNProductDetailPublicImgCellModel *publicImgCellModel = (TNProductDetailPublicImgCellModel *)model;

        if (HDIsStringNotEmpty(publicImgCellModel.publicDetailAppLink)) {
            [SAWindowManager openUrl:publicImgCellModel.publicDetailAppLink withParameters:nil];
            [SATalkingData trackEvent:@"[电商]公共详情图" label:@"" parameters:@{@"link": publicImgCellModel.publicDetailAppLink}];
        }
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.customNaviBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarH);
        make.left.right.top.equalTo(self);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kRealHeight(50) + kiPhoneXSeriesSafeBottomHeight);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 500;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
    }
    return _tableView;
}
/** @lazy bottomView */
- (TNProductDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TNProductDetailBottomView alloc] initWithViewModel:self.viewModel];
        _bottomView.hidden = YES;
        @HDWeakify(self);
        _bottomView.addCartButtonClickedHander = ^{
            @HDStrongify(self);
            [self buyNowOrAddToCart:TNProductBuyTypeAddCart];
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_加入购物车"]];

            // 首页转化漏斗
            NSString *homeSource = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_source"];
            NSString *homeAssociateId = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_associatedId"];

            [LKDataRecord.shared traceEvent:@"add_shopcart"
                                       name:[NSString stringWithFormat:@"电商_购物车_加购_%@",
                                                                       HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : (HDIsStringNotEmpty(homeSource) ? homeSource : @"other")]
                                 parameters:@{
                                     @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : (HDIsStringNotEmpty(homeAssociateId) ? homeAssociateId : @""),
                                     @"goodsId": self.viewModel.productId
                                 }
                                        SPM:[LKSPM SPMWithPage:@"TNProductDetailViewController" area:@"" node:@""]];
            // end
        };
        _bottomView.buyNowButtonClickedHander = ^{
            @HDStrongify(self);
            [self buyNowOrAddToCart:TNProductBuyTypeBuyNow];
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_立即购买"]];
            // 首页转化漏斗
            NSString *homeSource = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_source"];
            NSString *homeAssociateId = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_associatedId"];

            [LKDataRecord.shared traceEvent:@"add_shopcart"
                                       name:[NSString stringWithFormat:@"电商_购物车_加购_%@",
                                                                       HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : (HDIsStringNotEmpty(homeSource) ? homeSource : @"other")]
                                 parameters:@{
                                     @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : (HDIsStringNotEmpty(homeAssociateId) ? homeAssociateId : @""),
                                     @"goodsId": self.viewModel.productId
                                 }
                                        SPM:[LKSPM SPMWithPage:@"TNProductDetailViewController" area:@"" node:@""]];
            // end
        };
        _bottomView.customerServiceButtonClickedHander = ^(NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_联系客服"] label:@"" parameters:@{@"渠道": @"在线客服"}];
            [self getCustomerList:storeNo];
        };
        _bottomView.phoneButtonClickedHander = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_联系客服"] label:@"" parameters:@{@"渠道": @"电话"}];
            [self makePhoneCall];
        };
        _bottomView.smsButtonClickedHander = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_联系客服"] label:@"" parameters:@{@"渠道": @"SMS"}];
            [self sendMessage];
        };
    }
    return _bottomView;
}

- (TNProductNavigationBarView *)customNaviBar {
    if (!_customNaviBar) {
        _customNaviBar = [[TNProductNavigationBarView alloc] init];
        @HDWeakify(self);
        _customNaviBar.shareCallBack = ^{
            @HDStrongify(self);
            [self shareProduct];
        };
        _customNaviBar.callPhoneCallBack = ^{
            @HDStrongify(self);
            [self makePhoneCall];
        };
        _customNaviBar.moreCallBack = ^(HDUIButton *_Nonnull sender) {
            @HDStrongify(self);
            [self showPopMenu:sender];
        };
        _customNaviBar.searchCallBack = ^{
            @HDStrongify(self);
            [self goToSearchPage];
        };
        _customNaviBar.selectedItemCallBack = ^(NSInteger index) {
            @HDStrongify(self);
            if (HDIsArrayEmpty(self.viewModel.titleArr)) {
                return;
            }

            [self scrollerToSectionWithIndex:index];
        };
        _customNaviBar.shopCartcallBack = ^{
            @HDStrongify(self);
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击购物车"]];

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (HDIsStringNotEmpty(self.viewModel.salesType)) {
                dict[@"tab"] = self.viewModel.salesType;
            }
            [SAWindowManager openUrl:@"SuperApp://TinhNow/ShoppingCar" withParameters:dict];
        };
    }
    return _customNaviBar;
}

- (NSArray *)getNavTitleArray {
    NSMutableArray *returnTitleArray = [NSMutableArray array];
    for (TNProductNavTitleModel *itemModel in self.viewModel.titleArr) {
        [returnTitleArray addObject:itemModel.title];
    }
    return returnTitleArray;
}

- (void)setNavTitleSection {
    [self.navTitleSectionArray removeAllObjects];
    @HDWeakify(self);
    [self.viewModel.titleArr enumerateObjectsUsingBlock:^(TNProductNavTitleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        [self.navTitleSectionArray addObject:@(obj.section)];
    }];
}

- (NSMutableArray *)navTitleSectionArray {
    if (!_navTitleSectionArray) {
        _navTitleSectionArray = [NSMutableArray array];
    }
    return _navTitleSectionArray;
}

- (NSArray<TNPopMenuCellModel *> *)menuDataSourceArray {
    if (!_menuDataSourceArray) {
        TNPopMenuCellModel *phoneModel = TNPopMenuCellModel.new;
        phoneModel.icon = @"tinhnow_product_nav_menu_contactmerchant";
        phoneModel.title = TNLocalizedString(@"tn_contact", @"联系商家");
        phoneModel.type = TNPopMenuTypeContactMerchant;

        TNPopMenuCellModel *homeModel = TNPopMenuCellModel.new;
        homeModel.icon = @"tinhnow_product_nav_menu_home";
        homeModel.title = TNLocalizedString(@"tn_product_backhome", @"主页");
        homeModel.type = TNPopMenuTypeHome;

        TNPopMenuCellModel *searchModel = TNPopMenuCellModel.new;
        searchModel.icon = @"tinhnow_product_nav_menu_search";
        searchModel.title = TNLocalizedString(@"tn_search_k", @"搜索");
        searchModel.type = TNPopMenuTypeSearch;

        TNPopMenuCellModel *platformModel = TNPopMenuCellModel.new;
        platformModel.icon = @"tinhnow_product_nav_menu_contactplatform";
        platformModel.title = TNLocalizedString(@"tn_service", @"联系平台");
        platformModel.type = TNPopMenuTypeContactPlatform;

        _menuDataSourceArray = [NSArray arrayWithObjects:phoneModel, homeModel, searchModel, platformModel, nil];
    }
    return _menuDataSourceArray;
}

///** @lazy player */
- (SJVideoPlayer *)player {
    if (!_player) {
        _player = [SJVideoPlayer player];
        [self setUpVideoPlayer];
    }
    return _player;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNProductDetailSkeletonImageCell cellWithTableView:tableview];
            } else if (indexPath.row == 1) {
                return [TNProductDetailSkeletonInfoCell cellWithTableView:tableview];
            } else {
                return [TNProductDetailSkeletonCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNProductDetailSkeletonImageCell skeletonViewHeight];
            } else if (indexPath.row == 1) {
                return [TNProductDetailSkeletonInfoCell skeletonViewHeight];
            } else {
                return [TNProductDetailSkeletonCell skeletonViewHeight];
            }
        }];
        _provider.numberOfRowsInSection = 4;
    }
    return _provider;
}

@end

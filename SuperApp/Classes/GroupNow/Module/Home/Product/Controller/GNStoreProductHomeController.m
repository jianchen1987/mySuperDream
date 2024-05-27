//
//  GNStoreProductHomeController.m
//  SuperApp
//
//  Created by wmz on 2021/6/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreProductHomeController.h"
#import "GNAlertUntils.h"
#import "GNGroupFootView.h"
#import "GNHomeDTO.h"
#import "GNOrderSubmitViewModel.h"
#import "GNProductFilterView.h"
#import "GNShareView.h"
#import "GNStoreProductViewController.h"
#import "SAAddressModel.h"
#import "SASocialShareView.h"
#import "UIViewPlaceholderViewModel.h"
#import "WMZPageView.h"
#import "LKDataRecord.h"
#import "SAAddressCacheAdaptor.h"

@interface GNStoreProductHomeController ()
/// 筛选
@property (nonatomic, strong) GNProductFilterView *filterView;
/// 网络请求
@property (nonatomic, strong) GNHomeDTO *homeDTO;
/// 从订单详情进入
@property (nonatomic, copy) NSString *fromOrder;
/// 无数据VM
@property (nonatomic, strong) UIViewPlaceholderViewModel *placeholderViewModel;
///抢购viewModel
@property (nonatomic, strong) GNOrderSubmitViewModel *buyViewModel;
///分享按钮
@property (nonatomic, strong) HDUIButton *shareBTN;
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;

@end


@implementation GNStoreProductHomeController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        if (parameters[@"ID"]) {
            @HDWeakify(self) self.productCode = [parameters objectForKey:@"ID"];
            [self showloading];
            [self.homeDTO productGetDetailRequestCode:self.productCode success:^(GNProductModel *_Nonnull rspModel) {
                @HDStrongify(self)[self dismissLoading];
                self.storeNo = rspModel.storeNo;
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self)[self dismissLoading];
                self.placeholderViewModel.image = @"placeholder_network_error";
                self.placeholderViewModel.title = rspModel.msg;
                self.placeholderViewModel.needRefreshBtn = NO;
                [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
            }];
        } else {
            self.storeModel = [parameters objectForKey:@"storeModel"];
            self.productCode = [parameters objectForKey:@"productCode"];
            self.fromOrder = [parameters objectForKey:@"fromOrder"];
            self.storeNo = [parameters objectForKey:@"storeNo"];
        }
    }
    return self;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.boldTitle = GNLocalizedString(@"gn_group_detail", @"团购详情");
    self.hd_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareBTN];
}

- (void)hd_setupViews {
    @HDWeakify(self);
    self.filterView.dataSource = self.storeModel.productList ?: @[];
    WMZPageParam *param = WMZPageParam.new;
    [self setParamTitle:param];
    param.wCustomNaviBarY = ^CGFloat(CGFloat nowY) {
        return 0;
    };
    param.wMenuFixShadowSet(YES);
    param.wMenuFixRightData = @{@"image": @"gn_store_whole"};
    param.wCustomTitleContent = ^NSString *_Nullable(id _Nullable model, NSInteger index) {
        if ([model isKindOfClass:GNProductModel.class]) {
            GNProductModel *pro = (GNProductModel *)model;
            return pro.name.desc;
        }
        return nil;
    };
    param.wMenuFixWidth = kRealWidth(64);
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        @HDStrongify(self);
        GNStoreProductViewController *productVC = GNStoreProductViewController.new;
        productVC.productNo = self.storeModel.productList[index].codeId;
        if (self.storeModel) {
            productVC.storeNo = self.storeModel.storeNo;
        } else {
            productVC.storeNo = self.storeNo;
        }
        return productVC;
    };
    param.wEventEndTransferController = ^(UIViewController *_Nullable oldVC, UIViewController *_Nullable newVC, NSInteger oldIndex, NSInteger newIndex) {
        @HDStrongify(self);
        [self.filterView.dataSource enumerateObjectsUsingBlock:^(GNProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.select = (idx == newIndex);
        }];
        [self.filterView.tableView updateUI];
    };
    param.wEventFixedClick = ^(id _Nullable anyID, NSInteger index) {
        @HDStrongify(self);
        if ([self.filterView isShow]) {
            [self.filterView dissmiss];
        } else {
            [self.filterView show:self.view];
        }
    };
    self.pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH) param:param parentReponder:self];
    [self.view addSubview:self.pageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productUpNotifacation:) name:kNotificationNameProductUp object:nil];
}

/// 刷新通知
- (void)productUpNotifacation:(NSNotification *)no {
    /// 重新刷新
    [self getData];
}

#pragma mark GNEvent
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    /// 抢购
    if ([event.key isEqualToString:@"buyAction"]) {
        GNStoreProductViewController *productVC = (GNStoreProductViewController *)self.pageView.upSc.currentVC;

        if (!productVC.viewModel.productModel.codeId)
            return;
        @HDWeakify(self)[self showloading];
        [self.buyViewModel getRushBuyDetailStoreNo:self.storeNo code:productVC.viewModel.productModel.codeId completion:^(NSString *_Nonnull error) {
            @HDStrongify(self)[self dismissLoading];
            if (!error) {
                [HDMediator.sharedInstance navigaveToGNOrderTakeViewController:@{
                    @"storeNo": [NSString stringWithFormat:@"%@", self.storeNo ?: self.storeModel.storeNo],
                    @"productCode": productVC.viewModel.productModel.codeId,
                    @"viewModel": self.buyViewModel
                }];
            }
        }];
    }
    /// 筛选选择
    else if ([event.key isEqualToString:@"filterSelectAction"]) {
        [self.pageView selectMenuWithIndex:event.indexPath.row];
    }
    ///联系商家
    else if ([event.key isEqualToString:@"callAction"]) {
        [GNAlertUntils callAndServerString:self.storeModel.businessPhone];
    }
}

///分享
- (void)shareAction {
    @HDWeakify(self);
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    GNStoreProductViewController *productVC = (GNStoreProductViewController *)self.pageView.upSc.currentVC;
    NSString *routePath = [NSString stringWithFormat:@"SuperApp://GroupOn/product_detail?ID=%@", productVC.viewModel.productModel.codeId];
    NSString *encodeRoutePath = [routePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?="].invertedSet];
    NSString *language = @"en";
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        language = @"zh";
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        language = @"km";
    }

    NSString *webpageUrl = [NSString stringWithFormat:@"%@?productId=%@&lat=%@&lon=%@&lang=%@&routePath=%@",
                                                      productVC.viewModel.productModel.shareUrl,
                                                      productVC.viewModel.productModel.codeId,
                                                      addressModel ? addressModel.lat.stringValue : @(kDefaultLocationPhn.latitude).stringValue,
                                                      addressModel ? addressModel.lon.stringValue : @(kDefaultLocationPhn.longitude).stringValue,
                                                      language,
                                                      encodeRoutePath];
    SAShareWebpageObject *shareObject = SAShareWebpageObject.new;
    shareObject.title = [NSString stringWithFormat:GNLocalizedString(@"gn_store_worth_spending", @"这家店值得到店消费 [%@]"), GNFillEmpty(productVC.viewModel.productModel.storeName.desc)];
    shareObject.webpageUrl = webpageUrl;
    if ([productVC.viewModel.productModel.codeId isEqualToString:GNProductTypeP2]) {
        shareObject.thumbData = UIImageJPEGRepresentation([UIImage imageNamed:@"gn_product_bg"], 0.5f);
    } else {
        shareObject.thumbImage = productVC.viewModel.productModel.imagePathArr.firstObject;
    }
    HDSocialShareCellModel *generateImageFunctionModel = [SASocialShareView generateImageFunctionModel];
    generateImageFunctionModel.clickedHandler = ^(HDSocialShareCellModel *_Nonnull cellModel, NSInteger index) {
        @HDStrongify(self) GNShareView *imageShareView = GNShareView.new;
        imageShareView.storeModel = self.storeModel;
        imageShareView.codeURL = webpageUrl;
        imageShareView.productModel = productVC.viewModel.productModel;
        [imageShareView addSharePorductView];

        [SASocialShareView showShareWithTopCustomView:imageShareView completion:nil];
    };

    [SASocialShareView showShareWithShareObject:shareObject functionModels:@[SASocialShareView.copyLinkFunctionModel, generateImageFunctionModel]
                                     completion:^(BOOL success, NSString *_Nullable shareChannel) {
                                         [LKDataRecord.shared traceEvent:@"click_pv_socialShare" name:@"" parameters:@{
                                             @"shareResult": success ? @"success" : @"fail",
                                             @"traceId": productVC.viewModel.productModel.codeId,
                                             @"traceUrl": webpageUrl,
                                             @"traceContent": @"GroupOnProductShare",
                                             @"channel": shareChannel
                                         }];
                                     }];
}

#pragma mark 获取默认选中
- (NSInteger)getDefaultSelect:(WMZPageParam *)param {
    if (self.productCode) {
        @HDWeakify(self);
        __block NSUInteger selectIndex = 0;
        [param.wTitleArr enumerateObjectsUsingBlock:^(GNProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            @HDStrongify(self);
            if ([obj.codeId isEqualToString:self.productCode]) {
                selectIndex = idx;
                *stop = YES;
                return;
            }
        }];
        return selectIndex;
    }
    return 0;
}

- (void)setStoreNo:(NSString *)storeNo {
    _storeNo = storeNo;
    if (!self.storeModel && storeNo) {
        [self getData];
    }
}

- (void)getData {
    if (self.fromOrder) {
        [self checkMerchantStatusWithStoreNo];
    } else {
        [self getStoreDetail];
    }
}

/// 获取门店详情
- (void)getStoreDetail {
    @HDWeakify(self);
    [self.view hd_removePlaceholderView];
    [self.homeDTO merchantDetailStoreNo:self.storeNo productCode:self.fromOrder ? self.productCode : nil success:^(GNStoreDetailModel *_Nonnull detailModel) {
        @HDStrongify(self);
        [self dismissLoading];
        self.storeModel = detailModel;
        [self setParamTitle:self.pageView.param];
        self.filterView.dataSource = self.storeModel.productList ?: @[];
        if (self.storeModel.productList.count) {
            [self.view hd_removePlaceholderView];
            [self.pageView updateMenuData];
        } else {
            self.placeholderViewModel.needRefreshBtn = NO;
            self.placeholderViewModel.image = @"gn_store_nodata";
            self.placeholderViewModel.title = GNLocalizedString(@"gn_store_noProduct", @"该商家还没有上架商品！");
            [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/// 设置标题
- (void)setParamTitle:(WMZPageParam *)param {
    if (self.fromOrder && [self.fromOrder isEqualToString:@"bugAgain"] && self.productCode) {
        GNProductModel *productModel = nil;
        for (GNProductModel *product in self.storeModel.productList) {
            if ([product.codeId isEqualToString:self.productCode]) {
                productModel = product;
                break;
            }
        }
        self.storeModel.productList = productModel ? @[productModel] : @[];
    }
    param.wTitleArr = self.storeModel.productList ?: @[];
    param.wMenuDefaultIndex = [self getDefaultSelect:param];
}

/// 获取门店状态
- (void)checkMerchantStatusWithStoreNo {
    @HDWeakify(self)[self.view hd_removePlaceholderView];
    [self showloading];
    [self.homeDTO checkMerchantStatusWithStoreNo:self.storeNo success:^(BOOL result, GNMessageCode *_Nonnull model) {
        @HDStrongify(self) if (result && model) {
            self.shareBTN.hidden = YES;
            /// 关闭
            if ([model.codeId isEqualToString:GNStoreCheckStatusClosed]) {
                [self dismissLoading];
                self.placeholderViewModel.image = @"gn_store_close";
                self.placeholderViewModel.title = GNLocalizedString(@"gn_store_closet", @"很遗憾,门店停业中");
                self.placeholderViewModel.needRefreshBtn = YES;
                [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
            }
            /// 营业
            else if ([model.codeId isEqualToString:GNStoreCheckStatusOpen]) {
                [self.view hd_removePlaceholderView];
                self.shareBTN.hidden = NO;
                [self getStoreDetail];
            }
            /// 未知状态
            else {
                [self dismissLoading];
                self.placeholderViewModel.image = @"gn_store_close";
                self.placeholderViewModel.title = GNLocalizedString(@"gn_store_closet", @"很遗憾,门店停业中");
                self.placeholderViewModel.needRefreshBtn = YES;
                [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
            }
        }
        else {
            self.shareBTN.hidden = YES;
            [self dismissLoading];
            /// 网络错误
            self.placeholderViewModel.image = @"placeholder_network_error";
            self.placeholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
            self.placeholderViewModel.needRefreshBtn = NO;
            [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
        }
    }];
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

- (GNProductFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[GNProductFilterView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH)];
    }
    return _filterView;
}

- (GNOrderSubmitViewModel *)buyViewModel {
    return _buyViewModel ?: ({ _buyViewModel = GNOrderSubmitViewModel.new; });
}

- (UIViewPlaceholderViewModel *)placeholderViewModel {
    if (!_placeholderViewModel) {
        @HDWeakify(self) _placeholderViewModel = UIViewPlaceholderViewModel.new;
        _placeholderViewModel.needRefreshBtn = YES;
        _placeholderViewModel.title = GNLocalizedString(@"gn_store_closet", @"很遗憾,门店停业中");
        _placeholderViewModel.image = @"gn_store_close";
        _placeholderViewModel.needRefreshBtn = YES;
        _placeholderViewModel.refreshBtnTitle = GNLocalizedString(@"gn_to_home", @"去团购首页");
        _placeholderViewModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self)[self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _placeholderViewModel;
}

- (HDUIButton *)shareBTN {
    if (!_shareBTN) {
        _shareBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_shareBTN setImage:[UIImage imageNamed:@"gn_home_share_black"] forState:UIControlStateNormal];
        [_shareBTN setImageEdgeInsets:UIEdgeInsetsMake(kRealWidth(3), kRealWidth(3), kRealWidth(3), kRealWidth(3))];
        @HDWeakify(self)[_shareBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self shareAction];
        }];
    }
    return _shareBTN;
}

- (BOOL)allowContinuousBePushed {
    return YES;
}

- (BOOL)needLogin {
    return NO;
}

- (BOOL)needClose {
    return YES;
}

@end

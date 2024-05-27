//
//  GNStoreDetailViewController.m
//  SuperApp
//
//  Created by wmz on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStoreDetailViewController.h"
#import "GNAlertUntils.h"
#import "GNNaviView.h"
#import "GNOrderSubmitViewModel.h"
#import "GNShareView.h"
#import "GNStoreDetailHeadCell.h"
#import "GNStoreDetailViewModel.h"
#import "GNStoreTimeView.h"
#import "SASocialShareView.h"
#import "WMCustomViewActionView.h"
#import "LKDataRecord.h"


@interface GNStoreDetailViewController () <GNTableViewProtocol>
/// viewModel
@property (nonatomic, strong) GNStoreDetailViewModel *viewModel;
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
/// 抢购viewModel
@property (nonatomic, strong) GNOrderSubmitViewModel *buyViewModel;
///导航栏
@property (nonatomic, strong) GNNaviView *naviView;
/// gl
@property (nonatomic, strong) CAGradientLayer *gl;

/// 埋点相关
///< 来源
@property (nonatomic, copy) NSString *source;
///< 关联ID
@property (nonatomic, copy) NSString *associatedId;

@end


@implementation GNStoreDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        NSString *storeNo = [parameters objectForKey:@"storeNo"];
        if (!storeNo && [parameters objectForKey:@"ID"])
            storeNo = [parameters objectForKey:@"ID"];
        self.storeNo = storeNo;
        self.source = [parameters objectForKey:@"source"];
        self.associatedId = [parameters objectForKey:@"associatedId"];
    }
    return self;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviView];
    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if ([self.tableView.placeholderViewModel.refreshBtnTitle isEqualToString:GNLocalizedString(@"gn_to_home", @"去团购首页")]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self gn_getNewData];
        }
    };

    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self gn_getNewData];
    };

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productUpNotifacation:) name:kNotificationNameProductUp object:nil];
}

/// 刷新通知
- (void)productUpNotifacation:(NSNotification *)no {
    [self gn_getNewData];
}

- (void)updateViewConstraints {
    [self.naviView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationBarH);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self)[self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self gn_getData];
    }];
}

- (void)gn_getData {
    @HDWeakify(self) self.naviView.titleLB.text = self.viewModel.detailModel.storeName.desc;
    [self.tableView reloadData];
    self.tableView.GNdelegate = self;
    if (!self.viewModel.detailModel) {
        [self.tableView reloadFail];
        [self changeContentWithAlpah:1];
    } else {
        if (![self.viewModel.detailModel.storeStatus.codeId isEqualToString:GNStoreStatusOpening] || ![self.viewModel.detailModel.businessStatus.codeId isEqualToString:GNStoreBusnessTypeOpen]) {
            [self changeContentWithAlpah:1];
            self.tableView.customPlaceHolder = ^(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError) {
                @HDStrongify(self);
                self.tableView.placeholderViewModel.title = GNLocalizedString(@"gn_store_closet", @"很遗憾,门店停业中");
                self.tableView.placeholderViewModel.image = @"gn_store_close";
                self.tableView.placeholderViewModel.refreshBtnTitle = GNLocalizedString(@"gn_to_home", @"去团购首页");
            };
            [self.tableView reloadFail];
        } else {
            [self changeContentWithAlpah:0];
            [self.naviView.layer insertSublayer:self.gl atIndex:0];
            self.naviView.rightBTN.hidden = NO;
            [self.tableView reloadData:NO];
        }
    }
}

- (void)gn_getNewData {
    [self.viewModel getStoreDetailStoreNo:self.storeNo productCode:nil];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///刷新cell
    if ([event.key isEqualToString:@"reloadAction"]) {
        [self.tableView updateCell:nil];
    }
    /// reViews
    else if ([event.key isEqualToString:@"operationAction"]) {
        [HDMediator.sharedInstance navigaveToGNReViewListViewController:@{@"storeNo": self.storeNo}];
    }
    ///点击headView
    else if ([event.key isEqualToString:@"sectionAction"]) {
        GNCellModel *sectionModel = event.info[@"model"];
        if ([sectionModel isKindOfClass:GNCellModel.class] && [sectionModel.tag isKindOfClass:NSString.class]) {
            ///跳转相册
            if ([sectionModel.tag isEqualToString:@"photos"]) {
                GNViewController *vc = [[NSClassFromString(@"GNStorePhotoViewController") alloc] initWithViewModel:self.viewModel];
                [SAWindowManager navigateToViewController:vc parameters:@{@"storeNo": self.storeNo}];
            }
            ///跳转评论
            else if ([sectionModel.tag isEqualToString:@"reviews"]) {
                [HDMediator.sharedInstance navigaveToGNReViewListViewController:@{@"storeNo": self.storeNo}];
            }
        }
    }

    ///抢购
    else if ([event.key isEqualToString:@"buyAction"]) {
        @HDWeakify(self)[self showloading];
        [self.buyViewModel getRushBuyDetailStoreNo:self.storeNo code:event.info[@"code"] completion:^(NSString *_Nonnull error) {
            @HDStrongify(self)[self dismissLoading];
            if (!error) {
                [HDMediator.sharedInstance
                    navigaveToGNOrderTakeViewController:
                        @{@"productCode": event.info[@"code"], @"storeNo": self.storeNo, @"viewModel": self.buyViewModel, @"source": self.source, @"associatedId": self.associatedId}];
            }
        }];
    }
    ///导航
    else if ([event.key isEqualToString:@"navigationAction"]) {
        [GNAlertUntils navigation:self.viewModel.detailModel.storeName.desc lat:self.viewModel.detailModel.geoPointDTO.lat.doubleValue lon:self.viewModel.detailModel.geoPointDTO.lon.doubleValue];
    }
    ///联系商家
    else if ([event.key isEqualToString:@"callAction"]) {
        [GNAlertUntils callString:self.viewModel.detailModel.businessPhone];
    }
    ///点击评论商品
    else if ([event.key isEqualToString:@"commentProduct"]) {
        GNProductModel *model = event.info[@"data"];
        if ([model isKindOfClass:GNProductModel.class]) {
            [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{@"storeNo": self.storeNo, @"productCode": model.productCode, @"fromOrder": @"bugAgain"}];
        }
    }
    ///返回
    else if ([event.key isEqualToString:@"dissmiss"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    ///跳转地图
    else if ([event.key isEqualToString:@"mapAction"]) {
        if (self.viewModel.detailModel) {
            [HDMediator.sharedInstance navigaveToGNStoreMapViewController:@{@"storeModel": self.viewModel.detailModel}];
        } else {
            [HDMediator.sharedInstance navigaveToGNStoreMapViewController:@{@"storeNo": self.storeNo}];
        }
    }
    ///营业时间详情
    else if ([event.key isEqualToString:@"buinessDetailAction"]) {
        GNStoreTimeView *timeView = [[GNStoreTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        timeView.detailModel = self.viewModel.detailModel;
        [timeView layoutyImmediately];
        WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:timeView block:^(HDCustomViewActionViewConfig *_Nullable config) {
            config.title = PNLocalizedString(@"business_opening", @"营业时间");
            config.needTopSepLine = YES;
        }];
        [actionView show];
    }
}

#pragma - mark tableViewProtocol
- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    ///点击团购商品
    if ([NSStringFromClass(rowData.cellClass) isEqualToString:@"GNStoreDetailProductTableViewCell"] && [rowData.businessData isKindOfClass:GNProductModel.class]) {
        GNProductModel *model = (GNProductModel *)rowData.businessData;
        [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{
            @"storeNo": self.storeNo,
            @"storeModel": self.viewModel.detailModel,
            @"productCode": model.codeId,
        }];
    }
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (void)gnScrollViewDidScroll:(UIScrollView *)tableView {
    CGFloat alpah = MAX(0, MIN(1, tableView.contentOffset.y / kNavigationBarH));
    [self changeContentWithAlpah:alpah];
}

- (void)changeContentWithAlpah:(CGFloat)alpah {
    self.naviView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpah];
    self.naviView.titleLB.alpha = alpah;
    [self.naviView.leftBTN setImage:[UIImage imageNamed:alpah == 1 ? @"gn_home_nav_back" : @"gn_home_nav_back_white"] forState:UIControlStateNormal];
    [self.naviView.rightBTN setImage:[UIImage imageNamed:alpah == 1 ? @"gn_home_share_black" : @"gn_home_share_white"] forState:UIControlStateNormal];
    self.gl.colors = @[
        (__bridge id)[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:(1 - alpah) * 0.8].CGColor,
        (__bridge id)[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0].CGColor
    ];
    if (alpah > 0.5) {
        self.hd_statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.hd_statusBarStyle = UIStatusBarStyleLightContent;
    }
}

///分享
- (void)shareAction {
    @HDWeakify(self) NSString *routePath = [NSString stringWithFormat:@"SuperApp://GroupOn/store_detail?ID=%@", self.storeNo];
    NSString *encodeRoutePath = [routePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?="].invertedSet];
    NSString *language = @"en";
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        language = @"zh";
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        language = @"km";
    }
    NSString *webpageUrl = [NSString stringWithFormat:@"%@?storeNo=%@&language=%@&routePath=%@", self.viewModel.detailModel.shareUrl, self.storeNo, language, encodeRoutePath];

    SAShareWebpageObject *shareObject = SAShareWebpageObject.new;
    shareObject.title = [NSString stringWithFormat:GNLocalizedString(@"gn_store_worth_spending", @"这家店值得到店消费 [%@]"), GNFillEmpty(self.viewModel.detailModel.storeName.desc)];
    shareObject.webpageUrl = webpageUrl;
    shareObject.thumbImage = self.viewModel.detailModel.logo;
    HDSocialShareCellModel *generateImageFunctionModel = [SASocialShareView generateImageFunctionModel];
    generateImageFunctionModel.clickedHandler = ^(HDSocialShareCellModel *_Nonnull cellModel, NSInteger index) {
        @HDStrongify(self) GNShareView *imageShareView = GNShareView.new;
        imageShareView.storeModel = self.viewModel.detailModel;
        imageShareView.codeURL = webpageUrl;
        [imageShareView addShareStoreView];
        [SASocialShareView showShareWithTopCustomView:imageShareView completion:nil];
    };
    [SASocialShareView showShareWithShareObject:shareObject functionModels:@[SASocialShareView.copyLinkFunctionModel, generateImageFunctionModel] completion:^(BOOL success,
                                                                                                                                                               NSString *_Nullable shareChannel) {
        [LKDataRecord.shared
            traceEvent:@"click_pv_socialShare"
                  name:@""
            parameters:@{@"shareResult": success ? @"success" : @"fail", @"traceId": self.storeNo, @"traceUrl": webpageUrl, @"traceContent": @"GroupOnStoreShare", @"channel": shareChannel}];
    }];
}

- (GNStoreDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNStoreDetailViewModel.new;
    }
    return _viewModel;
}

- (GNNaviView *)naviView {
    if (!_naviView) {
        _naviView = GNNaviView.new;
        @HDWeakify(self)[_naviView.rightBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self shareAction];
        }];
        _naviView.rightBTN.hidden = YES;
        [self gnScrollViewDidScroll:self.tableView];
    }
    return _naviView;
}

- (CAGradientLayer *)gl {
    if (!_gl) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0, 0, kScreenWidth, kNavigationBarH);
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.locations = @[@(0), @(1.0f)];
        _gl = gl;
    }
    return _gl;
}

- (GNOrderSubmitViewModel *)buyViewModel {
    return _buyViewModel ?: ({ _buyViewModel = GNOrderSubmitViewModel.new; });
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.needRefreshHeader = YES;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kiPhoneXSeriesSafeBottomHeight, 0);
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return (id)[GNStoreDetailHeadCell cellWithTableView:tableview];
            } else {
                return [GNTableViewCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [GNStoreDetailHeadCell skeletonViewHeight];
            } else {
                return [GNTableViewCell skeletonViewHeight];
            }
        }];
        _tableView.provider.numberOfRowsInSection = 10;
        _tableView.delegate = self.tableView.provider;
        _tableView.dataSource = self.tableView.provider;
        _tableView.needShowErrorView = YES;
        _tableView.needRefreshBTN = YES;
    }
    return _tableView;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameProductUp object:nil];
}

@end

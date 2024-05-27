//
//  SACMSWaterfallViewController.m
//  SuperApp
//
//  Created by seeu on 2021/12/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallViewController.h"
#import "HDCollectionViewVerticalLayout.h"
#import "LKDataRecord.h"
#import "SACMSCardView.h"
#import "SACMSCollectionReusableView.h"
#import "SACMSCollectionViewCell.h"
#import "SACMSFloatWindowPluginView.h"
#import "SACMSManager.h"
#import "SACMSNavigationBarPlugin.h"
#import "SACMSNewUserMarketingView.h"
#import "SACMSWaterfallCategoryCollectionReusableView.h"
#import "SACacheManager.h"
#import "SACollectionView.h"
#import "SAWriteDateReadableModel.h"
#import <HDKitCore/NSString+HD_Util.h>
#import "SAAddressCacheAdaptor.h"
#import "SACMSUserGeneratedContentCollectionViewCell.h"
#import "SACMSWaterfallViewController+waterfall.h"
#import "SACMSWaterfallViewController+YumNowBrandLanding.h"
#import "YumNowLandingPageStoreListCollectionReusableView.h"


@interface SACMSWaterfallViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>

@property (nonatomic, strong) SACollectionView *collectionView;               ///<
@property (nonatomic, strong) UIImageView *bgImageView;                       ///< 背景图
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource; ///< 数据源
@property (nonatomic, assign) UIEdgeInsets edgeInst;                          ///< 内边距

///< cms配置
@property (nonatomic, strong) SACMSPageViewConfig *pageConfig;
///< CMS卡片Section
@property (nonatomic, strong) HDTableViewSectionModel *cardSection;
///< 顶部自定义区域
@property (nonatomic, strong) HDTableViewSectionModel *customTopSection;
///< 底部自定义区
@property (nonatomic, strong) HDTableViewSectionModel *customBottomSection;

///< 当前位置
@property (nonatomic, strong) SAAddressModel *currentAddress;

///< 浮动插件
@property (nonatomic, strong) SACMSFloatWindowPluginView *floatWindow;
///< 导航栏插件
@property (nonatomic, strong) SACMSNavigationBarPlugin *navigationPlugin;
///< 新用户营销插件
@property (nonatomic, strong) SACMSNewUserMarketingView *userMarketingPlugin;
///< 状态栏占位图
@property (nonatomic, strong) UIView *placeHolderView;
///< 定位是否托管
@property (nonatomic, assign) BOOL locationServiceWasEscrow;

@property (nonatomic, assign) BOOL isHandleLocationChange;

///< 是否透传参数
@property (nonatomic, assign) BOOL isRedirectionParams;
///< 任务中心参数
@property (nonatomic, copy) NSString *taskId;
///< 是否第一次加载
@property (nonatomic, assign) BOOL isFirstLoad;

@end


@implementation SACMSWaterfallViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.isRedirectionParams = NO;

        NSString *taskId = [parameters valueForKey:@"taskId"];
        NSString *redirection = [parameters valueForKey:@"redirection"];
        if (!HDIsObjectNil(taskId) && HDIsStringNotEmpty(taskId)) {
            self.taskId = [taskId copy];
        }

        if (!HDIsObjectNil(redirection) && HDIsStringNotEmpty(redirection)) {
            self.isRedirectionParams = [redirection boolValue];
        }
    }
    return self;
}

- (void)hd_setupViews {
    self.edgeInst = UIEdgeInsetsMake(0, 0, 0, 0);
    self.currentPage = 1;
    self.currentCategory = nil;
    // 定位没有被托管
    self.locationServiceWasEscrow = NO;
    self.isFirstLoad = YES;

    [self.view addSubview:self.container];
    [self.container addSubview:self.bgImageView];
    [self.container addSubview:self.placeHolderView];
    [self.container addSubview:self.collectionView];

    @HDWeakify(self);
    self.collectionView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };

    self.collectionView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };

    [self.collectionView registerEndScrollinghandler:^{
        @HDStrongify(self);
        if (!self.collectionView.isScrolling && !HDIsObjectNil(self.floatWindow)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //停止滚动的时候  展开浮动窗口
                [self.floatWindow expand];
            });
        }
    } withKey:@"CMSPluginFloatWindow"];

//    [self.collectionView successGetNewDataWithNoMoreData:NO];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置管理器位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logoutHandler) name:kNotificationNameUserLogout object:nil];
    // 监听手切位置改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
}

- (void)updateViewConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (self.navigationPlugin) {
            make.top.equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height);
        } else {
            make.top.equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height + 44);
        }
    }];

    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top).offset(self.edgeInst.top);
        make.left.equalTo(self.bgImageView.mas_left).offset(self.edgeInst.left);
        make.right.equalTo(self.bgImageView.mas_right).offset(-self.edgeInst.right);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-self.edgeInst.bottom);
    }];

    [super updateViewConstraints];
}

- (void)hd_languageDidChanged {
    [self getNewData];
    
    // 判断是否已经展示过该 window
    BOOL hasShown = [[NSUserDefaults.standardUserDefaults objectForKey:@"hasShownChooseLanguageWindow"] boolValue];
    if (hasShown) {
        // 拿当前用户选择的经纬度
        if (HDLocationUtils.getCLAuthorizationStatus == HDCLAuthorizationStatusNotDetermined) {
            [HDLocationManager.shared requestWhenInUseAuthorization];
        }
    }
}

#pragma mark - public methods
- (void)reloadWithNoMoreData:(BOOL)noMore {
    [self.collectionView successGetNewDataWithNoMoreData:noMore scrollToTop:NO];
}

- (void)registerClass:(nullable Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
}

#pragma mark - Data
- (void)getNewData {
    if (self.locationServiceWasEscrow) {
        HDLog(@"位置已经被插件代理，用插件的地址请求");
        [self getNewDataWithAddressModel:self.navigationPlugin.currentlyAddress isRefresh:true];
        return;
    }

    HDLog(@"位置没有被插件代理，当前地址请求");
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    [self getNewDataWithAddressModel:addressModel isRefresh:true];
    // 回调代理，通知位置变化
    if ([self respondsToSelector:@selector(locationDidChanged:)]) {
        [self locationDidChanged:addressModel];
    }
}

- (void)getNewDataWithAddressModel:(SAAddressModel *_Nullable)addressModel {
    [self getNewDataWithAddressModel:addressModel isRefresh:YES];
}

- (void)getNewDataWithAddressModel:(SAAddressModel *_Nullable)addressModel isRefresh:(BOOL)isRefresh {
    NSString *pageLabel = self.parameters[@"pageLabel"];
    if (HDIsStringEmpty(pageLabel)) {
        [self.collectionView failGetNewData];
        return;
    }

    //相同地址，非下拉刷新时，直接return
    if (self.currentAddress && [self.currentAddress isEqual:addressModel] && !isRefresh)
        return;

    self.currentAddress = addressModel;

    // 异步开始请求最新数据
    @HDWeakify(self);

    [SACMSManager getPageWithAddress:self.currentAddress
                            identify:pageLabel
                           pageWidth:kScreenWidth
                          operatorNo:[SAUser hasSignedIn] ? SAUser.shared.operatorNo : @""
                             success:^(SACMSPageView *_Nonnull page, SACMSPageViewConfig *_Nonnull config) {
            @HDStrongify(self);
            [self translateCmsDataToCellDataWithPageView:page config:config];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            // 移除加载骨架，避免首次加载异常时没有内容显示
            self.cardSection.list = [self.cardSection.list hd_filterWithBlock:^BOOL(id  _Nonnull item) {
                return ![item isKindOfClass:SACMSSkeletonCollectionViewCellModel.class];
            }];
            self.waterfallSection.list = [self.waterfallSection.list hd_filterWithBlock:^BOOL(id  _Nonnull item) {
                return ![item isKindOfClass:SACMSWaterfallSkeletonCollectionViewCellModel.class];
            }];
            // 用源数据刷新，避免用户无法操作
            [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        }];
}

- (void)loadMoreData {
    
    if(self.pageConfig.pageTemplateType == 11) {
        [self waterfallTemplateLoadMoreData];
        
    } else if(self.pageConfig.pageTemplateType == 12) {
        [self yumNowBrandLandingTemplateLoadMoreData];
    } else {
        [self.collectionView successLoadMoreDataWithNoMoreData:YES];
    }
    
}

#pragma mark - private methods
- (void)translateCmsDataToCellDataWithPageView:(SACMSPageView *)page config:(SACMSPageViewConfig *)config {
    if ([self.pageConfig isEqual:config]) {
        HDLog(@"页面配置一致, 不需要重新创建");
        [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        // 加载模板内容
        [self generateDiffTemplateWithPageConfig:config];
        
        if(self.isFirstLoad) {
            self.isFirstLoad = NO;
            [self performSelector:@selector(firstLoadSuccessHandler) withObject:nil afterDelay:0.5];
            
        }
        
    } else {
        HDLog(@"页面配置不一致, 重新创建");
        self.pageConfig = config;
        [self generateCMSPageViewWithConfig:config];
        [self generateCMSCardsWithPage:page config:config];
        @HDWeakify(self);
        [self generatePlugins:config.plugins completion:^{
            @HDStrongify(self);
            [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
            // 根据页面模板生成差异性内容
            [self generateDiffTemplateWithPageConfig:config];
            
            if(self.isFirstLoad) {
                self.isFirstLoad = NO;
                [self performSelector:@selector(firstLoadSuccessHandler) withObject:nil afterDelay:0.5];
            }
            
        }];
    }
}

/// 配置CMS页面
/// @param config cms页面配置
- (void)generateCMSPageViewWithConfig:(SACMSPageViewConfig *)config {
    ///  设置页面属性

    self.container.backgroundColor = [config getBackgroundColor];
    self.edgeInst = [config getContentEdgeInsets];

    if (HDIsStringNotEmpty(config.getBackgroundImage)) {
        self.bgImageView.hidden = NO;
        [HDWebImageManager setImageWithURL:config.getBackgroundImage placeholderImage:nil imageView:self.bgImageView];
    } else {
        self.bgImageView.hidden = YES;
    }
}
/// 配置CMS卡片
/// @param page cms页面对象
/// @param config cms页面配置
- (void)generateCMSCardsWithPage:(SACMSPageView *)page config:(SACMSPageViewConfig *)config {
    // 配置卡片
    NSMutableArray<SACMSCollectionViewCellModel *> *cellModels = [[NSMutableArray alloc] initWithCapacity:3];
    [page.cardViews enumerateObjectsUsingBlock:^(SACMSCardView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        SACMSCollectionViewCellModel *model = SACMSCollectionViewCellModel.new;
        model.cardView = obj;
        model.cardConfig = obj.config;
        model.cardView.clickNode = ^(SACMSCardView *_Nonnull card, SACMSNode *_Nullable node, NSString *_Nullable link, NSString *_Nullable spm) {
            if (HDIsStringNotEmpty(link)) {
                if ([link.lowercaseString hasPrefix:@"superapp://"] && ![SAWindowManager canOpenURL:link]) {
                    [NAT showAlertWithMessage:SALocalizedString(@"feature_no_support", @"您的App不支持这个功能哦~请升级最新版APP体验完整功能~")
                                  buttonTitle:SALocalizedString(@"update_righnow", @"去升级") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                      [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1507128993"];
                                  }];
                    return;
                } else {
                    [SAWindowManager openUrl:link withParameters:@{
                        @"source" : [NSString stringWithFormat:@"%@.%@@%zd.%@", card.page.pageName, card.config.cardName, idx, spm],
                        @"associatedId" : node.nodePublishNo
                    }];
                }
            }

            [LKDataRecord.shared traceClickEvent:HDIsStringNotEmpty(node.name) ? node.name : @"" parameters:@{@"route": link}
                                             SPM:[LKSPM SPMWithPage:card.page.pageName area:[NSString stringWithFormat:@"%@@%zd", card.config.cardName, idx] node:spm]];

            HDLog(@"spm:%@", spm);

            // 首页转化漏斗
            [NSUserDefaults.standardUserDefaults setObject:node.name forKey:@"homePage_click_source"];
            [NSUserDefaults.standardUserDefaults setObject:node.nodePublishNo forKey:@"homePage_click_associatedId"];
        };
        [cellModels addObject:model];
    }];

    self.cardSection.list = cellModels;
}

- (void)generateDiffTemplateWithPageConfig:(SACMSPageViewConfig *)config {

    /// 不同模板不同处理
    if (config.pageTemplateType == 11) {
        [self generateWaterfallTemplateWithPageConfig:config];
        
    } else if(config.pageTemplateType == 12) {
        [self generateYumNowBrandLandingTemplateWithPageConfig:config];
        
    } else {
        self.categoryTitleViewConfig = nil;
        self.waterfallSection.list = @[];
        self.currentCategory = nil;
        self.waterfallConfig = nil;
        self.collectionView.needRefreshFooter = NO;
        //配置插件
        [self.collectionView successGetNewDataWithNoMoreData:YES];
    }
}

/// 配置插件
- (void)generatePlugins:(NSArray<SACMSPluginViewConfig *> *_Nullable)pluginConfigs completion:(void (^)(void))completion {
    NSArray<SACMSPluginViewConfig *> *floatWindowFilterResult = [pluginConfigs hd_filterWithBlock:^BOOL(SACMSPluginViewConfig *_Nonnull item) {
        return [item.modleLable isEqualToString:CMSPluginIdentifyFloatWindow];
    }];

    if (floatWindowFilterResult.count) {
        if (self.floatWindow && [self.floatWindow.config isEqual:floatWindowFilterResult.firstObject]) {
            HDLog(@"已经存在浮动窗口，且配置一样，不需要替换");
        } else {
            SACMSPluginViewConfig *pluginConfig = floatWindowFilterResult.firstObject;
            pluginConfig.pageConfig = self.pageConfig;

            if (!self.floatWindow) {
                // 如果不存在则创建
                self.floatWindow = [[SACMSFloatWindowPluginView alloc] initWithConfig:pluginConfig];
                [self.view addSubview:self.floatWindow];
                [self.view bringSubviewToFront:self.floatWindow];
            } else {
                // 存在，更新配置
                [self.floatWindow removeFromSuperview];
                self.floatWindow.config = pluginConfig;
                [self.view addSubview:self.floatWindow];
                [self.view bringSubviewToFront:self.floatWindow];
            }
        }
    } else {
        // 没有配置，移除当前窗口
        if (self.floatWindow) {
            [self.floatWindow removeFromSuperview];
            self.floatWindow = nil;
        }
    }

    NSArray<SACMSPluginViewConfig *> *userMarketingPluginFilterResult = [pluginConfigs hd_filterWithBlock:^BOOL(SACMSPluginViewConfig *_Nonnull item) {
        return [item.modleLable isEqualToString:CMSPluginIdentifyNewUserMarketingView];
    }];
    if (userMarketingPluginFilterResult.count) {
        if (self.userMarketingPlugin && [self.userMarketingPlugin.config isEqual:userMarketingPluginFilterResult.firstObject]) {
            HDLog(@"已经存在该插件，且配置一样，不需要更新");
        } else {
            SACMSPluginViewConfig *pluginConfig = userMarketingPluginFilterResult.firstObject;
            pluginConfig.pageConfig = self.pageConfig;

            if (!self.userMarketingPlugin) {
                self.userMarketingPlugin = [[SACMSNewUserMarketingView alloc] initWithConfig:pluginConfig];
                self.userMarketingPlugin.frame = CGRectMake(0, self.view.bottom - kRealWidth(56), kScreenWidth, kRealWidth(56));
                if (![SAUser hasSignedIn]) {
                    [self.view addSubview:self.userMarketingPlugin];
                    [self.view bringSubviewToFront:self.userMarketingPlugin];
                }

            } else {
                self.userMarketingPlugin.config = pluginConfig;
            }
        }
    } else {
        // 移除
        if (self.userMarketingPlugin) {
            [self.userMarketingPlugin removeFromSuperview];
            self.userMarketingPlugin = nil;
        }
    }

    NSArray<SACMSPluginViewConfig *> *navPluginFilterResult = [pluginConfigs hd_filterWithBlock:^BOOL(SACMSPluginViewConfig *_Nonnull item) {
        return [item.modleLable isEqualToString:CMSPluginIdentifyNavigationBar];
    }];

    if (navPluginFilterResult.count) {
        if (self.navigationPlugin && [self.navigationPlugin.config isEqual:navPluginFilterResult.firstObject]) {
            HDLog(@"导航栏已存在，且配置没变，不需要重新创建");
            !completion ?: completion();
        } else {
            SACMSPluginViewConfig *pluginConfig = navPluginFilterResult.firstObject;
            pluginConfig.pageConfig = self.pageConfig;

            if (!self.navigationPlugin) {
                self.navigationPlugin = [[SACMSNavigationBarPlugin alloc] initWithConfig:pluginConfig];
                self.navigationPlugin.bindVCName = NSStringFromClass(self.class);
            } else {
                self.navigationPlugin.config = pluginConfig;
            }

            if (self.navigationPlugin.navConfig.enableLocation) {
                // 定位逻辑交由插件托管
                self.locationServiceWasEscrow = YES;
                @HDWeakify(self);
                self.navigationPlugin.locationChangedHandler = ^(SAAddressModel *_Nullable address) {
                    @HDStrongify(self);
                    HDLog(@"插件位置变化了，处理业务逻辑");
                    [self getNewDataWithAddressModel:address isRefresh:false];
                    // 回调代理，通知位置变化
                    if ([self respondsToSelector:@selector(locationDidChanged:)]) {
                        [self locationDidChanged:address];
                    }
                };
            } else {
                // 插件没有开启定位功能，自己实现，不托管
                self.locationServiceWasEscrow = NO;
            }

            [self.hd_navigationBar setHidden:YES];
            [self setBoldTitle:@""];

            [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height);
            }];

            MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.collectionView.mj_header;
            // 如果是白色背景，状态栏设置成黑色
            if ([self.navigationPlugin.navConfig.backgroundColor isEqualToString:@"#FFFFFF"]) {
                self.hd_statusBarStyle = UIStatusBarStyleDefault;
                if (head.loadingView.activityIndicatorViewStyle != UIActivityIndicatorViewStyleGray) {
                    head.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                }
            } else {
                self.hd_statusBarStyle = UIStatusBarStyleLightContent;
                head.stateLabel.textColor = UIColor.whiteColor;
                if (head.loadingView.activityIndicatorViewStyle != UIActivityIndicatorViewStyleWhite) {
                    head.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                }
            }
            @HDWeakify(self);
            [UIView animateWithDuration:0.3 animations:^{
                @HDStrongify(self);
                [self.placeHolderView setHidden:NO];
                self.placeHolderView.backgroundColor = self.navigationPlugin.backgroundColor;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                !completion ?: completion();
            }];
        }
    } else {
        // 没有导航栏插件，移除原有的
        if (self.navigationPlugin) {
            [self.navigationPlugin removeFromSuperview];
            self.navigationPlugin = nil;
        }
        self.locationServiceWasEscrow = NO;
        [self.hd_navigationBar setHidden:NO];
        //设置导航栏名称
        [self setBoldTitle:self.pageConfig.pageName];
        @HDWeakify(self);
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            @HDStrongify(self);
            make.top.equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height + 44);
        }];
        self.hd_statusBarStyle = UIStatusBarStyleDefault;
        MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.collectionView.mj_header;
        if (head.loadingView.activityIndicatorViewStyle != UIActivityIndicatorViewStyleGray) {
            head.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }

        [UIView animateWithDuration:0.3 animations:^{
            @HDStrongify(self);
            [self.placeHolderView setHidden:YES];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            !completion ?: completion();
        }];
    }
}


#pragma mark - setter
- (void)setEdgeInst:(UIEdgeInsets)edgeInst {
    if (!UIEdgeInsetsEqualToEdgeInsets(edgeInst, _edgeInst)) {
        [self.view setNeedsUpdateConstraints];
    }
    _edgeInst = edgeInst;
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    if (self.locationServiceWasEscrow) {
        HDLog(@"位置管理已经被托管，忽略当前回调");
        return;
    }

    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status != HDCLAuthorizationStatusNotDetermined) {
        [self getNewData];
    }
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.locationServiceWasEscrow) {
        HDLog(@"位置管理已经被托管，忽略当前回调");
        return;
    }
    HDLog(@"位置变化了，处理业务逻辑");
    if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
        if (self.isHandleLocationChange)
            return;

        self.isHandleLocationChange = true;

        CLLocationCoordinate2D coordinate2D;
        SAAddressModel *cacheAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
        if(!HDIsObjectNil(cacheAddress) && [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(cacheAddress.lat.doubleValue, cacheAddress.lon.doubleValue)]) {
            coordinate2D = CLLocationCoordinate2DMake(cacheAddress.lat.doubleValue, cacheAddress.lon.doubleValue);
        } else {
            coordinate2D = HDLocationManager.shared.coordinate2D;
        }
        
        
        if (!HDIsObjectNil(self.currentAddress) &&
            [HDLocationUtils distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.currentAddress.lat.doubleValue longitude:self.currentAddress.lon.doubleValue]
                                       toLocation:[[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude]]
                < 200.0) {
            HDLog(@"2位置变化不大，忽略");
            self.isHandleLocationChange = false;
            return;
        }
        [SALocationUtil transferCoordinateToAddress:coordinate2D completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary *_Nullable addressDictionary) {
            SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
            addressModel.lat = @(coordinate2D.latitude);
            addressModel.lon = @(coordinate2D.longitude);
            addressModel.address = address;
            addressModel.consigneeAddress = consigneeAddress;
            addressModel.fromType = SAAddressModelFromTypeLocate;

            // 回调代理，通知位置变化
            if ([self respondsToSelector:@selector(locationDidChanged:)]) {
                [self locationDidChanged:addressModel];
            }

            [self getNewDataWithAddressModel:addressModel isRefresh:false];
            self.isHandleLocationChange = false;
        }];
    }
}

- (void)userChangedLocationHandler:(NSNotification *)noti {
        HDLog(@"用户手切地址了");
    if(self.locationServiceWasEscrow) {
        return;
    }
    self.isHandleLocationChange = YES;
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    
    // 回调代理，通知位置变化
    if ([self respondsToSelector:@selector(locationDidChanged:)]) {
        [self locationDidChanged:addressModel];
    }

    [self getNewDataWithAddressModel:addressModel isRefresh:false];
    
    self.isHandleLocationChange = NO;
 }

- (void)firstLoadSuccessHandler {
    
}

#pragma mark - UserLoginStateChanged
- (void)loginSuccessHandler {
    if (self.userMarketingPlugin) {
        [self.userMarketingPlugin removeFromSuperview];
    }
}

- (void)logoutHandler {
    if (self.userMarketingPlugin) {
        [self.view addSubview:self.userMarketingPlugin];
        [self.view bringSubviewToFront:self.userMarketingPlugin];
    }
}

#pragma mark - collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:numberOfItemsInArea:)]) {
        return [self collectionView:collectionView numberOfItemsInArea:CMSContainerCustomSectionTop];
    }

    if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:numberOfItemsInArea:)]) {
        return [self collectionView:collectionView numberOfItemsInArea:CMSContainerCustomSectionBottom];
    }

    return sectionModel.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *tmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];

    if (indexPath.section >= self.dataSource.count) {
        return tmp;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:inArea:)]) {
        return [self collectionView:collectionView cellForItemAtIndexPath:indexPath inArea:CMSContainerCustomSectionTop];
    }

    if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:inArea:)]) {
        return [self collectionView:collectionView cellForItemAtIndexPath:indexPath inArea:CMSContainerCustomSectionBottom];
    }
    // 瀑布流由模板各自实现
    if([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            
        } else {
            return tmp;
        }
    }
    

    if (indexPath.row >= sectionModel.list.count) {
        return tmp;
    }

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SACMSCollectionViewCellModel.class]) {   // cms卡片cell
        SACMSCollectionViewCellModel *cellModel = (SACMSCollectionViewCellModel *)model;
        SACMSCollectionViewCell *cell = [SACMSCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(SACMSCollectionViewCell.class)];
        cell.model = cellModel;
        return cell;
        
    } else if ([model isKindOfClass:SACMSSkeletonCollectionViewCellModel.class]) { // cms卡片加载骨架
        SACMSSkeletonCollectionViewCellModel *trueModel = (SACMSSkeletonCollectionViewCellModel *)model;
        SACMSSkeletonCollectionViewCell *cell = [SACMSSkeletonCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                             identifier:NSStringFromClass(SACMSSkeletonCollectionViewCell.class)];
        cell.model = trueModel;
        return cell;
        
    }
    
    return tmp;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= self.dataSource.count) {
        return;
    }
    id section = self.dataSource[indexPath.section];
    
    if([section isEqual:self.waterfallSection] || [section isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            [self waterfallTemplateCollectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        } else if(self.pageConfig.pageTemplateType == 12) {
            [self yumNowBrandLandingTemplateCollectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        }
    }
    
    
    if ([cell isKindOfClass:SACMSSkeletonCollectionViewCell.class]) {
        [cell hd_beginSkeletonAnimation];
    } else if ([cell isKindOfClass:SACMSCollectionViewCell.class]) {  //监听视频卡片出现播放视频
        [(SACMSCollectionViewCell *)cell startPlayer];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //监听视频卡片消失暂停视频
    if ([cell isKindOfClass:SACMSCollectionViewCell.class]) {
        [(SACMSCollectionViewCell *)cell stopPlayer];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return nil;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:inArea:)]) {
        return [self collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath inArea:CMSContainerCustomSectionTop];
    }

    if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:inArea:)]) {
        return [self collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath inArea:CMSContainerCustomSectionBottom];
    }

    if ([sectionModel isEqual:self.cardSection]) {
        if ([self respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:inArea:)]) {
            return [self collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath inArea:CMSContainerCustomSectionCard];

        } else if (self.navigationPlugin) {
            SACMSCollectionReusableView *reusableView = [SACMSCollectionReusableView headerWithCollectionView:collectionView forIndexPath:indexPath];
            reusableView.customeView = self.navigationPlugin;
            return reusableView;

        } else {
            return nil;
        }
    }

    if ([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:didSelectItemAtRow:inArea:)]) {
        return [self collectionView:collectionView didSelectItemAtRow:indexPath.row inArea:CMSContainerCustomSectionTop];
    }

    if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:didSelectItemAtRow:inArea:)]) {
        return [self collectionView:collectionView didSelectItemAtRow:indexPath.row inArea:CMSContainerCustomSectionBottom];
    }

    if (indexPath.row >= sectionModel.list.count) {
        return;
    }
    
    if([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            [self waterfallTemplateCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            [self yumNowBrandLandingTemplateCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
}
#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count) {
        return CGSizeMake(0, 0);
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:layout:sizeForItemAtRow:inArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtRow:indexPath.row inArea:CMSContainerCustomSectionTop];
        
    } else if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:layout:sizeForItemAtRow:inArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtRow:indexPath.row inArea:CMSContainerCustomSectionBottom];
        
    } else if([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
            
        } else {
            return CGSizeZero;
        }
        
    }

    if (indexPath.row >= self.dataSource[indexPath.section].list.count) {
        HDLog(@"数组越界：section %zd, row:%zd", indexPath.section, indexPath.row);
        return CGSizeMake(0, 0);
    }
    
    id model = sectionModel.list[indexPath.row];

    if ([model isKindOfClass:SACMSCollectionViewCellModel.class]) {
        SACMSCollectionViewCellModel *trueModel = (SACMSCollectionViewCellModel *)model;
        return CGSizeMake(kScreenWidth, [trueModel.cardView heightOfCardView]);

    } else if ([model isKindOfClass:SACMSSkeletonCollectionViewCellModel.class]) {
        SACMSSkeletonCollectionViewCellModel *trueModel = (SACMSSkeletonCollectionViewCellModel *)model;
        return CGSizeMake(kScreenWidth, trueModel.cellHeight);

    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return CGSizeZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInArea:CMSContainerCustomSectionTop];
        
    } else if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInArea:CMSContainerCustomSectionBottom];
        
    } else if([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
        }
        
    } else if ([sectionModel isEqual:self.cardSection]) {
        if ([self respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInArea:)]) {
            return [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInArea:CMSContainerCustomSectionCard];
            
        } else if (self.navigationPlugin) {
            return CGSizeMake(kScreenWidth, 44);
        }
    }
    
    return CGSizeZero;

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return UIEdgeInsetsZero;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:layout:insetForArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout insetForArea:CMSContainerCustomSectionTop];
        
    } else if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:layout:insetForArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout insetForArea:CMSContainerCustomSectionBottom];
        
    } else if ([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
            
        }
        
    }
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForArea:CMSContainerCustomSectionTop];
        
    } else if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForArea:CMSContainerCustomSectionBottom];
        
    } else if ([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
            
        }
        
    }
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 0;
    }

    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    // 自定义区域
    if ([sectionModel isEqual:self.customTopSection] && [self respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForArea:CMSContainerCustomSectionTop];
        
    } else if ([sectionModel isEqual:self.customBottomSection] && [self respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForArea:)]) {
        return [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForArea:CMSContainerCustomSectionBottom];
        
    } else if ([sectionModel isEqual:self.waterfallSection] || [sectionModel isEqual:self.noDataSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
            
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
            
        }
    }
    
    return 0;
}

#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return 1;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if ([sectionModel isEqual:self.waterfallSection]) {
        if(self.pageConfig.pageTemplateType == 11) {
            return [self waterfallTemplateCollectionView:collectionView layout:collectionViewLayout columnCountOfSection:section];
        } else if(self.pageConfig.pageTemplateType == 12) {
            return [self yumNowBrandLandingTemplateCollectionView:collectionView layout:collectionViewLayout columnCountOfSection:section];
            
        }
    }
    
    return 1;
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];

    if (self.navigationPlugin) {
        // 放大 imageView 及其蒙版
        CGRect newFrame = self.placeHolderView.frame;
        CGFloat settingViewOffsetY = UIApplication.sharedApplication.statusBarFrame.size.height - scrollView.contentOffset.y;
        newFrame.size.height = settingViewOffsetY;
        if (settingViewOffsetY < UIApplication.sharedApplication.statusBarFrame.size.height) {
            newFrame.size.height = UIApplication.sharedApplication.statusBarFrame.size.height;
        }
        self.placeHolderView.frame = newFrame;

        NSArray<UICollectionReusableView *> *headerView = [self.collectionView visibleSupplementaryViewsOfKind:UICollectionElementKindSectionHeader];
        //        HDLog(@"当前header数量：%zd, 位移:%f, views:%@", headerView.count, scrollView.contentOffset.y, headerView);

        UIColor *bgColor = nil;
        if (headerView.count == 0 && scrollView.contentOffset.y == 0) {
            bgColor = self.navigationPlugin.backgroundColor;
            self.hd_statusBarStyle = UIStatusBarStyleLightContent;
        } else if (headerView.count == 0) {
            bgColor = UIColor.whiteColor;
            self.hd_statusBarStyle = UIStatusBarStyleDefault;
        } else {
            NSArray<UICollectionReusableView *> *tmp = [headerView sortedArrayUsingComparator:^NSComparisonResult(UICollectionReusableView *_Nonnull obj1, UICollectionReusableView *_Nonnull obj2) {
                return obj1.frame.origin.y > obj2.frame.origin.y ? NSOrderedDescending : NSOrderedAscending;
            }];

            __block UICollectionReusableView *bottomView = nil;
            [tmp enumerateObjectsUsingBlock:^(UICollectionReusableView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (bottomView) {
                    if (obj.frame.origin.y < scrollView.contentOffset.y && obj.frame.origin.y > bottomView.frame.origin.y) {
                        bottomView = obj;
                    }
                } else {
                    bottomView = obj;
                }
            }];

            bgColor = bottomView.backgroundColor;
            if ([bottomView.reuseIdentifier isEqualToString:NSStringFromClass(SACMSWaterfallCategoryCollectionReusableView.class)]) {
                self.hd_statusBarStyle = UIStatusBarStyleDefault;
            } else {
                self.hd_statusBarStyle = UIStatusBarStyleLightContent;
            }
        }

        [UIView animateWithDuration:0.3 animations:^{
            self.placeHolderView.backgroundColor = bgColor;
        }];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    scrollView.isScrolling = false;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!HDIsObjectNil(self.floatWindow)) {
        [self.floatWindow shrink];
    }
}

#pragma mark - lazy load
/** @lazy bgImageView */
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

/** @lazy tableview */
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.header_suspension = YES;
        _collectionView = [[SACollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.needRefreshHeader = YES;
        _collectionView.needShowNoDataView = YES;

        [_collectionView registerClass:SACMSWaterfallCategoryCollectionReusableView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACMSWaterfallCategoryCollectionReusableView.class)];

        [_collectionView registerClass:SACMSCollectionReusableView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACMSCollectionReusableView.class)];

        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        
        [_collectionView registerClass:YumNowLandingPageStoreListCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YumNowLandingPageStoreListCollectionReusableView.class)];

        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.font.standard3;
        placeHolderModel.titleColor = HDAppTheme.color.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        @HDWeakify(self);
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self getNewData];
        };
        _collectionView.placeholderViewModel = placeHolderModel;
    }
    return _collectionView;
}

- (NSArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[self.customTopSection, self.cardSection, self.customBottomSection, self.waterfallSection, self.noDataSection];
    }
    return _dataSource;
}

- (HDTableViewSectionModel *)cardSection {
    if (!_cardSection) {
        _cardSection = [[HDTableViewSectionModel alloc] init];
        _cardSection.list = @[SACMSSkeletonCollectionViewCellModel.new,
                              SACMSSkeletonCollectionViewCellModel.new,
                              SACMSSkeletonCollectionViewCellModel.new,
                              SACMSSkeletonCollectionViewCellModel.new];
    }
    return _cardSection;
}

- (HDTableViewSectionModel *)waterfallSection {
    if (!_waterfallSection) {
        _waterfallSection = [[HDTableViewSectionModel alloc] init];
        _waterfallSection.list = @[SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new,
                                   SACMSWaterfallSkeletonCollectionViewCellModel.new
        ];
    }
    return _waterfallSection;
}

- (HDTableViewSectionModel *)noDataSection {
    if (!_noDataSection) {
        _noDataSection = [[HDTableViewSectionModel alloc] init];
        _noDataSection.list = @[];
    }
    return _noDataSection;
}

- (HDTableViewSectionModel *)customTopSection {
    if (!_customTopSection) {
        _customTopSection = [[HDTableViewSectionModel alloc] init];
        _customTopSection.list = @[];
    }
    return _customTopSection;
}

- (HDTableViewSectionModel *)customBottomSection {
    if (!_customBottomSection) {
        _customBottomSection = [[HDTableViewSectionModel alloc] init];
        _customBottomSection.list = @[];
    }
    return _customBottomSection;
}

- (UIView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView =
            [[UIView alloc] initWithFrame:CGRectMake(0, -UIApplication.sharedApplication.statusBarFrame.size.height, kScreenWidth, UIApplication.sharedApplication.statusBarFrame.size.height)];
        _placeHolderView.backgroundColor = UIColor.whiteColor;
        _placeHolderView.hidden = YES;
    }
    return _placeHolderView;
}

#pragma mark - overwrite
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    if (self.navigationPlugin) {
        return HDViewControllerNavigationBarStyleHidden;
    } else {
        return HDViewControllerNavigationBarStyleWhite;
    }
}
/// 是否隐藏导航栏底部线条
- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

/// 是否添加导航栏底部阴影
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (BOOL)allowContinuousBePushed {
    return YES;
}

@end

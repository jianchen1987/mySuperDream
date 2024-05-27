//
//  SAMineViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMineViewModel.h"
#import "LKDataRecord.h"
#import "SAApolloManager.h"
#import "SAAppSwitchManager.h"
#import "SAAppVersionViewModel.h"
#import "SACMSCardTableViewCell.h"
#import "SACMSCardView.h"
#import "SACMSManager.h"
#import "SACacheManager.h"
#import "SAChangeLanguageViewPresenter.h"
#import "SACouponTicketDTO.h"
#import "SAGetSigninActivityEntranceRspModel.h"
#import "SAInfoViewModel.h"
#import "SAInternationalizationModel.h"
#import "SAUserViewModel.h"
#import "SAVersionAlertManager.h"
#import "SAWindowManager.h"
#import "SAWriteDateReadableModel.h"
#import <HDUIKit/HDAppTheme.h>
#import <HDUIKit/HDTableViewSectionModel.h>
#import <HDUIKit/HDUIKit.h>


@interface SAMineViewModel ()
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 优惠信息
@property (nonatomic, strong) HDTableViewSectionModel *couponInfoSectionModel;
@property (nonatomic, strong) HDTableViewSectionModel *invitationSectionModel; ///< 邀请码入口
/// 用户信息
@property (nonatomic, strong) SAGetUserInfoRspModel *userInfoRspModel;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// app 版本 VM
@property (nonatomic, strong) SAAppVersionViewModel *appVersionViewModel;
/// 用户 VM
@property (nonatomic, strong) SAUserViewModel *userViewModel;
/// 优惠券 DTO
@property (nonatomic, strong) SACouponTicketDTO *couponTicketDTO;

///< cms配置
@property (nonatomic, strong) SACMSPageViewConfig *config;

@end


@implementation SAMineViewModel
- (void)hd_initialize {
    self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.bgColor = UIColor.whiteColor;
    self.bgImageUrl = @"";
}

- (void)getNewData:(void (^)(void))completion {
    @HDWeakify(self);
    NSString *cmsSwitch = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeySAMineUseCMS];
    if (HDIsStringNotEmpty(cmsSwitch) && [cmsSwitch.lowercaseString isEqualToString:@"off"]) {
        // 使用本地数据
        [self clearDataSource];
        self.dataSource = [self defaultDataSource];
        self.refreshFlag = !self.refreshFlag;

        //        dispatch_group_enter(self.taskGroup);
        //        [self getCouponInfoCompletion:^{
        //            @HDStrongify(self);
        //            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        //        }];
    } else {
        [self clearDataSource];
        // 使用CMS数据
        //        dispatch_group_enter(self.taskGroup);
        //        [self getMineCMSConfig:^{
        //            @HDStrongify(self);
        //            self.refreshFlag = !self.refreshFlag;
        //            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        //        }];
    }

    dispatch_group_enter(self.taskGroup);
    [self getUserInfoCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self getSigninActivityEntranceCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        !completion ?: completion();
    });
}

- (void)getMineCMSConfig:(void (^)(void))finish {
    SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"%@_%@", kCacheKeyWowNowMinePageConfig, SAMultiLanguageManager.currentLanguage]
                                                                          type:SACacheTypeDocumentPublic];
    SACMSPageViewConfig *config = [SACMSPageViewConfig yy_modelWithJSON:cacheModel.storeObj];
    if (config) {
        // HDLog(@"使用缓存数据");
        [self parsingCMSPageConfig:config];
        finish();

    } else {
        // HDLog(@"没缓存，使用默认数据");
        self.dataSource = [self defaultDataSource];
        finish();
    }

    @HDWeakify(self);
    [SACMSManager getPageWithAddress:nil identify:CMSPageIdentifyMine pageWidth:kScreenWidth operatorNo:[SAUser hasSignedIn] ? SAUser.shared.operatorNo : @""
                             success:^(SACMSPageView *_Nonnull page, SACMSPageViewConfig *_Nonnull config) {
                                 @HDStrongify(self);

                                 if (!HDIsObjectNil(self.config) && [config isEqual:self.config]) {
                                     //                                     HDLog(@"当前有配置，且配置一样，不刷新");
                                     self.plugins = config.plugins;
                                 } else {
                                     //                                     HDLog(@"当前无配置，或者配置不一样，刷新");
                                     [self parsingCMSPageConfig:config];
                                     self.plugins = config.plugins;
                                     // 用最新数据刷新
                                     self.refreshFlag = !self.refreshFlag;
                                 }

                                 // 写入缓存, 只存1小时，防止有什么故障时 异常数据无法清除
                                 [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:config]
                                                           forKey:[NSString stringWithFormat:@"%@_%@", kCacheKeyWowNowMinePageConfig, SAMultiLanguageManager.currentLanguage]
                                                         duration:60 * 60
                                                             type:SACacheTypeDocumentPublic];
                             }
                             failure:nil];
}

- (void)parsingCMSPageConfig:(SACMSPageViewConfig *)config {
    self.config = config;

    SACMSPageView *page = [[SACMSPageView alloc] initWithWidth:kScreenWidth config:config];
    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
    NSMutableArray *cellModels = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < page.cardViews.count; i++) {
        SACMSCardTableViewCellModel *model = SACMSCardTableViewCellModel.new;
        model.cardView = page.cardViews[i];
        model.cardConfig = config.cards[i];
        model.cardView.clickNode = ^(SACMSCardView *_Nonnull card, SACMSNode *_Nullable node, NSString *_Nullable link, NSString *_Nullable spm) {
            if (HDIsStringNotEmpty(link)) {
                if ([link.lowercaseString hasPrefix:@"superapp://"] && ![SAWindowManager canOpenURL:link]) {
                    [NAT showAlertWithMessage:SALocalizedString(@"feature_no_support", @"您的App不支持这个功能哦~请升级最新版APP体验完整功能~")
                                  buttonTitle:SALocalizedString(@"update_righnow", @"去升级") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                      [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1507128993"];
                                  }];
                    return;
                }

                [SAWindowManager openUrl:link withParameters:@{@"bannerId": node.nodeNo, @"bannerLocation": [NSNumber numberWithUnsignedInteger:node.location], @"bannerTitle": node.name}];
                // 埋点
                [LKDataRecord.shared traceClickEvent:node.name
                                          parameters:@{@"route": HDIsStringNotEmpty(link) ? link : @"", @"nodePublishNo": HDIsStringNotEmpty(node.nodePublishNo) ? node.nodePublishNo : @""}
                                                 SPM:[LKSPM SPMWithPage:config.pageName area:[NSString stringWithFormat:@"%@@%d", card.config.cardName, i] node:spm]];
            }
        };
        [cellModels addObject:model];
    }
    sectionModel.list = cellModels;
    self.dataSource = @[sectionModel].mutableCopy;

    self.contentInsets = [config getContentEdgeInsets];
    self.bgColor = [config getBackgroundColor];
    self.bgImageUrl = [config getBackgroundImage];
}

- (void)getCouponInfoCompletion:(void (^)(void))finish {
    if (!SAUser.hasSignedIn) {
        !finish ?: finish();
        return;
    }

    @HDWeakify(self);
    [self.couponTicketDTO getCouponInfoWithBusinessLine:nil success:^(SACouponInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self updateCouponInfoSectionModel:rspModel];
        !finish ?: finish();
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !finish ?: finish();
    }];
}

- (void)getUserInfoCompletion:(void (^)(void))finish {
    if (!SAUser.hasSignedIn) {
        !finish ?: finish();
        return;
    }

    @HDWeakify(self);
    [self.userViewModel getUserInfoWithOperatorNo:SAUser.shared.operatorNo success:^(SAGetUserInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [SAUser.shared saveWithUserInfo:rspModel];

        self.userInfoRspModel = rspModel;
        !finish ?: finish();
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !finish ?: finish();
    }];
}

- (void)getSigninActivityEntranceCompletion:(void (^)(void))finish {
    @HDWeakify(self);
    [self.couponTicketDTO getSigninActivityEntranceSuccess:^(SAGetSigninActivityEntranceRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(rspModel.url)) {
            self.signinActivityEntranceUrl = [rspModel.url copy];
        }
        !finish ?: finish();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.signinActivityEntranceUrl = @"";
        !finish ?: finish();
    }];
}

- (void)clearDataSource {
    [self.dataSource removeAllObjects];
    self.dataSource = nil;

    // 获取原来的 value
    SAInfoViewModel *infoModel = self.couponInfoSectionModel.list.firstObject;
    NSString *oldInfoModelValueText = infoModel.valueText;

    // 触发懒加载
    self.couponInfoSectionModel = nil;

    // 恢复
    infoModel = self.couponInfoSectionModel.list.firstObject;
    if (SAUser.hasSignedIn) {
        infoModel.valueText = oldInfoModelValueText;
    }
}

#pragma mark - private methods
- (void)updateCouponInfoSectionModel:(SACouponInfoRspModel *)rspModel {
    SAInfoViewModel *infoModel = self.couponInfoSectionModel.list.firstObject;
    if (infoModel && [infoModel isKindOfClass:SAInfoViewModel.class]) {
        infoModel.valueText = [NSString stringWithFormat:@"%@", rspModel.cashCouponAmount];
        self.couponInfoSectionModel.list = @[infoModel];
    }
}

- (void)checkAppVersion {
    [self.view showloading];
    @HDWeakify(self);
    [self.appVersionViewModel getAppVersionInfoSuccess:^(SAAppVersionInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (HDIsStringEmpty(rspModel.publicVersion)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"app_version_latest", @"当前版本已是最新") type:HDTopToastTypeSuccess];
        } else {
            SAVersionAlertViewConfig *config = SAVersionAlertViewConfig.new;
            config.versionId = rspModel.versionId;
            config.updateInfo = rspModel.versionInfo;
            config.updateVersion = rspModel.publicVersion;
            config.updateModel = rspModel.updateModel;
            config.packageLink = rspModel.packageLink;
            config.ignoreCache = YES;
            if ([SAVersionAlertManager versionShouldAlert:config]) {
                SAVersionBaseAlertView *alertView = [SAVersionAlertManager alertViewWithConfig:config];
                alertView.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {

                };
                [alertView show];
            }
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark - lazy load
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithArray:[self defaultDataSource]];
    }
    return _dataSource;
}

- (NSMutableArray *)defaultDataSource {
    NSMutableArray *dataSource = [NSMutableArray array];

    SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
    NSMutableArray<SAInfoViewModel *> *sectionList = [NSMutableArray array];
    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
    sectionModel.headerModel = HDTableHeaderFootViewModel.new;

    UIImage *arrowImage = [UIImage imageNamed:@"black_arrow"];

    // 钱包
    model.leftImage = [UIImage imageNamed:@"icon-wallet"];
    model.keyText = SALocalizedString(@"wallet", @"Wallet");
    model.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToWalletViewController:nil];
    };
    model.rightButtonImage = arrowImage;
    [sectionList addObject:model];

    //内测隐藏菜单
    NSDictionary *remoteConfigs = [SACacheManager.shared objectForKey:kCacheKeyRemoteConfigs type:SACacheTypeDocumentPublic relyLanguage:NO];
    if (remoteConfigs && [remoteConfigs isKindOfClass:NSDictionary.class]) {
        NSArray *menus = remoteConfigs[kApolloSwitchKeySAMineMenus];
        for (NSDictionary *dic in menus) {
            if ([dic isKindOfClass:NSDictionary.class]) {
                SAInternationalizationModel *title = [SAInternationalizationModel yy_modelWithDictionary:dic[@"title"]];
                NSString *link = dic[@"link"];
                NSString *image = dic[@"image"];
                SAInfoViewModel *infoModel = SAInfoViewModel.new;
                infoModel.leftImage = [UIImage imageNamed:image];
                infoModel.keyText = title.desc;
                infoModel.eventHandler = ^{
                    [SAWindowManager openUrl:link withParameters:nil];
                };
                infoModel.rightButtonImage = arrowImage;
                [sectionList addObject:infoModel];
            }
        }
    }

    sectionModel.list = sectionList;
    [dataSource addObject:sectionModel];

    // 券
    [dataSource addObject:self.couponInfoSectionModel];

    // 新的一组
    sectionModel = [[HDTableViewSectionModel alloc] init];
    sectionModel.headerModel = HDTableHeaderFootViewModel.new;
    sectionList = [NSMutableArray array];

    // 收货地址
    model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:@"icon-address"];
    model.keyText = SALocalizedString(@"shopping_address", @"收货地址");
    model.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToShoppingAddressViewController:nil];
    };
    model.rightButtonImage = arrowImage;
    [sectionList addObject:model];

    // 选择语言
    model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:@"icon-language"];
    model.keyText = SALocalizedString(@"choose_language", @"选择语言");
    model.rightButtonImage = arrowImage;
    model.eventHandler = ^{
        [SAChangeLanguageViewPresenter showChangeLanguageView];
    };
    model.valueText = SAMultiLanguageManager.currentLanguageDisplayName;
    [sectionList addObject:model];

    sectionModel.list = sectionList;
    [dataSource addObject:sectionModel];

    // 新的一组
    sectionModel = [[HDTableViewSectionModel alloc] init];
    sectionModel.headerModel = HDTableHeaderFootViewModel.new;
    sectionList = [NSMutableArray array];

    model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:@"icon-suggestion"];
    model.keyText = SALocalizedString(@"suggestion_and_feedback", @"建议与反馈");
    model.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToSuggestionViewController:nil];
    };
    model.rightButtonImage = arrowImage;
    [sectionList addObject:model];

    model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:@"icon-helpCenter"];
    model.keyText = SALocalizedString(@"help_center", @"帮助中心");
    model.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/help-center"}];
    };
    model.rightButtonImage = arrowImage;
    [sectionList addObject:model];

    model = [[SAInfoViewModel alloc] init];
    model.leftImage = [UIImage imageNamed:@"icon-appVersion"];
    model.keyText = SALocalizedString(@"app_version", @"APP版本");
    @HDWeakify(self);
    model.eventHandler = ^{
        @HDStrongify(self);
        [self checkAppVersion];
    };
    model.rightButtonImage = arrowImage;
    model.valueText = [NSString stringWithFormat:@"V%@", HDDeviceInfo.appVersion];
    [sectionList addObject:model];

    sectionModel.list = sectionList;
    [dataSource addObject:sectionModel];
    return dataSource;
}

- (HDTableViewSectionModel *)couponInfoSectionModel {
    if (!_couponInfoSectionModel) {
        HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.leftImage = [UIImage imageNamed:@"icon-coupon"];
        model.keyText = SALocalizedString(@"my_coupons", @"我的优惠券");
        model.valueColor = HDAppTheme.color.G1;
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToMyCouponsViewController:nil];
        };
        model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        model.valueText = @"";

        sectionModel.list = @[model];
        _couponInfoSectionModel = sectionModel;
    }
    return _couponInfoSectionModel;
}

/** @lazy invitationSectionModel */
- (HDTableViewSectionModel *)invitationSectionModel {
    if (!_invitationSectionModel) {
        _invitationSectionModel = [[HDTableViewSectionModel alloc] init];
        _invitationSectionModel.headerModel = HDTableHeaderFootViewModel.new;
    }
    return _invitationSectionModel;
}

- (SAAppVersionViewModel *)appVersionViewModel {
    return _appVersionViewModel ?: ({ _appVersionViewModel = SAAppVersionViewModel.new; });
}

- (SAUserViewModel *)userViewModel {
    return _userViewModel ?: ({ _userViewModel = SAUserViewModel.new; });
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (SACouponTicketDTO *)couponTicketDTO {
    if (!_couponTicketDTO) {
        _couponTicketDTO = SACouponTicketDTO.new;
    }
    return _couponTicketDTO;
}

@end

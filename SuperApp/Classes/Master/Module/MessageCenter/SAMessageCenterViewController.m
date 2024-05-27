//
//  SAMessageCenterViewController.m
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageCenterViewController.h"
#import "LKDataRecord.h"
#import "SAChatMessageViewController.h"
#import "SAGetUnreadInnerMessageCountRspModel.h"
#import "SAMessageCenterListViewController.h"
#import "SAMessageDTO.h"
#import "SAMessageListChildViewControllerConfig.h"
#import "SAMessageManager.h"
#import "SAMissingNotificationTipView.h"
#import "SAOrderNotLoginView.h"


@interface SAMessageCenterViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, SAMessageManagerDelegate>
/// 头部
@property (nonatomic, strong) SAMissingNotificationTipView *headerView;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryNumberView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 配置
@property (nonatomic, strong) NSArray<SAMessageListChildViewControllerConfig *> *configs;

@property (nonatomic, strong) SAMessageDTO *messageDTO; ///<

@property (nonatomic, strong) HDAnnouncementView *tipsView;         ///< 推送开启提示
@property (nonatomic, strong) HDAnnouncementViewConfig *tipsConfig; ///< 提示配置
@property (nonatomic, strong) SAOperationButton *settingBtn;        ///< 设置
/// 标题栏阴影图层
@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;
/// 全部已读按钮
@property (nonatomic, strong) HDUIButton *readAllBTN;
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation SAMessageCenterViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    SAClientType clientType = [parameters objectForKey:@"clientType"];
    self.clientType = HDIsStringNotEmpty(clientType) ? clientType : SAClientTypeMaster;

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"messages", @"消息");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.readAllBTN]];
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 2.0;

    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.tipsView];
    [self.view addSubview:self.settingBtn];

    [self.view addSubview:self.notSignInView];

    [self applicationBecomeActive];

    @HDWeakify(self);
    self.categoryTitleView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.categoryTitleViewShadowLayer) {
            [self.categoryTitleViewShadowLayer removeFromSuperlayer];
            self.categoryTitleViewShadowLayer = nil;
        }
        self.categoryTitleViewShadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                                        shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                                          fillColor:UIColor.whiteColor.CGColor
                                                       shadowOffset:CGSizeMake(0, 3)];
    };

    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    [SAMessageManager.share addListener:self];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [SAMessageManager.share removeListener:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)hd_languageDidChanged {
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"pg_label_msg_need_login", @"登录后可查看消息");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }

    if (!self.tipsView.isHidden) {
        self.tipsConfig.text = SALocalizedString(@"privacy_notification_tips", @"开启通知，随时获取订单信息、优惠信息开启通知，随时获取订单信息、优惠信息。");
        self.tipsView.config = self.tipsConfig;
        [self.settingBtn setTitle:SALocalizedString(@"O3N3zScm", @"去开启") forState:UIControlStateNormal];
    }

    self.categoryTitleView.titles = [self.configs mapObjectsUsingBlock:^id _Nonnull(SAMessageListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
        return obj.title.desc;
    }];

    [self.readAllBTN setTitle:SALocalizedString(@"message_read_all", @"全部已读") forState:UIControlStateNormal];
}

- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];

    if (!self.tipsView.isHidden) {
        [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.categoryTitleView.mas_bottom);
            make.height.mas_equalTo(36.5);
        }];

        [self.settingBtn sizeToFit];
        [self.settingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tipsView.mas_centerY);
            make.right.equalTo(self.tipsView.mas_right).offset(-kRealWidth(15));
        }];
    }

    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        if (!self.tipsView.isHidden) {
            make.top.equalTo(self.tipsView.mas_bottom);
        } else {
            make.top.equalTo(self.categoryTitleView.mas_bottom);
        }
        make.bottom.equalTo(self.view);
    }];

    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (void)hd_getNewData {
    [super hd_getNewData];
    [self updateUnreadCount];
}

#pragma mark - private methods
- (void)clickOnSetting:(SAOperationButton *)button {
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

- (void)clickReadAllHandler {
    if (![SAUser hasSignedIn]) {
        return;
    }

    [self showloading];
    @HDWeakify(self);
    [SAMessageManager.share updateAllMessageReadedWithCompletion:^{
        @HDStrongify(self);
        [self dismissLoading];
    }];

    [LKDataRecord.shared traceEvent:@"click_messageCenter_readAll_button" name:@"点击全部已读" parameters:nil SPM:[LKSPM SPMWithPage:@"SAMessageCenterViewController" area:@"" node:@""]];
}

#pragma mark - Notification
- (void)applicationBecomeActive {
    if (!SAGeneralUtil.isNotificationEnable) {
        self.tipsView.hidden = NO;
        self.settingBtn.hidden = NO;
    } else {
        self.tipsView.hidden = YES;
        self.settingBtn.hidden = YES;
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)userLoginHandler {
    self.notSignInView.hidden = true;
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
}
#pragma mark - Data
- (void)updateUnreadCount {
    @HDWeakify(self);
    [SAMessageManager.share getUnreadMessageCount:^(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *_Nonnull details) {
        @HDStrongify(self);
        self.categoryTitleView.counts = @[details[SAAppInnerMessageTypeMarketing], details[SAAppInnerMessageTypePersonal], details[SAAppInnerMessageTypeChat]];
        [self.categoryTitleView reloadDataWithoutListContainer];
    }];
}

#pragma mark - listener
- (void)unreadMessageCountChanged:(NSUInteger)count details:(NSDictionary<SAAppInnerMessageType, NSNumber *> *)details {
    self.categoryTitleView.counts = @[details[SAAppInnerMessageTypeMarketing], details[SAAppInnerMessageTypePersonal], details[SAAppInnerMessageTypeChat]];
    [self.categoryTitleView reloadDataWithoutListContainer];
}

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<HDCategoryListContentViewDelegate> listVC = self.configs[index].vc;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configs.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;

    SAMessageListChildViewControllerConfig *config = self.configs[index];
    [LKDataRecord.shared traceEvent:@"click_messageCenter_category" name:config.title.zh_CN parameters:nil SPM:[LKSPM SPMWithPage:@"SAMessageCenterViewController" area:@""
                                                                                                                             node:[NSString stringWithFormat:@"node@%zd", index]]];
}

#pragma mark - lazy load
- (SAMissingNotificationTipView *)headerView {
    if (!_headerView) {
        _headerView = SAMissingNotificationTipView.new;
        SAMissingNotificationTipModel *model = SAMissingNotificationTipModel.new;
        model.shouldFittingSize = true;
        _headerView.model = model;
    }
    return _headerView;
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
- (HDCategoryNumberView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryNumberView.new;
        _categoryTitleView.titles = [self.configs mapObjectsUsingBlock:^id _Nonnull(SAMessageListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title.desc;
        }];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.color.sa_C1;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
        _categoryTitleView.numberBackgroundColor = [UIColor hd_colorWithHexString:@"#CA0000"];
        _categoryTitleView.numberLabelOffset = CGPointMake(0, -5);
        _categoryTitleView.numberLabelWidthIncrement = 10;
        _categoryTitleView.titleSelectedColor = HDAppTheme.color.sa_C1;
        _categoryTitleView.numberStringFormatterBlock = ^NSString *(NSInteger number) {
            if (number > 99) {
                return @"99+";
            } else if (number > 0) {
                return [NSString stringWithFormat:@"%zd", number];
            } else {
                return @"";
            }
        };
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSArray<SAMessageListChildViewControllerConfig *> *)configs {
    if (!_configs) {
        NSMutableArray<SAMessageListChildViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:3];

        SAInternationalizationModel *title = [SAInternationalizationModel modelWithInternationalKey:@"message_center_promotion" value:@"Promotion" table:nil];
        SAMessageCenterListViewController *vc = [[SAMessageCenterListViewController alloc] initWithRouteParameters:@{
            @"source" : self.viewModel.source,
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.messageType = SAAppInnerMessageTypeMarketing;
        SAMessageListChildViewControllerConfig *config = [SAMessageListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"message_center_personal" value:@"Personal" table:nil];
        vc = [[SAMessageCenterListViewController alloc] initWithRouteParameters:@{
            @"source" : self.viewModel.source,
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.messageType = SAAppInnerMessageTypePersonal;
        config = [SAMessageListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"message_center_chats" value:@"Chats" table:nil];
        SAChatMessageViewController *chats = SAChatMessageViewController.new;
        config = [SAMessageListChildViewControllerConfig configWithTitle:title vc:chats];
        [configList addObject:config];

        _configs = configList;
    }
    return _configs;
}

/** @lazy messageDTO */
- (SAMessageDTO *)messageDTO {
    if (!_messageDTO) {
        _messageDTO = [[SAMessageDTO alloc] init];
    }
    return _messageDTO;
}
/** @lazy tipsview */
- (HDAnnouncementView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[HDAnnouncementView alloc] init];
    }
    return _tipsView;
}

/** @lazy tipsConfig */
- (HDAnnouncementViewConfig *)tipsConfig {
    if (!_tipsConfig) {
        _tipsConfig = [[HDAnnouncementViewConfig alloc] init];
        _tipsConfig.textFont = HDAppTheme.font.standard4;
        _tipsConfig.textColor = [UIColor hd_colorWithHexString:@"#2F2F2F"];
        _tipsConfig.trumpetImage = [UIImage imageNamed:@"message_push_alert"];
        _tipsConfig.backgroundColor = [UIColor hd_colorWithHexString:@"#FFE4E4"];
        _tipsConfig.trumpetToTextMargin = 7;
        _tipsConfig.contentInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, 90);
    }
    return _tipsConfig;
}

/** @lazy settignbtn */
- (SAOperationButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_settingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_settingBtn setTitle:SALocalizedString(@"O3N3zScm", @"去开启") forState:UIControlStateNormal];
        _settingBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _settingBtn.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        [_settingBtn applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#CA0000"]];
        [_settingBtn addTarget:self action:@selector(clickOnSetting:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.cornerRadius = 3.0f;
    }
    return _settingBtn;
}

- (HDUIButton *)readAllBTN {
    if (!_readAllBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"message_read_all", @"全部已读") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button sizeToFit];
        [button addTarget:self action:@selector(clickReadAllHandler) forControlEvents:UIControlEventTouchUpInside];
        _readAllBTN = button;
    }
    return _readAllBTN;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end

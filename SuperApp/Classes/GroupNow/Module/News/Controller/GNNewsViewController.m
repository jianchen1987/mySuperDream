//
//  GNNewsViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsViewController.h"
#import "GNNewsTableViewCell.h"
#import "GNNewsViewModel.h"
#import "SAOrderNotLoginView.h"
#import "SATabBar.h"
#import "SATabBarButton.h"


@interface GNNewsViewController () <GNTableViewProtocol>
/// tableview
@property (nonatomic, strong) GNTableView *tableView;
/// viewModel
@property (nonatomic, strong) GNNewsViewModel *viewModel;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;

@end


@implementation GNNewsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (SAUser.hasSignedIn) {
        [self getUnReadCount];
    }
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.boldTitle = GNLocalizedString(@"gn_news_title", @"消息");
    self.hd_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.backBtn]];
    @HDWeakify(self)[self.backBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self)[self dismissAnimated:YES completion:nil];
    }];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tableView.delegate = self.provider;
            self.tableView.dataSource = self.provider;
            [self.tableView reloadData];
        }
        [self gn_getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self gn_getNewData];
    };

    [self.view addSubview:self.notSignInView];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    if (SAUser.hasSignedIn) {
        [self gn_getNewData];
    }
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];

    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)hd_languageDidChanged {
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"view_order_after_sign_in", @"登录后可查看订单");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }
}

#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
    [self.tableView.mj_header beginRefreshing];
    [self getUnReadCount];
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
}

- (void)gn_getNewData {
    if (!SAUser.hasSignedIn)
        return;
    @HDWeakify(self);
    [self.viewModel getNewsListPageNum:self.tableView.pageNum completion:^(GNNewsPagingRspModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        self.tableView.GNdelegate = self;
        if (!error) {
            [self.tableView reloadData:!rspModel.hasNextPage];
        } else {
            [self.tableView reloadFail];
        }
    }];
}

#pragma mark GNTableViewProtocol
- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    if ([rowData isKindOfClass:GNNewsCellModel.class]) {
        void (^defaultAction)(SASystemMessageModel *) = ^void(SASystemMessageModel *model) {
            if (HDIsStringEmpty(model.linkAddress)) {
                [HDMediator.sharedInstance navigaveToMessageDetailController:@{@"sendSerialNumber": model.sendSerialNumber, @"clientType": SAClientTypeGroupBuy}];
            } else {
                [SAWindowManager openUrl:model.linkAddress withParameters:nil];
            }
        };

        GNNewsCellModel *trueModel = (GNNewsCellModel *)rowData;
        // 有link就跳，没有就展示详情
        if (trueModel.messageType == SAMessageTypeSystem || trueModel.messageType == SAMessageTypeNotice || trueModel.messageType == SAMessageTypeCoupon) {
            defaultAction(trueModel);
        } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem] && trueModel.messageType == SAMessageTypeGroup) {
            // 跳到订单页
            [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": trueModel.bizNo}];
        } else {
            defaultAction(trueModel);
        }

        /// 如果消息未读，更新为已读
        if (trueModel.readStatus == SAStationLetterReadStatusUnread) {
            @HDWeakify(self);
            [self.viewModel.newsDTO updateMessageStatusToReadWithSendSerialNumber:trueModel.sendSerialNumber success:^{
                @HDStrongify(self);
                trueModel.readStatus = SAStationLetterReadStatusRead;
                [self.tableView reloadData];
            } failure:nil];
        }
    }
}

/// 获取未读数量
- (void)getUnReadCount {
    if (self.notSignInView.isHidden) {
        @HDWeakify(self);
        [self.viewModel.newsDTO getUnreadSystemMessageCountBlock:^(NSUInteger station) {
            @HDStrongify(self);
            SATabBarButton *tabbarBtn = [self getCurrentTabBarButton];
            tabbarBtn.config.badgeValue = station ? @" " : @"";
            [tabbarBtn setConfig:[self getCurrentTabBarButton].config];
        }];
    }
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _tableView.provider = self.provider;
        _tableView.delegate = self.provider;
        _tableView.dataSource = self.provider;
        _tableView.needRefreshBTN = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.needRefreshHeader = YES;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
    }
    return _tableView;
}

- (GNNewsViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNNewsViewModel.new; });
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [GNNewsTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [GNNewsTableViewCell skeletonViewHeight];
        }];
    }
    return _provider;
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

- (SATabBarButton *)getCurrentTabBarButton {
    SATabBar *tabbar = (SATabBar *)self.tabBarController.tabBar;
    if ([tabbar isKindOfClass:SATabBar.class] && tabbar.buttons.count > 2) {
        return tabbar.buttons[2];
    }
    return nil;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

@end

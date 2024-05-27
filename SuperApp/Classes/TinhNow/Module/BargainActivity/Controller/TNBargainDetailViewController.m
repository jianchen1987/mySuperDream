//
//  TNBargainDetailViewController.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainDetailViewController.h"
#import "SATableView.h"
#import "TNBargainFriendListCell.h"
#import "TNBargainGoodInfoCell.h"
#import "TNBargainRecordAndStrtegyCell.h"
#import "TNBargainViewModel.h"
#import "TNShareManager.h"


@interface TNBargainDetailViewController () <UITableViewDelegate, UITableViewDataSource>
/// table
@property (strong, nonatomic) SATableView *tableView;
/// 分享按钮
@property (nonatomic, strong) UIBarButtonItem *shareBarButtonItem;
/// viewModel
@property (strong, nonatomic) TNBargainViewModel *viewModel;
/// 助力记录和邀人攻略数据源
@property (strong, nonatomic) TNBargainRecordAndStrtegyCellModel *recordModel;
/// 任务id
@property (nonatomic, copy) NSString *taskId;
/// 显示的section
@property (nonatomic, assign) NSInteger section;
@end


@implementation TNBargainDetailViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        NSString *taskId = parameters[@"taskId"];
        if (HDIsStringNotEmpty(taskId)) {
            self.taskId = taskId;
        }
    }
    return self;
}
- (void)dealloc {
    [self.viewModel cancelBargainDetailTimer];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //刷新一下table 因为按钮动画离开页面可能会停止  这里重启
    NSInteger count = [self.tableView numberOfRowsInSection:0];
    if (count > 1) {
        // table 已经刷新好了
        [self.tableView hd_reloadDataAtIndex:1 animated:NO];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.hd_navigationItem.rightBarButtonItem = self.shareBarButtonItem;
    self.recordModel.taskId = self.taskId;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_bargain_detail_title_k", @"超低价拿走，快递送到家");
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    //获取砍价任务详情数据
    [self.viewModel getBargainDetailDataWithTaskId:self.taskId pageType:1];
    @HDWeakify(self);
    [self.viewModel setQueryFailureCallBack:^{
        @HDStrongify(self);
        self.section = 0;
        [self.tableView failGetNewData];
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.hd_navigationItem.rightBarButtonItem = self.shareBarButtonItem;
        //组装 助力记录和邀人攻略数据
        self.section = 3;
        self.recordModel.bargainType = self.viewModel.detailModel.bargainType;
        self.recordModel.strategyList = self.viewModel.ruleModel.rulePics; //邀人攻略数据
        if (self.recordModel.bargainType != TNBargainTaskTypeSpecified) {
            self.recordModel.isShowStrategy = true; //除了指定成单的砍价任务都显示流程图
        }
        [self.recordModel.recordList removeAllObjects];
        self.recordModel.currentPage = 1;
        self.recordModel.hasNextPage = self.viewModel.recordRspModel.hasNextPage;
        [self.recordModel.recordList addObjectsFromArray:self.viewModel.recordRspModel.items]; //助力记录数据
        [self.tableView successGetNewDataWithNoMoreData:true];
    }];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark - 分享点击
- (void)shareProduct {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    shareModel.shareImage = self.viewModel.detailModel.images;
    NSString *headUrl = HDIsStringEmpty([SAUser shared].headURL) ? @"" : [SAUser shared].headURL;
    NSString *name = [SAUser shared].loginName;
    NSString *baseUrl = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowBargainDetail];
    shareModel.shareLink = [NSString stringWithFormat:@"%@id=%@&isWeiXin=false&name=%@&userImg=%@", baseUrl, self.taskId, name, headUrl];
    shareModel.shareTitle = self.viewModel.detailModel.goodsName;
    shareModel.shareContent = TNLocalizedString(@"tn_share_bargain_desc", @"帮我助力超低价拿走商品吧！");
    shareModel.type = TNShareTypeBargainInvite;
    shareModel.sourceId = self.viewModel.detailModel.activityId;
    [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
}
#pragma mark - 查看订单点击
- (void)orderDetailClick {
    if (HDIsStringEmpty(self.viewModel.detailModel.orderNo)) {
        [HDTips showWithText:TNLocalizedString(@"tn_bargain_order_wait_tips", @"您的订单正在等待审核，请你耐心等待!") inView:self.view hideAfterDelay:3];
        return;
    }
    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.viewModel.detailModel.orderNo}];
}
#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.section;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TNBargainGoodInfoCell *cell = [TNBargainGoodInfoCell cellWithTableView:tableView];
        cell.model = self.viewModel.detailModel;
        return cell;
    } else if (indexPath.row == 1) {
        TNBargainFriendListCell *cell = [TNBargainFriendListCell cellWithTableView:tableView];
        cell.model = self.viewModel.detailModel;
        @HDWeakify(self);
        cell.shareClickCallBack = ^{
            @HDStrongify(self);
            [self shareProduct];
        };
        cell.orderDetailClickCallBack = ^{
            @HDStrongify(self);
            [self orderDetailClick];
        };
        return cell;
    } else if (indexPath.row == 2) {
        TNBargainRecordAndStrtegyCell *cell = [TNBargainRecordAndStrtegyCell cellWithTableView:tableView];
        cell.model = self.recordModel;
        @HDWeakify(self);
        cell.recordAndStrtegyChangeCallBack = ^{
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    }
    return nil;
}
#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getBargainDetailDataWithTaskId:self.taskId pageType:1];
        };
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self.viewModel getBargainDetailDataWithTaskId:self.taskId pageType:1];
        };
        _tableView.placeholderViewModel = placeHolderModel;
    }
    return _tableView;
}
/** @lazy shareButton */
- (UIBarButtonItem *)shareBarButtonItem {
    if (!_shareBarButtonItem) {
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"tinhnow-black-share"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareProduct) forControlEvents:UIControlEventTouchUpInside];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
        _shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    }
    return _shareBarButtonItem;
}
/** @lazy viewModel */
- (TNBargainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNBargainViewModel alloc] init];
    }
    return _viewModel;
}
- (TNBargainRecordAndStrtegyCellModel *)recordModel {
    if (!_recordModel) {
        _recordModel = [[TNBargainRecordAndStrtegyCellModel alloc] init];
    }
    return _recordModel;
}
#pragma mark - 允许连续push
- (BOOL)allowContinuousBePushed {
    return YES;
}
@end

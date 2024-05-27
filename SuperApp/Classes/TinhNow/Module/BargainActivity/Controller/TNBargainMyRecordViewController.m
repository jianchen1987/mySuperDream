//
//  TNBargainMyRecordViewController.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainMyRecordViewController.h"
#import "SATableView.h"
#import "TNBargainDetailViewController.h"
#import "TNBargainRecordCell.h"
#import "TNBargainViewModel.h"
#import "TNNoDataCell.h"
#import "TNNotificationConst.h"


@interface TNBargainMyRecordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) SATableView *tableView;
/// viewModel
@property (strong, nonatomic) TNBargainViewModel *viewModel;
/// 数据源
@property (strong, nonatomic) HDTableViewSectionModel *sectionModel;
/// 定时器
@property (nonatomic, strong) dispatch_source_t timer;
/// 骨架
@property (strong, nonatomic) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNBargainMyRecordViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_bargain_record", @"助力记录");
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self.viewModel getMyRecordNewData];
    @HDWeakify(self);
    self.viewModel.queryFailureCallBack = ^{
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        if (HDIsArrayEmpty(self.viewModel.myRecords)) {
            TNNoDataCellModel *model = [[TNNoDataCellModel alloc] init];
            model.noDataText = TNLocalizedString(@"tn_bargain_no_record_k", @"暂无邀请助力记录");
            self.sectionModel.list = @[model];
        } else {
            self.sectionModel.list = self.viewModel.myRecords;
            [self startTimer]; //开启定时器
        }
        if (self.viewModel.pageNum == 1) {
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }
    }];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateViewConstraints];
}
#pragma mark - 定时器
- (void)startTimer {
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), 1.0 * NSEC_PER_SEC, 0);
        @HDWeakify(self);
        dispatch_source_set_event_handler(timer, ^{
            @HDStrongify(self);
            BOOL allExpired = true;
            for (TNBargainRecordModel *record in self.viewModel.myRecords) {
                if (record.expiredTimeOut > 0) {
                    allExpired = false;
                }
                if (record.expiredTimeOut <= 0) {
                    continue;
                }
                record.expiredTimeOut = record.expiredTimeOut - 1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBargainCountTime object:nil];
            });
            if (allExpired) {
                [self cancelTimer];
            }
            HDLog(@"倒计时===");
        });
        self.timer = timer;
        dispatch_resume(self.timer);
    }
}
- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}
#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionModel.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNBargainRecordModel.class]) {
        TNBargainRecordCell *cell = [TNBargainRecordCell cellWithTableView:tableView];
        TNBargainRecordModel *rModel = (TNBargainRecordModel *)model;
        cell.model = rModel;
        @HDWeakify(self);
        cell.orderDetailClickCallBack = ^{
            @HDStrongify(self);
            if (HDIsStringEmpty(rModel.orderNo)) {
                [HDTips showWithText:TNLocalizedString(@"tn_bargain_order_wait_tips", @"您的订单正在等待审核，请你耐心等待!") inView:self.view hideAfterDelay:3];
                return;
            }
            [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": rModel.orderNo}];
        };
        return cell;
    } else if ([model isKindOfClass:TNNoDataCellModel.class]) {
        TNNoDataCell *cell = [TNNoDataCell cellWithTableView:tableView];
        cell.model = (TNNoDataCellModel *)model;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNBargainRecordModel.class]) {
        return kRealWidth(135);
    } else if ([model isKindOfClass:TNNoDataCellModel.class]) {
        return self.view.height - HD_STATUSBAR_NAVBAR_HEIGHT;
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kRealWidth(15);
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNBargainRecordModel.class]) {
        TNBargainRecordModel *rModel = (TNBargainRecordModel *)model;
        TNBargainDetailViewController *detailVC = [[TNBargainDetailViewController alloc] initWithRouteParameters:@{@"taskId": rModel.taskId}];
        [SAWindowManager navigateToViewController:detailVC];
        if (rModel.status == TNBargainGoodStatusOngoing) {
            [SATalkingData trackEvent:@"[电商]砍价专题页_点击继续助力"];
        }
    }
}

/** @lazy tableView */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.needShowErrorView = true;
        _tableView.mj_footer.hidden = true;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getMyRecordNewData];
        };
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel loadMyRecordMoreData];
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
            self.tableView.delegate = self.provider;
            self.tableView.dataSource = self.provider;
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
            [self.viewModel getMyRecordNewData];
        };
        _tableView.placeholderViewModel = placeHolderModel;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}
- (HDTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _sectionModel;
}
/** @lazy viewModel */
- (TNBargainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNBargainViewModel alloc] init];
    }
    return _viewModel;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNBargainRecordCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNBargainRecordCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}
@end

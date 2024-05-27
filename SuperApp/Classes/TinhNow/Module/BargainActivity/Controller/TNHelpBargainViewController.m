//
//  TNHelpBargainViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHelpBargainViewController.h"
#import "SATableView.h"
#import "TNBargainGoodInfoCell.h"
#import "TNBargainSuccessAlertView.h"
#import "TNBargainViewModel.h"
#import "TNHelpBargainInfoCell.h"
#import "TNHelpBargainRecommendCell.h"
#import "TNHelpBargainStrategyCell.h"
#import "TNHomeDTO.h"
#import "TNQueryGoodsRspModel.h"


@interface TNHelpBargainViewController () <UITableViewDelegate, UITableViewDataSource>
/// table
@property (strong, nonatomic) SATableView *tableView;
/// viewModel
@property (strong, nonatomic) TNBargainViewModel *viewModel;
/// 任务id
@property (nonatomic, copy) NSString *taskId;
/// 数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 商品详情section
@property (strong, nonatomic) HDTableViewSectionModel *infoSectionModel;
/// 助力详情section
@property (strong, nonatomic) HDTableViewSectionModel *bargainSectionModel;
/// 规则图片section
@property (strong, nonatomic) HDTableViewSectionModel *strategySectionModel;
/// 推荐商品section
@property (strong, nonatomic) HDTableViewSectionModel *recommendSectionModel;
/// 推荐商品dto
@property (strong, nonatomic) TNHomeDTO *homeDto;
@end


@implementation TNHelpBargainViewController
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
    [_viewModel cancelBargainDetailTimer];
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
- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_bargain_detail_title_k", @"超低价拿走，快递送到家");
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    //获取砍价详情数据
    [self.viewModel getBargainDetailDataWithTaskId:self.taskId pageType:2];
    @HDWeakify(self);
    [self.viewModel setQueryFailureCallBack:^{
        @HDStrongify(self);
        self.dataSource = nil;
        [self.tableView failGetNewData];
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.viewModel.detailModel.rulePics = self.viewModel.ruleModel.rulePics;
        self.infoSectionModel.list = @[self.viewModel.detailModel];
        self.bargainSectionModel.list = @[self.viewModel.detailModel];
        self.strategySectionModel.list = @[self.viewModel.detailModel];
        [self.dataSource removeAllObjects];
        self.dataSource = @[self.infoSectionModel, self.bargainSectionModel, self.strategySectionModel].mutableCopy;
        [self.tableView successLoadMoreDataWithNoMoreData:true];
        //继续请求推荐商品数据
        [self getRecommendGoodData];
    }];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark - 获取推荐商品数据
- (void)getRecommendGoodData {
    //只取10条数据
    @HDWeakify(self);
    [self.homeDto queryChoicenessInfoWithPageSize:20 pageNum:1 success:^(TNQueryGoodsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.recommendSectionModel.list = rspModel.list;
        if (self.viewModel.detailModel.status != TNBargainGoodStatusOngoing || self.viewModel.detailModel.isHelpedBargain) { //砍过价 就显示推荐列表
            [self.dataSource addObject:self.recommendSectionModel];
            [self.tableView successLoadMoreDataWithNoMoreData:true];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
#pragma mark - 马上帮助好友
- (void)helpBargainClick {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    @HDWeakify(self);
    [self.viewModel helpBargainCompletion:^(BOOL isSuccess) {
        @HDStrongify(self);
        if (isSuccess) {
            [self.viewModel cancelBargainDetailTimer];
            [self showBargainSuccessAlertView];
        }
        if (self.viewModel.detailModel.isHelpedBargain || self.viewModel.detailModel.status != TNBargainGoodStatusOngoing) { //砍过价 就显示推荐列表
            [self.dataSource addObject:self.recommendSectionModel];
        }
        [self.tableView successLoadMoreDataWithNoMoreData:true];
    }];
}

#pragma mark - 砍价成功弹窗
- (void)showBargainSuccessAlertView {
    TNBargainSuccessAlertView *alertView = [TNBargainSuccessAlertView alertViewWithBargainPrice:self.viewModel.detailModel.userMsgPrice.thousandSeparatorAmount
                                                                                       showTips:self.viewModel.detailModel.helpCopywritingV2
                                                                                         coupon:self.viewModel.detailModel.couponList];
    alertView.beginMyBargainClick = ^{ //发起我的砍价
        [SAWindowManager openUrl:@"SuperApp://TinhNow/helpActivity" withParameters:@{}];
    };
    alertView.viewNowCouponListClick = ^{
        [HDMediator.sharedInstance navigaveToTinhNowCouponListViewController:@{}];
    };
    [alertView show];
}

#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id sectionModel = self.dataSource[indexPath.row];
    if (sectionModel == self.infoSectionModel) {
        TNBargainGoodInfoCell *cell = [TNBargainGoodInfoCell cellWithTableView:tableView];
        cell.isFromHelpBargain = YES;
        cell.model = self.viewModel.detailModel;
        return cell;
    } else if (sectionModel == self.bargainSectionModel) {
        TNHelpBargainInfoCell *cell = [TNHelpBargainInfoCell cellWithTableView:tableView];
        cell.model = self.viewModel.detailModel;
        @HDWeakify(self);

        cell.helpBargainClickCallBack = ^{
            @HDStrongify(self);
            [self helpBargainClick];
        };
        cell.startMyBargainClickCallBack = ^{
            [SAWindowManager openUrl:@"SuperApp://TinhNow/helpActivity" withParameters:@{}];
        };
        return cell;
    } else if (sectionModel == self.strategySectionModel) {
        TNHelpBargainStrategyCell *cell = [TNHelpBargainStrategyCell cellWithTableView:tableView];
        cell.model = self.viewModel.detailModel;
        @HDWeakify(self);
        cell.getRealImageSizeCallBack = ^{
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    } else if (sectionModel == self.recommendSectionModel) {
        TNHelpBargainRecommendCell *cell = [TNHelpBargainRecommendCell cellWithTableView:self.tableView];
        cell.dataSource = self.recommendSectionModel.list;
        return cell;
    }
    return nil;
}
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        @HDWeakify(self);
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self.viewModel getBargainDetailDataWithTaskId:self.taskId pageType:2];
        };
        _tableView.placeholderViewModel = placeHolderModel;
    }
    return _tableView;
}
/** @lazy viewModel */
- (TNBargainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNBargainViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy infoSectionModel */
- (HDTableViewSectionModel *)infoSectionModel {
    if (!_infoSectionModel) {
        _infoSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _infoSectionModel;
}
/** @lazy bargainSectionModel */
- (HDTableViewSectionModel *)bargainSectionModel {
    if (!_bargainSectionModel) {
        _bargainSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _bargainSectionModel;
}
/** @lazy infoSectionModel */
- (HDTableViewSectionModel *)strategySectionModel {
    if (!_strategySectionModel) {
        _strategySectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _strategySectionModel;
}
/** @lazy recommendSectionModel */
- (HDTableViewSectionModel *)recommendSectionModel {
    if (!_recommendSectionModel) {
        _recommendSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _recommendSectionModel;
}
/** @lazy homeDto */
- (TNHomeDTO *)homeDto {
    if (!_homeDto) {
        _homeDto = [[TNHomeDTO alloc] init];
    }
    return _homeDto;
}
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark - 允许连续push
- (BOOL)allowContinuousBePushed {
    return YES;
}
@end

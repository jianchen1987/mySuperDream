//
//  SACouponListViewController.m
//  SuperApp
//
//  Created by seeu on 2021/7/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponListViewController.h"
#import "LKDataRecord.h"
#import "SACancelltionApplicationAlertView.h"
#import "SACouponFilterDownView.h"
#import "SACouponFilterView.h"
#import "SACouponListViewModel.h"
#import "SACouponTicketCell+Skeleton.h"
#import "SACouponTicketCell.h"
#import "SACouponTicketDTO.h"
#import "SACouponTicketModel.h"
#import "SAGetUserCouponTicketRspModel.h"


@interface SACouponListViewController () <UITableViewDelegate, UITableViewDataSource>
/// 数据源
@property (nonatomic, copy) NSArray *dataSource;
/// 所有优惠券模型 备份
@property (nonatomic, strong) NSMutableArray<SACouponTicketModel *> *couponTicketModelList;
/// DTO
@property (nonatomic, strong) SACouponTicketDTO *couponTicketDTO;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
@property (nonatomic, strong) SACouponFilterView *filterView;   ///< 筛选栏
@property (nonatomic, strong) SACouponListViewModel *viewModel; ///<

@property (nonatomic, strong) SACouponFilterDownView *downView;

/**筛选框过滤条件*/
///券类别9-全部 10-平台券 11-门店券
@property (nonatomic) SACouponListSceneType sceneType;
///排序10-默认 11-新到 12-快过期 13-面额由大到小 14-面额由小到大
@property (nonatomic) SACouponListOrderByType orderBy;
///筛选业务线，仅不区分业务线时，该值才会变化，如果页面有传业务值，则该值不变
@property (nonatomic, copy) SAClientType filterBusinessLine;

/// 空数据容器
@property (nonatomic, strong) UIViewPlaceholderViewModel *noDatePlaceHolder;
/// 网络错误容器
@property (nonatomic, strong) UIViewPlaceholderViewModel *errorPlaceHolder;

@end


@implementation SACouponListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    NSString *busLine = parameters[@"businessLine"];
    self.businessLine = HDIsStringNotEmpty(busLine) ? busLine : SAClientTypeAll;
    return self;
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;

    self.sceneType = SACouponListSceneTypeTypeAll;
    self.orderBy = SACouponListOrderByTypeDefault;
    self.filterBusinessLine = SAClientTypeAll;
    if (!self.businessLine) {
        self.businessLine = SAClientTypeAll;
    } else {
        self.filterBusinessLine = self.businessLine;
    }

    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };
    [self.tableView successGetNewDataWithNoMoreData:YES];
    [self getNewData];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"sortType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self getNewData];
    }];
}

- (void)hd_setupNavigation {
    if (SACouponListViewStyleIndependent == self.viewModel.style && HDIsStringNotEmpty(self.viewModel.title)) {
        self.boldTitle = self.viewModel.title;
    }
}

- (void)updateViewConstraints {
    if (self.viewModel.showFilterBar && self.couponTicketModelList.count) {
        [self.filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (SACouponListViewStyleSubView == self.viewModel.style) {
                make.top.equalTo(self.view);
            } else {
                make.top.equalTo(self.hd_navigationBar.mas_bottom);
            }
            if (self.viewModel.showFilterBar && self.couponTicketModelList.count) {
                make.height.mas_equalTo(kRealWidth(44));
            } else {
                make.height.mas_equalTo(kRealWidth(0));
            }
        }];
    } else {
        [self.filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (SACouponListViewStyleSubView == self.viewModel.style) {
                make.top.equalTo(self.view);
            } else {
                make.top.equalTo(self.hd_navigationBar.mas_bottom);
            }
            make.height.mas_equalTo(kRealWidth(0));
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.filterView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - Data
- (void)getNewData {
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    @HDWeakify(self);
    [self.couponTicketDTO getNewSortCouponTicketListWithPageSize:10 pageNum:pageNo couponState:self.viewModel.couponState businessLine:self.filterBusinessLine topFilterSortType:self.viewModel.sortType
        couponType:self.viewModel.couponType
        sceneType:self.sceneType
        orderBy:self.orderBy success:^(SAGetUserCouponTicketRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            // 修正 number
            self.currentPageNo = rspModel.pageNum;
            NSArray<SACouponTicketModel *> *list = rspModel.list;
            if (pageNo == 1) {
                [self.couponTicketModelList removeAllObjects];
                if (list.count) {
                    // 刷新
                    [self.couponTicketModelList addObjectsFromArray:list];
                    self.couponTicketModelList.firstObject.isFirstCell = true;
                } else {
                    if (self.viewModel.sortType == SACouponListNewSortTypeDefault && self.sceneType == SACouponListSceneTypeTypeAll && self.orderBy == SACouponListOrderByTypeDefault
                        && self.filterBusinessLine == SAClientTypeAll && self.viewModel.couponState == SACouponStateUnused) {
                        //当没有做过筛选时，没有优惠券，改变情感化文言
                        self.noDatePlaceHolder.title = SALocalizedString(@"coupon_match_YouDoNotHaveCouponGoClaimAtCouponCenter", @"你还没有优惠券，去领券中心领取吧");
                    }

                    self.tableView.placeholderViewModel = self.noDatePlaceHolder;
                }
                if (self.viewModel.showFilterBar && list.count) {
                    [self updateViewConstraints];
                }
                self.dataSource = self.couponTicketModelList;
                [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            } else {
                if (list.count) {
                    [self.couponTicketModelList addObjectsFromArray:list];
                    self.dataSource = self.couponTicketModelList;
                }
                [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);

            self.dataSource = @[];
            self.tableView.placeholderViewModel = self.errorPlaceHolder;
            pageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
        }];
}

#pragma mark - private methods
- (NSString *)getCouponNameWithType:(SACouponListCouponType)type {
    if (type == SACouponListCouponTypeAll) {
        return @"全部";
    } else if (type == SACouponListCouponTypeCashCoupon) {
        return @"现金券";
    } else if (type == SACouponListCouponTypeExpressCoupon) {
        return @"运费券";
    } else if (type == SACouponListCouponTypePaymentCoupon) {
        return @"支付券";
    } else {
        return @"全部";
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SACouponTicketCell *cell = [SACouponTicketCell cellWithTableView:tableView];
    if ([model isKindOfClass:SACouponTicketModel.class]) {
        SACouponTicketModel *trueModel = (SACouponTicketModel *)model;
        cell.model = trueModel;
        @HDWeakify(self);
        cell.clickedToUseBTNBlock = ^{
            if (HDIsStringNotEmpty(trueModel.useLink)) {
                [SAWindowManager openUrl:trueModel.useLink withParameters:@{
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|优惠券列表.%@.去使用", [self getCouponNameWithType:self.viewModel.couponType]] : [NSString stringWithFormat:@"优惠券列表.%@.去使用", [self getCouponNameWithType:self.viewModel.couponType]],
                    @"associatedId" : self.viewModel.associatedId
                }];
            } else {
                if (trueModel.businessTypeList.count == 1 && trueModel.businessTypeList.firstObject.unsignedIntegerValue == SACouponTicketBusinessLineYumNow) {
                    [HDMediator.sharedInstance navigaveToYumNowController:@{
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|优惠券列表.%@.去使用", [self getCouponNameWithType:self.viewModel.couponType]] : [NSString stringWithFormat:@"优惠券列表.%@.去使用", [self getCouponNameWithType:self.viewModel.couponType]],
                        @"associatedId" : self.viewModel.associatedId
                    }];
                } else if (trueModel.businessTypeList.count == 1 && trueModel.businessTypeList.firstObject.unsignedIntegerValue == SACouponTicketBusinessLineTinhNow) {
                    [HDMediator.sharedInstance navigaveToTinhNowController:nil];
                } else {
                    [SAWindowManager switchWindowToMainTabBarController];
                }
            }

            [LKDataRecord.shared traceEvent:@"click_use_coupon_button" name:@"点击优惠券立即使用"
                                 parameters:@{@"couponNo": trueModel.couponNo, @"route": HDIsStringNotEmpty(trueModel.useLink) ? trueModel.useLink : @""}
                                        SPM:[LKSPM SPMWithPage:@"SACouponListViewController" area:@"" node:@""]];
        };
        cell.clickedViewDetailBlock = ^{
            @HDStrongify(self);
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SACouponTicketSkeletonModel.class]) {
        [cell hd_beginSkeletonAnimation];
    } else {
        [cell hd_endSkeletonAnimation];
    }
}

#pragma mark - SAViewModelProtocol
- (BOOL)allowContinuousBePushed {
    return true;
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - overwirte
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    if (SACouponListViewStyleIndependent == self.viewModel.style) {
        return HDViewControllerNavigationBarStyleWhite;
    } else {
        return HDViewControllerNavigationBarStyleHidden;
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = kRealHeight(128);
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return _tableView;
}

- (SACouponTicketDTO *)couponTicketDTO {
    if (!_couponTicketDTO) {
        _couponTicketDTO = SACouponTicketDTO.new;
    }
    return _couponTicketDTO;
}

- (NSMutableArray<SACouponTicketModel *> *)couponTicketModelList {
    if (!_couponTicketModelList) {
        _couponTicketModelList = [NSMutableArray array];
    }
    return _couponTicketModelList;
}

- (SACouponFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[SACouponFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(44))];
        NSMutableArray<SACouponFilterViewConfig *> *configs = [[NSMutableArray alloc] initWithCapacity:3];
        SACouponFilterViewConfig *config = SACouponFilterViewConfig.new;
        config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_filter_default" value:@"默认" table:nil];
        config.value = @(SACouponListNewSortTypeDefault);
        [configs addObject:config];

        config = SACouponFilterViewConfig.new;
        config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_NewArrival" value:@"新到" table:nil];
        config.value = @(SACouponListNewSortTypeNew);
        [configs addObject:config];

        config = SACouponFilterViewConfig.new;
        config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_ExpireSoon" value:@"快过期" table:nil];
        config.value = @(SACouponListNewSortTypeNearlyExpired);
        [configs addObject:config];

        if (self.businessLine == SAClientTypeAll) {
            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_FoodDelivery" value:@"外卖" table:nil];
            config.value = @(SACouponListNewSortTypeYumNow);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_OnlineShopping" value:@"电商" table:nil];
            config.value = @(SACouponListNewSortTypeTinhNow);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_TopUp" value:@"话费充值" table:nil];
            config.value = @(SACouponListNewSortTypePhoneTopUp);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_Hotel" value:@"酒店" table:nil];
            config.value = @(SACouponListNewSortTypeHotelChannel);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"coupon_match_Game" value:@"游戏" table:nil];
            config.value = @(SACouponListNewSortTypeGameChannel);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"Coupon_bl_GroupBuy" value:@"团购" table:nil];
            config.value = @(SACouponListNewSortTypeGroupBuy);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"Coupon_bl_AirTicket" value:@"机票" table:nil];
            config.value = @(SACouponListNewSortTypeAirTicket);
            [configs addObject:config];

            config = SACouponFilterViewConfig.new;
            config.name = [SAInternationalizationModel modelWithInternationalKey:@"Coupon_bl_Travel" value:@"旅游" table:nil];
            config.value = @(SACouponListNewSortTypeTravel);
            [configs addObject:config];
        }

        _filterView.isHiddenFilterBtn = self.businessLine != SAClientTypeAll;
        _filterView.configs = configs;
        @HDWeakify(self);
        _filterView.clickOnFilterItemBlock = ^(SACouponFilterViewConfig *_Nonnull config) {
            @HDStrongify(self);
            //初始化默认值
            self.sceneType = SACouponListSceneTypeTypeAll;
            self.orderBy = SACouponListOrderByTypeDefault;
            if (self.businessLine == SAClientTypeAll) { //如果没有业务线，重置筛选框的业务线
                self.filterBusinessLine = SAClientTypeAll;
            }
            self.downView = nil; //清空弹窗选项
            self.viewModel.sortType = ((NSNumber *)config.value).integerValue;
        };
        NSArray<SACouponFilterViewConfig *> *result = [configs hd_filterWithBlock:^BOOL(SACouponFilterViewConfig *_Nonnull item) {
            return [item.value isEqualToNumber:@(self.viewModel.sortType)];
        }];
        NSUInteger idx = [configs indexOfObject:result.firstObject];
        _filterView.selectedIndex = idx;

        _filterView.filterBlock = ^{
            @HDStrongify(self);
            if (self.downView.showing)
                return;

            if (!self.downView) {
                SACouponFilterDownView *downView = [[SACouponFilterDownView alloc] initWithStartOffsetY:kNavigationBarH + kRealWidth(40)];
                self.downView = downView;
                [downView show];
                @HDWeakify(self);
                downView.submitBlock = ^(NSInteger sceneType, SAClientType _Nonnull businessLine, NSInteger orderBy) {
                    @HDStrongify(self);
                    self.sceneType = sceneType;
                    self.filterBusinessLine = businessLine;
                    self.orderBy = orderBy;
                    self.filterView.selectedIndex = -1;                       //清空顶部按钮选中状态
                    self.viewModel.sortType = SACouponListNewSortTypeDefault; //触发刷新列表
                };
            } else {
                [self.downView show];
            }
        };
    }
    return _filterView;
}

/** @lazy  */
- (SACouponListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SACouponListViewModel alloc] init];
        _viewModel.couponType = [self.parameters[@"couponType"] integerValue] != 0 ? [self.parameters[@"couponType"] integerValue] : SACouponListCouponTypeAll;
        _viewModel.sortType = SACouponListNewSortTypeDefault;
        NSNumber *couponState = self.parameters[@"couponState"];
        _viewModel.couponState = (couponState.integerValue >= SACouponStateUnused) ? couponState.integerValue : SACouponStateUnused;
        NSNumber *style = self.parameters[@"style"];
        _viewModel.style = style ? style.integerValue : SACouponListViewStyleIndependent;
        _viewModel.title = self.parameters[@"title"];
        _viewModel.showFilterBar = [self.parameters[@"showFilterBar"] boolValue];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

/** @lazy datasource */
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[SACouponTicketSkeletonModel.new, SACouponTicketSkeletonModel.new, SACouponTicketSkeletonModel.new, SACouponTicketSkeletonModel.new, SACouponTicketSkeletonModel.new];
    }
    return _dataSource;
}

- (UIViewPlaceholderViewModel *)noDatePlaceHolder {
    if (!_noDatePlaceHolder) {
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"coupon_no_coupon";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = HDAppTheme.font.standard4;
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#999999"];
        placeHolder.needRefreshBtn = NO;
        if (self.viewModel.couponState == SACouponStateUnused) {
            placeHolder.title = SALocalizedString(@"coupon_match_CouponTypeNotAvailable", @"你没有这类优惠券");
        } else {
            placeHolder.title = SALocalizedString(@"coupon_match_NoRecordet", @"暂无记录");
        }
        _noDatePlaceHolder = placeHolder;
    }
    return _noDatePlaceHolder;
}

- (UIViewPlaceholderViewModel *)errorPlaceHolder {
    if (!_errorPlaceHolder) {
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"coupon_no_coupon";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = HDAppTheme.font.standard4;
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#999999"];
        placeHolder.needRefreshBtn = YES;
        placeHolder.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        placeHolder.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        _errorPlaceHolder = placeHolder;
    }
    return _errorPlaceHolder;
}

@end

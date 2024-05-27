//
//  TNExpressDetailsViewController.m
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressDetailsViewController.h"
#import "SATableView.h"
#import "TNExpressDetailsItemCell.h"
#import "TNExpressHeaderView.h"
#import "TNExpressViewModel.h"
#import "SAMapView.h"
#import "TNExpressOrderInfoCell.h"
#import "TNExpressRiderCell.h"
#define mapViewHeight kRealWidth(300)


@interface TNExpressDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
/// 聚合订单号
@property (nonatomic, strong) NSString *bizOrderId;

@property (nonatomic, strong) TNExpressViewModel *viewModel;
///
@property (nonatomic, strong) SATableView *tableView;
/// 地图
@property (nonatomic, strong) SAMapView *mapView;
///
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 运单信息
@property (strong, nonatomic) HDTableViewSectionModel *infoSectionModel;
/// 配送进度信息
@property (strong, nonatomic) HDTableViewSectionModel *eventsSectionModel;
/// 骑手信息
@property (strong, nonatomic) HDTableViewSectionModel *riderSectionModel;
/// 占位空白
@property (strong, nonatomic) HDTableViewSectionModel *emptySectionModel;
/// 收货人大头针
@property (nonatomic, strong) SAAnnotation *receiverAnnotation;
/// 商家大头针
@property (nonatomic, strong) SAAnnotation *storeAnnotation;
/// 配送员大头针
@property (nonatomic, strong) SAAnnotation *riderAnnotation;
/// 刷新按钮
@property (strong, nonatomic) HDUIButton *refreshBtn;
/// 阴影
@property (nonatomic, strong) UIView *shadowView;


@end


@implementation TNExpressDetailsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.bizOrderId = [parameters objectForKey:@"bizOrderId"];
        if (HDIsStringEmpty(self.bizOrderId)) {
            return nil;
        }
    }
    return self;
}

- (void)updateViewConstraints {
    [self.refreshBtn sizeToFit];
    [self.refreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mapView.mas_right).offset(-kRealWidth(10));
        make.bottom.equalTo(self.mapView.mas_bottom).offset(-kRealWidth(10));
    }];
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        //        make.bottom.equalTo(self.view.mas_bottom).offset(-mapViewHeight);
        make.height.mas_equalTo(mapViewHeight);
    }];
    [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mapView);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_express_details_title", @"运单详情");
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self.viewModel getNewDataWithOrderNo:self.bizOrderId];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsObjectNil(self.viewModel.expModel)) {
            if (!HDIsObjectNil(self.viewModel.riderModel) && HDIsStringNotEmpty(self.viewModel.riderModel.riderId)) {
                //骑手信息
                self.riderSectionModel.list = @[self.viewModel.riderModel];
                if (self.viewModel.riderModel.deliveryStatus == TNDeliveryStatusSending) {
                    [self showMapView];
                    [self addEmptyModel];
                    //大头针
                    [self addAnnotation];
                } else {
                    [self hideMapView];
                    [self clearEmptyModel];
                }
            } else {
                [self hideMapView];
                [self clearEmptyModel];
            }
            self.infoSectionModel.list = @[self.viewModel.expModel];
            self.eventsSectionModel.list = self.viewModel.expModel.events;
            self.dataSource = @[self.riderSectionModel, self.infoSectionModel, self.eventsSectionModel, self.emptySectionModel];
            [self.tableView successLoadMoreDataWithNoMoreData:NO];
        }
    }];
}
- (void)hd_setupViews {
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.shadowView];
    [self.mapView addSubview:self.refreshBtn];
    [self.view addSubview:self.tableView];
}
#pragma mark - 添加占位空白视图
- (void)addEmptyModel {
    //运单列表显示10条 大概就可以滑动到顶部  如果小于10条  补齐
    NSInteger count = 10;
    if (self.viewModel.expModel.events.count < count) {
        count = count - self.viewModel.expModel.events.count;
    }
    NSMutableArray *emptyArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *emptyStr = @"";
        [emptyArr addObject:emptyStr];
    }
    self.emptySectionModel.list = emptyArr;
}
- (void)clearEmptyModel {
    self.emptySectionModel.list = @[];
}
#pragma mark - 展示地图
- (void)showMapView {
    self.mapView.hidden = NO;
    self.tableView.bounces = NO;
    self.tableView.hd_ignoreSpace = [UIScrollViewIgnoreSpaceModel ignoreSpaceWithMinX:0 maxX:0 minY:0 maxY:mapViewHeight];
    self.tableView.contentInset = UIEdgeInsetsMake(mapViewHeight, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, -mapViewHeight) animated:false];
}
#pragma mark - 隐藏地图
- (void)hideMapView {
    self.mapView.hidden = YES;
    self.tableView.bounces = YES;
    self.tableView.hd_ignoreSpace = [UIScrollViewIgnoreSpaceModel ignoreSpaceWithMinX:0 maxX:0 minY:0 maxY:0];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [self.tableView setContentOffset:CGPointZero animated:false];
}
#pragma mark - 添加大头针
- (void)addAnnotation {
    //设置收货人和门店大头针
    self.receiverAnnotation.coordinate = CLLocationCoordinate2DMake(self.viewModel.riderModel.endLatitude.doubleValue, self.viewModel.riderModel.endLongitude.doubleValue);
    self.storeAnnotation.coordinate = CLLocationCoordinate2DMake(self.viewModel.riderModel.startLatitude.doubleValue, self.viewModel.riderModel.startLongitude.doubleValue);
    [self.mapView.mapView removeAnnotations:@[self.receiverAnnotation, self.storeAnnotation]];
    [self.mapView.mapView addAnnotations:@[self.receiverAnnotation, self.storeAnnotation]];

    if (self.viewModel.riderModel.currentLatitude) {
        self.riderAnnotation.coordinate = CLLocationCoordinate2DMake(self.viewModel.riderModel.currentLatitude.doubleValue, self.viewModel.riderModel.currentLongitude.doubleValue);
        [self.mapView.mapView removeAnnotation:self.riderAnnotation];
        [self.mapView.mapView addAnnotations:@[self.riderAnnotation]];
    }
    [self updateMapViewCenterAndLeavel];
}
#pragma mark - 更新地图中心点及显示级别
- (void)updateMapViewCenterAndLeavel {
    [self.mapView.mapView setCenterCoordinate:self.receiverAnnotation.coordinate animated:false];
    double latitudeDelta = 0;  // 纬度范围
    double longitudeDelta = 0; // 经度范围
    CGFloat leavel = 4;        // 缩放等级，越大缩的越小
    if ([self.mapView.mapView.annotations containsObject:self.storeAnnotation]) {
        latitudeDelta = fabs(self.storeAnnotation.coordinate.latitude - self.receiverAnnotation.coordinate.latitude) * leavel;
        longitudeDelta = fabs(self.storeAnnotation.coordinate.longitude - self.receiverAnnotation.coordinate.longitude) * leavel;
    }
    if ([self.mapView.mapView.annotations containsObject:self.riderAnnotation]) {
        latitudeDelta = MAX(fabs(self.riderAnnotation.coordinate.latitude - self.receiverAnnotation.coordinate.latitude) * leavel, latitudeDelta);
        longitudeDelta = MAX(fabs(self.riderAnnotation.coordinate.longitude - self.receiverAnnotation.coordinate.longitude) * leavel, longitudeDelta);
    }
    // 纬度范围最大180度，经度范围最大360度
    latitudeDelta = MIN(180, latitudeDelta);
    longitudeDelta = MIN(360, longitudeDelta);
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.receiverAnnotation.coordinate, span);
    [self.mapView.mapView setRegion:region animated:false];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = true;

    if (self.mapView.isHidden)
        return;

    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;

    CGFloat alpha = offsetY / mapViewHeight;
    alpha = alpha > 0.98 ? 1 : alpha;
    alpha = alpha < 0.02 ? 0 : alpha;
    self.shadowView.alpha = alpha;

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    scrollView.isScrolling = false;

    if (self.mapView.isHidden)
        return;

    // 滚动停止
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;

    // 临界值
    const CGFloat criticalY = mapViewHeight * 0.5;

    if (offsetY > 0 && offsetY < criticalY) {
        [scrollView setContentOffset:CGPointMake(0, -scrollView.contentInset.top) animated:true];
    } else if (offsetY >= criticalY && offsetY < mapViewHeight) {
        [scrollView setContentOffset:CGPointMake(0, mapViewHeight - scrollView.contentInset.top) animated:true];
    }
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    return sectionModel.list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (sectionModel == self.emptySectionModel) {
        return 70;
    } else {
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (sectionModel == self.infoSectionModel) {
        TNExpressOrderInfoCell *cell = [TNExpressOrderInfoCell cellWithTableView:tableView];
        cell.model = sectionModel.list[indexPath.row];
        return cell;
    } else if (sectionModel == self.eventsSectionModel) {
        TNExpressDetailsItemCell *cell = [TNExpressDetailsItemCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        } else {
            cell.isFirst = NO;
        }
        if (indexPath.row == sectionModel.list.count - 1) {
            cell.isLast = YES;
        } else {
            cell.isLast = NO;
        }
        cell.eventInfoModel = sectionModel.list[indexPath.row];
        return cell;
    } else if (sectionModel == self.riderSectionModel) {
        TNExpressRiderCell *cell = [[TNExpressRiderCell alloc] init];
        cell.riderModel = sectionModel.list[indexPath.row];
        cell.trackingNo = self.viewModel.expModel.trackingNo;
        return cell;
    } else if (sectionModel == self.emptySectionModel) {
        SATableViewCell *cell = [SATableViewCell cellWithTableView:tableView];
        return cell;
    }
    return UITableViewCell.new;
}


#pragma mark
- (TNExpressViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNExpressViewModel alloc] init];
    }
    return _viewModel;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (SAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[SAMapView alloc] init];
        _mapView.hidden = YES;
    }
    return _mapView;
}
/** @lazy  infoSectionModel*/
- (HDTableViewSectionModel *)infoSectionModel {
    if (!_infoSectionModel) {
        _infoSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _infoSectionModel;
}
/** @lazy eventsSectionModel */
- (HDTableViewSectionModel *)eventsSectionModel {
    if (!_eventsSectionModel) {
        _eventsSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _eventsSectionModel;
}
/** @lazy riderSectionModel */
- (HDTableViewSectionModel *)riderSectionModel {
    if (!_riderSectionModel) {
        _riderSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _riderSectionModel;
}
/** @lazy emptySectionModel */
- (HDTableViewSectionModel *)emptySectionModel {
    if (!_emptySectionModel) {
        _emptySectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _emptySectionModel;
}
- (SAAnnotation *)receiverAnnotation {
    if (!_receiverAnnotation) {
        _receiverAnnotation = SAAnnotation.new;
        _receiverAnnotation.type = SAAnnotationTypeConsignee;
        _receiverAnnotation.logoImage = [UIImage imageNamed:@"annotation_user_logo"];
    }
    return _receiverAnnotation;
}

- (SAAnnotation *)storeAnnotation {
    if (!_storeAnnotation) {
        _storeAnnotation = SAAnnotation.new;
        _storeAnnotation.type = SAAnnotationTypeMerchant;
        _storeAnnotation.logoImage = [UIImage imageNamed:@"tn_annotion_store"];
    }
    return _storeAnnotation;
}

- (SAAnnotation *)riderAnnotation {
    if (!_riderAnnotation) {
        _riderAnnotation = SAAnnotation.new;
        _riderAnnotation.type = SAAnnotationTypeDeliveryMan;
        _riderAnnotation.logoImage = [UIImage imageNamed:@"delivery_rider"];
    }
    return _riderAnnotation;
}
/** @lazy refreshBtn */
- (HDUIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[HDUIButton alloc] init];
        [_refreshBtn setImage:[UIImage imageNamed:@"tn_map_refresh"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_refreshBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewModel getNewDataWithOrderNo:self.bizOrderId];
        }];
    }
    return _refreshBtn;
}
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.new;
        _shadowView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _shadowView.alpha = 0;
    }
    return _shadowView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

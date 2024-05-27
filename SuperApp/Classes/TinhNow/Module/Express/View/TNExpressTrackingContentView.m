//
//  TNExpressTrackingContentView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressTrackingContentView.h"
#import "TNExpressContactCell.h"
#import "TNExpressDetailsItemCell.h"
#import "TNExpressDetailsModel.h"
#import "TNExpressFreightDetailCell.h"
#import "TNExpressInfoCell.h"
#import "TNExpressTrackingStatusCell.h"
#import "TNNoDataCell.h"


@interface TNExpressTrackingContentView () <UITableViewDelegate, UITableViewDataSource>
/// tableView
@property (strong, nonatomic) UITableView *tableView;
/// 数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataArr;
/// 物流模型数据
@property (strong, nonatomic) TNExpressDetailsModel *expressModel;
/// 是否是免邮订单
@property (nonatomic, assign) BOOL isFreeshipping;
@end


@implementation TNExpressTrackingContentView
- (instancetype)initWithExpressModel:(TNExpressDetailsModel *)model isFreeshipping:(BOOL)isFreeshipping {
    if (self = [super init]) {
        self.expressModel = model;
        self.isFreeshipping = isFreeshipping;
        [self prepareData];
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.tableView];
}
#pragma mark - 组装数据
- (void)prepareData {
    if (HDIsObjectNil(self.expressModel)) {
        HDTableViewSectionModel *section = HDTableViewSectionModel.new;
        TNNoDataCellModel *noModel = [[TNNoDataCellModel alloc] init];
        noModel.noDataText = TNLocalizedString(@"HuV6uEKZ", @"暂无信息");
        section.list = @[noModel];
        [self.dataArr addObject:section];
    } else {
        //是否需要展示暂无信息提示   只要没有物流公司和物流节点  就显示暂无信息
        if (HDIsStringNotEmpty(self.expressModel.status)) {
            HDTableViewSectionModel *section = HDTableViewSectionModel.new;
            TNExpressTrackingStatusCellModel *esModel = [[TNExpressTrackingStatusCellModel alloc] init];
            esModel.isNeedHiddenArrowIV = YES;
            esModel.contentText = self.expressModel.status;
            section.list = @[esModel];
            [self.dataArr addObject:section];
        }

        if (HDIsStringNotEmpty(self.expressModel.deliveryCorp)) {
            HDTableViewSectionModel *section = HDTableViewSectionModel.new;
            TNExpressInfoCellModel *eiModel = TNExpressInfoCellModel.new;
            eiModel.deliveryCorp = self.expressModel.deliveryCorp;
            eiModel.trackingNo = self.expressModel.trackingNo;
            eiModel.deliveryCorpUrl = self.expressModel.deliveryCorpUrl;
            section.list = @[eiModel];
            [self.dataArr addObject:section];
        }
        if (!HDIsArrayEmpty(self.expressModel.telephone) || !HDIsArrayEmpty(self.expressModel.telegrams)) {
            HDTableViewSectionModel *section = HDTableViewSectionModel.new;
            HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
            section.headerModel = headerModel;
            TNExpressContactCellModel *cModel = TNExpressContactCellModel.new;
            cModel.phones = self.expressModel.telephone;
            cModel.telegrams = self.expressModel.telegrams;
            section.list = @[cModel];
            [self.dataArr addObject:section];
        }

        if (!self.isFreeshipping && !HDIsArrayEmpty(self.expressModel.pricingItems)) {
            HDTableViewSectionModel *section = HDTableViewSectionModel.new;
            HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
            section.headerModel = headerModel;
            TNExpressFreightDetailCellModel *freight = [TNExpressFreightDetailCellModel configCellModelWithDetailModel:self.expressModel];
            section.list = @[freight];
            [self.dataArr addObject:section];
        }

        if (!HDIsArrayEmpty(self.expressModel.events)) {
            HDTableViewSectionModel *section = HDTableViewSectionModel.new;
            HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
            section.headerModel = headerModel;
            section.list = self.expressModel.events;
            [self.dataArr addObject:section];
        } else {
            HDTableViewSectionModel *section = HDTableViewSectionModel.new;
            TNNoDataCellModel *noModel = [[TNNoDataCellModel alloc] init];
            noModel.noDataText = TNLocalizedString(@"HuV6uEKZ", @"暂无信息");
            section.list = @[noModel];
            [self.dataArr addObject:section];
        }
    }
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr[section].list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNExpressTrackingStatusCellModel.class]) {
        TNExpressTrackingStatusCell *cell = [TNExpressTrackingStatusCell cellWithTableView:tableView];
        cell.model = (TNExpressTrackingStatusCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNExpressInfoCellModel.class]) {
        TNExpressInfoCell *cell = [TNExpressInfoCell cellWithTableView:tableView];
        cell.model = (TNExpressInfoCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNExpressEventInfoModel.class]) {
        TNExpressDetailsItemCell *cell = [TNExpressDetailsItemCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        }
        if (indexPath.row == sectionModel.list.count - 1) {
            cell.isLast = YES;
        }
        cell.eventInfoModel = (TNExpressEventInfoModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNNoDataCellModel.class]) {
        TNNoDataCell *cell = [TNNoDataCell cellWithTableView:tableView];
        cell.model = (TNNoDataCellModel *)model;
        cell.backgroundColor = HDAppTheme.TinhNowColor.G5;
        return cell;
    } else if ([model isKindOfClass:TNExpressFreightDetailCellModel.class]) {
        TNExpressFreightDetailCell *cell = [TNExpressFreightDetailCell cellWithTableView:tableView];
        cell.model = (TNExpressFreightDetailCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNExpressContactCellModel.class]) {
        TNExpressContactCell *cell = [TNExpressContactCell cellWithTableView:tableView];
        cell.model = (TNExpressContactCellModel *)model;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        return kRealWidth(10);
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNNoDataCellModel.class]) {
        return kScreenHeight - HD_STATUSBAR_NAVBAR_HEIGHT - kRealWidth(45);
    } else {
        return UITableViewAutomaticDimension;
    }
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
/** @lazy dataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}

@end

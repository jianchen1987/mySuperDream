//
//  SAChooseZoneView.m
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChooseZoneView.h"
#import "SATableView.h"
#import "SAChooseZoneViewModel.h"
#import "SAAddressZoneModel.h"
#import "SAChooseZoneCell.h"
#import "SAChooseZoneHeaderView.h"


@interface SAChooseZoneView () <UITableViewDelegate, UITableViewDataSource>

/// VM
@property (nonatomic, strong) SAChooseZoneViewModel *viewModel;
/// tableView
@property (nonatomic, strong) SATableView *tableView;
/// 头部
@property (nonatomic, strong) SAChooseZoneHeaderView *headerView;

@end


@implementation SAChooseZoneView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:true];
    }];
}

#pragma mark - public methods
- (void)setupLocation:(SAAddressZoneModel *)zoneModel {
    self.headerView.locationModel = zoneModel;
}

- (void)setupHotCitys:(NSArray<SAAddressZoneModel *> *)hotCitys {
    self.headerView.hotCitys = hotCitys;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count)
        return 0;
    return self.viewModel.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.viewModel.dataSource.count)
        return UITableViewCell.new;
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAAddressZoneModel.class]) {
        SAChooseZoneCell *cell = [SAChooseZoneCell cellWithTableView:tableView];
        SAAddressZoneModel *trueModel = (SAAddressZoneModel *)model;
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count)
        return nil;
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if (sectionModel.list.count <= 0 || HDIsStringEmpty(sectionModel.headerModel.title))
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count)
        return CGFLOAT_MIN;
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if (sectionModel.list.count <= 0 || HDIsStringEmpty(sectionModel.headerModel.title))
        return CGFLOAT_MIN;
    return kRealWidth(45);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.viewModel.dataSource.count)
        return;
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAAddressZoneModel.class]) {
        [self chooseZoneCompleteWithModel:model];
    }
}

#pragma mark - private methods
- (void)chooseZoneCompleteWithModel:(SAAddressZoneModel *)model {
    if (model.zlevel == SAAddressZoneLevelDistrict) {
        [self.viewModel chooseZoneModel:model];
        [self.viewController.navigationController popViewControllerAnimated:true];
    } else if (model.zlevel == SAAddressZoneLevelProvince) {
        NSUInteger section = [self.viewModel findSectionWithChooseHotCity:model];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:false];
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        SATableView *tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.needRefreshHeader = false;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 45;
        tableView.tableHeaderView = self.headerView;
        _tableView = tableView;
    }
    return _tableView;
}
- (SAChooseZoneHeaderView *)headerView {
    if (!_headerView) {
        _headerView = SAChooseZoneHeaderView.new;
        @HDWeakify(self);
        _headerView.chooseCityBlock = ^(SAAddressZoneModel *_Nonnull model) {
            @HDStrongify(self);
            [self chooseZoneCompleteWithModel:model];
        };
    }
    return _headerView;
}

@end

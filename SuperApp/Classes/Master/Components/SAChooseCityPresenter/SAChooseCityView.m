//
//  SAChooseCityView.m
//  SuperApp
//
//  Created by seeu on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAChooseCityView.h"
#import "SAAddressZoneModel.h"
#import "SAChooseCityViewModel.h"
#import "SAChooseZoneCell.h"
#import "SAChooseZoneHeaderView.h"
#import "SATableView.h"


@interface SAChooseCityView () <UITableViewDelegate, UITableViewDataSource>

/// VM
@property (nonatomic, strong) SAChooseCityViewModel *viewModel;
/// tableView
@property (nonatomic, strong) SATableView *tableView;
/// 头部
@property (nonatomic, strong) SAChooseZoneHeaderView *headerView;

@end


@implementation SAChooseCityView

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count)
        return 0;
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.viewModel.dataSource.count)
        return UITableViewCell.new;

    id model = self.viewModel.dataSource[indexPath.row];
    if ([model isKindOfClass:SAAddressZoneModel.class]) {
        SAChooseZoneCell *cell = [SAChooseZoneCell cellWithTableView:tableView];
        SAAddressZoneModel *trueModel = (SAAddressZoneModel *)model;
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.viewModel.dataSource.count)
        return;

    id model = self.viewModel.dataSource[indexPath.row];
    if ([model isKindOfClass:SAAddressZoneModel.class]) {
        [self chooseZoneCompleteWithModel:model];
    }
}

#pragma mark - private methods
- (void)chooseZoneCompleteWithModel:(SAAddressZoneModel *)model {
    if (model.zlevel == SAAddressZoneLevelProvince) {
        [self.viewModel chooseZoneModel:model];
        [self.viewController.navigationController popViewControllerAnimated:true];
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

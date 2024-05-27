//
//  TNCategoryFirstLevelView.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryFirstLevelView.h"
#import "SATableView.h"
#import "TNCategoryFirstLevelTableViewCell.h"
#import "TNCategoryModel.h"
#import "TNCategoryViewModel.h"
#import "TNFirstLevelCategoryModel.h"
#import "TNSecondLevelCategoryModel.h"


@interface TNCategoryFirstLevelView () <UITableViewDelegate, UITableViewDataSource>

/// tableview
@property (nonatomic, strong) SATableView *tableView;
/// dataSource
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// viewmodel
@property (nonatomic, strong) TNCategoryViewModel *viewModel;
@end


@implementation TNCategoryFirstLevelView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.firstLevel];
    [self.tableView successGetNewDataWithNoMoreData:YES];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"firstLevel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.firstLevel];
        if (self.dataSource.count > 0 && self.dataSource.firstObject.list.count > 0) {
            TNFirstLevelCategoryModel *model = self.viewModel.firstLevel[0].list[0];
            model.isSelected = true;
            [self prepareSecondLevelData:model];
        }
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark 准备二级分类数据
- (void)prepareSecondLevelData:(TNFirstLevelCategoryModel *)model {
    HDTableViewSectionModel *section = HDTableViewSectionModel.new;
    section.list = [NSArray arrayWithArray:model.children];
    self.viewModel.secondLevelHeader = model.name;
    self.viewModel.adImageUrl = model.advImgUrl;
    self.viewModel.adOpenUrl = model.advAppUrl;
    self.viewModel.secondLevel = @[section];
    [SATalkingData trackEvent:@"[电商]分类tab_点击一级分类" label:@"" parameters:@{@"分类ID": model.categoryId}];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNFirstLevelCategoryModel *model = self.dataSource[indexPath.section].list[indexPath.row];
    TNCategoryFirstLevelTableViewCell *cell = [TNCategoryFirstLevelTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *list = self.dataSource[indexPath.section].list;
    TNFirstLevelCategoryModel *model = list[indexPath.row];
    if (model.isSelected == true) {
        return;
    }
    model.isSelected = !model.isSelected;
    for (TNFirstLevelCategoryModel *fModel in list) {
        if (model != fModel) {
            fModel.isSelected = false;
        }
    }
    [self prepareSecondLevelData:model];
    [self.tableView successGetNewDataWithNoMoreData:true];
}

#pragma mark - lazy load
/** @lazy tableviw */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, 80, 100) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.G6;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.needShowNoDataView = NO;
        _tableView.bounces = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

/** @lazy dataSource */
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _dataSource;
}

@end

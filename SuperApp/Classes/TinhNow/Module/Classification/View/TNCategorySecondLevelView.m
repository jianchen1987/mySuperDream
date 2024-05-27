//
//  TNCategorySectionLevelView.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategorySecondLevelView.h"
#import "SATableView.h"
#import "TNCategoryModel.h"
#import "TNCategorySecondLevelTableViewCell.h"
#import "TNCategoryTableViewHeaderView.h"
#import "TNCategoryViewModel.h"
#import "TNSecondLevelCategoryModel.h"


@interface TNCategorySecondLevelView () <UITableViewDelegate, UITableViewDataSource>
/// tableview
@property (nonatomic, strong) SATableView *tableView;
/// dataSource
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// viewmodel
@property (nonatomic, strong) TNCategoryViewModel *viewModel;
/// 头部广告图
@property (nonatomic, strong) UIView *adHeaderView;
/// 头部图片
@property (strong, nonatomic) UIImageView *adImageView;
@end


@implementation TNCategorySecondLevelView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    //     self.tableView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.secondLevel];
    [self.tableView successGetNewDataWithNoMoreData:YES];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"secondLevel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.viewModel.adImageUrl)) {
            self.tableView.tableHeaderView = self.adHeaderView;
            [HDWebImageManager setImageWithURL:self.viewModel.adImageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.adImageView.height * 2, self.adImageView.height)]
                                     imageView:self.adImageView];
        } else {
            self.tableView.tableHeaderView = nil;
        }
        self.dataSource = [NSMutableArray arrayWithArray:self.viewModel.secondLevel];
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - 广告图点击
- (void)adClick:(UITapGestureRecognizer *)tap {
    if (HDIsStringNotEmpty(self.viewModel.adOpenUrl)) {
        [SAWindowManager openUrl:self.viewModel.adOpenUrl withParameters:@{}];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNSecondLevelCategoryModel *model = self.dataSource[indexPath.section].list[indexPath.row];
    TNCategorySecondLevelTableViewCell *cell = [TNCategorySecondLevelTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - lazy load
/** @lazy tableviw */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, 80, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

/** @lazy  */
- (UIView *)adHeaderView {
    if (!_adHeaderView) {
        _adHeaderView = [[UIView alloc] init];
        _adHeaderView.size = CGSizeMake(self.width, kRealWidth(92));
        _adImageView = [[UIImageView alloc] init];
        [_adHeaderView addSubview:_adImageView];
        _adImageView.frame = CGRectMake(15, 10, self.width - 30, kRealHeight(82));
        _adHeaderView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClick:)];
        [_adHeaderView addGestureRecognizer:tap];
    }
    return _adHeaderView;
}
@end

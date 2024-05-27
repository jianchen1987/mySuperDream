//
//  WMOrderDetailTrackingView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailTrackingView.h"
#import "SATableView.h"
#import "WMOrderDetailTrackingTableViewCell.h"


@interface WMOrderDetailTrackingView () <UITableViewDelegate, UITableViewDataSource>
/// 数据源
@property (nonatomic, copy) NSArray<WMOrderDetailTrackingTableViewCellModel *> *dataSource;
/// 语言列表
@property (nonatomic, strong) SATableView *tableView;

@end


@implementation WMOrderDetailTrackingView

- (instancetype)initWithTrackingModel:(NSArray<WMOrderDetailTrackingTableViewCellModel *> *)modelArray {
    if (self = [super init]) {
        [modelArray enumerateObjectsUsingBlock:^(WMOrderDetailTrackingTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.status == WMOrderDetailTrackingStatusProcessing) {
                *stop = YES;
            }
            if (obj.status == WMOrderDetailTrackingStatusExpected) {
                obj.hightNode = YES;
                *stop = YES;
            }
        }];
        self.dataSource = modelArray;
        [self.tableView successGetNewDataWithNoMoreData:NO];
        [self.tableView layoutIfNeeded];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(self.tableView.contentSize.height);
    }];
    [super updateConstraints];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.tableView.frame) + kRealWidth(12));
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    WMOrderDetailTrackingTableViewCellModel *model = self.dataSource[indexPath.row];
    WMOrderDetailTrackingTableViewCell *cell = [WMOrderDetailTrackingTableViewCell cellWithTableView:tableView];
    model.showUpLine = indexPath.row != 0;
    model.showDownLine = indexPath.row != self.dataSource.count - 1;
    cell.model = model;
    return cell;
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = kRealWidth(44);
        _tableView.estimatedRowHeight = kRealWidth(44);
        _tableView.bounces = false;
    }
    return _tableView;
}
@end

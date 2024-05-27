//
//  PayActionSheetView.m
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayActionSheetView.h"


@implementation PayActionSheetView
- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    PaySelectableTableViewCellModel *model = self.dataSource[indexPath.row];
    PaySelectableTableViewCell *cell = [PaySelectableTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    PaySelectableTableViewCellModel *model = self.dataSource[indexPath.row];
    !self.selectedItemHandler ?: self.selectedItemHandler(model);
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self selectDefaultIndexPath];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.tableView.contentSize.height);
    self.tableView.frame = self.bounds;
}

#pragma mark - private methods
- (void)selectDefaultIndexPath {
    for (PaySelectableTableViewCellModel *model in self.dataSource) {
        if ([model.text isEqualToString:self.DefaultStr]) {
            // 默认选中
            NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:model] inSection:0];
            [self.tableView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.bounces = false;
    }
    return _tableView;
}

@end

//
//  WMOrderRefundChooseReasonView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRefundChooseReasonView.h"
#import "SATableView.h"
#import "WMOrderRefundReasonCell.h"


@interface WMOrderRefundChooseReasonView () <UITableViewDelegate, UITableViewDataSource>
/// 语言列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray<WMOrderRefundReasonCellModel *> *dataSource;
@end


@implementation WMOrderRefundChooseReasonView

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
    WMOrderRefundReasonCellModel *model = self.dataSource[indexPath.row];
    model.needTopLine = indexPath.row == 0;
    model.needBottomLine = indexPath.row != self.dataSource.count - 1;
    WMOrderRefundReasonCell *cell = [WMOrderRefundReasonCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

    WMOrderRefundReasonCellModel *model = self.dataSource[indexPath.row];
    !self.selectedItemHandler ?: self.selectedItemHandler(model);
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.tableView.contentSize.height);
    self.tableView.frame = self.bounds;
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

- (NSMutableArray<WMOrderRefundReasonCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:3];
        NSArray<NSString *> *languages = @[
            WMLocalizedString(@"refund_reason_not_pair", @"商品与网上说明不符"),
            WMLocalizedString(@"refund_reason_quality", @"商品有质量问题"),
            WMLocalizedString(@"refund_reason_other", @"其他（请在问题描述里填写）")
        ];
        for (NSString *language in languages) {
            WMOrderRefundReasonCellModel *model = WMOrderRefundReasonCellModel.new;
            model.text = language;
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

@end

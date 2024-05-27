//
//  SAChangeAppEnvView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeAppEnvView.h"
//#import "SACacheManager.h"
//#import "SAChangeCountryViewProvider.h"
#import "SAAppEnvManager.h"
#import "SASelectableTableViewCell.h"
#import "SATableView.h"


@interface SAChangeAppEnvView () <UITableViewDelegate, UITableViewDataSource>
/// 国家列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<SAAppEnvConfig *> *dataSource;
@end


@implementation SAChangeAppEnvView
- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return nil;
    SAAppEnvConfig *model = self.dataSource[indexPath.row];
    SASelectableTableViewCellModel *cellModel = SASelectableTableViewCellModel.new;
    cellModel.text = model.name;

    SASelectableTableViewCell *cell = [SASelectableTableViewCell cellWithTableView:tableView];
    cell.model = cellModel;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

    SAAppEnvConfig *model = self.dataSource[indexPath.row];
    // 切换环境
    [SAAppEnvManager.sharedInstance setEnvType:model.type];
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
- (NSString *)imageNameForCountryCode:(NSString *)code {
    if ([code isEqualToString:@"855"]) {
        return @"ic_khmer_cycle";
    }
    if ([code isEqualToString:@"86"]) {
        return @"ic_chinese_cycle";
    }
    return nil;
}

- (void)selectDefaultIndexPath {
    // 获取当前选择的国家
    SAAppEnvConfig *appEnvConfig = SAAppEnvManager.sharedInstance.appEnvConfig;
    for (SAAppEnvConfig *config in self.dataSource) {
        if ([config.type isEqualToString:appEnvConfig.type]) {
            // 默认选中
            NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:config] inSection:0];
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

- (NSArray<SAAppEnvConfig *> *)dataSource {
    if (!_dataSource) {
        _dataSource = SAAppEnvManager.sharedInstance.dataSource;
    }
    return _dataSource;
}

@end

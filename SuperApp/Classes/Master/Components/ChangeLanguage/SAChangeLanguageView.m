//
//  SAChangeLanguageView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangeLanguageView.h"
#import "SAMultiLanguageManager.h"
#import "SASelectableTableViewCell.h"
#import "SATableView.h"


@interface SAChangeLanguageView () <UITableViewDelegate, UITableViewDataSource>
/// 语言列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray<SASelectableTableViewCellModel *> *dataSource;
@end


@implementation SAChangeLanguageView
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
    SASelectableTableViewCellModel *model = self.dataSource[indexPath.row];
    SASelectableTableViewCell *cell = [SASelectableTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

    SASelectableTableViewCellModel *model = self.dataSource[indexPath.row];
    SALanguageType type = [SAMultiLanguageManager languageTypeForDisplayName:model.text];
    [SAMultiLanguageManager setLanguage:type];
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
    // 获取当前语言
    NSString *currentLanguage = SAMultiLanguageManager.currentLanguageDisplayName;
    for (SASelectableTableViewCellModel *model in self.dataSource) {
        if ([model.text isEqualToString:currentLanguage]) {
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

- (NSMutableArray<SASelectableTableViewCellModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:3];
        NSArray<NSString *> *languages = SAMultiLanguageManager.supportLanguageDisplayNames;
        for (NSString *language in languages) {
            SASelectableTableViewCellModel *model = SASelectableTableViewCellModel.new;
            model.text = language;
            model.image = [UIImage imageNamed:[SAMultiLanguageManager imageNameForLanguageType:[SAMultiLanguageManager languageTypeForDisplayName:language]]];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

@end

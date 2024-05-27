//
//  SASearchHistoryView.m
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchHistoryView.h"
#import "SASearchFindCell.h"
#import "SASearchRankCell.h"
#import "SASearchRecentlyCell.h"
#import "SASearchViewModel.h"
#import "SATableView.h"


@interface SASearchHistoryView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) SASearchViewModel *viewModel;
/// tableView
@property (nonatomic, strong) SATableView *tableView;
/// 是否查看全部
@property (nonatomic) BOOL isShowAll;

@end


@implementation SASearchHistoryView

#pragma mark - SAViewProtocol
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewBlock)(void) = ^(void) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:true];
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewBlock();
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - private methods
/// 清除商户搜索历史纪录
- (void)clearMerchantSearchHistoryRecord {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[0];
    NSArray *wordList = sectionModel.list.firstObject;
    if ([wordList isKindOfClass:NSArray.class] && wordList.count > 1) {
        [NAT showAlertWithMessage:WMLocalizedString(@"confirm_delete_all", @"确认全部删除？") confirmButtonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
             confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                 [alertView dismiss];
                 [self _clearAllHistoryRecord];
             }
                cancelButtonTitle:WMLocalizedStringFromTable(@"cancel", @"取消", @"Buttons")
              cancelButtonHandler:nil];
    } else {
        [self _clearAllHistoryRecord];
    }
}

- (void)_clearAllHistoryRecord {
    // 删除缓存的搜索纪录
    [self.viewModel removeAllHistorySearch];
    //刷新第一组
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.viewModel.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);
    HDTableViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    id model = sectionModel.list;
    if (indexPath.section == 0) {
        SASearchRecentlyCell *cell = [SASearchRecentlyCell cellWithTableView:tableView];
        cell.dataSource = model[indexPath.row];
        cell.clickItemBlock = ^(NSString *_Nonnull itemStr) {
            @HDStrongify(self);
            //            HDLog(@"点击了搜索发现的关键词:%@", itemStr);
            if (self.keywordSelectedBlock)
                self.keywordSelectedBlock(itemStr);
        };
        cell.clearAllHistoryBlock = ^{
            @HDStrongify(self);
            [self clearMerchantSearchHistoryRecord];
        };
        return cell;
    } else if (indexPath.section == 1) {
        SASearchFindCell *cell = [SASearchFindCell cellWithTableView:tableView];
        cell.isShowAll = self.isShowAll;
        cell.dataSource = model[indexPath.row];

        cell.reloadCellBlock = ^{
            @HDStrongify(self);
            //刷新第二组
            self.isShowAll = !self.isShowAll;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        cell.clickItemBlock = ^(NSString *_Nonnull itemStr) {
            @HDStrongify(self);
            //            HDLog(@"点击了搜索发现的关键词:%@", itemStr);
            if (self.keywordSelectedBlock)
                self.keywordSelectedBlock(itemStr);
        };
        return cell;
    } else if (indexPath.section == 2) {
        SASearchRankCell *cell = [SASearchRankCell cellWithTableView:tableView];
        cell.dataSource = model[indexPath.row];
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark lazy
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.needShowNoDataView = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return _tableView;
}

@end

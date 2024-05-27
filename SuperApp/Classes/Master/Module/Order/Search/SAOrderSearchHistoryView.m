//
//  SAOrderSearchView.m
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderSearchHistoryView.h"
#import "SAOrderSearchHistoryCell.h"
#import "SAOrderSearchViewModel.h"
#import "SATableView.h"


@interface SAOrderSearchHistoryView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) SAOrderSearchViewModel *viewModel;
/// tableView
@property (nonatomic, strong) SATableView *tableView;

@end


@implementation SAOrderSearchHistoryView

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
    NSArray *wordList = self.viewModel.dataSource;
    if (wordList.count > 1) {
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

    [self.tableView successGetNewDataWithNoMoreData:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);

    SAOrderSearchHistoryCell *cell = [SAOrderSearchHistoryCell cellWithTableView:tableView];
    cell.dataSource = self.viewModel.dataSource;
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
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

@end

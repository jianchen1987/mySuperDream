//
//  GNListViewController.m
//  SuperApp
//
//  Created by wmz on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNListViewController.h"


@implementation GNListViewController

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.view addSubview:self.tableView];
    @HDWeakify(self) self.tableView.requestNewDataHandler = self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self) self.tableView.pageNum = 1;
        [self gn_getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self)[self gn_getNewData];
    };
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///刷新cell
    if ([event.key isEqualToString:@"reloadAction"]) {
        [self.tableView updateCell:nil];
    }
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarH);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    [super updateViewConstraints];
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.needRefreshBTN = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.needShowErrorView = YES;
    }
    return _tableView;
}

- (BOOL)needLogin {
    return NO;
}

@end

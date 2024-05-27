//
//  WMCNStoreDetailOrderFoodView.m
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCNStoreDetailOrderFoodView.h"
#import "SATableView.h"
#import "WMCNStoreDetailOrderFoodCateCell.h"
#import "WMShoppingGoodTableViewCell.h"
#import "WMStoreDetailViewModel.h"
#import "WMZPageDataView.h"
#import "WMZPageProtocol.h"


@interface WMCNStoreDetailOrderFoodView () <WMZPageProtocol>

@end


@implementation WMCNStoreDetailOrderFoodView

- (void)hd_setupViews {
    self.sortSelectIndex = NSNotFound;
    [self addSubview:self.sortTableView];
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.sortTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sortTableView.isHidden) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kRealWidth(88));
        }
    }];

    if (self.limitTipsView && [self.subviews containsObject:self.limitTipsView]) {
        [self.limitTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.limitTipsView.isHidden) {
                make.top.mas_equalTo(0);
                make.left.right.equalTo(self.tableView);
            }
        }];
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.limitTipsView && !self.limitTipsView.isHidden) {
            make.top.equalTo(self.limitTipsView.mas_bottom);
        } else {
            make.top.mas_equalTo(0);
        }
        make.bottom.right.mas_equalTo(0);
        if (self.sortTableView.isHidden) {
            make.left.mas_equalTo(0);
        } else {
            make.left.equalTo(self.sortTableView.mas_right);
        }
    }];
}

- (NSArray<UIScrollView *> *)getMyScrollViews {
    return @[self.sortTableView, self.tableView];
}

- (SATableView *)sortTableView {
    if (!_sortTableView) {
        _sortTableView = [[SATableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _sortTableView.needRefreshFooter = NO;
        _sortTableView.needRefreshHeader = NO;
        _sortTableView.needShowNoDataView = NO;
        _sortTableView.needShowErrorView = NO;
        _sortTableView.scrollsToTop = NO;
        _sortTableView.tag = 22222;
        _sortTableView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _sortTableView;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.tag = 11111;
        _tableView.needShowNoDataView = NO;
        _tableView.needShowErrorView = NO;
        _tableView.scrollsToTop = NO;
        _tableView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _tableView;
}

@end

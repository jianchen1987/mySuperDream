//
//  WMSelectCouponsView.m
//  SuperApp
//
//  Created by wmz on 2022/7/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSelectCouponsView.h"
#import "WMSelectCouponsCell.h"


@interface WMSelectCouponsView () <GNTableViewProtocol>

@end


@implementation WMSelectCouponsView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bgGray;
    [self addSubview:self.tableView];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.tableView.GNdelegate = self;
    if (dataSource) {
        [self.tableView reloadData:NO];
        ///查找是否有选中的
        NSArray *selectArr = [dataSource hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *item) {
            return item.isSelected;
        }];
        if (!HDIsArrayEmpty(selectArr)) {
            [self.tableView layoutIfNeeded];
            NSInteger index = [dataSource indexOfObject:selectArr.firstObject];
            if (index != NSNotFound && [self.tableView numberOfRowsInSection:0] > index) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    } else {
        [self.tableView reloadFail];
    }
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
    }];
    [super updateConstraints];
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    WMOrderSubmitCouponModel *model = (id)rowData;
    if ([model isKindOfClass:WMOrderSubmitCouponModel.class] && [model.usable isEqualToString:SABoolValueTrue]) {
        [GNEvent eventResponder:self target:tableView key:@"selcctCouponAction" indexPath:indexPath info:@{@"data": model}];
    }
}

- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

- (Class)classOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return WMSelectCouponsCell.class;
}

- (BOOL)xibOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.estimatedRowHeight = 0.01;
        _tableView.delegate = _tableView.provider;
        _tableView.dataSource = _tableView.provider;
        _tableView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _tableView;
}

@end

//
//  TNMicroShopLeftCategoryView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopLeftCategoryView.h"
#import "TNCategoryLeftTableViewCell.h"


@interface TNMicroShopLeftCategoryView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end


@implementation TNMicroShopLeftCategoryView

- (void)hd_setupViews {
    self.backgroundColor = HexColor(0xF7F7F9);
    [self addSubview:self.tableView];
}
- (void)setDataArr:(NSArray<TNFirstLevelCategoryModel *> *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryLeftTableViewCell *cell = [TNCategoryLeftTableViewCell cellWithTableView:tableView];
    TNFirstLevelCategoryModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TNFirstLevelCategoryModel *model = self.dataArr[indexPath.row];
    if (model.isSelected == true) {
        return;
    }
    model.isSelected = !model.isSelected;
    for (TNFirstLevelCategoryModel *fModel in self.dataArr) {
        if (model != fModel) {
            fModel.isSelected = false;
        }
    }
    [self.tableView reloadData];

    !self.categoryClickCallBack ?: self.categoryClickCallBack(model);
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        _tableView.rowHeight = kRealWidth(60);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = HexColor(0xF7F7F9);
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
@end

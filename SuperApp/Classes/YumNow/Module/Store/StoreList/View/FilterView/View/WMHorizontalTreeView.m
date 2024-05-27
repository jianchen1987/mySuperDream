//
//  WMHorizontalTreeView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMHorizontalTreeView.h"

static NSString *const kMainListTableCellReuseIdentifier = @"kMainListTableCellReuseIdentifier";
static NSString *const kSubListTableCellReuseIdentifier = @"kSubListTableCellReuseIdentifier";


@interface WMHorizontalTreeView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) HDUIButton *confirmBTN;
@property (nonatomic, strong) UITableView *mainTableView;                                  ///< 主
@property (nonatomic, strong) UITableView *subTableView;                                   ///< 子
@property (nonatomic, copy) NSArray<WMStoreFilterTableViewCellBaseModel *> *subDataSource; ///< 数据源
/// 最后一个子选择
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *lastSelectSubModel;

@end


@implementation WMHorizontalTreeView

- (instancetype)initWithDataSource:(NSArray<WMStoreFilterTableViewCellModel *> *)dataSource {
    if (self = [super init]) {
        self.dataSource = dataSource;
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.mainTableView];
    if (self.shouldAddSubTableView) {
        [self addSubview:self.subTableView];
    }
}

- (void)updateConstraints {
    if (!_subTableView) {
        if (self.oneNest) {
            [self addSubview:self.confirmBTN];
            [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kRealWidth(15));
                make.right.mas_equalTo(kRealWidth(-15));
                make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight - kRealWidth(10));
                make.height.mas_equalTo(kRealWidth(45));
            }];

            [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.width.equalTo(self);
                make.bottom.equalTo(self.confirmBTN.mas_top).offset(kRealWidth(-10));
            }];
        } else {
            [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.left.top.bottom.equalTo(self);
            }];
        }
    } else {
        [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            if (self.maxWidth) {
                make.width.mas_equalTo(self.maxWidth);
            } else {
                make.width.equalTo(self).multipliedBy(0.35);
            }
        }];

        [self.subTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTableView.mas_right);
            make.right.top.bottom.equalTo(self);
        }];
    }

    [super updateConstraints];
}

#pragma mark - private methods
- (BOOL)shouldAddSubTableView {
    BOOL ret = false;
    for (WMStoreFilterTableViewCellModel *model in self.dataSource) {
        if (model.subArrList.count > 0) {
            ret = true;
            break;
        }
    }
    return ret;
}

/// 选中目标 TableView 的 model.isSelected 行 cell，如果不存在则选中第一行
/// @param tableView 目标 TableView
/// @param dataSource 目标 TableView 数据源
- (void)selectCellForTableView:(UITableView *)tableView dataSource:(NSArray *)dataSource {
    if (dataSource.count <= 0 || !tableView)
        return;

    // 主动选择
    id selectedCellModel = dataSource.firstObject;
    for (WMStoreFilterTableViewCellBaseModel *model in dataSource) {
        if (model.isSelected) {
            selectedCellModel = model;
            break;
        }
    }

    // 获取选中的索引
    NSUInteger index = [dataSource indexOfObject:selectedCellModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    if (index < dataSource.count) {
        [tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - getters and setters
- (void)setDataSource:(NSArray<WMStoreFilterTableViewCellModel *> *)dataSource {
    _dataSource = dataSource;

    if (self.dataSource.count <= 0)
        return;

    [self.mainTableView reloadData];

    if (self.shouldAddSubTableView) {
        [self addSubview:self.subTableView];

        self.subDataSource = nil;
        [self.subTableView reloadData];

        // 主动选择 mainTableView
        [self selectCellForTableView:self.mainTableView dataSource:self.dataSource];

        // 主动选择 subTableView
        [self selectCellForTableView:self.subTableView dataSource:self.subDataSource];
    } else {
        [self.subTableView removeFromSuperview];
        self.subDataSource = nil;
        self.subTableView = nil;

        // 主动选择 mainTableView
        [self selectCellForTableView:self.mainTableView dataSource:self.dataSource];
    }

    if (self.shouldAddSubTableView) {
        _mainTableView.backgroundColor = HDAppTheme.color.G5;
        _mainTableView.backgroundView.backgroundColor = HDAppTheme.color.G5;
    }
}

- (WMStoreFilterTableViewCellBaseModel *)selectedSubCellModel {
    WMStoreFilterTableViewCellBaseModel *model;
    if (_subTableView) {
        for (WMStoreFilterTableViewCellModel *cellModel in self.subDataSource) {
            if (cellModel.isSelected) {
                model = cellModel;
                break;
            }
        }
    } else {
        for (WMStoreFilterTableViewCellBaseModel *cellModel in self.dataSource) {
            if (cellModel.isSelected) {
                model = cellModel;
                break;
            }
        }
    }

    return model;
}

- (WMStoreFilterTableViewCellBaseModel *)selectedMainCellModel {
    WMStoreFilterTableViewCellBaseModel *model;
    for (WMStoreFilterTableViewCellBaseModel *cellModel in self.dataSource) {
        if (cellModel.isSelected) {
            model = cellModel;
            break;
        }
    }
    return model;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return self.dataSource.count;
    } else if (tableView == self.subTableView) {
        return self.subDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMStoreFilterTableViewCell *cell = nil;
    if (tableView == self.mainTableView) {
        cell = [WMStoreFilterTableViewCell cellWithTableView:tableView identifier:kMainListTableCellReuseIdentifier];
        WMStoreFilterTableViewCellModel *model = self.dataSource[indexPath.row];
        model.indexPath = indexPath;
        model.isMain = true;
        if (!self.shouldAddSubTableView) {
            model.needBottomLine = indexPath.row < self.dataSource.count - 1;
        }
        cell.model = model;
    } else if (tableView == self.subTableView) {
        cell = [WMStoreFilterTableViewCell cellWithTableView:tableView identifier:kSubListTableCellReuseIdentifier];
        WMStoreFilterTableViewCellBaseModel *model = self.subDataSource[indexPath.row];
        model.needTopLine = false;
        model.indexPath = indexPath;
        model.needBottomLine = false;
        cell.model = model;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        WMStoreFilterTableViewCellModel *model = self.dataSource[indexPath.row];
        if (self.oneNest) {
            if (!model.canSelect)
                return;
            model.selected = YES;
        } else {
            model.selected = YES;
        }

        if (_subTableView) {
            self.subDataSource = model.subArrList.copy;

            [self.subTableView reloadData];
            [self.subTableView setNeedsLayout];
            [self.subTableView layoutIfNeeded];

            !self.didSelectMainTableViewRowAtIndexPath ?: self.didSelectMainTableViewRowAtIndexPath(model, indexPath);
        } else {
            if (!self.oneNest) {
                // 没有二级表单直接当条件回传
                !self.didSelectSubTableViewRowAtIndexPath ?: self.didSelectSubTableViewRowAtIndexPath(model, indexPath);
            }
        }
    } else if (tableView == self.subTableView) {
        self.lastSelectSubModel.selected = false;
        WMStoreFilterTableViewCellBaseModel *model = self.subDataSource[indexPath.row];
        self.lastSelectSubModel = model;
        [self.subDataSource enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellBaseModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.selected = (idx == indexPath.row);
        }];
        !self.didSelectSubTableViewRowAtIndexPath ?: self.didSelectSubTableViewRowAtIndexPath(model, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        WMStoreFilterTableViewCellModel *model = self.dataSource[indexPath.row];
        model.selected = false;
        [self.mainTableView reloadData];
    } else if (tableView == self.subTableView) {
        WMStoreFilterTableViewCellBaseModel *model = self.subDataSource[indexPath.row];
        model.selected = false;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        if (self.oneNest) {
            return self.cellHeight;
        }
    }
    return self.cellHeight ?: UITableViewAutomaticDimension;
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self.mainTableView setNeedsLayout];
    [self.mainTableView layoutIfNeeded];

    if (_subTableView) {
        [self.subTableView setNeedsLayout];
        [self.subTableView layoutIfNeeded];
    }

    CGFloat mainTableViewContentSizeHeight = self.mainTableView.contentSize.height;

    if (_subTableView) {
        CGFloat subTableViewContentSizeHeight = self.subTableView.contentSize.height;
        mainTableViewContentSizeHeight = MAX(mainTableViewContentSizeHeight, subTableViewContentSizeHeight);
    }

    mainTableViewContentSizeHeight = mainTableViewContentSizeHeight < self.minHeight ? self.minHeight : mainTableViewContentSizeHeight;
    mainTableViewContentSizeHeight = mainTableViewContentSizeHeight > self.maxHeight ? self.maxHeight : mainTableViewContentSizeHeight;

    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), mainTableViewContentSizeHeight);
    self.mainTableViewContentSizeHeight = mainTableViewContentSizeHeight;
}

#pragma mark - lazy load
- (UITableView *)setPropertiesForTableView:(UITableView *)tableView {
    // 以下三项是适配iOS 11刷新时会漂移的情况
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = false;
    tableView.showsHorizontalScrollIndicator = false;
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = 0;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN)];
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.backgroundView.backgroundColor = UIColor.whiteColor;
    tableView.allowsSelection = true;
    tableView.allowsMultipleSelection = false;
    return tableView;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        [self setPropertiesForTableView:_mainTableView];
        [_mainTableView registerClass:WMStoreFilterTableViewCell.class forCellReuseIdentifier:kMainListTableCellReuseIdentifier];
    }
    return _mainTableView;
}

- (UITableView *)subTableView {
    if (!_subTableView) {
        _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        [self setPropertiesForTableView:_subTableView];
        [_subTableView registerClass:WMStoreFilterTableViewCell.class forCellReuseIdentifier:kSubListTableCellReuseIdentifier];
    }
    return _subTableView;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        _confirmBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:17];
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBTN setTitle:SALocalizedString(@"complete", @"完成") forState:UIControlStateNormal];
        @HDWeakify(self)[_confirmBTN addEventHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) !self.didSelectMainTableViewRowAtIndexPath ?: self.didSelectMainTableViewRowAtIndexPath((id)self.selectedMainCellModel, self.selectedMainCellModel.indexPath);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBTN;
}

@end

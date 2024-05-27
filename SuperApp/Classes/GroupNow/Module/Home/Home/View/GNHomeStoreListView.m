//
//  GNHomeStoreListView.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNHomeStoreListView.h"
#import "GNFilterView.h"
#import "WMZPageProtocol.h"


@interface GNHomeStoreListView () <WMZPageProtocol> {
    CGFloat _startOffsetY;
}
/// tableView
@property (nonatomic, strong, readwrite) GNTableView *tableView;
/// viewModel
@property (nonatomic, strong, readwrite) GNHomeCustomViewModel *viewModel;

@end


@implementation GNHomeStoreListView

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
}

- (void)pageViewDidAppear {
    if (!self.sectionModel.rows.count && self.updateMenuList) {
        self.tableView.pageNum = 1;
        [self gn_getNewData];
    }
}

- (void)gn_getNewData {
    @HDWeakify(self);
    [self.viewModel getColumnStoreDataCode:self.columnCode columnType:self.columnType pageNum:self.tableView.pageNum completion:^(GNStorePagingRspModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        if (!error) {
            if (self.tableView.pageNum > 1) {
                [self.sectionModel.rows addObjectsFromArray:rspModel.list ?: @[]];
            } else {
                self.sectionModel.rows = [NSMutableArray arrayWithArray:rspModel.list ?: @[]];
            }
        }
        self.tableView.GNdelegate = self;
        !error ? [self.tableView reloadData:!rspModel.hasNextPage] : [self.tableView reloadFail];
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tableView.delegate = self.tableView.provider;
            self.tableView.dataSource = self.tableView.provider;
            [self.tableView reloadData];
        }
        [self gn_getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self gn_getNewData];
    };
    self.tableView.delegate = self.tableView.provider;
    self.tableView.dataSource = self.tableView.provider;
}

- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.safeBottom ? -kTabBarH : 0);
    }];
    [super updateConstraints];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///刷新
    if ([event.key isEqualToString:@"reloadAction"]) {
        [self.tableView reloadData];
    }
}

#pragma mark GNTableViewProtocol
- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return @[self.sectionModel];
}

- (UIView *)GNTableView:(GNTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.filterBarView;
}

#pragma mark GNPageProtocol
- (UIScrollView *)getMyScrollView {
    return self.tableView;
}

#pragma mark lazy
- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.needRefreshFooter = true;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [GNStoreViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [GNStoreViewCell skeletonViewHeight];
        }];
        _tableView.customPlaceHolder = ^(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError) {
            if (!showError) {
                placeholderViewModel.title = GNLocalizedString(@"gn_no_content", @"这里没有内容哦！到别处逛逛？");
                placeholderViewModel.titleFont = [HDAppTheme.font gn_ForSize:12];
                placeholderViewModel.titleColor = HDAppTheme.color.gn_333Color;
                placeholderViewModel.image = @"gn_home_blank_data";
            }
        };
    }
    return _tableView;
}

- (GNSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = GNSectionModel.new;
        _sectionModel.headerHeight = kRealWidth(45);
    }
    return _sectionModel;
}

- (CGFloat)startOffsetY {
    if (!_startOffsetY) {
        _startOffsetY = kNavigationBarH + kRealWidth(32) + kRealWidth(50);
    }
    return _startOffsetY;
}

- (void)setStartOffsetY:(CGFloat)startOffsetY {
    _startOffsetY = startOffsetY;
    self.filterBarView.startOffsetY = startOffsetY;
}

- (GNFilterView *)filterBarView {
    if (!_filterBarView) {
        _filterBarView = [[GNFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(32)) filterModel:self.viewModel.filterModel startOffsetY:self.startOffsetY];
        @HDWeakify(self);
        _filterBarView.viewWillDisappear = ^(UIView *_Nonnull view) {
            @HDStrongify(self);
            self.tableView.pageNum = 1;
            if (self.tableView.hd_hasData) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            [self gn_getNewData];
        };
    }
    return _filterBarView;
}

- (NSMutableArray<GNStoreCellModel *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.new; });
}

- (GNHomeCustomViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNHomeCustomViewModel.new; });
}

@end

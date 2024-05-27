//
//  GNTableView.m
//  SuperApp
//
//  Created by wGN on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTableView.h"


@implementation GNTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self config];
    }
    return self;
}

- (void)setGNdelegate:(id<GNTableViewProtocol>)GNdelegate {
    _GNdelegate = GNdelegate;
    self.dataSource = self;
    self.delegate = self;
}

- (void)config {
    self.pageNum = 1;
    self.reuse = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.estimatedRowHeight = 44;
    self.rowHeight = UITableViewAutomaticDimension;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.sectionFooterHeight = 0;
    self.sectionHeaderHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    if (@available(iOS 13.0, *)) {
        self.automaticallyAdjustsScrollIndicatorInsets = false;
    }
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
    self.showsHorizontalScrollIndicator = NO;
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}

- (NSInteger)numberOfSectionsInTableView:(GNTableView *)tableView {
    if ([self.GNdelegate respondsToSelector:@selector(numberOfSectionsInGNTableView:)]) {
        self.dataArr = [self.GNdelegate numberOfSectionsInGNTableView:self];
        return self.dataArr.count;
    } else if ([self.GNdelegate respondsToSelector:@selector(numberOfRowsInGNTableView:)]) {
        GNSectionModel *sectionModel = [GNSectionModel new];
        sectionModel.rows = (NSMutableArray *)[self.GNdelegate numberOfRowsInGNTableView:self];
        self.dataArr = @[sectionModel];
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(GNTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<GNRowModelProtocol> model = [self.dataArr[indexPath.section].rows objectAtIndex:indexPath.row];
    SATableViewCell *cell = nil;
    Class cellClass = nil;
    NSString *identifier = nil;
    BOOL xib = NO;
    if ([self.GNdelegate respondsToSelector:@selector(classOfGNTableView:atIndexPath:)]) {
        Class class = [self.GNdelegate classOfGNTableView:tableView atIndexPath:indexPath];
        if (class)
            cellClass = class;
        xib = YES;
    }
    if ([self.GNdelegate respondsToSelector:@selector(xibOfGNTableView:atIndexPath:)]) {
        xib = [self.GNdelegate xibOfGNTableView:tableView atIndexPath:indexPath];
    } else {
        if ([model conformsToProtocol:@protocol(GNRowModelProtocol)]) {
            xib = model.xib;
        }
    }
    if ([model conformsToProtocol:@protocol(GNRowModelProtocol)]) {
        model.indexPath = indexPath;
        if (!cellClass)
            cellClass = model.cellClass;
        if (!cellClass)
            return SATableViewCell.new;
        identifier = NSStringFromClass(cellClass);
        if (!self.reuse) {
            cell = [tableView cellForRowAtIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        if (xib) {
            if (!cell)
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass) owner:nil options:nil] lastObject];
        } else {
            if (!cell)
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.contentView.backgroundColor = model.backgroundColor ?: UIColor.whiteColor;
        cell.selectionStyle = model.selectionStyle;
        cell.accessoryType = model.accessoryType;
        if ([cell respondsToSelector:@selector(setGNCellModel:)])
            [cell setGNCellModel:model];
        if ([cell respondsToSelector:@selector(setGNModel:)])
            [cell setGNModel:model.businessData ?: model];
    } else {
        if (!self.reuse) {
            cell = [tableView cellForRowAtIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        if (xib) {
            if (!cell)
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass) owner:nil options:nil] lastObject];
        } else {
            if (!cell)
                cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        if ([cell respondsToSelector:@selector(setGNModel:)])
            [cell setGNModel:model];
    }
    if (cell && [self.GNdelegate respondsToSelector:@selector(GNTableView:cellRowAtIndexPath:cell:data:)]) {
        [self.GNdelegate GNTableView:self cellRowAtIndexPath:indexPath cell:cell data:model];
    }
    return cell ?: [UITableViewCell new];
}

- (NSInteger)tableView:(nonnull GNTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.dataArr.count > section) ? self.dataArr[section].rows.count : 0;
}

- (CGFloat)tableView:(GNTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = UITableViewAutomaticDimension;
    if (self.dataArr.count <= indexPath.section)
        return height;
    GNSectionModel *section = self.dataArr[indexPath.section];
    if (section.rows.count <= indexPath.row)
        return height;
    id<GNRowModelProtocol> model = [section.rows objectAtIndex:indexPath.row];
    if ([model conformsToProtocol:@protocol(GNRowModelProtocol)]) {
        if (!model.hidden)
            height = model.cellHeight ?: UITableViewAutomaticDimension;
    }
    return height;
}

- (CGFloat)tableView:(GNTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    GNSectionModel *sectionModel = self.dataArr[section];
    if ((sectionModel.headerModel.title && sectionModel.headerModel.title.length) || ![sectionModel.headerClass isEqual:GNTableHeaderFootView.class]) {
        return (sectionModel.headerHeight > 0.01) ? sectionModel.headerHeight : UITableViewAutomaticDimension;
    }
    if (sectionModel.headerHeight == 0.01 && self.style == UITableViewStylePlain)
        return 0;
    return sectionModel.headerHeight;
}

- (CGFloat)tableView:(GNTableView *)tableView heightForFooterInSection:(NSInteger)section {
    GNSectionModel *sectionModel = self.dataArr[section];
    if ((sectionModel.footerModel.title && sectionModel.footerModel.title.length) || ![sectionModel.footerClass isEqual:GNTableHeaderFootView.class]) {
        return sectionModel.footerHeight > 0.01 ? sectionModel.footerHeight : UITableViewAutomaticDimension;
    }
    if (sectionModel.footerHeight == 0.01 && self.style == UITableViewStylePlain)
        return 0;
    return sectionModel.footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    if (self.dataArr.count <= indexPath.section)
        return height;
    GNSectionModel *section = self.dataArr[indexPath.section];
    if (section.rows.count <= indexPath.row)
        return height;
    id<GNRowModelProtocol> model = [section.rows objectAtIndex:indexPath.row];
    if ([model conformsToProtocol:@protocol(GNRowModelProtocol)]) {
        if (model.estimatedHeight)
            height = model.estimatedHeight;
    }
    return height;
}

- (UIView *)tableView:(GNTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.GNdelegate respondsToSelector:@selector(GNTableView:viewForHeaderInSection:)]) {
        return [self.GNdelegate GNTableView:tableView viewForHeaderInSection:section];
    }
    GNSectionModel *sectionModel = self.dataArr[section];
    GNTableHeaderFootView *headView = nil;
    if (sectionModel.headerHeight <= 0.01 && !sectionModel.headerModel.title) {
        return headView;
    }
    if (sectionModel.headerXib) {
        headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(sectionModel.headerClass)];
        if (!headView) {
            headView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(sectionModel.headerClass) owner:nil options:nil] lastObject];
        }
    } else {
        headView = [sectionModel.headerClass headerWithTableView:tableView];
    }
    [headView setGNModel:sectionModel.headerModel];
    return headView;
}

- (UIView *)tableView:(GNTableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.GNdelegate respondsToSelector:@selector(GNTableView:viewForFooterInSection:)]) {
        return [self.GNdelegate GNTableView:tableView viewForFooterInSection:section];
    }
    GNSectionModel *sectionModel = self.dataArr[section];
    GNTableHeaderFootView *footerView = nil;
    if (sectionModel.footerHeight <= 0.01 && !sectionModel.footerModel.title && ![sectionModel.footerClass isEqual:GNTableHeaderFootView.class])
        return footerView;
    if (sectionModel.footerXib) {
        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(sectionModel.footerClass)];
        if (!footerView) {
            footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(sectionModel.footerClass) owner:nil options:nil] lastObject];
        }
    } else {
        footerView = [sectionModel.footerClass headerWithTableView:tableView];
    }
    [footerView setGNModel:sectionModel.footerModel];
    return footerView;
}

- (void)tableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.GNdelegate && [self.GNdelegate respondsToSelector:@selector(GNTableView:didSelectRowAtIndexPath:data:)]) {
        [self.GNdelegate GNTableView:self didSelectRowAtIndexPath:indexPath data:[self.dataArr[indexPath.section].rows objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(GNTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    GNSectionModel *section = nil;
    id<GNRowModelProtocol> model = nil;
    if (self.dataArr.count > indexPath.section)
        section = self.dataArr[indexPath.section];
    if (!section)
        return;
    if (section.rows.count > indexPath.row) {
        model = section.rows[indexPath.row];
    }
    if (!model)
        return;
    if ([model conformsToProtocol:@protocol(GNRowModelProtocol)]) {
        if (!model.isNotCacheheight)
            model.cellHeight = cell.frame.size.height;
        if (section.cornerRadios) {
            CGFloat cornerRadius = section.cornerRadios;
            CGRect bounds = cell.bounds;
            NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
            UIView *headerView;
            if ([self respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
                headerView = [self tableView:tableView viewForHeaderInSection:indexPath.section];
            }
            UIBezierPath *bezierPath = nil;
            if (headerView) {
                if (indexPath.row == 0 && numberOfRows == 1) {
                    bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                             cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                } else if (indexPath.row == numberOfRows - 1) {
                    bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                             cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                } else {
                    bezierPath = [UIBezierPath bezierPathWithRect:bounds];
                }
            } else {
                if (numberOfRows == 1) {
                    bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                } else if (numberOfRows > 1) {
                    if (indexPath.row == 0) {
                        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                    } else if (indexPath.row == numberOfRows - 1) {
                        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                 cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
                    } else {
                        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
                    }
                } else {
                    bezierPath = [UIBezierPath bezierPathWithRect:bounds];
                }
            }
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = bezierPath.CGPath;
            cell.layer.mask = layer;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    GNSectionModel *sectionModel = nil;
    if (self.dataArr.count > section)
        sectionModel = self.dataArr[section];
    if (!sectionModel)
        return;
    if (sectionModel.cornerRadios) {
        CGFloat cornerRadius = sectionModel.cornerRadios;
        CGRect bounds = view.bounds;
        UIBezierPath *bezierPath = nil;
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        view.layer.mask = layer;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.GNdelegate && [self.GNdelegate respondsToSelector:@selector(GNTableView:editRowAtIndexPath:data:)]) {
        [self.GNdelegate GNTableView:self editRowAtIndexPath:indexPath data:[self.dataArr[indexPath.section].rows objectAtIndex:indexPath.row]];
    }
    [self.dataArr[indexPath.section].rows removeObjectAtIndex:indexPath.row];
    [self reloadData:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.GNdelegate && [self.GNdelegate respondsToSelector:@selector(gnScrollViewDidScroll:)]) {
        [self.GNdelegate gnScrollViewDidScroll:scrollView];
    }
    if (self.topSop && scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.click = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.click = NO;
}

- (void)hd_languageDidChanged {
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.mj_header;
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_NORMAL", @"下拉刷新") forState:MJRefreshStateIdle];
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_PULLING", @"放开刷新") forState:MJRefreshStatePulling];
    [head setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];
    MJRefreshBackNormalFooter *foot = (MJRefreshBackNormalFooter *)self.mj_footer;
    [foot setTitle:SALocalizedString(@"MJ_STATE_UP_NORMAL", @"上拉或者点击加载更多") forState:MJRefreshStateIdle];
    [foot setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];
    [foot setTitle:@"——  END LINE  ——" forState:MJRefreshStateNoMoreData];
    [foot setTitle:SALocalizedString(@"MJ_STATE_UP_RELEASE_TO_LOAD_MORE", @"松开立即加载更多") forState:MJRefreshStatePulling];
}

- (void)getNewData {
    if (self.needRefreshHeader) {
        [self setContentOffset:CGPointMake(0.0, -self.contentInset.top) animated:NO];
        // 如果当前正在刷新，结束刷新
        BOOL isRefreshing = self.mj_header.state == MJRefreshStateRefreshing;
        if (isRefreshing) {
            [self.mj_header endRefreshing];
            [self.mj_header beginRefreshing];
        } else {
            [self.mj_header beginRefreshing];
        }
    }
}

- (void)setNeedRefreshHeader:(BOOL)needRefreshHeader {
    _needRefreshHeader = needRefreshHeader;
    if (needRefreshHeader) {
        @HDWeakify(self) self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @HDStrongify(self) self.pageNum = 1;
            if (self.requestNewDataHandler)
                self.requestNewDataHandler();
        }];
        [self hd_languageDidChanged];
    } else {
        self.mj_header = nil;
    }
}

- (void)setNeedRefreshFooter:(BOOL)needRefreshFooter {
    _needRefreshFooter = needRefreshFooter;
    if (needRefreshFooter) {
        //        @HDWeakify(self) self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @HDWeakify(self) self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @HDStrongify(self) if (!self.pageNum) self.pageNum = 1;
            self.pageNum += 1;
            if (self.requestMoreDataHandler)
                self.requestMoreDataHandler();
        }];
        [self hd_languageDidChanged];
    } else {
        self.mj_footer = nil;
    }
}

- (void)reloadData:(BOOL)isNoMore needEndHeadRefresh:(BOOL)needEndHeadRefresh {
    [self reloadData];
    if (self.needShowErrorView || self.needShowNoDataView)
        [self hd_removePlaceholderView];
    [self hd_removePlaceholderView];
    if (self.pageNum == 1) {
        if (self.needRefreshFooter) {
            [self.mj_footer resetNoMoreData];
            if (isNoMore) {
                [self.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.mj_footer endRefreshing];
            }
        }
        if (self.needRefreshHeader && self.mj_header.isRefreshing && needEndHeadRefresh)
            [self.mj_header endRefreshing];
    } else {
        if (self.needRefreshFooter) {
            if (isNoMore && self.mj_footer.isRefreshing) {
                [self.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.mj_footer endRefreshing];
            }
        }
    }
    [self showOrHideNoDataPlacholderView];
}

- (void)reloadData:(BOOL)isNoMore {
    [self reloadData:isNoMore needEndHeadRefresh:YES];
}

- (void)reloadFail {
    if (self.needShowErrorView || self.needShowNoDataView)
        [self hd_removePlaceholderView];
    if (self.needRefreshHeader && self.mj_header.isRefreshing)
        [self.mj_header endRefreshing];
    if (self.needRefreshFooter && self.mj_footer.isRefreshing)
        [self.mj_footer endRefreshing];
    [self reloadData];
    [self showOrHideNetworkErrorPlacholderView];
}

- (void)showOrHideNoDataPlacholderView {
    if (self.needShowNoDataView && !self.hd_hasData) {
        self.mj_header.hidden = self.needRefreshBTN;
        self.mj_footer.hidden = YES;
        self.placeholderViewModel.title = SALocalizedString(@"no_data", @"暂无数据");
        self.placeholderViewModel.image = @"no_data_placeholder";
        if (self.customPlaceHolder)
            self.customPlaceHolder(self.placeholderViewModel, NO);
        [self hd_showPlaceholderViewWithModel:self.placeholderViewModel];
    } else {
        self.mj_header.hidden = NO;
        self.mj_footer.hidden = NO;
        [self hd_removePlaceholderView];
    }
}

- (void)showOrHideNetworkErrorPlacholderView {
    if (self.needShowErrorView && !self.hd_hasData) {
        self.mj_header.hidden = self.needRefreshBTN;
        self.mj_footer.hidden = YES;
        self.placeholderViewModel.image = @"placeholder_network_error";
        self.placeholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
        if (self.customPlaceHolder)
            self.customPlaceHolder(self.placeholderViewModel, YES);
        [self hd_showPlaceholderViewWithModel:self.placeholderViewModel];
    } else {
        [self hd_removePlaceholderView];
        self.mj_header.hidden = NO;
        self.mj_footer.hidden = NO;
    }
}

- (void)showErrorPlacholderView {
    if (self.customPlaceHolder)
        self.customPlaceHolder(self.placeholderViewModel, YES);
    [self hd_showPlaceholderViewWithModel:self.placeholderViewModel];
}

- (UIViewPlaceholderViewModel *)placeholderViewModel {
    if (!_placeholderViewModel) {
        UIViewPlaceholderViewModel *placeholderViewModel = UIViewPlaceholderViewModel.new;
        placeholderViewModel.title = SALocalizedString(@"no_data", @"暂无数据");
        placeholderViewModel.image = @"no_data_placeholder";
        placeholderViewModel.needRefreshBtn = self.needRefreshBTN;
        placeholderViewModel.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");

        @HDWeakify(self) placeholderViewModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self) self.pageNum = 1;
            if (self.tappedRefreshBtnHandler)
                self.tappedRefreshBtnHandler();
        };
        _placeholderViewModel = placeholderViewModel;
    }
    return _placeholderViewModel;
}

- (BOOL)hd_hasData {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++)
            totalCount += [tableView numberOfRowsInSection:section];
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++)
            totalCount += [collectionView numberOfItemsInSection:section];
    }

    return totalCount;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [GNTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [GNTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 20;
    }
    return _provider;
}

- (void)updateUI {
    self.refresh = YES;
    [self reloadData];
}

- (void)updateCell:(nullable NSIndexPath *)indexPath {
    //    [UIView setAnimationsEnabled:NO];
    [self reloadData];
    //    [UIView setAnimationsEnabled:YES];
}

@end

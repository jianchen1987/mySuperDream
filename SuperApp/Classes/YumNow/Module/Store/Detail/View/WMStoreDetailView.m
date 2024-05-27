//
//  WMStoreDetailView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailView.h"


@interface WMStoreDetailView () <UITableViewDelegate, UITableViewDataSource, HDCategoryViewDelegate, HDCategoryTitleViewDataSource>
/// 分类 headerView
@property (nonatomic, strong) UIView *categoryTitleContainerHeaderView;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *pinCategoryView;

@end


@implementation WMStoreDetailView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self setUpTableView];
    [self addSubview:self.zoomableImageV];
    [self addSubview:self.tableView];
    [self addSubview:self.customNavigationBar];
    [super hd_setupViews];
}

- (void)setUpTableView {
    SATableView *_tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.needRefreshHeader = false;
    _tableView.needRefreshFooter = false;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kShoppingGoodTableViewCellSize + kShoppingGoodTableViewCellTopMargin + kShoppingGoodTableViewCellBottomMargin;
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.backgroundView.backgroundColor = UIColor.clearColor;
    _tableView.userInteractionEnabled = false;
    _tableView.dataSource = self.provider;
    _tableView.delegate = self.provider;
    _tableView.contentInset = UIEdgeInsetsMake(kTableViewContentInsetTop, 0, 0, 0);
    _tableView.hd_ignoreSpace = [[UIScrollViewIgnoreSpaceModel alloc] initWithMinX:0 maxX:0 minY:kTableViewContentInsetTop maxY:0];
    [_tableView setContentOffset:CGPointMake(0, -kTableViewContentInsetTop) animated:false];
    self.tableView = _tableView;
}

- (void)reloadTableViewAndTableHeaderView {
    [self.customNavigationBar showOrHiddenFunctionBTN:!self.viewModel.isStoreClosed];
    [self.customNavigationBar updateTitle:self.viewModel.detailInfoModel.storeName.desc];

    // 启用交互
    self.tableView.userInteractionEnabled = !self.viewModel.isStoreClosed;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (!self.viewModel.productId) {
        [self scrollViewDidScroll:self.tableView];
    }

    NSArray<NSString *> *titleArray = [self.viewModel.menuList mapObjectsUsingBlock:^id _Nonnull(WMStoreMenuItem *_Nonnull obj, NSUInteger idx) {
        return obj.name;
    }];
    self.pinCategoryView.titles = titleArray;
    [self.pinCategoryView reloadDataWithoutListContainer];

    self.dataSource = self.viewModel.dataSource;
    [self.tableView successGetNewDataWithNoMoreData:true];

    [HDWebImageManager setImageWithURL:self.viewModel.isStoreClosed ? nil : self.viewModel.detailInfoModel.photo
                      placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kScreenWidth * 0.4)]
                             imageView:self.zoomableImageV];
    self.shoppingCartDockView.hidden = self.viewModel.isStoreClosed;
    [self dealEventWithBottom];
    if (!self.shoppingCartDockView.isHidden && HDIsStringNotEmpty(self.viewModel.onceAgainOrderNo) && self.viewModel.payFeeTrialCalRspModel) {
        self.viewModel.onceAgainOrderNo = nil;
        !self.shoppingCartDockView.clickedStoreCartDockBlock ?: self.shoppingCartDockView.clickedStoreCartDockBlock();
    }
    [self setNeedsUpdateConstraints];

    if (self.viewModel.isStoreClosed && self.viewModel.isFromOnceAgain) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"store_stopped", @"The store have stopped operation.") type:HDTopToastTypeError];
    }
}

- (void)reloadFirstGoodsTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView successGetNewDataWithNoMoreData:true];
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)itemIndex {
    [self loadGoodsByScrollerIndex:itemIndex isClickIndex:true loadTop:false loadDown:false isNeedFixContentOffset:false]; //按钮点击的话   就直接中间截取
}

- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return 0;
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;
    id model = sectionModel.list[indexPath.row];
    return [self setUpModel:model tableView:tableView indexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return nil;
    if (section == kPinSectionIndex) {
        if (self.viewModel.isValidMenuListEmpty)
            return nil;

        WMStoreDetailCategoryTitleContainerHeaderView *headerView = [WMStoreDetailCategoryTitleContainerHeaderView headerWithTableView:tableView];
        self.categoryTitleContainerHeaderView = headerView;
        if (self.pinCategoryView.superview == nil) {
            // 首次使用 WMStoreDetailCategoryTitleContainerHeaderView 的时候，把 pinCategoryView 添加到它上面
            self.pinCategoryView.top = kPinCategoryViewTop;
            [headerView addSubview:self.pinCategoryView];
        }
        if (self.viewModel.hasBestSaleMenu) {
            self.limitTipsView.top = kPinCategoryViewTop + kStoreDetailCategoryTitleViewHeight + kRealWidth(10);
            [headerView addSubview:self.limitTipsView];
        }
        headerView.contentView.backgroundColor = HDAppTheme.WMColor.bgGray;
        return headerView;
    }

    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (section <= 0 || sectionModel.list.count <= 0 || HDIsStringEmpty(sectionModel.headerModel.title))
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return CGFLOAT_MIN;
    if (section == kPinSectionIndex) {
        if (self.viewModel.isValidMenuListEmpty)
            return CGFLOAT_MIN;
        CGFloat height = kStoreDetailCategoryTitleViewHeight + kPinCategoryViewTop;
        if (self.viewModel.hasBestSaleMenu) {
            self.limitTipsLabel.text = self.viewModel.availableBestSaleCount == 0 ?
                                           WMLocalizedString(@"9MVBO0bU", @"今日活动次数已用完，可按原价购买。") :
                                           [NSString stringWithFormat:WMLocalizedString(@"KuVJaYjS", @"今日可购买%zd件特价商品"), self.viewModel.availableBestSaleCount];
            CGSize size = [self.limitTipsView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            self.limitTipsView.size = size;
            height += (size.height + kRealWidth(20));
        }
        return height;
    }

    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (section <= 0 || sectionModel.list.count <= 0 || HDIsStringEmpty(sectionModel.headerModel.title))
        return CGFLOAT_MIN;

    CGFloat height = [sectionModel.headerModel.title boundingAllRectWithSize:CGSizeMake(kScreenWidth - UIEdgeInsetsGetHorizontalValue(sectionModel.headerModel.edgeInsets), MAXFLOAT)
                                                                        font:sectionModel.headerModel.titleFont]
                         .height;
    return MAX(kRealWidth(46), height + kRealWidth(15));
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    if (self.dataSource.count > indexPath.section) {
        HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
        if (sectionModel.list.count > indexPath.row) {
            id model = sectionModel.list[indexPath.row];
            if ([model isKindOfClass:WMStoreGoodsItem.class]) {
                WMStoreGoodsItem *item = model;
                if (!item.goodId && !item.menuId) {
                    [cell hd_beginSkeletonAnimation];
                }
            }
            [self cellWilldisplayTbleView:tableView indexPath:indexPath model:model];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = true;
    if (self.tableView.dataSource != self || self.viewModel.isStoreClosed)
        return;
    // 放大 imageView 及其蒙版
    CGRect newFrame = self.zoomableImageV.frame;
    CGFloat settingViewOffsetY = kZoomImageViewHeight - scrollView.contentOffset.y;
    newFrame.size.height = settingViewOffsetY;
    if (settingViewOffsetY < kZoomImageViewHeight) {
        newFrame.size.height = kZoomImageViewHeight;
    }

    self.zoomableImageV.frame = newFrame;

    // 更新导航栏
    [self.customNavigationBar updateUIWithScrollViewOffsetY:scrollView.contentOffset.y + scrollView.contentInset.top];
    if (!self.viewModel.isValidMenuListEmpty) {
        [self handlerPinCategoryViewSuperViewWithScrollView:scrollView];
        [self handlerSrollNavBarWithScrollView:scrollView];
    }
    
    if(self.viewModel.detailInfoModel.videoUrls.count) {
        CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
        if (self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused || self.player.floatSmallViewController.isAppeared) {
            if (self.playerMaxY <= 0) {
                self.playerMaxY = CGRectGetMaxY(self.player.presentView.frame);
            }
            if (offsetY > self.playerMaxY) {
                CGPoint scrollVelocity = [scrollView.panGestureRecognizer translationInView:self];
                if (!self.player.floatSmallViewController.isAppeared && !self.player.isFitOnScreen && scrollVelocity.y < 0 && !self.player.isFitOnScreen) { //大屏和向上滑都不触发显示小屏
                    [self.player.floatSmallViewController showFloatView];
                }
                if (self.player.isPlaying) {
                    [self.player pauseForUser];
                }
                
            } else {
                if (self.player.floatSmallViewController.isAppeared) {
                    [self.player.floatSmallViewController dismissFloatView];
                }
            }
        }
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    scrollView.isScrolling = false;
}

#pragma mark - private methods
/// 根据 UIScrollView 偏移量决定 pinCategoryView 父控件是哪一个
/// @param scrollView UIScrollView 对象
- (void)handlerPinCategoryViewSuperViewWithScrollView:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;

    if (self.tableView.numberOfSections <= kPinSectionIndex)
        return;
    CGRect sectionHeaderRect = [self.tableView rectForSection:kPinSectionIndex];
    self.pinCategoryView.backgroundColor = HDAppTheme.WMColor.bgGray;
    if (offsetY >= sectionHeaderRect.origin.y + kPinCategoryViewTop) {
        // 当滚动的 contentOffset.y 大于了指定 sectionHeader 的 y 值，且还没有被添加到 self 上的时候，就需要切换 superView
        self.pinCategoryView.backgroundColor = UIColor.whiteColor;
        if (self.pinCategoryView.superview != self) {
            self.pinCategoryView.top = kNavigationBarH;
            [self insertSubview:self.pinCategoryView belowSubview:self.customNavigationBar];
        }
    } else if (self.pinCategoryView.superview != self.categoryTitleContainerHeaderView) {
        // 当滚动的 contentOffset.y 小于了指定 sectionHeader 的 y 值，且还没有被添加到 categoryTitleContainerHeaderView 上的时候，就需要切换 superView
        self.pinCategoryView.top = kPinCategoryViewTop;
        [self.categoryTitleContainerHeaderView addSubview:self.pinCategoryView];
    }
}

/// 根据 UIScrollView 偏移来滚动到对应标题
/// @param scrollView UIScrollView 对象
- (void)handlerSrollNavBarWithScrollView:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        // HDLog(@"不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理");
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    BOOL isCategoryTitleViewFloating = self.pinCategoryView.superview == self;
    CGFloat visableCellFrameHeight;
    if (isCategoryTitleViewFloating) {
        visableCellFrameHeight = CGRectGetHeight(self.tableView.frame) - kStoreDetailCategoryTitleViewHeight;
    } else {
        visableCellFrameHeight = CGRectGetHeight(self.tableView.frame) - (self.headerCell.height - offsetY);
    }
    CGFloat pointY = offsetY + CGRectGetHeight(self.tableView.frame) - visableCellFrameHeight;
    NSIndexPath *targetPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, pointY)];
    NSInteger targetSection = targetPath.section;
    //    HDLog(@"移动的位置=%@=====section=%ld===row=%ld",targetPath, targetPath.section, targetPath.row);
    CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if (targetPath != nil && targetSection >= kPinSectionBeforeHasIndex) {
        NSInteger goodIndex = targetSection - kPinSectionBeforeHasIndex;
        if (targetSection != self.lastSection) {
            if (vel.y > 5) {
                //向上加载
                [self loadGoodsByScrollerIndex:goodIndex isClickIndex:false loadTop:true loadDown:false isNeedFixContentOffset:false];
            } else if (vel.y < -5) {
                //向下加载
                [self loadGoodsByScrollerIndex:goodIndex isClickIndex:false loadTop:false loadDown:true isNeedFixContentOffset:false];
            }
            self.lastSection = targetSection;
            [self setPinCategoryViewSelectedItem:goodIndex]; //设置偏移量
        } else {
            CGFloat sectionHeaderHeight = [self.tableView.delegate tableView:self.tableView heightForHeaderInSection:targetSection];
            CGFloat sectionOffsetY = offsetY - sectionHeaderHeight - self.headerCell.height;
            //其它情况
            if (vel.y > 5) {
                //向上加载  向上比较特别  如果数据不全 table滚动高度不完整 就可能忽略一些菜单
                if (sectionOffsetY <= self.currentSectionRect.origin.y) {
                    [self loadGoodsByScrollerIndex:goodIndex - 1 isClickIndex:false loadTop:true loadDown:false isNeedFixContentOffset:true];
                    self.currentSectionRect = [self getSectionHeaderPathRect:targetSection]; //保存当前section的header位置
                    return;
                }
            } else if (vel.y < -5) {
                //当前section最后一个row出现的时候判断下个section是否有数据
                if (offsetY + CGRectGetHeight(self.tableView.frame)
                        >= CGRectGetMaxY(self.currentSectionRect) - (kShoppingGoodTableViewCellSize + kShoppingGoodTableViewCellTopMargin + kShoppingGoodTableViewCellBottomMargin)
                    && goodIndex < self.viewModel.menuList.count - 1) { //到最后一组数据就不管了
                    NSInteger nextIndex = goodIndex;
                    while (nextIndex >= 0 && nextIndex < self.viewModel.menuList.count) {
                        HDTableViewSectionModel *sectionModel = self.dataSource[nextIndex + kPinSectionBeforeHasIndex];
                        if (HDIsArrayEmpty(sectionModel.list)) {
                            break;
                        }
                        //如果相隔太多也不用管  等待下一次请求
                        if ((nextIndex - goodIndex) > 2) {
                            break;
                        }
                        nextIndex += 1;
                    }
                    [self loadGoodsByScrollerIndex:nextIndex isClickIndex:false loadTop:false loadDown:true isNeedFixContentOffset:true];
                    [self setPinCategoryViewSelectedItem:goodIndex]; //设置偏移量
                }
            }
        }
        self.currentSectionRect = [self getSectionHeaderPathRect:targetSection]; //保存当前section的header位置
    }
}

///设置菜单栏的选中位置
- (void)setPinCategoryViewSelectedItem:(NSInteger)selectedIndex {
    if (selectedIndex >= 0) {
        if (self.pinCategoryView.selectedIndex != selectedIndex) {
            // 不相同才切换
            [self.pinCategoryView selectItemAtIndex:selectedIndex];
        }
    }
}

- (void)dealingWithAutoScrollToSpecifiedIndexPath {
    if (self.viewModel.isStoreClosed)
        return;
    // 滚动到指定 cell
    NSIndexPath *indexPath = self.viewModel.autoScrolledToIndexPath;
    if (!self.viewModel.hasAutoScrolledToSpecIndexPath && indexPath && self.dataSource.count > indexPath.section && self.dataSource[indexPath.section].list.count > indexPath.row) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 菜单选中
            [self.pinCategoryView selectItemAtIndex:indexPath.section - kPinSectionBeforeHasIndex];

            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];

            // 获取当前 offsetY
            CGFloat offsetY = self.tableView.contentOffset.y;
            [self.tableView setContentOffset:CGPointMake(0, offsetY - kStoreDetailCategoryTitleViewHeight) animated:false];

            self.viewModel.hasAutoScrolledToSpecIndexPath = true;

            WMShoppingGoodTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell flash];
        });
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.customNavigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarH);
        make.left.right.top.equalTo(self);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.shoppingCartDockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(5) - kiPhoneXSeriesSafeBottomHeight);
    }];

    self.tableView.contentInset
    = UIEdgeInsetsMake(self.viewModel.detailInfoModel.videoUrls.count ? 0 : kTableViewContentInsetTop, 0, self.shoppingCartDockView.isHidden ? kiPhoneXSeriesSafeBottomHeight : (self.shoppingCartDockView.hd_height + kRealWidth(25)), 0);

    
    self.tableView.bounces = !self.viewModel.detailInfoModel.videoUrls.count;
    self.zoomableImageV.hidden = self.viewModel.detailInfoModel.videoUrls.count;
    
    [self.storeShoppingCartVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (HDCategoryTitleView *)pinCategoryView {
    if (!_pinCategoryView) {
        _pinCategoryView = HDCategoryTitleView.new;
        _pinCategoryView.averageCellSpacingEnabled = false;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.WMColor.mainRed;
        _pinCategoryView.indicators = @[lineView];
        _pinCategoryView.backgroundColor = HDAppTheme.WMColor.bgGray;
        _pinCategoryView.delegate = self;
        _pinCategoryView.titleDataSource = self;
        _pinCategoryView.frame = CGRectMake(0, 0, kScreenWidth, kStoreDetailCategoryTitleViewHeight);
        _pinCategoryView.titleFont = [HDAppTheme.WMFont wm_ForSize:14];
        _pinCategoryView.titleSelectedFont = [HDAppTheme.WMFont wm_boldForSize:14];
        _pinCategoryView.titleSelectedColor = HDAppTheme.WMColor.mainRed;
        _pinCategoryView.titleColor = HDAppTheme.WMColor.B9;
        _pinCategoryView.titleLabelZoomEnabled = false;

        UIView *sepView = UIView.new;
        sepView.backgroundColor = HDAppTheme.color.G4;
        [_pinCategoryView addSubview:sepView];
        [sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_pinCategoryView);
            make.height.mas_equalTo(PixelOne);
        }];
    }
    return _pinCategoryView;
}

@end

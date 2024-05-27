//
//  WMCNStoreDetailView.m
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCNStoreDetailView.h"
#import "HDMediator+GroupOn.h"
#import "WMCNStoreDetailOrderFoodView.h"
#import "WMStoreInfoViewModel.h"
#import "WMStoreReviewsViewController.h"
#import "WMZPageView+Skeleton.h"
#import "WMZPageView.h"
#import "SJVideoPlayer.h"
#import "HDAppTheme+TinhNow.h"
#import "SJFloatSmallViewController.h"

static SJEdgeControlButtonItemTag WMEdgeControlBottomMuteButtonItemTag = 101; //声音按钮
static SJEdgeControlButtonItemTag WMEdgeControlCenterPlayButtonItemTag = 102; //播放按钮

@interface WMCNStoreDetailView () <UITableViewDataSource, UITableViewDelegate>
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;
///点餐
@property (nonatomic, strong) WMCNStoreDetailOrderFoodView *foodView;
///占位head
@property (nonatomic, strong) UIView *placeholderHead;
/// 初始头部高度
@property (nonatomic, assign) CGFloat originHeadHeight;
/// 滚动到底部
@property (nonatomic, assign) BOOL scrollToBottom;
/// 开始减速
@property (nonatomic, assign) BOOL beganDecelerate;
/// 开始拖动
@property (nonatomic, assign) BOOL beganDrag;
/// infoViewModel
@property (nonatomic, strong) WMStoreInfoViewModel *infoViewModel;
/// 团购
@property (nonatomic, strong) HDUIButton *groupBTN;
/// 展示详情
@property (nonatomic, assign) BOOL showDetail;
/// 手动滚动
@property (nonatomic, assign) BOOL handleScroll;
/// 头部 cell
@property (nonatomic, strong) WMStoreDetailHeaderView *headView;
/// 点菜
@property (nonatomic, strong) WMZPageNaviBtn *menuBTN;
/// storeHeadScroll
@property (nonatomic, strong) WMCNStoreScrollHeadView *storeHeadScroll;
///// 播放器
//@property (strong, nonatomic) SJVideoPlayer *player;
///// 播放器视图的位置  记录一次
//@property (nonatomic, assign) CGFloat playerMaxY;

@end

@implementation WMCNStoreDetailView

- (void)hd_setupViews {
    @HDWeakify(self) self.tableView = self.foodView.tableView;
    WMZPageParam *param = WMZPageParam.new;
    param.wLazyLoading = NO;
    param.wInsertMenuLine = ^(UIView *_Nullable bgView) {
        bgView.backgroundColor = HDAppTheme.WMColor.lineColorE9;
        CGRect rect = bgView.frame;
        rect.size.height = HDAppTheme.WMValue.line;
        bgView.frame = rect;
    };
    param.wTitleArrSet(@[WMLocalizedString(@"", @"点菜"), WMLocalizedString(@"review", @"评价")]);
    param.wMenuImagePosition = PageBtnPositionRight;
    param.wMenuHeight = kRealWidth(40);
    param.wMenuHeadView = ^UIView *_Nullable {
        HDLog(@"重新获取高度");
        @HDStrongify(self)[self.headView layoutIfNeeded];
        self.placeholderHead.frame = CGRectMake(0, 0, kScreenWidth, self.viewModel.detailInfoModel.videoUrls.count ? self.headView.hd_height - kNavigationBarH : self.headView.hd_height);
        self.originHeadHeight = self.placeholderHead.hd_height;
        return self.placeholderHead;
    };
    param.wEventClick = ^(id _Nullable anyID, NSInteger index) {
        @HDStrongify(self) if (index == 0 && [self.menuBTN imageForState:UIControlStateNormal]) {
            [self.pageView.downSc setContentOffset:CGPointZero animated:NO];
            [self.foodView.sortTableView setContentOffset:CGPointZero animated:NO];
            [self.foodView.tableView setContentOffset:CGPointZero animated:NO];
            [self.pageView.downSc setContentOffset:CGPointZero animated:NO];
            [self setPinCategoryViewSelectedItem:0];
        }
    };
    param.wSonScrollCanPull = NO;
    param.wTopSuspensionSet(YES);
    param.wBouncesSet(YES);
    param.wEventEndTransferController = ^(UIViewController *_Nullable oldVC, UIViewController *_Nullable newVC, NSInteger oldIndex, NSInteger newIndex) {
        @HDStrongify(self) self.shoppingCartDockView.alpha = (newIndex == 0);
    };
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        @HDStrongify(self) if (index == 0) {
            return (id)self.foodView;
        }
        else {
            WMStoreReviewsViewController *vc = [[WMStoreReviewsViewController alloc] initWithRouteParameters:@{@"detailModel": self.viewModel.detailInfoModel}];
            return vc;
        }
    };
    [self addSubview:self.zoomableImageV];

    self.pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH) autoFix:NO param:param parentReponder:self.viewController];
    [self addSubview:self.pageView];
    [self addSubview:self.customNavigationBar];

    [super hd_setupViews];
    self.backgroundColor = UIColor.whiteColor;
    self.pageView.downSc.hidden = YES;
    self.pageView.upSc.mainView.hidden = YES;
    self.storeHeadScroll.hidden = YES;

    [self.pageView addSubview:self.storeHeadScroll];
    [self.storeHeadScroll addSubview:self.headView];

    [self.storeHeadScroll mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_lessThanOrEqualTo(kiPhoneXSeriesSafeBottomHeight ? -kiPhoneXSeriesSafeBottomHeight : -20);
    }];

    [self.pageView hd_beginSkeletonAnimation];

    UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:pan];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///展开全部
    if ([event.key isEqualToString:@"expandAction"]) {
        if (event.info[@"expand"]) {
            BOOL expand = [event.info[@"expand"] boolValue];
            if (expand) {
                [self headShowToBottom:YES];
            } else {
                [self headDissmissToTop:YES];
            }
        }
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];
    [self.customNavigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarH);
        make.left.right.top.equalTo(self);
    }];

    [self.shoppingCartDockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(5) - kiPhoneXSeriesSafeBottomHeight);
    }];
}

- (void)reloadTableViewAndTableHeaderView {
    if (!self.viewModel.detailInfoModel && !self.viewModel.isStoreClosed)
        return;
    [self.pageView hd_endSkeletonAnimation];
    self.foodView.sortTableView.hidden = NO;
    if (self.viewModel.isStoreClosed || self.viewModel.isValidMenuListEmpty) {
        self.foodView.sortTableView.hidden = YES;
        [self.foodView setNeedsUpdateConstraints];
    }
    if (self.viewModel.dataSource.count) {
        self.pageView.downSc.hidden = NO;
        self.pageView.upSc.mainView.hidden = NO;
    }
    self.storeHeadScroll.hidden = NO;
    self.showDetail = YES;
    self.groupBTN.hidden = !self.viewModel.detailInfoModel.grouponStoreNo;
    self.tableView.userInteractionEnabled = !self.viewModel.isStoreClosed;
    [self.customNavigationBar showOrHiddenFunctionBTN:!self.viewModel.isStoreClosed];

    [self.foodView addSubview:self.limitTipsView];
    self.foodView.limitTipsView = self.limitTipsView;
    self.limitTipsLabel.hidden = self.limitTipsView.hidden = !self.viewModel.hasBestSaleMenu;
    if (self.viewModel.hasBestSaleMenu) {
        self.limitTipsLabel.text
            = (self.viewModel.availableBestSaleCount == 0 ? WMLocalizedString(@"9MVBO0bU", @"今日活动次数已用完，可按原价购买。") :
                                                            [NSString stringWithFormat:WMLocalizedString(@"KuVJaYjS", @"今日可购买%zd件特价商品"), self.viewModel.availableBestSaleCount]);
    }
    [self.foodView setNeedsUpdateConstraints];
    self.dataSource = self.viewModel.dataSource;
    [self.foodView.sortTableView successGetNewDataWithNoMoreData:YES];
    if (HDIsArrayEmpty(self.viewModel.currentRequestGoods) && !HDIsArrayEmpty(self.viewModel.menuList) && !self.viewModel.isStoreClosed) {
        self.foodView.tableView.delegate = self.goodsProvider;
        self.foodView.tableView.dataSource = self.goodsProvider;
    } else {
        [self.foodView.tableView successGetNewDataWithNoMoreData:YES];
    }

    [self.customNavigationBar updateTitle:self.viewModel.detailInfoModel.storeName.desc];
    [HDWebImageManager setImageWithURL:self.viewModel.isStoreClosed ? nil : self.viewModel.detailInfoModel.photo
                      placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kScreenWidth * 0.4)]
                             imageView:self.zoomableImageV];
    self.shoppingCartDockView.hidden = self.viewModel.isStoreClosed;
    [self dealEventWithBottom];

    if (!self.shoppingCartDockView.isHidden && HDIsStringNotEmpty(self.viewModel.onceAgainOrderNo) && self.viewModel.payFeeTrialCalRspModel) {
        self.viewModel.onceAgainOrderNo = nil;
        !self.shoppingCartDockView.clickedStoreCartDockBlock ?: self.shoppingCartDockView.clickedStoreCartDockBlock();
    }

    if (self.foodView.sortSelectIndex == NSNotFound) {
        self.headView.model = self.viewModel.detailInfoModel;
        if(self.viewModel.detailInfoModel) {
            self.infoViewModel.repModel = self.viewModel.detailInfoModel;
        }
        [self.headView.storeInfoView hd_reloadData];
        [self.foodView.sortTableView layoutIfNeeded];
        if(!self.viewModel.isStoreClosed) {
            [self setPinCategoryViewSelectedItem:0];
        }
        self.pageView.param.wTitleArrSet(@[
            @{WMZPageKeyName: WMLocalizedString(@"", @"点菜"), WMZPageKeyTitleWidth: @(kRealWidth(70))},
            [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"review", @"评价"), self.viewModel.detailInfoModel.reviewCount]
        ]);
        [self.pageView updateTitle];
        [self.pageView updateHeadView];
        self.menuBTN = self.pageView.upSc.mainView.btnArr.firstObject;
        self.pageView.headView.userInteractionEnabled = NO;
        self.pageView.downSc.pointInsideH = self.originHeadHeight;
    }
    [self setNeedsUpdateConstraints];

    if (self.viewModel.isStoreClosed && self.viewModel.isFromOnceAgain) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"store_stopped", @"The store have stopped operation.") type:HDTopToastTypeError];
    }
    self.foodView.tableView.contentInset = self.foodView.sortTableView.contentInset
        = UIEdgeInsetsMake(0, 0, self.shoppingCartDockView.isHidden ? kiPhoneXSeriesSafeBottomHeight : (kScreenHeight - CGRectGetMinY(self.shoppingCartDockView.frame) + kRealWidth(25)), 0);
    //解决视频情况遮挡问题
    
    if(self.viewModel.detailInfoModel.videoUrls.count) {
        HDLog(@"有视频的店铺");
        self.pageView.layer.masksToBounds = NO;
        self.pageView.clipsToBounds = NO;

        [self.storeHeadScroll mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-kNavigationBarH);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(kNavigationBarH);
        }];

        [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(kiPhoneXSeriesSafeBottomHeight ? -kiPhoneXSeriesSafeBottomHeight - kNavigationBarH: -20-kNavigationBarH);
        }];
    }else{
        HDLog(@"没有视频的店铺");
    }
}

- (void)reloadFirstGoodsTableView {
    self.foodView.tableView.delegate = self;
    self.foodView.tableView.dataSource = self;
    [self.foodView.tableView successGetNewDataWithNoMoreData:YES];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow && ![self.pageView.parentResponder isKindOfClass:UIViewController.class]) {
        ///添加购物车
        self.pageView.parentResponder = self.viewController;
        [self.pageView updateMenuData];
        [self.pageView.upSc.mainView addSubview:self.groupBTN];
        [self.groupBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.pageView.upSc.mas_right).offset(-kRealWidth(16));
            make.centerY.equalTo(self.pageView.upSc.mainView);
        }];
        self.pageView.backgroundColor = self.pageView.downSc.backgroundColor = UIColor.clearColor;
        self.pageView.downSc.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.pageView.downSc.dataSource = self;
        self.pageView.downSc.delegate = self;
        [self.pageView.downSc reloadData];

        [self.viewController addChildViewController:self.storeShoppingCartVC];
        [self insertSubview:self.storeShoppingCartVC.view belowSubview:self.shoppingCartDockView];
        [self.storeShoppingCartVC didMoveToParentViewController:self.viewController];
        [self.storeShoppingCartVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.pageView.downSc) {
        [self.pageView performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
        scrollView.isScrolling = true;
        if (self.pageView.downSc.dataSource != self || self.viewModel.isStoreClosed)
            return;
        if (scrollView.contentOffset.y >= (int)self.originHeadHeight) {
            if ([self.menuBTN imageForState:UIControlStateNormal] == nil) {
                [self.menuBTN setImage:[UIImage imageNamed:@"yn_top_gray"] forState:UIControlStateNormal];
                [self.menuBTN setImage:[UIImage imageNamed:@"yn_top_gray"] forState:UIControlStateSelected];
                [self.menuBTN tagSetImagePosition:PageBtnPositionRight spacing:kRealWidth(3)];
            }
        } else {
            if ([self.menuBTN imageForState:UIControlStateNormal] != nil) {
                [self.menuBTN setImage:nil forState:UIControlStateNormal];
                [self.menuBTN setImage:nil forState:UIControlStateSelected];
                self.menuBTN.titleEdgeInsets = UIEdgeInsetsZero;
                self.menuBTN.imageEdgeInsets = UIEdgeInsetsZero;
            }
        }
        [self.headView page_y:MIN(0, -scrollView.contentOffset.y)];
        if (scrollView.contentOffset.y <= 0 && !self.handleScroll && (!self.scrollToBottom)) {
            CGFloat changeAlpah = MAX(0, MIN(1, fabs(scrollView.contentOffset.y) / (self.originHeadHeight / 2.0)));
            changeAlpah = MAX(CGFLOAT_MIN, changeAlpah);
            [self changeBottomViewAlpah:changeAlpah];
        }
        [self.customNavigationBar updateCNUIWithScrollViewOffsetY:scrollView.contentOffset.y + scrollView.contentInset.top];
        
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
        
        
        
    } else if (scrollView == self.foodView.tableView) {
        [self handlerSrollNavBarWithScrollView:scrollView];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
    }
    if (self.handleScroll)
        self.handleScroll = NO;
    
    

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.foodView.tableView) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        scrollView.isScrolling = false;
    }
}

///头部滑动到最底部
- (BOOL)headShowToBottom:(BOOL)click {
    if (!self.scrollToBottom) {
        if (!click) {
            if (self.pageView.downSc.contentOffset.y >= -self.originHeadHeight / 2.0)
                return NO;
        }
        self.scrollToBottom = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [self.pageView.downSc page_y:kScreenHeight * 2];
            self.shoppingCartDockView.alpha = 0;
        } completion:^(BOOL finished) {
            [self changeBottomViewAlpah:1 force:click];
        }];
        return YES;
    }
    return NO;
}

///头部恢复到原来的位置
- (BOOL)headDissmissToTop:(BOOL)click {
    if (self.scrollToBottom) {
        if (click) {
            self.scrollToBottom = NO;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self.pageView.downSc page_y:0];
            self.shoppingCartDockView.alpha = 1;
        } completion:^(BOOL finished) {
            if (!click) {
                self.scrollToBottom = NO;
            }
            [self changeBottomViewAlpah:0 force:click];
        }];
        return YES;
    }
    return NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageView.downSc) {
        self.beganDecelerate = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.pageView.downSc) {
        if (!decelerate) {
            [self scrollViewDidEndDecelerating:scrollView];
        } else {
            [self headShowToBottom:NO];
        }
        self.beganDrag = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.pageView.downSc) {
        self.beganDrag = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageView.downSc) {
        if (!self.scrollToBottom) {
            [self changeBottomViewAlpah:0 force:YES];
        } else {
            [self changeBottomViewAlpah:1 force:YES];
        }
        self.beganDecelerate = NO;
    }
}

- (void)changeBottomViewAlpah:(CGFloat)changeAlpah {
    [self changeBottomViewAlpah:changeAlpah force:NO];
}

- (void)changeBottomViewAlpah:(CGFloat)changeAlpah force:(BOOL)force {
    if (!force) {
        if (self.headView.storeInfoView.alpha == changeAlpah)
            return;
    }
    BOOL show = (changeAlpah > CGFLOAT_MIN);
    self.headView.showDetail = show;
    [self.headView updateMoreBtnSelect:changeAlpah > 0];
    [self.headView changeAlpah:changeAlpah];
}

- (void)panAction:(UISwipeGestureRecognizer *)guesture {
    if (guesture.state == UIGestureRecognizerStateEnded && guesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self headDissmissToTop:NO];
    }
}

/// 根据 UIScrollView 偏移来滚动到对应标题
- (void)handlerSrollNavBarWithScrollView:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating))
        return;
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
    NSIndexPath *targetPath;
    NSInteger targetSection = -1;
    NSArray<UITableViewCell *> *cellArray = [self.tableView visibleCells];
    if (cellArray) {
        UITableViewCell *cell = [cellArray firstObject];
        targetPath = [self.tableView indexPathForCell:cell];
        targetSection = targetPath.section;
    }
    if (targetPath != nil && targetSection >= 0) {
        NSInteger goodIndex = targetSection;
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
            CGFloat sectionOffsetY = offsetY - sectionHeaderHeight - self.headView.height;
            if (vel.y > 5) {
                //向上加载  向上比较特别  如果数据不全 table滚动高度不完整 就可能忽略一些菜单
                if (sectionOffsetY <= self.currentSectionRect.origin.y) {
                    [self loadGoodsByScrollerIndex:goodIndex - 1 isClickIndex:false loadTop:true loadDown:false isNeedFixContentOffset:true];
                    self.currentSectionRect = [self getSectionHeaderPathRect:targetSection];
                    return;
                }
            } else if (vel.y < -5) {
                //当前section最后一个row出现的时候判断下个section是否有数据
                if (offsetY + CGRectGetHeight(self.tableView.frame)
                        >= CGRectGetMaxY(self.currentSectionRect) - (kShoppingGoodTableViewCellSize + kShoppingGoodTableViewCellTopMargin + kShoppingGoodTableViewCellBottomMargin)
                    && goodIndex < self.viewModel.menuList.count - 1) { //到最后一组数据就不管了
                    NSInteger nextIndex = goodIndex;
                    while (nextIndex >= 0 && nextIndex < self.viewModel.menuList.count) {
                        HDTableViewSectionModel *sectionModel = self.dataSource[nextIndex];
                        if (HDIsArrayEmpty(sectionModel.list))
                            break;
                        //如果相隔太多也不用管  等待下一次请求
                        if ((nextIndex - goodIndex) > 2)
                            break;
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

- (void)setPinCategoryViewSelectedItem:(NSInteger)selectedIndex {
    if (selectedIndex >= 0 && [self.foodView.sortTableView numberOfRowsInSection:0] > selectedIndex && self.viewModel.menuList.count > selectedIndex
        && selectedIndex != self.foodView.sortSelectIndex) {
        [self.viewModel.menuList enumerateObjectsUsingBlock:^(WMStoreMenuItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.select = (idx == selectedIndex);
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self.foodView.sortTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.foodView.sortTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self scrollToCenter:self.foodView.sortTableView indexPath:indexPath];
        [UIView performWithoutAnimation:^{
            UITableView *tableView = self.foodView.sortTableView;
            [tableView reloadData];
        }];
        self.foodView.sortSelectIndex = selectedIndex;
    }
}

// 根据位置拉取对应的类目数据
- (void)loadGoodsByScrollerIndex:(NSInteger)index isClickIndex:(BOOL)isClickIndex loadTop:(BOOL)loadTop loadDown:(BOOL)loadDown isNeedFixContentOffset:(BOOL)isNeedFixContentOffset {
    if (HDIsArrayEmpty(self.dataSource))
        return;
    NSInteger goodIndex = index;
    if (goodIndex >= self.dataSource.count || goodIndex < 0)
        return;
    if (HDIsArrayEmpty(self.viewModel.menuList))
        return;
    WMStoreMenuItem *menuItem = index < 0 ? nil : self.viewModel.menuList[index];
    if (menuItem && ![self.viewModel.alreadyRequestMenuIds containsObject:menuItem.menuId] && self.isLoadingData == false) { //当前没有数据
        if (isNeedFixContentOffset) { //需要手动纠正偏移量的时候  就需要定住  不能继续滑动了
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        }
        self.isLoadingData = true;
        @HDWeakify(self);
        [self.viewModel getGoodListByIndex:index loadTop:loadTop loadDown:loadDown completion:^(BOOL isSuccess) { //直接用实际的index  因为要去筛选 菜单栏
            @HDStrongify(self);
            self.isLoadingData = false;
            if (isSuccess) {
                [self.tableView successGetNewDataWithNoMoreData:true];
                if (isClickIndex) {
                    [self tableViewScollToMenuList:goodIndex];
                } else {
                    if (isNeedFixContentOffset && loadTop) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:goodIndex + 1];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:false];
                        self.lastSection = goodIndex;
                        [self setPinCategoryViewSelectedItem:index];
                    }
                }
            }
        }];
    } else {
        if (isClickIndex)
            [self tableViewScollToMenuList:goodIndex];
    }
}

- (void)tableViewScollToMenuList:(NSInteger)goodIndex {
    if (goodIndex < [self.tableView numberOfSections]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:goodIndex];
        if ([self.tableView numberOfRowsInSection:goodIndex] == 0)
            return;
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
        self.lastSection = goodIndex;
        self.currentSectionRect = [self getSectionHeaderPathRect:goodIndex];
    }
}

- (void)dealingWithAutoScrollToSpecifiedIndexPath {
    if (self.viewModel.isStoreClosed)
        return;
    NSIndexPath *indexPath = self.viewModel.autoScrolledToIndexPath;
    if (!self.viewModel.hasAutoScrolledToSpecIndexPath && indexPath && self.dataSource.count > indexPath.section && self.dataSource[indexPath.section].list.count > indexPath.row) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageView downScrollViewSetOffset:CGPointZero animated:NO];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
            self.viewModel.hasAutoScrolledToSpecIndexPath = true;
            WMShoppingGoodTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell flash];
            [self.foodView.sortTableView layoutIfNeeded];
            [self setPinCategoryViewSelectedItem:indexPath.section];
        });
    }
}


- (void)setUpVideoPlayer {
    //设置颜色
    SJVideoPlayer.update(^(SJVideoPlayerConfigurations *_Nonnull configs) {
        configs.resources.progressThumbSize = 10;
        configs.resources.progressThumbColor = UIColor.whiteColor;
        configs.resources.progressTraceColor = UIColor.whiteColor;
        configs.resources.progressTrackColor = UIColor.darkGrayColor;
        configs.resources.bottomIndicatorTraceColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.backImage = [UIImage imageNamed:@"icon_login_close_white"];
        configs.resources.floatSmallViewCloseImage = [UIImage imageNamed:@"tn_video_close"];
        configs.resources.playFailedButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.noNetworkButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;

        configs.localizedStrings.reload = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        configs.localizedStrings.playbackFailedPrompt = @"";
        configs.localizedStrings.noNetworkPrompt = SALocalizedString(@"network_error", @"网络开小差啦");
    });

    self.player.onlyUsedFitOnScreen = YES;
    self.player.resumePlaybackWhenScrollAppeared = NO;
    self.player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = NO;
    if (@available(iOS 14.0, *)) {
        self.player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    } else {
        // Fallback on earlier versions
    }

    //设置占位图图片样式
    self.player.presentView.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    //默认静音播放
    self.player.muted = YES;
    //设置小窗样式
    SJFloatSmallViewController *floatSmallViewController = (SJFloatSmallViewController *)self.player.floatSmallViewController;
    floatSmallViewController.layoutPosition = SJFloatViewLayoutPositionTopRight;
    floatSmallViewController.layoutInsets = UIEdgeInsetsMake(kNavigationBarH - kStatusBarH, 12, 20, 12);
    floatSmallViewController.layoutSize = CGSizeMake(kRealWidth(120), kRealWidth(120));
    floatSmallViewController.floatView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };

    //删除原有的播放  放大按钮
    [self.player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
    [self.player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Play];
    [self.player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];

    //当前时间
    SJEdgeControlButtonItem *currentTimeItem = [self.player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_CurrentTime];
    currentTimeItem.insets = SJEdgeInsetsMake(15, 0);
    [self.player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_Progress withItemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    SJEdgeControlButtonItem *durationTimeItem = [self.player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    durationTimeItem.insets = SJEdgeInsetsMake(0, 60);

    //声音按钮固定在底部控制层
    __block HDUIButton *muteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [muteBtn setImage:[UIImage imageNamed:@"wm_video_unmute"] forState:UIControlStateNormal];
    [muteBtn setImage:[UIImage imageNamed:@"wm_video_mute"] forState:UIControlStateSelected];
    muteBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    [muteBtn addTarget:self action:@selector(muteClick) forControlEvents:UIControlEventTouchUpInside];
//    muteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [muteBtn sizeToFit];
    [self.player.defaultEdgeControlLayer.controlView addSubview:muteBtn];
    [muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.player.defaultEdgeControlLayer.bottomAdapter.view).offset(-40);
        make.right.equalTo(self.player.defaultEdgeControlLayer.bottomAdapter.view.mas_right).offset(-15);
    }];
    muteBtn.hidden = YES;

    
    
//    //退出全屏按钮固定在底部控制层
    __block HDUIButton *scaleBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [scaleBtn setImage:[UIImage imageNamed:@"wm_video_scale"] forState:UIControlStateNormal];
    scaleBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    [scaleBtn addTarget:self.player.defaultEdgeControlLayer action:@selector(_backItemWasTapped) forControlEvents:UIControlEventTouchUpInside];

    [scaleBtn sizeToFit];
    [self.player.defaultEdgeControlLayer.controlView addSubview:scaleBtn];
    [scaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.player.defaultEdgeControlLayer.bottomAdapter.view);
        make.right.equalTo(self.player.defaultEdgeControlLayer.bottomAdapter.view.mas_right).offset(-15);
    }];
    scaleBtn.hidden = YES;
    


//    //小窗添加一个是否禁音按钮
//    __block SJEdgeControlButtonItem *muteItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"wm_video_mute"] target:self action:@selector(muteClick)
//                                                                                           tag:WMEdgeControlBottomMuteButtonItemTag];
//    SJEdgeControlButtonItem *fillItem = [[SJEdgeControlButtonItem alloc] initWithTag:200];
//    fillItem.fill = YES;
//    self.player.defaultFloatSmallViewControlLayer.bottomHeight = 35;
//    [self.player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:fillItem];
//    [self.player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:muteItem];
////    [self.player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
    //静音回调
    @HDWeakify(self);
    self.player.playbackObserver.mutedDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        muteBtn.selected = !player.isMuted;
//        if (player.isMuted) {
//            muteItem.image = [UIImage imageNamed:@"wm_video_mute"];
//        } else {
//            muteItem.image = [UIImage imageNamed:@"wm_video_unmute"];
//        }
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
        }
    };

    //添加 中间播放按钮
    [self.player.defaultEdgeControlLayer.centerAdapter removeItemForTag:SJEdgeControlLayerCenterItem_Replay];


    
    
    SJEdgeControlButtonItem *playItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"wm_video_play"] target:self action:@selector(playClick)
                                                                                   tag:WMEdgeControlCenterPlayButtonItemTag];
    playItem.hidden = YES;
    [self.player.defaultEdgeControlLayer.centerAdapter addItem:playItem];
    [self.player.defaultEdgeControlLayer.centerAdapter reload];

    //播放完毕事件回调
    self.player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self.player.presentView showPlaceholderAnimated:YES];
        [self setPlayItemHidden:NO];
        
        [LKDataRecord.shared traceEvent:@"playVideoFinishCount" name:@"playVideoFinishCount"
                                  parameters:@{@"type": @"playVideoFinishCount", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000], @"storeNo": [NSString stringWithFormat:@"%@",self.viewModel.storeNo]}
                                         SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];

        
    };

    //全屏回调
    self.player.fitOnScreenObserver.fitOnScreenWillBeginExeBlock = ^(id<SJFitOnScreenManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isFitOnScreen) {
            //进入全屏就打开声音
        } else {
//            if (self.tableView.contentOffset.y > self.playerMaxY) { //这种情况是浮窗进入大屏  再放小的情况  这个时候 暂停视频
//                [self.player pauseForUser];
//            }
            //非全屏自动静音
            if (!self.player.isMuted) {
                self.player.muted = YES;
            }
            //全屏切换回小屏暂停播放
            if (self.player.isPlaying) {
                [self.player pauseForUser];
            }
        }
        scaleBtn.hidden = !mgr.isFitOnScreen;
        muteBtn.hidden = !mgr.isFitOnScreen;
    };

    self.player.gestureControl.supportedGestureTypes = SJPlayerGestureTypeMask_SingleTap | SJPlayerGestureTypeMask_Pan;
    //单击事件回调
    self.player.gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl> _Nonnull control, CGPoint location) {
        @HDStrongify(self);
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.floatSmallViewController dismissFloatView];
            [self.player setFitOnScreen:YES animated:YES];
        } else {
            if (!self.player.isFitOnScreen) {
                [self.player setFitOnScreen:YES animated:YES];
            } else {
                if (self.player.controlLayerAppearManager.isAppeared) {
                    [self.player controlLayerNeedDisappear];
                } else {
                    [self.player controlLayerNeedAppear];
                }
            }
        }
    };
    self.player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ^(id<SJControlLayerAppearManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isAppeared) {
            if (self.player.isFitOnScreen) {
                [self setPlayItemHidden:NO];
            } else {
                [self setPlayItemHidden:self.player.isPlaying];
            }
        } else {
            [self setPlayItemHidden:self.player.isPlaying];
        }
    };
    self.player.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self showPlayItemImage:self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused];
        if (self.player.isPlaying && !self.player.isFitOnScreen) {
            [self setPlayItemHidden:YES];
        }
        //全屏状态下  如果播放后 控制层不在 马上隐藏播放按钮
        if (self.player.isPlaying && self.player.isFitOnScreen && !self.player.controlLayerAppeared) {
            [self setPlayItemHidden:YES];
        }
        if (self.player.isPaused) {
            [self setPlayItemHidden:NO];
        }
    };
}

#pragma mark 静音按钮点击
- (void)muteClick {
    self.player.muted = !self.player.isMuted;
}

- (void)scaleClick {
//    self.player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
}
#pragma mark 播放按钮点击
- (void)playClick {
    //放大状态下
    if (self.player.isPlaying) {
        [self.player pauseForUser];
    } else {
        if (!self.player.presentView.isPlaceholderImageViewHidden) {
            [self.player.presentView hiddenPlaceholderAnimated:YES];
        }
        if (self.player.isPlaybackFinished) {
            [self.player replay];
        } else {
            [self.player play];
        }
    }
}

- (void)setPlayItemHidden:(BOOL)hidden {
    SJEdgeControlButtonItem *playitem = [self.player.defaultEdgeControlLayer.centerAdapter itemForTag:WMEdgeControlCenterPlayButtonItemTag];
    playitem.hidden = hidden;
    [self.player.defaultEdgeControlLayer.centerAdapter reload];
}
//设置播放图片
- (void)showPlayItemImage:(BOOL)isPlaying {
    SJEdgeControlButtonItem *playItem = [self.player.defaultEdgeControlLayer.centerAdapter itemForTag:WMEdgeControlCenterPlayButtonItemTag];
    if (isPlaying) {
        playItem.image = [UIImage imageNamed:@"wm_video_pause"];
    } else {
        playItem.image = [UIImage imageNamed:@"wm_video_play"];
    }
    [self.player.defaultEdgeControlLayer.centerAdapter reload];

    if (isPlaying && !self.player.presentView.isPlaceholderImageViewHidden) {
        [self.player.presentView hiddenPlaceholderAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if(self.viewModel.isStoreClosed){
        if (tableView == self.foodView.tableView && self.viewModel.dataSource.count) return 1;
    }else{
        NSInteger count = 0;
        if (tableView == self.foodView.sortTableView)
            count = 1;
        else if (tableView == self.foodView.tableView)
            count = self.viewModel.dataSource.count;
        return count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if(self.viewModel.isStoreClosed){
        if (tableView == self.foodView.tableView && self.viewModel.dataSource.count) return 1;
    }else{
        if (tableView == self.foodView.sortTableView)
            count = self.viewModel.menuList.count;
        else if (tableView == self.foodView.tableView)
            count = self.viewModel.dataSource[section].list.count;
        return count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    if(self.viewModel.isStoreClosed){
        if(self.viewModel.dataSource.count){
            model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
        }else{
            model = self.viewModel.noDateCellModel;
        }
    }else{
        if (tableView == self.foodView.sortTableView)
            model = self.viewModel.menuList[indexPath.row];
        else if (tableView == self.foodView.tableView)
            model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
    }
    return [self setUpModel:model tableView:tableView indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.foodView.sortTableView) {
        [self.pageView downScrollViewSetOffset:CGPointZero animated:NO];
        [self loadGoodsByScrollerIndex:indexPath.row isClickIndex:true loadTop:false loadDown:false isNeedFixContentOffset:false];
        [self.viewModel.menuList enumerateObjectsUsingBlock:^(WMStoreMenuItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.select = (idx == indexPath.row);
        }];
        [self scrollToCenter:tableView indexPath:indexPath];
        [UIView performWithoutAnimation:^{
            [tableView reloadData];
        }];
    }
}

- (void)scrollToCenter:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    if (tableView.contentSize.height + tableView.contentInset.bottom > tableView.hd_height) {
        CGFloat centerY = tableView.hd_height / 2;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect indexFrame = cell.frame;
        CGFloat contenSize = tableView.contentSize.height + tableView.contentInset.bottom;
        CGPoint point = CGPointZero;
        if (indexFrame.origin.y <= centerY) {
            point = CGPointMake(0, 0);
        } else if (CGRectGetMaxY(indexFrame) > (contenSize - centerY)) {
            point = CGPointMake(0, contenSize - tableView.hd_height);
        } else {
            point = CGPointMake(0, CGRectGetMaxY(indexFrame) - centerY - indexFrame.size.height / 2);
        }
        point = CGPointMake(point.x, MIN(contenSize, MAX(0, point.y)));
        [tableView setContentOffset:point animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
    if (tableView == self.foodView.tableView && self.viewModel.dataSource.count > indexPath.section && self.viewModel.dataSource[indexPath.section].list.count > indexPath.row) {
        id model = self.viewModel.dataSource[indexPath.section].list[indexPath.row];
        [self cellWilldisplayTbleView:tableView indexPath:indexPath model:model];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.foodView.tableView && !HDIsArrayEmpty(self.viewModel.menuList) && self.dataSource.count > section) {
        HDTableViewSectionModel *sectionModel = self.dataSource[section];
        HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
        HDTableHeaderFootViewModel *model = sectionModel.headerModel;
        model.titleFont = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightBold];
        headView.model = model;
        headView.contentView.backgroundColor = HDAppTheme.WMColor.white;
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.foodView.tableView && !HDIsArrayEmpty(self.viewModel.menuList) && self.dataSource.count > section) {
        HDTableViewSectionModel *sectionModel = self.dataSource[section];
        CGFloat height = [sectionModel.headerModel.title boundingAllRectWithSize:CGSizeMake(kScreenWidth - UIEdgeInsetsGetHorizontalValue(sectionModel.headerModel.edgeInsets), MAXFLOAT)
                                                                            font:sectionModel.headerModel.titleFont]
                             .height;
        return MAX(kRealWidth(46), height + kRealWidth(15));
    }
    return CGFLOAT_MIN;
}

- (UIView *)placeholderHead {
    if (!_placeholderHead) {
        _placeholderHead = UIView.new;
        _placeholderHead.userInteractionEnabled = NO;
    }
    return _placeholderHead;
}

- (WMCNStoreDetailOrderFoodView *)foodView {
    if (!_foodView) {
        _foodView = WMCNStoreDetailOrderFoodView.new;
        _foodView.sortTableView.delegate = self;
        _foodView.sortTableView.dataSource = self;
        _foodView.tableView.delegate = self;
        _foodView.tableView.dataSource = self;
    }
    return _foodView;
}

- (WMStoreInfoViewModel *)infoViewModel {
    if (!_infoViewModel) {
        _infoViewModel = [[WMStoreInfoViewModel alloc] initWithImage:@"star_rating_level_1" font:HDAppTheme.font.standard4 textColor:HDAppTheme.color.G2 startColor:HDAppTheme.color.C1];
        _infoViewModel.storeNo = self.viewModel.storeNo;
    }
    return _infoViewModel;
}

- (HDUIButton *)groupBTN {
    if (!_groupBTN) {
        _groupBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _groupBTN.adjustsButtonWhenHighlighted = NO;
        [_groupBTN setTitle:WMLocalizedString(@"", @"预订团购") forState:UIControlStateNormal];
        _groupBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(8), kRealWidth(3), kRealWidth(8));
        [_groupBTN setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        _groupBTN.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
        _groupBTN.layer.borderWidth = 1;
        _groupBTN.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        _groupBTN.layer.cornerRadius = kRealWidth(4);
        _groupBTN.hidden = YES;
        @HDWeakify(self);
        [_groupBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": self.viewModel.detailInfoModel.grouponStoreNo}];
        }];
    }
    return _groupBTN;
}

- (WMStoreDetailHeaderView *)headView {
    if (!_headView) {
        _headView = [[WMStoreDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarH)];
        _headView.storeInfoView.viewModel = self.infoViewModel;
        _headView.clipsToBounds = YES;
        _headView.layer.cornerRadius = kRealWidth(8);
        _headView.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner;
        @HDWeakify(self);
        [_headView setHd_frameWillChangeBlock:^CGRect(__kindof UIView *_Nonnull view, CGRect followingFrame) {
            @HDStrongify(self);
            if (followingFrame.origin.y == 0 && self.pageView.downSc.contentOffset.y > 0) {
                followingFrame.origin.y = -self.pageView.downSc.contentOffset.y;
            }
            followingFrame.origin.y = MIN(0, MAX(-self.originHeadHeight, followingFrame.origin.y));
            return followingFrame;
        }];
        _headView.videoTapClick = ^(HDCyclePagerView * _Nonnull pagerView, NSIndexPath * _Nonnull indexPath, NSURL * _Nonnull videoUrl) {
            @HDStrongify(self);
//            [self.player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageUrl]];
            SJPlayModel *playModel = [SJPlayModel playModelWithCollectionView:pagerView.collectionView indexPath:indexPath superviewSelector:NSSelectorFromString(@"videoContentView")];
            self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:videoUrl playModel:playModel];
            HDReachability *reachability = [HDReachability reachabilityForInternetConnection];
            if (reachability.currentReachabilityStatus == ReachableViaWWAN) {
                [HDTips showWithText:TNLocalizedString(@"tn_video_play_tip", @"您正在使用非WiFi播放，请注意手机流量消耗") hideAfterDelay:3];
            }
            [self.player play];
            
            [LKDataRecord.shared traceEvent:@"playVedioClickCount" name:@"playVedioClickCount"
                                      parameters:@{@"type": @"playVedioClickCount", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000], @"storeNo": [NSString stringWithFormat:@"%@",self.viewModel.storeNo]}
                                             SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
            self.videoTime = time(NULL);

        };
    }
    return _headView;
}

- (WMCNStoreScrollHeadView *)storeHeadScroll {
    if (!_storeHeadScroll) {
        _storeHeadScroll = WMCNStoreScrollHeadView.new;
        _storeHeadScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _storeHeadScroll.delaysContentTouches = NO;
        _storeHeadScroll.bounces = NO;
    }
    return _storeHeadScroll;
}

- (HDSkeletonLayerDataSourceProvider *)goodsProvider {
    if (!_goodsProvider) {
        _goodsProvider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMShoppingGoodTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMShoppingGoodTableViewCell skeletonViewHeight];
        }];
        _goodsProvider.numberOfRowsInSection = 10;
    }
    return _goodsProvider;
}

@end


@implementation WMCNStoreScrollHeadView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGFloat height = self.frame.size.height;
    CGFloat contentYoffset = self.contentOffset.y;
    CGFloat distanceFromBottom = self.contentSize.height - contentYoffset;
    if (distanceFromBottom <= height && self.contentSize.height >= height) {
        return YES;
    }
    return NO;
}
@end

//
//  TNBargainActivityViewController.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//  砍价列表页  砍价专题页

#import "TNBargainActivityViewController.h"
#import "HDCollectionViewVerticalLayout.h"
#import "TNBargainBannerCell.h"
#import "TNBargainCategoryReusableView.h"
#import "TNBargainDetailViewController.h"
#import "TNBargainGoodsCell.h"
#import "TNBargainOnListCell.h"
#import "TNBargainSelectGoodsView.h"
#import "TNBargainShowBannerContainrView.h"
#import "TNBargainSuspendWindow.h"
#import "TNBargainViewModel.h"
#import "TNCollectionView.h"
#import "TNCreateBargainTaskModel.h"
#import "TNHomeChoicenessSkeletonCell.h"
#import "TNHomeViewController.h"
#import "TNNotificationConst.h"
#import "TNShareManager.h"


@interface TNBargainActivityViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
@property (nonatomic, strong) TNCollectionView *collectionView;
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 助力记录数据源
@property (strong, nonatomic) HDTableViewSectionModel *recordSectionModel;
/// 助力商品数据源
@property (strong, nonatomic) HDTableViewSectionModel *goodsSectionModel;
/// banner
@property (strong, nonatomic) HDTableViewSectionModel *bannerSectionModel;
/// viewModel
@property (strong, nonatomic) TNBargainViewModel *viewModel;
/// 是否展开了
@property (nonatomic, assign) BOOL isExtend;
/// 定时器
@property (nonatomic, strong) dispatch_source_t timer;
/// 选择商品规格视图
@property (strong, nonatomic) TNBargainSelectGoodsView *selectView;
/// 成功助力数据源
@property (strong, nonatomic) NSArray *successBargainArr;
/// 助力成功显示视图
@property (strong, nonatomic) TNBargainShowBannerContainrView *showView;
/// 类别视图
@property (strong, nonatomic) TNBargainCategoryReusableView *headerView;
/// 当前分类页码
@property (nonatomic, assign) NSInteger currentCategoryIndex;
/// 我的助力记录浮层
@property (strong, nonatomic) TNBargainSuspendWindow *recordWindow;
/// 是否来自砍价专题页面
@property (nonatomic, assign) BOOL isFromBargainActivity;
/// 活动ID
@property (nonatomic, copy) NSString *activityId;
/// 专题加载失败占位展示
@property (nonatomic, strong) UIViewPlaceholderViewModel *failNetWorkPlaceHolderModel;
/// 专题失效占位展示
@property (nonatomic, strong) UIViewPlaceholderViewModel *activityFailPlaceHolderModel;
/// 导航栏按钮
@property (strong, nonatomic) NSMutableArray<UIBarButtonItem *> *rightItems;
@end


@implementation TNBargainActivityViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        NSString *activityId = parameters[@"activityNo"];
        if (HDIsStringNotEmpty(activityId)) {
            self.isFromBargainActivity = YES;
            self.activityId = activityId;
        }
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancelTimer];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)hd_setupViews {
    [self.view addSubview:self.collectionView];
    [self.recordWindow showInView:self.view];

    // 监听用户登录
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [self addSkeleLayerCellModel]; //先加骨架
    @HDWeakify(self);
    [self.collectionView registerEndScrollinghandler:^{
        @HDStrongify(self);
        if (!self.collectionView.isScrolling) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //停止滚动的时候  收起购物车
                [self.recordWindow expand];
            });
        }
    } withKey:@"TNBargainActivity_scroll_key"];
}
- (void)hd_setupNavigation {
    if (!self.isFromBargainActivity) {
        self.boldTitle = TNLocalizedString(@"tn_bargain_Index_title", @"好友助力免费送");
    }
}
- (void)hd_bindViewModel {
    self.currentCategoryIndex = 0;
    [self.viewModel hd_bindView:self.view];
    if (self.isFromBargainActivity) { //砍价专题
        //获取专题配置数据 banner及标题 分享url数据  以及是否已下架
        [self getBargainActivityConfigData];
    } else { //普通砍价列表
        //分类数据
        [self getCategoryDataByScene:TNProductCategorySceneBargainList];
        //砍价推荐列表数据
        [self getBargainIndexData];
        //请求助力成功任务列表
        [self getBargainSuccessListData];
        //获取正在进行中任务数据
        [self getBargainUnderwayTaskData];
    }
}
#pragma mark - 获取正在进行中任务数据
- (void)getBargainUnderwayTaskData {
    @HDWeakify(self);
    //正在进行中任务数据
    if ([SAUser hasSignedIn]) {
        [self.viewModel getUnderwayTaskDataCompletion:^{
            @HDStrongify(self);
            [self prepareUnderWayTaskData];
        }];
    }
}
#pragma mark - 获取助力成功展示弹窗数据
- (void)getBargainSuccessListData {
    @HDWeakify(self);
    [self.viewModel getSucessTaskListCompletion:^(NSArray<TNBargainSuccessModel *> *_Nonnull sucessTaskList) {
        if (!HDIsArrayEmpty(sucessTaskList)) {
            @HDStrongify(self);
            self.successBargainArr = sucessTaskList;
            if (self.showView == nil) {
                [self showSucessTaskListBanner:sucessTaskList];
            }
        }
    }];
}
#pragma mark - 获取分类标题数据
- (void)getCategoryDataByScene:(TNProductCategoryScene)secene {
    @HDWeakify(self);
    [self.viewModel getBargainCategoryDataByScene:secene souceId:self.activityId completion:^{
        @HDStrongify(self);
        TNHomeCategoryModel *model = self.viewModel.categoryArr[self.currentCategoryIndex];
        TNBargainPageConfig *config = self.viewModel.goodsDic[model.name];
        [self.collectionView successGetNewDataWithNoMoreData:!config.hasNextPage];
    }];
}
#pragma mark - 获取砍价首页推荐列表数据
- (void)getBargainIndexData {
    @HDWeakify(self);
    [self.viewModel getBargainListIndexNewDataCompletion:^(BOOL isSuccess) {
        @HDStrongify(self);
        if (isSuccess) {
            if (HDIsStringNotEmpty(self.viewModel.banner)) {
                TNBargainBannerCellModel *cellModel = [[TNBargainBannerCellModel alloc] init];
                self.bannerSectionModel.list = @[cellModel];
            } else {
                self.bannerSectionModel.list = nil;
            }
            self.hd_navigationItem.rightBarButtonItems = self.rightItems;
            TNHomeCategoryModel *model = self.viewModel.categoryArr.firstObject;
            TNBargainPageConfig *config = self.viewModel.goodsDic[model.name];
            self.goodsSectionModel.list = config.goods;
            [self.collectionView successGetNewDataWithNoMoreData:!config.hasNextPage];
        } else {
            self.dataSource = @[];
            [self.collectionView failGetNewData];
        }
    }];
}
#pragma mark - 获取砍价列表推荐更多数据
- (void)loadBargainIndexMoreData {
    @HDWeakify(self);
    [self.viewModel loadBargainListIndexMoreDataCompletion:^(BOOL isSuccess) {
        @HDStrongify(self);
        TNHomeCategoryModel *model = self.viewModel.categoryArr.firstObject;
        TNBargainPageConfig *config = self.viewModel.goodsDic[model.name];
        if (isSuccess) {
            self.goodsSectionModel.list = config.goods;
            [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
        }
    }];
}
#pragma mark - 获取砍价专题配置数据  banner 标题  分享url
- (void)getBargainActivityConfigData {
    @HDWeakify(self);
    [self.viewModel getBargainActivityConfigDataByActivityId:self.activityId successBlock:^{
        @HDStrongify(self);
        self.boldTitle = self.viewModel.configModel.name;
        if (HDIsStringNotEmpty(self.viewModel.banner)) {
            TNBargainBannerCellModel *cellModel = [[TNBargainBannerCellModel alloc] init];
            self.bannerSectionModel.list = @[cellModel];
        } else {
            self.bannerSectionModel.list = nil;
        }
        [self.collectionView successGetNewDataWithNoMoreData:NO];
        //分类数据
        [self getCategoryDataByScene:TNProductCategorySceneGoodsSpecial];
        //砍价专题列表数据
        [self getBargainActivityDataByIndex:self.currentCategoryIndex isLoadMore:NO];
        //请求助力成功任务列表
        [self getBargainSuccessListData];
        //获取正在进行中任务数据
        [self getBargainUnderwayTaskData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if ([rspModel.code isEqualToString:@"TN1017"]) {
            self.dataSource = @[];
            self.collectionView.placeholderViewModel = self.activityFailPlaceHolderModel;
            [self.collectionView failGetNewData];
        } else {
            self.dataSource = @[];
            self.collectionView.placeholderViewModel = self.failNetWorkPlaceHolderModel;
            [self.collectionView failGetNewData];
        }
    }];
}
#pragma mark - 获取砍价专题推荐数据
- (void)getBargainActivityDataByIndex:(NSInteger)index isLoadMore:(BOOL)isLoadMore {
    if (index >= self.viewModel.categoryArr.count) {
        return;
    }
    TNHomeCategoryModel *model = self.viewModel.categoryArr[index];
    TNBargainPageConfig *config = self.viewModel.goodsDic[model.name];
    if (!config) {
        config = [[TNBargainPageConfig alloc] init];
        self.viewModel.goodsDic[model.name] = config;
    }
    //如果对应页面已有数据 且不是加载更多 就直接刷新
    if (!HDIsArrayEmpty(config.goods) && !isLoadMore) {
        self.goodsSectionModel.list = config.goods;
        [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
        [self updateCollectionViewOffset];
        return;
    }
    if (isLoadMore) {
        config.currentPage += 1;
    }
    @HDWeakify(self);
    [self.viewModel getCategoryBargainActivityListByActivityId:self.activityId categoryModel:model completion:^(BOOL isSuccess) {
        @HDStrongify(self);
        if (isSuccess) {
            self.goodsSectionModel.list = config.goods;
            if (config.currentPage == 1 && index == 0) {
                [self.collectionView successGetNewDataWithNoMoreData:!config.hasNextPage];
            } else {
                [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
            }
            if (config.currentPage == 1 && index != 0) {
                [self updateCollectionViewOffset];
            }
        } else {
            [self.collectionView failLoadMoreData];
        }
    }];
}

#pragma mark - 配置正在进行中的数据
- (void)prepareUnderWayTaskData {
    if (self.viewModel.records.count > 0) {
        TNBargainOnListCellModel *cellModel = [[TNBargainOnListCellModel alloc] init];
        cellModel.list = [self prepareUnderwayTaskArrByExtend:false]; //默认未展开
        self.recordSectionModel.list = @[cellModel];
        [self startTimer]; //开启定时器
        TNHomeCategoryModel *model = self.viewModel.categoryArr[self.currentCategoryIndex];
        TNBargainPageConfig *config = self.viewModel.goodsDic[model.name];
        if (config.currentPage == 1) {
            [self.collectionView successGetNewDataWithNoMoreData:!config.hasNextPage];
        } else {
            [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
        }
    }
}
#pragma mark - 获取砍价列表分类下的列表数据
- (void)getBargainCategoryPageListByIndex:(NSInteger)index isLoadMore:(BOOL)isLoadMore {
    if (index >= self.viewModel.categoryArr.count) {
        return;
    }
    TNHomeCategoryModel *model = self.viewModel.categoryArr[index];
    TNBargainPageConfig *config = self.viewModel.goodsDic[model.name];

    //如果对应页面已有数据 且不是加载更多 就直接刷新
    if (!HDIsArrayEmpty(config.goods) && !isLoadMore) {
        self.goodsSectionModel.list = config.goods;
        [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
        [self updateCollectionViewOffset];
        return;
    }
    //如果是推荐页面的数据 就要重新拉取
    if (index == 0) {
        [self getBargainIndexData];
        return;
    }

    if (isLoadMore) {
        config.currentPage += 1;
    }
    @HDWeakify(self);
    [self.viewModel getCategoryBargainListByCategoryModel:model completion:^(BOOL isSuccess) {
        @HDStrongify(self);
        if (isSuccess) {
            self.goodsSectionModel.list = config.goods;
            [self.collectionView successLoadMoreDataWithNoMoreData:!config.hasNextPage];
            if (config.currentPage == 1) {
                [self updateCollectionViewOffset];
            }
        } else {
            [self.collectionView failLoadMoreData];
        }
    }];
}
#pragma mark - 设置collectionView偏移位置
- (void)updateCollectionViewOffset {
    //重新设置一次   不然可弄会出现悬停头部位置错乱   下个版本优化
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    if (self.collectionView.contentSize.height <= self.collectionView.height) { //解决悬浮头部可能移动位置的问题
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    } else {
        NSInteger section = self.collectionView.numberOfSections;
        CGFloat goodCellY = 0;
        NSIndexPath *targetPath = nil;
        if (section > 0 && section <= self.dataSource.count) {
            targetPath = [NSIndexPath indexPathForItem:0 inSection:section - 1];
            UICollectionViewLayoutAttributes *attrs = [self.collectionView layoutAttributesForItemAtIndexPath:targetPath];
            goodCellY = attrs.frame.origin.y;
        }
        if (targetPath != nil && self.collectionView.contentOffset.y > goodCellY) {
            HDTableViewSectionModel *model = self.dataSource[targetPath.section];
            if (HDIsArrayEmpty(model.list)) { //没有数据 直接置顶
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            } else {
                [self.collectionView scrollToItemAtIndexPath:targetPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                //再移动header位置
                [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y - kRealWidth(40) - kRealWidth(10)) animated:NO];
            }
        }
    }
}
- (void)updateViewConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)addSkeleLayerCellModel {
    NSMutableArray<TNHomeChoicenessSkeletonCellModel *> *skeletonModelArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < 10; i++) {
        TNHomeChoicenessSkeletonCellModel *model = TNHomeChoicenessSkeletonCellModel.new;
        [skeletonModelArray addObject:model];
    }
    self.goodsSectionModel.list = skeletonModelArray;
    self.dataSource = @[self.bannerSectionModel, self.recordSectionModel, self.goodsSectionModel];
    [self.collectionView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
}

#pragma mark - nav config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}
- (UIStatusBarStyle)hd_statusBarStyle {
    return UIStatusBarStyleDefault;
}
#pragma mark - method
- (void)shareClick {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    shareModel.shareImage = self.viewModel.banner;
    shareModel.shareTitle = self.boldTitle;
    shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
    if (self.isFromBargainActivity) {
        shareModel.shareLink = self.viewModel.configModel.shareUrl;
    } else {
        shareModel.shareLink = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowBargainIndexList];
        shareModel.type = TNShareTypeBargainList;
    }
    [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
}
- (void)searchClick {
    [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:nil];
}
#pragma mark - 用户登录通知
- (void)userLoginHandler {
    //请求正在进行中数据
    [self getBargainUnderwayTaskData];
}
/// 准备展开进行中的数据
- (NSArray *)prepareUnderwayTaskArrByExtend:(BOOL)isExtend {
    if (self.viewModel.records.count <= 2) {
        return self.viewModel.records;
    }
    if (isExtend) {
        return self.viewModel.records;
    } else {
        return [self.viewModel.records subarrayWithRange:NSMakeRange(0, 2)]; //取两个
    }
}
#pragma mark - 定时器
- (void)startTimer {
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), 1.0 * NSEC_PER_SEC, 0);
        @HDWeakify(self);
        dispatch_source_set_event_handler(timer, ^{
            @HDStrongify(self);
            BOOL allExpired = true;
            for (TNBargainRecordModel *record in self.viewModel.records) {
                if (record.expiredTimeOut > 0) {
                    allExpired = false;
                }
                if (record.expiredTimeOut <= 0) {
                    continue;
                }
                record.expiredTimeOut = record.expiredTimeOut - 1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameBargainCountTime object:nil];
            });
            if (allExpired) {
                [self cancelTimer];
            }
            HDLog(@"倒计时===");
        });
        self.timer = timer;
        dispatch_resume(self.timer);
    }
}
- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}
#pragma mark - 显示助力成功列表
- (void)showSucessTaskListBanner:(NSArray<TNBargainSuccessModel *> *)list {
    self.showView = [[TNBargainShowBannerContainrView alloc] init];
    self.showView.dataArr = list;
    [self.showView showInView:self.collectionView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = true;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.recordWindow shrink];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    scrollView.isScrolling = false;
}
#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (model == self.recordSectionModel) {
        TNBargainOnListCell *cell = [TNBargainOnListCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainOnListCell.class)];
        cell.isShowExtend = self.viewModel.isShowExtendOngoingTask;
        TNBargainOnListCellModel *cmodel = model.list[indexPath.row];
        cell.dataArr = cmodel.list;
        cell.isExtend = self.isExtend;
        @HDWeakify(self);
        cell.extendClickCallBack = ^(BOOL isExtend) {
            @HDStrongify(self) self.isExtend = isExtend;
            cmodel.list = [self prepareUnderwayTaskArrByExtend:isExtend];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        cell.continueBargainClickTrackEventCallBack = ^{
            [SATalkingData trackEvent:@"[电商]砍价专题页_点击继续助力"];
        };
        return cell;
    } else if (model == self.goodsSectionModel) {
        id rowModel = model.list[indexPath.row];
        if ([rowModel isKindOfClass:[TNBargainGoodModel class]]) {
            TNBargainGoodsCell *cell = [TNBargainGoodsCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainGoodsCell.class)];
            TNBargainGoodModel *gModel = (TNBargainGoodModel *)rowModel;
            cell.isFromBargainList = YES; //来自砍价列表
            cell.model = gModel;
            return cell;
        } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
            TNHomeChoicenessSkeletonCell *cell = [TNHomeChoicenessSkeletonCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                           identifier:NSStringFromClass(TNHomeChoicenessSkeletonCell.class)];
            return cell;
        }
    } else if (model == self.bannerSectionModel) {
        TNBargainBannerCell *cell = [TNBargainBannerCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:NSStringFromClass(TNBargainBannerCell.class)];
        cell.banner = self.viewModel.banner;
        return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (model == self.goodsSectionModel) {
        TNBargainGoodModel *gModel = model.list[indexPath.row];
        if (gModel.stockNumber <= 0) {
            return; //无库存不给点击
        }
        [[HDMediator sharedInstance] navigaveTinhNowBargainProductDetailViewController:@{@"activityId": gModel.activityId}];
        if (self.isFromBargainActivity) {
            [SATalkingData trackEvent:@"[电商]砍价专题页_点击商品" label:@"" parameters:@{@"商品ID": gModel.activityId}];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (model == self.recordSectionModel) {
        TNBargainOnListCellModel *cellModel = model.list[indexPath.row];
        return CGSizeMake(kScreenWidth, cellModel.tableHeight);
    } else if (model == self.goodsSectionModel) {
        id rowModel = model.list[indexPath.row];
        if ([rowModel isKindOfClass:[TNBargainGoodModel class]]) {
            TNBargainGoodModel *gModel = (TNBargainGoodModel *)rowModel;
            gModel.preferredWidth = self.itemWidth;
            return CGSizeMake(self.itemWidth, gModel.cellHeight);
        } else if ([rowModel isKindOfClass:[TNHomeChoicenessSkeletonCellModel class]]) {
            return CGSizeMake(self.itemWidth, ChoicenessSkeletonCellHeight);
        }
    } else if (model == self.bannerSectionModel) {
        TNBargainBannerCellModel *cellModel = model.list[indexPath.row];
        return CGSizeMake(kScreenWidth, cellModel.cellHeight);
    }
    return CGSizeZero;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:TNHomeChoicenessSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model.headerModel != nil) {
        return CGSizeMake(kScreenWidth, kRealWidth(40));
    }
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *model = self.dataSource[indexPath.section];
    if (model.headerModel != nil) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(TNBargainCategoryReusableView.class)
                                                                        forIndexPath:indexPath];
            self.headerView.list = self.viewModel.categoryArr;
            @HDWeakify(self);
            self.headerView.categoryClickCallBack = ^(NSInteger index) {
                @HDStrongify(self);
                if (self.currentCategoryIndex == index) {
                    return;
                }
                self.currentCategoryIndex = index;
                if (self.isFromBargainActivity) {
                    [self getBargainActivityDataByIndex:index isLoadMore:NO];
                    [SATalkingData trackEvent:@"[电商]砍价专题页_点击一级分类导航tab"];
                } else {
                    [self getBargainCategoryPageListByIndex:index isLoadMore:NO];
                }
            };
            return self.headerView;
        }
    }
    return nil;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(20), kRealWidth(15));
    }
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        return kRealWidth(10);
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        return kRealWidth(10);
    }
    return 0;
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    HDTableViewSectionModel *model = self.dataSource[section];
    if (model == self.goodsSectionModel) {
        return 2;
    }
    return 1;
}
#pragma mark - lazy
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.header_suspension = YES;
        flowLayout.delegate = self;
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = false;
        _collectionView.needRefreshFooter = true;
        _collectionView.needShowErrorView = true;
        _collectionView.needShowNoDataView = false;
        _collectionView.mj_footer.hidden = YES;
        @HDWeakify(self);
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            if (self.isFromBargainActivity) {
                [self getBargainActivityDataByIndex:self.currentCategoryIndex isLoadMore:YES];
            } else {
                if (self.currentCategoryIndex == 0) {
                    [self loadBargainIndexMoreData];
                } else {
                    [self getBargainCategoryPageListByIndex:self.currentCategoryIndex isLoadMore:YES];
                }
            }
        };
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self addSkeleLayerCellModel]; //先加骨架
            if (self.isFromBargainActivity) {
                [self getBargainActivityConfigData];
            } else {
                [self getBargainIndexData];
                [self getBargainUnderwayTaskData];
            }
        };
        _collectionView.placeholderViewModel = placeHolderModel;
        [_collectionView registerClass:TNBargainCategoryReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TNBargainCategoryReusableView.class)];
    }
    return _collectionView;
}
- (HDTableViewSectionModel *)recordSectionModel {
    if (!_recordSectionModel) {
        _recordSectionModel = [[HDTableViewSectionModel alloc] init];
    }
    return _recordSectionModel;
}
- (HDTableViewSectionModel *)goodsSectionModel {
    if (!_goodsSectionModel) {
        _goodsSectionModel = [[HDTableViewSectionModel alloc] init];
        HDTableHeaderFootViewModel *header = [[HDTableHeaderFootViewModel alloc] init];
        _goodsSectionModel.headerModel = header;
    }
    return _goodsSectionModel;
}
- (HDTableViewSectionModel *)bannerSectionModel {
    if (!_bannerSectionModel) {
        _bannerSectionModel = [[HDTableViewSectionModel alloc] init];
        TNBargainBannerCellModel *cellModel = [[TNBargainBannerCellModel alloc] init];
        _bannerSectionModel.list = @[cellModel];
    }
    return _bannerSectionModel;
}

- (TNBargainSuspendWindow *)recordWindow {
    if (!_recordWindow) {
        _recordWindow = [[TNBargainSuspendWindow alloc] init];
    }
    return _recordWindow;
}
/** @lazy viewModel */
- (TNBargainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNBargainViewModel alloc] init];
    }
    return _viewModel;
}
- (CGFloat)itemWidth {
    return (kScreenWidth - kRealWidth(40)) / 2;
}
- (UIViewPlaceholderViewModel *)failNetWorkPlaceHolderModel {
    if (!_failNetWorkPlaceHolderModel) {
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow-ic-home-placeholder";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        @HDWeakify(self);
        placeHolderModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self addSkeleLayerCellModel]; //先加骨架
            [self getBargainActivityConfigData];
        };
        _failNetWorkPlaceHolderModel = placeHolderModel;
    }
    return _failNetWorkPlaceHolderModel;
}

- (UIViewPlaceholderViewModel *)activityFailPlaceHolderModel {
    if (!_activityFailPlaceHolderModel) {
        UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
        placeHolderModel.image = @"tinhnow_product_failure";
        placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
        placeHolderModel.title = TNLocalizedString(@"tn_topic_expired_tips", @"专题已失效，去首页看看吧");
        placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolderModel.needRefreshBtn = YES;
        placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_go_home_page", @"去首页");
        placeHolderModel.refreshBtnBackgroundColor = HDAppTheme.TinhNowColor.C1;
        placeHolderModel.clickOnRefreshButtonHandler = ^{ //回主页
            [[HDMediator sharedInstance] navigaveToTinhNowController:nil];
        };
        _activityFailPlaceHolderModel = placeHolderModel;
    }
    return _activityFailPlaceHolderModel;
}
- (NSMutableArray<UIBarButtonItem *> *)rightItems {
    if (!_rightItems) {
        _rightItems = [NSMutableArray array];
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"tinhnow-black-share-new"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

        HDUIButton *searchButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:[UIImage imageNamed:@"tinhnow_nav_search"] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        [_rightItems addObject:shareItem];
        [_rightItems addObject:searchItem];
    }
    return _rightItems;
}
@end

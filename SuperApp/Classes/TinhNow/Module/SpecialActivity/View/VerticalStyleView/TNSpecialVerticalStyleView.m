//
//  TNSpecialVerticalStyleView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecialVerticalStyleView.h"
#import "TNSpeciaActivityViewModel.h"
#import "TNVerticalLeftCategoryView.h"
#import "TNVerticalRightProductView.h"

//#define kProductsListViewHeight (kScreenHeight - kNavigationBarH)  //商品列表高度
@interface TNSpecialVerticalStyleView ()
@property (nonatomic, strong) TNSpeciaActivityViewModel *viewModel;
///
@property (strong, nonatomic) TNVerticalLeftCategoryView *leftView;
///  当前位置
@property (nonatomic, copy) NSString *currentIndex;
/// 存储页面
@property (strong, nonatomic) NSMutableDictionary<NSString *, TNVerticalRightProductView *> *listDict;

@end


@implementation TNSpecialVerticalStyleView
- (void)dealloc {
    HDLog(@"TNSpecialVerticalStyleView -- 销毁");
    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:@{@"specialId": self.viewModel.activityId}];
}
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    [self addSubview:self.leftView];
    [self addSubview:self.scrollView];
    self.scrollView.scrollEnabled = NO; //禁止滚动
    [self updateScrollViewContentSize];
    //    [self getDefaultItemData];
}
- (void)refreshListData {
    [self.listDict removeAllObjects];
    [self.scrollView hd_removeAllSubviews];
    [self updateScrollViewContentSize];
}
- (void)refreshCategory {
    [self getDefaultItemData];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"adsAndCategoryRefrehFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self getDefaultItemData];
        [self updateScrollViewContentSize];
    }];
}
#pragma mark -更新滑动列表的滚动区域
- (void)updateScrollViewContentSize {
    self.viewModel.activityCardRspModel.isSpecialStyleVertical = YES;
    if (!HDIsArrayEmpty(self.viewModel.categoryArr)) {
        NSInteger count = self.viewModel.categoryArr.count;
        if (!HDIsArrayEmpty(self.viewModel.activityCardRspModel.list)) {
            count += 1; //有广告 要加上广告的位置
        }
        self.scrollView.contentSize = CGSizeMake(kScreenWidth - kRealWidth(75), count * self.viewModel.kProductsListViewHeight);
    }
}
//查询默认数据
- (void)getDefaultItemData {
    NSString *categoryItemName = kCategotyRecommondItemName;
    if (!HDIsObjectNil(self.viewModel.activityCardRspModel) && !HDIsArrayEmpty(self.viewModel.activityCardRspModel.list)) {
        categoryItemName = kCategotyThemeVenueItemName;
    }
    [self categoryClickToShowProductsViewByCategoryId:categoryItemName index:0 isNeedLoadNewData:NO];
}
#pragma mark -点击分类按钮 显示对应商品列表
- (void)categoryClickToShowProductsViewByCategoryId:(NSString *)categoryId index:(NSInteger)index isNeedLoadNewData:(BOOL)isNeedLoadNewData {
    if (HDIsStringEmpty(categoryId)) {
        return;
    }
    self.currentIndex = [NSString stringWithFormat:@"%ld", index];
    TNVerticalRightProductView *listView = [self.listDict objectForKey:self.currentIndex];
    if (listView == nil) {
        listView = [[TNVerticalRightProductView alloc] initWithViewModel:self.viewModel];
        listView.categoryId = categoryId;
        @HDWeakify(self);
        listView.scrollerShowTopBtnCallBack = ^(BOOL isShow) {
            @HDStrongify(self);
            !self.scrollerShowTopBtnCallBack ?: self.scrollerShowTopBtnCallBack(isShow);
        };
        listView.scrollerViewScrollerToTopCallBack = ^{
            @HDStrongify(self);
            !self.scrollerViewScrollerToTopCallBack ?: self.scrollerViewScrollerToTopCallBack();
        };
        [self.listDict setObject:listView forKey:self.currentIndex];
        listView.frame = CGRectMake(0, index * self.viewModel.kProductsListViewHeight, kScreenWidth - kRealWidth(75), self.viewModel.kProductsListViewHeight);
        [self.scrollView addSubview:listView];
        [listView layoutIfNeeded];
        [listView getNewData];
    } else {
        listView.categoryId = categoryId;
        if (isNeedLoadNewData) {
            [listView getNewData];
        }
    }

    [self.scrollView setContentOffset:CGPointMake(0, index * self.viewModel.kProductsListViewHeight)];

    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:@{@"specialId": self.viewModel.activityId}];
}
- (void)scrollerToTop {
    TNVerticalRightProductView *listView = [self.listDict objectForKey:self.currentIndex];
    if (listView != nil) {
        [listView scrollerToTop];
    }
    [self.leftView scrollerToTop];
}
- (void)keepScollerContentOffset {
    TNVerticalRightProductView *listView = [self.listDict objectForKey:self.currentIndex];
    if (listView != nil) {
        [listView keepScollerContentOffset];
    }
    [self.leftView scrollerToTop];
}
#pragma mark 是否可以滚动
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    TNVerticalRightProductView *listView = [self.listDict objectForKey:self.currentIndex];
    if (listView != nil) {
        listView.canScroll = canScroll;
    }
    self.leftView.canScroll = canScroll;
}
- (void)updateConstraints {
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(kSpecialLeftCategoryWidth);
    }];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(self.leftView.mas_right);
        make.height.mas_equalTo(self.viewModel.kProductsListViewHeight);
    }];
    [super updateConstraints];
}
/** @lazy leftView */
- (TNVerticalLeftCategoryView *)leftView {
    if (!_leftView) {
        _leftView = [[TNVerticalLeftCategoryView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _leftView.categoryClickCallBack = ^(NSString *_Nonnull categoryId, NSInteger index, BOOL isNeedLoadNewData) {
            @HDStrongify(self);
            [self categoryClickToShowProductsViewByCategoryId:categoryId index:index isNeedLoadNewData:isNeedLoadNewData];
        };
        _leftView.scrollerViewScrollerToTopCallBack = ^{
            @HDStrongify(self);
            !self.scrollerViewScrollerToTopCallBack ?: self.scrollerViewScrollerToTopCallBack();
        };
    }
    return _leftView;
}
/** @lazy listDict */
- (NSMutableDictionary<NSString *, TNVerticalRightProductView *> *)listDict {
    if (!_listDict) {
        _listDict = [NSMutableDictionary dictionary];
    }
    return _listDict;
}
@end

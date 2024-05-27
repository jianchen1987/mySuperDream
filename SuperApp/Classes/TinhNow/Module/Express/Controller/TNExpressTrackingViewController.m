//
//  TNExpressTrackingViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  物流跟踪

#import "TNExpressTrackingViewController.h"
#import "TNExpressChildControllerConfig.h"
#import "TNExpressTrackingContentView.h"
#import "TNExpressViewModel.h"


@interface TNExpressTrackingViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 标题数组
@property (strong, nonatomic) NSMutableArray<TNExpressChildControllerConfig *> *configList;
/// 中台统一订单号
@property (nonatomic, strong) NSString *bizOrderId;
/// viewModel
@property (nonatomic, strong) TNExpressViewModel *viewModel;
/// 是否是免邮订单
@property (nonatomic, assign) BOOL isFreeshipping;
@end


@implementation TNExpressTrackingViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.bizOrderId = [parameters objectForKey:@"orderNo"];
        NSNumber *isFreeshipping = [parameters objectForKey:@"isFreeshipping"];
        if (!HDIsObjectNil(isFreeshipping)) {
            self.isFreeshipping = [isFreeshipping boolValue];
        }
        if (HDIsStringEmpty(self.bizOrderId)) {
            return nil;
        }
    }
    return self;
}
- (void)hd_setupViews {
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"ZMMcmb5i", @"物流跟踪");
    self.hd_navShadowColor = [UIColor clearColor];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self.viewModel getNewDataWithOrderNo:self.bizOrderId];
    @HDWeakify(self);
    self.viewModel.networkFailCallBack = ^{
        @HDStrongify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self.viewModel getNewDataWithOrderNo:self.bizOrderId];
        }];
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUI];
    }];
}
- (void)updateUI {
    if (!HDIsArrayEmpty(self.viewModel.rspModel.expressOrder)) {
        self.categoryTitleView.hidden = self.viewModel.rspModel.expressOrder.count == 1 ? YES : NO;
        for (int i = 0; i < self.viewModel.rspModel.expressOrder.count; i++) {
            TNExpressDetailsModel *model = self.viewModel.rspModel.expressOrder[i];
            TNExpressChildControllerConfig *config = [TNExpressChildControllerConfig configWithTitle:[NSString stringWithFormat:@"%@0%d", TNLocalizedString(@"WTups989", @"包裹"), i + 1] model:model];
            [self.configList addObject:config];
        }
        self.categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNExpressChildControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        [self.categoryTitleView reloadData];
        [self.view setNeedsUpdateConstraints];
    } else {
        [self showNoDataPlaceHolderNeedRefrenshBtn:NO refrenshCallBack:nil];
    }
}
- (void)updateViewConstraints {
    if (!self.categoryTitleView.isHidden) {
        [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.height.mas_equalTo(kRealWidth(40));
        }];
    }
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        if (!self.categoryTitleView.isHidden) {
            make.top.equalTo(self.categoryTitleView.mas_bottom);
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNExpressChildControllerConfig *config = self.configList[index];
    TNExpressTrackingContentView *contentView = [[TNExpressTrackingContentView alloc] initWithExpressModel:config.model isFreeshipping:self.isFreeshipping];
    return contentView;
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
}
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 30;
        lineView.indicatorHeight = 2;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
        _categoryTitleView.contentEdgeInsetRight = kRealWidth(15);
        _categoryTitleView.cellSpacing = kRealWidth(20);
        _categoryTitleView.averageCellSpacingEnabled = NO;
    }
    return _categoryTitleView;
}
- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
- (NSMutableArray<TNExpressChildControllerConfig *> *)configList {
    if (!_configList) {
        _configList = [NSMutableArray array];
    }
    return _configList;
}
- (TNExpressViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNExpressViewModel alloc] init];
    }
    return _viewModel;
}
@end

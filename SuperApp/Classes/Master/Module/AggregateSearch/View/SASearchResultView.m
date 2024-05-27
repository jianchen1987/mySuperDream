//
//  SASearchResultView.m
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchResultView.h"
#import "SAAggregateSearchResultCollectionViewController.h"
#import "SAAggregateSearchResultTableViewViewController.h"
#import "SAAggregateSearchViewControllerConfig.h"
#import "SASearchViewModel.h"


@interface SASearchResultView () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>

/// VM
@property (nonatomic, strong) SASearchViewModel *viewModel;

/// 标题滚动 View
@property (nonatomic, strong) HDCategoryNumberView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 所有标题
@property (nonatomic, copy) NSArray<SAAggregateSearchViewControllerConfig *> *configList;
/// 标题栏阴影图层
@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;

/// 分栏下标
@property (nonatomic, strong) NSArray *indexArr;

@end


@implementation SASearchResultView

#pragma mark - SAViewProtocol
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.listContainerView];
    [self addSubview:self.categoryTitleView];
    
    @HDWeakify(self);
    self.categoryTitleView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.categoryTitleViewShadowLayer) {
            [self.categoryTitleViewShadowLayer removeFromSuperlayer];
            self.categoryTitleViewShadowLayer = nil;
        }
        self.categoryTitleViewShadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                                        shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                                          fillColor:UIColor.whiteColor.CGColor
                                                       shadowOffset:CGSizeMake(0, 3)];
    };
    //初始化角标数量
    self.indexArr = @[@(0),@(0),@(0)];
}

- (void)updateConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark public method

- (void)searchListForKeyWord:(NSString *)keyword {

    //获取下标数
    @HDWeakify(self);
    [self.viewModel searchWithKeyWord:keyword complete:^(NSArray * arr) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.indexArr = arr;
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL result = NO;
                for (NSInteger i = 0; i < self.indexArr.count; i++) {
                    if([self.indexArr[i] intValue]){
                        [self.categoryTitleView selectItemAtIndex:i];
//                        [self.listContainerView didClickSelectedItemAtIndex:i];
                        result = YES;
                        break;
                    }
                }
                if(!result){
                    SAAggregateSearchResultViewController *vc = self.configList[self.categoryTitleView.selectedIndex].vc;
                    [vc getNewDataWithKeyWord:keyword];
                }
            });
        });
    }];
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    SAAggregateSearchResultViewController *listVC = self.configList[index].vc;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.viewController.hd_interactivePopDisabled = index > 0;
    if (HDIsStringNotEmpty(self.viewModel.keyword)) {
        NSMutableArray *arr = self.indexArr.mutableCopy;
        arr[index] = @(0);
        self.categoryTitleView.counts = arr;
        [self.categoryTitleView reloadDataWithoutListContainer];
        self.indexArr = arr.mutableCopy;
        SAAggregateSearchResultViewController *vc = self.configList[index].vc;
        [vc getNewDataWithKeyWord:self.viewModel.keyword];
    }
}

#pragma mark - lazy load
- (HDCategoryNumberView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryNumberView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAAggregateSearchViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title.desc;
        }];
        
        _categoryTitleView.numberBackgroundColor = UIColor.sa_C1;
        _categoryTitleView.numberLabelOffset = CGPointMake(0, -10);
        _categoryTitleView .numberStringFormatterBlock = ^NSString *(NSInteger number) {
                if (number > 99) {
                    return @"99+";
                }
                return [NSString stringWithFormat:@"%ld", number];
            };
        
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [UIColor hd_colorWithHexString:@"#FC2040"];
        lineView.indicatorHeight = kRealHeight(4);
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
        
        _categoryTitleView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _categoryTitleView.titleColor = [UIColor hd_colorWithHexString:@"#666666"];
        _categoryTitleView.titleSelectedFont = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        _categoryTitleView.titleSelectedColor = [UIColor hd_colorWithHexString:@"#333333"];
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSArray<SAAggregateSearchViewControllerConfig *> *)configList {
    if (!_configList) {
        NSMutableArray<SAAggregateSearchViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:4];
        SAInternationalizationModel *title = [SAInternationalizationModel modelWithInternationalKey:@"Coupon_bl_YumNow" value:@"外卖" table:nil];
        SAAggregateSearchResultViewController *vc = [[SAAggregateSearchResultTableViewViewController alloc] initWithRouteParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|聚合搜索"] : @"聚合搜索",
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.businessLine = SAClientTypeYumNow;
        vc.currentlyAddress = self.viewModel.currentlyAddress;
        SAAggregateSearchViewControllerConfig *config = [SAAggregateSearchViewControllerConfig configWithTitle:title vc:vc];
        
        [configList addObject:config];
        
        title = [SAInternationalizationModel modelWithInternationalKey:@"Coupon_bl_TinhNow" value:@"电商" table:nil];
        vc = [[SAAggregateSearchResultCollectionViewController alloc] initWithRouteParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|聚合搜索"] : @"聚合搜索",
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.businessLine = SAClientTypeTinhNow;
        vc.currentlyAddress = self.viewModel.currentlyAddress;
        config = [SAAggregateSearchViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];
        
        title = [SAInternationalizationModel modelWithInternationalKey:@"Coupon_bl_GroupBuy1" value:@"本地生活" table:nil];
        vc = [[SAAggregateSearchResultTableViewViewController alloc] initWithRouteParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|聚合搜索"] : @"聚合搜索",
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.businessLine = SAClientTypeGroupBuy;
        vc.currentlyAddress = self.viewModel.currentlyAddress;
        config = [SAAggregateSearchViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];
        
        _configList = configList;
    }
    return _configList;
}

@end

//
//  WMStoreFilterView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterView.h"
#import "SACacheManager.h"
#import "SATalkingData.h"
#import "SAWriteDateReadableModel.h"
#import "WMCategoryItem.h"
#import "WMHorizontalTreeView.h"
#import "WMStoreFilterButton.h"
#import "WMStoreFilterModel.h"
#import "WMTraceableAssociatedModel.h"


@interface WMStoreFilterView ()
/// 存放所有按钮
@property (nonatomic, strong) HDGridView *containerView;
/// 数据源
@property (nonatomic, copy) NSArray<WMTraceableAssociatedModel *> *dataSource;
/// 当前选中的按钮
@property (nonatomic, strong) WMStoreFilterButton *currentSelectedButton;
/// 筛选模型
@property (nonatomic, strong) WMStoreFilterModel *filterModel;
/// 分类默认标题
@property (nonatomic, copy) NSString *categoryBTNDefaultTitle;
/// 阴影
@property (nonatomic, strong) CAShapeLayer *shadowLayer;
/// 排序
@property (nonatomic, copy) NSArray<WMStoreFilterTableViewCellModel *> *sortTypeDataSource;
/// 品类
@property (nonatomic, copy) NSArray<WMStoreFilterTableViewCellModel *> *merchantCategoryDataSource;
/// 品类配置模型
@property (nonatomic, strong) WMStoreFilterNavModel *categoryFilterNavModel;
/// 品类
@property (nonatomic, copy) NSString *businessScope;
/// 品类数据获取成功
@property (nonatomic, copy) void (^successGetCategoryListHandler)(void);
@end


@implementation WMStoreFilterView
- (instancetype)initWithBusinessScope:(NSString *)businessScope {
    if (self = [super init]) {
        self.businessScope = businessScope;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.containerView = ({
        HDGridView *view = HDGridView.new;
        [self addSubview:view];
        view;
    });

    for (WMTraceableAssociatedModel *traceableAssociatedModel in self.dataSource) {
        WMStoreFilterNavModel *model = traceableAssociatedModel.associatedObject;
        WMStoreFilterButton *button = [self buttonWithTitle:model.dataSource.firstObject.title image:model.image functionModel:traceableAssociatedModel];
        [self.containerView addSubview:button];
        if ([model.type isEqualToString:WMStoreFilterNavTypeCategory] && HDIsStringNotEmpty(self.categoryBTNDefaultTitle)) {
            [button setTitle:self.categoryBTNDefaultTitle forState:UIControlStateNormal];
        }
    }
    self.containerView.columnCount = 2;

    @HDWeakify(self);
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        if (CGRectIsValidated(view.frame)) {
            @HDStrongify(self);
            // 设置阴影圆角
            if (self.shadowLayer) {
                [self.shadowLayer removeFromSuperlayer];
                self.shadowLayer = nil;
            }
            self.shadowLayer = [self setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                           shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                             fillColor:UIColor.whiteColor.CGColor
                                          shadowOffset:CGSizeMake(0, 5)];
        }
    };
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - private methods
- (WMStoreFilterButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image functionModel:(WMTraceableAssociatedModel *)functionModel {
    WMStoreFilterButton *button = [WMStoreFilterButton buttonWithType:UIButtonTypeCustom];
    button.associatedObject = functionModel;
    //    button.hd_eventTimeInterval = CGFLOAT_MIN;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = HDAppTheme.font.standard3;
    [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
    [button setTitleColor:HDAppTheme.color.C1 forState:UIControlStateSelected];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[image hd_imageWithTintColor:HDAppTheme.color.C1] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickedButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (WMStoreFilterButton *)buttonForType:(WMStoreFilterNavType)type {
    WMStoreFilterButton *button;
    for (WMStoreFilterButton *btn in self.containerView.subviews) {
        WMTraceableAssociatedModel *traceModel = btn.associatedObject;
        WMStoreFilterNavModel *navModel = traceModel.associatedObject;
        if (navModel.type == type) {
            button = btn;
            break;
        }
    }
    return button;
}

- (NSArray<WMStoreFilterTableViewCellModel *> *)sortTypeDataSource {
    if (!_sortTypeDataSource) {
        NSMutableArray<WMStoreFilterTableViewCellModel *> *dataSource = [NSMutableArray array];
        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"98qt1uye", @"综合排序") associatedParamsModel:@""];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Nearest", @"距离最近") associatedParamsModel:@"MS_004"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Best_sell", @"销量最高") associatedParamsModel:@"MS_001"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Good_rates", @"好评优先") associatedParamsModel:@"MS_003"];
        [dataSource addObject:model];

        _sortTypeDataSource = dataSource.copy;
    }

    return _sortTypeDataSource;
}

- (NSArray<WMStoreFilterTableViewCellModel *> *)merchantCategoryDataSource {
    if (!_merchantCategoryDataSource) {
        NSMutableArray<WMStoreFilterTableViewCellModel *> *list = [NSMutableArray array];
        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"title_all", @"全部") associatedParamsModel:nil];

        SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyMerchantKind];
        NSArray<WMCategoryItem *> *cachedList = [NSArray yy_modelArrayWithClass:WMCategoryItem.class json:cacheModel.storeObj];
        @autoreleasepool {
            NSMutableArray<WMStoreFilterTableViewCellModel *> *subArrList = [NSMutableArray arrayWithCapacity:model.subArrList.count + 1];
            WMStoreFilterTableViewCellModel *totalSubCellModel = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"title_all", @"全部") associatedParamsModel:nil];
            totalSubCellModel.superTitle = WMLocalizedString(@"title_all", @"全部");
            [subArrList addObject:totalSubCellModel];

            for (WMCategoryItem *item in cachedList) {
                [subArrList addObjectsFromArray:[item.subClassifications mapObjectsUsingBlock:^id _Nonnull(WMCategoryItem *_Nonnull obj, NSUInteger idx) {
                                return [WMStoreFilterTableViewCellModel modelWithTitle:obj.message.desc associatedParamsModel:obj];
                            }]];
            }
            model.subArrList = subArrList;
            [list addObject:model];
        }

        @autoreleasepool {
            for (WMCategoryItem *item in cachedList) {
                model = [WMStoreFilterTableViewCellModel modelWithTitle:item.message.desc associatedParamsModel:item];
                NSMutableArray<WMStoreFilterTableViewCellModel *> *subArrList = [NSMutableArray arrayWithCapacity:model.subArrList.count + 1];
                WMStoreFilterTableViewCellModel *subCellModel = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"title_all", @"全部") associatedParamsModel:item];
                if (HDIsStringNotEmpty(self.businessScope) && [self.businessScope isEqualToString:item.scopeCode]) {
                    model.selected = true;
                    subCellModel.selected = true;
                    self.categoryBTNDefaultTitle = item.message.desc;
                    self.filterModel.businessScope = item.scopeCode;
                }
                subCellModel.superTitle = item.message.desc;
                [subArrList addObject:subCellModel];

                [subArrList addObjectsFromArray:[item.subClassifications mapObjectsUsingBlock:^id _Nonnull(WMCategoryItem *_Nonnull obj, NSUInteger idx) {
                                return [WMStoreFilterTableViewCellModel modelWithTitle:obj.message.desc associatedParamsModel:obj];
                            }]];
                model.subArrList = subArrList;
                [list addObject:model];
            }
        }
        _merchantCategoryDataSource = list.copy;
    }
    return _merchantCategoryDataSource;
}

#pragma mark - public methods
- (void)clearCurrentSelectedButton {
    self.currentSelectedButton = nil;
}

- (void)simulateClickCurrentTabForType:(WMStoreFilterNavType)type {
    WMStoreFilterButton *button = [self buttonForType:type];
    if (button) {
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)updateTitle:(NSString *)title forType:(WMStoreFilterNavType)type {
    // 超过部分显示...
    NSString *name = title.copy;
    NSUInteger limitCount = [name hd_doesContainChinese] ? 4 : 8;
    if (name.length > limitCount) {
        name = [[name substringToIndex:limitCount] stringByAppendingString:@"..."];
    }

    WMStoreFilterButton *button = [self buttonForType:type];
    if (button) {
        [button setTitle:name forState:UIControlStateNormal];
        [button.superview setNeedsUpdateConstraints];
    }
}

- (void)successGetCategoryList {
    // 触发懒加载
    self.merchantCategoryDataSource = nil;
    self.categoryFilterNavModel.dataSource = self.merchantCategoryDataSource;

    if (HDIsStringNotEmpty(self.businessScope)) {
        !self.refreshStoreListBlock ?: self.refreshStoreListBlock();
    }

    // 更新品类选中标题
    for (WMStoreFilterButton *button in self.containerView.subviews) {
        WMTraceableAssociatedModel *buttonAssociatedObject = button.associatedObject;
        WMStoreFilterNavModel *model = buttonAssociatedObject.associatedObject;
        if ([model.type isEqualToString:WMStoreFilterNavTypeCategory] && HDIsStringNotEmpty(self.categoryBTNDefaultTitle)) {
            [button setTitle:self.categoryBTNDefaultTitle forState:UIControlStateNormal];
            break;
        }
    }
    !self.successGetCategoryListHandler ?: self.successGetCategoryListHandler();
}

#pragma mark - getters and setters
- (WMStoreFilterNavModel *)currentFilterModel {
    WMTraceableAssociatedModel *buttonAssociatedObject = self.currentSelectedButton.associatedObject;

    if (!buttonAssociatedObject)
        return nil;

    WMStoreFilterNavModel *associatedObject = buttonAssociatedObject.associatedObject;

    return associatedObject;
}

#pragma mark - event response
/** 点击了按钮 */
- (void)clickedButtonHandler:(WMStoreFilterButton *)button {
    if (button.isSelected) {
        button.selected = false;
        return;
    }

    button.selected = true;
    self.currentSelectedButton.selected = false;
    self.currentSelectedButton = button;

    WMTraceableAssociatedModel *buttonAssociatedObject = button.associatedObject;
    WMStoreFilterNavModel *associatedObject = buttonAssociatedObject.associatedObject;

    if (!button.isSelected) {
        [SATalkingData trackEvent:@"商户搜索_点击" label:buttonAssociatedObject.trackName];
    }

    void (^showActionView)(void) = ^(void) {
        HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
        config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), 0, kRealWidth(15));
        config.contentHorizontalEdgeMargin = 0;
        config.title = associatedObject.title;
        config.style = HDCustomViewActionViewStyleClose;
        config.iPhoneXFillViewBgColor = UIColor.whiteColor;
        config.shouldAddScrollViewContainer = false;
        const CGFloat width = kScreenWidth - 2 * config.contentHorizontalEdgeMargin;
        WMHorizontalTreeView *view = [[WMHorizontalTreeView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
        view.dataSource = associatedObject.dataSource;

        view.minHeight = kScreenHeight * 0.4;
        view.maxHeight = kScreenHeight * 0.8;

        [view layoutyImmediately];
        HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

        @HDWeakify(actionView);
        @HDWeakify(self);
        view.didSelectMainTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
        };

        view.didSelectSubTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
            @HDStrongify(actionView);
            [actionView dismiss];

            id associatedParamsModel = model.associatedParamsModel;
            if ([associatedParamsModel isKindOfClass:NSString.class]) {
                if (![associatedParamsModel isEqualToString:WMLocalizedString(@"title_all", @"全部")]) {
                    self.filterModel.sortType = associatedParamsModel;
                } else {
                    self.filterModel.businessScope = nil;
                }
            } else if ([associatedParamsModel isKindOfClass:WMCategoryItem.class]) {
                WMCategoryItem *item = (WMCategoryItem *)associatedParamsModel;
                self.filterModel.businessScope = item.scopeCode;
            } else {
                self.filterModel.businessScope = nil;
            }

            // 更新标题
            NSString *title = model.title;
            if ([title isEqualToString:WMLocalizedString(@"title_all", @"全部")] && HDIsStringNotEmpty(model.superTitle)) {
                title = model.superTitle;
            }
            [self.currentSelectedButton setTitle:title forState:UIControlStateNormal];

            if ([self.delegate respondsToSelector:@selector(storeFilterViewDidSelectedOption:)]) {
                [self.delegate storeFilterViewDidSelectedOption:self];
            }
        };
        actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
            @HDStrongify(self);
            if (self.currentSelectedButton.isSelected) {
                [self.currentSelectedButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        };
        [actionView show];
    };

    // 判断品类数据是否已经获取到
    SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyMerchantKind];
    NSArray<WMCategoryItem *> *cachedList = [NSArray yy_modelArrayWithClass:WMCategoryItem.class json:cacheModel.storeObj];
    if ([associatedObject.type isEqualToString:WMStoreFilterNavTypeCategory] && (HDIsArrayEmpty(cachedList) || cachedList.count <= 1)) {
        !self.requestCategoryListBlock ?: self.requestCategoryListBlock();
        self.successGetCategoryListHandler = showActionView;
        return;
    }

    showActionView();
}

#pragma mark - lazy load
- (NSArray<WMTraceableAssociatedModel *> *)dataSource {
    if (!_dataSource) {
        NSMutableArray<WMTraceableAssociatedModel *> *dataSource = [NSMutableArray array];
        WMStoreFilterNavModel *navModel;
        WMTraceableAssociatedModel *traceableAssociatedModel;

        navModel = [WMStoreFilterNavModel merchantFilterNavModelWithType:WMStoreFilterNavTypeCategory title:WMLocalizedString(@"scope_of_business", @"品类")
                                                                   image:[UIImage imageNamed:@"filter_sortType"]];
        traceableAssociatedModel = [WMTraceableAssociatedModel traceableAssociatedModel:navModel trackName:@"品类"];
        navModel.dataSource = self.merchantCategoryDataSource;
        [dataSource addObject:traceableAssociatedModel];
        self.categoryFilterNavModel = navModel;

        navModel = [WMStoreFilterNavModel merchantFilterNavModelWithType:WMStoreFilterNavTypeSortType title:WMLocalizedString(@"home_sort_by", @"排序") image:[UIImage imageNamed:@"filter_category"]];
        traceableAssociatedModel = [WMTraceableAssociatedModel traceableAssociatedModel:navModel trackName:@"排序"];

        navModel.dataSource = self.sortTypeDataSource;
        [dataSource addObject:traceableAssociatedModel];

        _dataSource = dataSource.mutableCopy;
    }
    return _dataSource;
}

- (WMStoreFilterModel *)filterModel {
    if (!_filterModel) {
        _filterModel = WMStoreFilterModel.new;
        _filterModel.sortType = @"";
        _filterModel.businessScope = @"";
        _filterModel.inRange = SABoolValueTrue;
    }
    return _filterModel;
}
@end

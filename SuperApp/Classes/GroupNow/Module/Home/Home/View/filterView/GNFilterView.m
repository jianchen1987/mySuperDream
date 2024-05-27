//
//  GNFilterView.m
//  SuperApp
//
//  Created by wmz on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNFilterView.h"
#import "SAInternationalizationModel.h"
#import "WMAppTheme.h"
#import "WMCustomerSlideDownView.h"
#import "WMHorizontalTreeView.h"


@interface GNFilterView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// model
@property (nonatomic, strong) GNFilterModel *model;
/// 排序
@property (nonatomic, strong) HDUIButton *sortButton;

@property (nonatomic, strong, nullable) NSArray<WMStoreFilterTableViewCellModel *> *sortTypeDataSource;
/// 下滑窗口
@property (nonatomic, weak) WMCustomerSlideDownView *currentSlideView;

@end


@implementation GNFilterView

- (instancetype)initWithFrame:(CGRect)frame filterModel:(GNFilterModel *)filterModel startOffsetY:(CGFloat)offset {
    self.model = filterModel;
    self.startOffsetY = offset;
    self = [super initWithFrame:frame];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self addSubview:self.sortButton];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(15);
    CGFloat avaliableWith = kScreenWidth - 2 * margin;
    CGFloat btnWidth = avaliableWith / 3.0;
    [self.sortButton sizeToFit];
    [self.sortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
        make.left.mas_equalTo(margin);
        make.center.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.model keyPath:@"sortType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateUIWithModel:self.model];
    }];
}

#pragma mark - public methods
- (void)hideAllSlideDownView {
    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:nil];
    }
}

#pragma mark - setter
- (void)setModel:(GNFilterModel *)model {
    _model = model;
    [self updateUIWithModel:model];
}

#pragma mark - private methods
- (void)updateUIWithModel:(GNFilterModel *)model {
    if (model.sortType != GNHomeSortDefault) {
        [self.sortButton setTitle:[self getLocalizedStringWithSrotType:model.sortType] forState:UIControlStateNormal];
        [self.sortButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
    } else {
        [self.sortButton setTitle:GNLocalizedString(@"gn_default_sorting", @"默认排序") forState:UIControlStateNormal];
        [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    }

    [self setNeedsUpdateConstraints];
}

- (NSString *)getLocalizedStringWithSrotType:(GNHomeSortType)type {
    if ([type isEqualToString:GNHomeSortDefault]) {
        return GNLocalizedString(@"gn_default_sorting", @"默认排序");
    } else if ([type isEqualToString:GNHomeSortSales]) {
        return GNLocalizedString(@"gn_sort_by_sales", @"销量排序");
    } else if ([type isEqualToString:GNHomeSortScore]) {
        return GNLocalizedString(@"gn_sort_by_score", @"评分排序");
    } else if ([type isEqualToString:GNHomeSortDistance]) {
        return GNLocalizedString(@"gn_sort_by_distance", @"距离排序");
    } else if ([type isEqualToString:GNHomeSortPrice]) {
        return GNLocalizedString(@"gn_low_price_first", @"低价优先");
    } else {
        return @"";
    }
}

- (void)clickOnSort:(HDUIButton *)sortButton {
    if (self.sortButton.isSelected) {
        [self.currentSlideView dismissCompleted:nil];
        return;
    }

    void (^showActionView)(NSArray<WMStoreFilterTableViewCellModel *> *) = ^(NSArray<WMStoreFilterTableViewCellModel *> *categorys) {
        WMHorizontalTreeView *view = [[WMHorizontalTreeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.cellHeight = kRealWidth(50);
        view.dataSource = categorys;
        view.minHeight = kScreenHeight * 0.2;
        view.maxHeight = kScreenHeight * 0.6;
        [view layoutyImmediately];

        WMCustomerSlideDownView *slideDownView = [[WMCustomerSlideDownView alloc] initWithStartOffsetY:self.startOffsetY customerView:view];
        slideDownView.slideDownViewWillAppear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.sortButton setSelected:YES];
        };
        slideDownView.slideDownViewWillDisappear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.sortButton setSelected:NO];
        };
        self.currentSlideView = slideDownView;
        @HDWeakify(slideDownView);
        @HDWeakify(self);
        view.didSelectSubTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
            @HDStrongify(self);
            @HDStrongify(slideDownView);
            id associatedParamsModel = model.associatedParamsModel;
            NSString *title = nil;
            if ([associatedParamsModel isKindOfClass:NSString.class]) {
                if ([associatedParamsModel length] && associatedParamsModel != GNHomeSortDefault) {
                    self.model.sortType = associatedParamsModel;
                    title = model.title;
                    [self.sortButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                } else {
                    self.model.sortType = GNHomeSortDefault;
                    title = GNLocalizedString(@"gn_default_sorting", @"默认排序");
                    [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
                }
                [self.sortButton setTitle:title forState:UIControlStateNormal];
            }
            if (self.viewWillDisappear) {
                self.viewWillDisappear(self);
            }

            [slideDownView dismissCompleted:nil];
        };

        if (self.viewWillAppear) {
            self.viewWillAppear(self);
        }

        [slideDownView show];
    };

    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:^{
            showActionView(self.sortTypeDataSource);
        }];
    } else {
        showActionView(self.sortTypeDataSource);
    }
}

///重置筛选条件
- (void)resetAll {
    self.model.sortType = GNHomeSortDefault;
    [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
    [self.sortButton setTitle:WMLocalizedString(@"gn_default_sorting", @"默认排序") forState:UIControlStateNormal];
    self.sortTypeDataSource = nil;
}

#pragma mark - lazy load
/** @lazy sortButton */
- (HDUIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [[HDUIButton alloc] init];
        _sortButton.imagePosition = HDUIButtonImagePositionRight;
        _sortButton.titleLabel.font = HDAppTheme.font.standard3;
        _sortButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _sortButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_sortButton setImage:[UIImage imageNamed:@"yn_home_u"] forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"yn_home_d"] forState:UIControlStateSelected];
        [_sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(clickOnSort:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (NSArray<WMStoreFilterTableViewCellModel *> *)sortTypeDataSource {
    if (!_sortTypeDataSource) {
        NSMutableArray<WMStoreFilterTableViewCellModel *> *dataSource = [NSMutableArray array];
        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithTitle:GNLocalizedString(@"gn_default_sorting", @"默认排序") associatedParamsModel:@"GUST001"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:GNLocalizedString(@"gn_sort_by_sales", @"销量排序") associatedParamsModel:@"GUST002"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:GNLocalizedString(@"gn_sort_by_score", @"评分排序") associatedParamsModel:@"GUST003"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:GNLocalizedString(@"gn_sort_by_distance", @"距离排序") associatedParamsModel:@"GUST004"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:GNLocalizedString(@"gn_low_price_first", @"低价优先") associatedParamsModel:@"GUST005"];
        [dataSource addObject:model];

        [dataSource enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.titleColor = HDAppTheme.WMColor.B3;
            obj.titleSelectColor = HDAppTheme.color.gn_mainColor;
            obj.canSelect = YES;
            obj.titleFont = [HDAppTheme.font gn_boldForSize:16];
            obj.titleSelectFont = [HDAppTheme.font gn_boldForSize:16];
        }];
        _sortTypeDataSource = dataSource.copy;
    }

    return _sortTypeDataSource;
}
@end

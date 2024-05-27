//
//  YumNowStoreListFilterHeaderView.m
//  SuperApp
//
//  Created by seeu on 2023/12/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "YumNowStoreListFilterHeaderView.h"
#import <HDUIKit/HDUIKit.h>
#import "WMNearbyFilterBarView.h"
#import "WMNearbyFilterModel.h"

@interface YumNowStoreListFilterHeaderView ()<HDCategoryViewDelegate>

@property (nonatomic, strong) HDCategoryIconTitleView *titleView;
///< 筛选组件
@property (nonatomic, strong) WMNearbyFilterBarView *filterBarView;
///< 筛选模型
@property (nonatomic, strong) WMNearbyFilterModel *filterModel;
///< 高度
@property (nonatomic, assign) CGFloat startOffsetY;
@end

@implementation YumNowStoreListFilterHeaderView

- (void)hd_setupViews {
    [self addSubview:self.titleView];
    [self addSubview:self.filterBarView];
}


- (void)setModel:(YumNowStoreListFilterHeaderViewModel *)model {
    _model = model;
    
    self.titleView.titleFont = [UIFont systemFontOfSize:model.categoryFont weight:UIFontWeightRegular];
    self.titleView.titleSelectedFont = [UIFont systemFontOfSize:model.categoryFont weight:UIFontWeightBold];
    self.titleView.titleColor = [UIColor hd_colorWithHexString: model.categoryDefaultColor];
    self.titleView.titleSelectedColor = [UIColor hd_colorWithHexString:model.categoryColor];
    self.titleView.separatorLineColor = [UIColor hd_colorWithHexString:model.categoryBottomLineColor];
    self.titleView.relativePosition = HDCategoryIconRelativePositionTop;
    self.titleView.averageCellSpacingEnabled = NO;
    self.titleView.iconSize = model.iconSize;
    self.titleView.titleLabelZoomEnabled = NO;
    self.titleView.titleNumberOfLines = 2;
    self.titleView.cellWidth = kRealWidth(64);
    self.titleView.cellSpacing = 8;
    self.titleView.iconCornerRadius = 0;
    
    
    if(model.style == YumNowStoreListCategoryStyleIconOnly || model.style == YumNowStoreListCategoryStyleIconText) {
        self.titleView.icons = [model.iconUrls copy];
    }
    if(model.style == YumNowStoreListCategoryStyleTextOnly || model.style == YumNowStoreListCategoryStyleIconText) {
        self.titleView.titles = [model.titles copy];
    } else {
        self.titleView.titles = [model.iconUrls mapObjectsUsingBlock:^id _Nonnull(NSString * _Nonnull obj, NSUInteger idx) {
            return @"";
        }];
    }
    
    if(model.style == YumNowStoreListCategoryStyleTextOnly) {
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDIsStringNotEmpty(model.categoryBottomLineColor) ? [UIColor hd_colorWithHexString:model.categoryBottomLineColor] : HDAppTheme.color.C1;
        self.titleView.indicators = @[lineView];
    }

    [self.titleView reloadDataWithoutListContainer];
    
    self.filterBarView.startOffsetY = kNavigationBarH + model.viewHeight;
    
    if(model.showFiltterComponent) {
        self.filterBarView.hidden = NO;
    } else {
        self.filterBarView.hidden = YES;
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
    if(self.model.clearFilterOnTitleClicked) {
        self.filterModel.category = nil;
        self.filterModel.sortType = WMNearbyStoreSortTypeNone;
        self.filterModel.storeFeature = @[];
        self.filterModel.tags = @[];
        self.filterModel.marketingTypes = @[];
    }
    
    !self.titleDidSelected ?: self.titleDidSelected(index, self.filterModel);
}

#pragma mark - getter
- (CGFloat)startOffsetY {
    if (!_startOffsetY) {
        _startOffsetY = kNavigationBarH + kRealWidth(36) + kRealWidth(51);
    }
    return _startOffsetY;
}

- (void)updateConstraints {
    
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(85));
        if(self.filterBarView.isHidden) {
            make.bottom.equalTo(self);
        }
    }];
    
    if(!self.filterBarView.isHidden) {
        [self.filterBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleView);
            make.top.equalTo(self.titleView.mas_bottom);
            make.height.mas_equalTo(kRealWidth(36));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    
    [super updateConstraints];
}

- (HDCategoryIconTitleView *)titleView {
    if(!_titleView) {
        _titleView = [[HDCategoryIconTitleView alloc] init];
        _titleView.delegate = self;
        _titleView.backgroundColor = UIColor.whiteColor;
    }
    return _titleView;
}

- (WMNearbyFilterBarView *)filterBarView {
    if (!_filterBarView) {
        _filterBarView = [[WMNearbyFilterBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(36)) filterModel:self.filterModel startOffsetY:kNavigationBarH];
        @HDWeakify(self);
        _filterBarView.viewWillAppear = ^(UIView *_Nonnull view) {
            @HDStrongify(self);
            !self.filterViewWillAppear ?: self.filterViewWillAppear(view);
        };
        
        _filterBarView.viewWillDisappear = ^(UIView * _Nonnull view) {
            @HDStrongify(self);
            !self.filterViewWillDisAppear ?: self.filterViewWillDisAppear(view, self.filterModel);
        };
    }
    return _filterBarView;
}


- (WMNearbyFilterModel *)filterModel {
    return _filterModel ?: ({ _filterModel = WMNearbyFilterModel.new; });
}

@end


@implementation YumNowStoreListFilterHeaderViewModel


@end

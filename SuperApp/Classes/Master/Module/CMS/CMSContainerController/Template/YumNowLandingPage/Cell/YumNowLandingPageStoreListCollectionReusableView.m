//
//  YumNowLandingPageStoreListCollectionReusableView.m
//  SuperApp
//
//  Created by VanJay on 2023/12/4.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "YumNowLandingPageStoreListCollectionReusableView.h"
#import <HDUIKit/HDUIKit.h>
#import "YumNowStoreListFilterHeaderView.h"

@interface YumNowLandingPageStoreListCollectionReusableView ()
///< headerView
@property (nonatomic, strong) YumNowStoreListFilterHeaderView *headerView;

@end

@implementation YumNowLandingPageStoreListCollectionReusableView
#pragma mark - life cycle
- (void)commonInit {
    [self hd_setupViews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerView];
}

- (void)reset {
    self.headerView = nil;
    [self addSubview:self.headerView];
}

- (void)setModel:(YumNowLandingPageStoreListCollectionReusableViewModel *)model {
    _model = model;
    
    YumNowStoreListFilterHeaderViewModel *headerModel = YumNowStoreListFilterHeaderViewModel.new;
    
    headerModel.categoryFont = model.categoryFont;
    headerModel.categoryDefaultColor = model.categoryDefaultColor;
    headerModel.categoryColor = model.categoryColor;
    headerModel.categoryBottomLineColor = model.categoryBottomLineColor;
    headerModel.showFiltterComponent = model.sortFilter;
    headerModel.viewHeight = model.viewHeight;
    switch (model.showLabel) {
        case YumNowLandingPageCategoryStyleTextOnly:
            headerModel.style = YumNowStoreListCategoryStyleTextOnly;
            break;
        case YumNowLandingPageCategoryStyleIconOnly:
            headerModel.style = YumNowStoreListCategoryStyleIconOnly;
            break;
        case YumNowLandingPageCategoryStyleIconText:
            headerModel.style = YumNowStoreListCategoryStyleIconText;
            break;
            
        default:
            headerModel.style = YumNowStoreListCategoryStyleTextOnly;
            break;
    }
    headerModel.iconSize = CGSizeMake(44, 44);
    headerModel.titles = [model.categoryModels mapObjectsUsingBlock:^id _Nonnull(SAYumNowLandingPageCategoryModel * _Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    headerModel.iconUrls = [model.categoryModels mapObjectsUsingBlock:^id _Nonnull(SAYumNowLandingPageCategoryModel * _Nonnull obj, NSUInteger idx) {
        return obj.iconUrl;
    }];

    self.headerView.model = headerModel;
        
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (YumNowStoreListFilterHeaderView *)headerView {
    if(!_headerView) {
        _headerView = [[YumNowStoreListFilterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(85) + kRealWidth(36))];
        @HDWeakify(self);
        _headerView.filterViewWillAppear = ^(UIView * _Nonnull filterView) {
            @HDStrongify(self);
            !self.filterViewWillAppear ?: self.filterViewWillAppear(self);
        };

        _headerView.filterViewWillDisAppear = ^(UIView * _Nonnull filterView, WMNearbyFilterModel * _Nonnull option) {
            @HDStrongify(self);
            !self.filterViewWillDisAppear ?: self.filterViewWillDisAppear(self, option);
            
        };
        
        _headerView.titleDidSelected = ^(NSInteger index, WMNearbyFilterModel * _Nonnull option) {
            @HDStrongify(self);
            !self.categoryTitleClicked ?: self.categoryTitleClicked(self, index, option);
        };
    }
    return _headerView;
}


@end

@implementation YumNowLandingPageStoreListCollectionReusableViewModel


@end

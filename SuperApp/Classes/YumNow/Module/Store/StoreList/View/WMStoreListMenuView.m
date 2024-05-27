//
//  WMStoreListMenuView.m
//  SuperApp
//
//  Created by wmz on 2021/7/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMStoreListMenuView.h"
#import "WMStoreFilterTableViewCellModel.h"
#import "WMCustomerSlideDownView.h"
#import "WMHorizontalTreeView.h"
#import "WMNearbyFilterBarView.h"
#import "SAAddressModel.h"
#import "SAAddressCacheAdaptor.h"

@interface WMStoreListMenuView ()
/// menu
@property (nonatomic, strong) UIScrollView *menuScrollView;
/// allItemView
@property (nonatomic, strong) WMStoreListMenuItemView *allItemView;
/// menu
@property (nonatomic, strong) UIImageView *gl;
/// 综合排序
@property (nonatomic, strong) HDUIButton *sortButton;

@property (nonatomic, strong, nullable) NSArray<WMStoreFilterTableViewCellModel *> *sortTypeDataSource;

/// 筛选按钮
@property (nonatomic, strong) HDUIButton *filterButton;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) NSArray<WMNearbyFilterBarViewFilterModel *> *filterDataSource;

/// 下滑窗口
@property (nonatomic, weak) WMCustomerSlideDownView *currentSlideView;

@end


@implementation WMStoreListMenuView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.sortButton];
    [self addSubview:self.filterButton];
    [self addSubview:self.numberLabel];
    
    [self addSubview:self.allItemView];
    [self addSubview:self.menuScrollView];
    [self addSubview:self.gl];
    [self.menuScrollView addSubview:self.lineView];

    
    [self getFilterData];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.allItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(36));
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kRealWidth(68));
//        make.height.equalTo(self);
        make.height.mas_equalTo(kRealWidth(84));
    }];

    [self.menuScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.top.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(-kRealWidth(36));
        make.left.mas_equalTo(kRealWidth(5));
        make.right.equalTo(self.allItemView.mas_left);
        make.height.mas_equalTo(kRealWidth(84));
    }];

    [self.gl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.allItemView.mas_left);
        //        make.top.bottom.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(-kRealWidth(36));
        make.width.mas_equalTo(kRealWidth(16));
    }];
    
    CGFloat margin = kRealWidth(15);
    CGFloat avaliableWith = kScreenWidth - 3 * margin;

    if (!self.numberLabel.hidden) {
        [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.equalTo(self.filterButton.mas_centerY);
            make.right.mas_equalTo(-margin);
        }];
        avaliableWith -= 16;
    }
    
    CGFloat btnWidth = avaliableWith / 2;
    [self.sortButton sizeToFit];
    [self.sortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(kRealWidth(36));
        make.bottom.mas_equalTo(0);
    }];

    [self.filterButton sizeToFit];
    [self.filterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sortButton.mas_right).offset(margin);
        make.centerY.equalTo(self.sortButton.mas_centerY);
        make.width.mas_equalTo(btnWidth);
        make.top.mas_equalTo(self.sortButton);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)setAllModel:(WMCategoryItem *)allModel {
    _allModel = allModel;
    self.allItemView.model = allModel;
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    self.allItemView.userInteractionEnabled = YES;
    [self.allItemView addGestureRecognizer:ta];
}

- (void)setModel:(WMCategoryItem *)model {
    _model = model;
    self.dataSource = NSMutableArray.new;
    [self.menuScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.menuScrollView addSubview:self.lineView];
    WMStoreListMenuItemView *temp = nil;
    self.selectView = self.allItemView;
    for (WMCategoryItem *item in model.subClassifications) {
        WMStoreListMenuItemView *itemView = WMStoreListMenuItemView.new;
        [self.menuScrollView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!temp) {
                make.left.equalTo(self.menuScrollView.mas_left);
            } else {
                make.left.equalTo(temp.mas_right);
            }
            make.width.mas_equalTo(kRealWidth(64));
//            make.height.top.bottom.equalTo(self);
//            make.top.bottom.equalTo(self);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(100));
        }];
        temp = itemView;
        itemView.model = item;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer:ta];
        [self.dataSource addObject:itemView];
        if (item.isSelected) {
            self.selectView = itemView;
        }
    }
    [self.dataSource addObject:self.allItemView];
    [self.menuScrollView layoutIfNeeded];
    self.menuScrollView.contentSize = CGSizeMake(kRealWidth(64) * model.subClassifications.count, 0);
    self.menuScrollView.scrollEnabled = YES;
    if (self.selectView != self.allItemView) {
        [self scrollAction:self.selectView];
    }
}

- (void)updateAlpah:(CGFloat)num {
    BOOL all = (self.selectView == self.allItemView);
    if (!all) {
        if (![self.menuScrollView.subviews containsObject:self.lineView]) {
            [self.menuScrollView addSubview:self.lineView];
        }
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.menuScrollView.mas_left).offset(self.selectView.hd_left + kRealWidth(16));
            make.width.mas_equalTo(kRealWidth(32));
//            make.bottom.equalTo(self.mas_bottom);
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(36));
            make.height.mas_equalTo(kRealWidth(2));
        }];
    } else {
        if (![self.subviews containsObject:self.lineView]) {
            [self addSubview:self.lineView];
        }
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.selectView);
            make.width.mas_equalTo(kRealWidth(32));
//            make.bottom.equalTo(self.mas_bottom);
            make.bottom.mas_equalTo(-kRealWidth(36));
            make.height.mas_equalTo(kRealWidth(2));
        }];
    }
    [self.lineView setNeedsUpdateConstraints];
    [self.dataSource enumerateObjectsUsingBlock:^(WMStoreListMenuItemView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.iconLB.alpha = 1 - num;
    }];
    self.lineView.alpha = num;
    [self setNeedsUpdateConstraints];
}

- (void)getFilterData {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-merchant/app/super-app/v2/getNearbyFilterParam";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CLLocationCoordinate2D paramsCoordinate2D = CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue);
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:paramsCoordinate2D];
    if (HDIsObjectNil(addressModel) || !isParamsCoordinate2DValid) {
        // 没有选择地址或选择的地址无效，使用定位地址
        params[@"lon"] = [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.longitude].stringValue;
        params[@"lat"] = [NSNumber numberWithDouble:HDLocationManager.shared.coordinate2D.latitude].stringValue;
    } else {
        params[@"lon"] = addressModel.lon.stringValue;
        params[@"lat"] = addressModel.lat.stringValue;
    }
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        self.filterDataSource = [NSArray yy_modelArrayWithClass:WMNearbyFilterBarViewFilterModel.class json:rspModel.data];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"接口报错啦");
    }];
}

#pragma - mark 点击方法
- (void)clickView:(UITapGestureRecognizer *)ta {
    WMStoreListMenuItemView *itemView = (WMStoreListMenuItemView *)ta.view;
    BOOL all = (itemView == self.allItemView);
    if (self.selectView) {
        self.selectView.model.selected = NO;
        self.selectView.titleLB.textColor = HDAppTheme.WMColor.B6;
    }
    itemView.model.selected = YES;
    itemView.titleLB.textColor = HDAppTheme.WMColor.mainRed;
    [itemView layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        if (!all) {
            [self.menuScrollView addSubview:self.lineView];
//            [self.menuScrollView bringSubviewToFront:self.lineView];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.menuScrollView.mas_left).offset(itemView.hd_left + kRealWidth(16));
                make.width.mas_equalTo(kRealWidth(32));
//                make.bottom.mas_equalTo(0);
                make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(36));
                make.height.mas_equalTo(kRealWidth(2));
            }];
        } else {
            [self addSubview:self.lineView];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(itemView);
                make.width.mas_equalTo(kRealWidth(32));
//                make.bottom.equalTo(self.mas_bottom);
                make.bottom.mas_equalTo(-kRealWidth(36));
                make.height.mas_equalTo(kRealWidth(2));
            }];
        }
        [self.lineView setNeedsUpdateConstraints];
        if (!all) {
            [self scrollAction:itemView];
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickItem:)]) {
        [self.delegate clickItem:itemView.model];
    }
    self.selectView = itemView;
}

- (void)scrollAction:(WMStoreListMenuItemView *)itemView {
    if ([self.menuScrollView isScrollEnabled]) {
        CGFloat centerX = self.menuScrollView.hd_width / 2;
        CGRect indexFrame = itemView.frame;
        CGFloat contenSize = self.menuScrollView.contentSize.width;
        CGPoint point = CGPointZero;
        if (indexFrame.origin.x <= centerX) {
            point = CGPointMake(0, 0);
        } else if (CGRectGetMaxX(indexFrame) > (contenSize - centerX)) {
            point = CGPointMake(self.menuScrollView.contentSize.width - self.menuScrollView.hd_width, 0);
        } else {
            point = CGPointMake(CGRectGetMaxX(indexFrame) - centerX - indexFrame.size.width / 2, 0);
        }
        [self.menuScrollView setContentOffset:point animated:YES];
    }
}

- (void)clickOnSort:(HDUIButton *)sortButton {
    if (self.sortButton.isSelected) {
        [self.currentSlideView dismissCompleted:nil];
        return;
    }

    void (^showActionView)(NSArray<WMStoreFilterTableViewCellModel *> *) = ^(NSArray<WMStoreFilterTableViewCellModel *> *categorys) {
        WMHorizontalTreeView *view = [[WMHorizontalTreeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            view.cellHeight = kRealWidth(44);
        } else {
            view.cellHeight = kRealWidth(50);
        }
        view.dataSource = categorys;
        view.minHeight = kScreenHeight * 0.2;
        view.maxHeight = kScreenHeight * 0.6;
        [view layoutyImmediately];

        WMCustomerSlideDownView *slideDownView = [[WMCustomerSlideDownView alloc] initWithStartOffsetY:kNavigationBarH + kRealWidth(36) + kRealWidth(84) - kRealWidth(48) customerView:view];
        slideDownView.slideDownViewWillAppear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.sortButton setSelected:YES];
        };
        slideDownView.slideDownViewWillDisappear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.sortButton setSelected:NO];
        };
        slideDownView.cornerRadios = kRealWidth(8);
        self.currentSlideView = slideDownView;
        @HDWeakify(slideDownView);
        @HDWeakify(self);
        view.didSelectSubTableViewRowAtIndexPath = ^(WMStoreFilterTableViewCellBaseModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
            @HDStrongify(self);
            @HDStrongify(slideDownView);
            id associatedParamsModel = model.associatedParamsModel;
            NSString *title = nil;
            if ([associatedParamsModel isKindOfClass:NSString.class]) {
                if ([associatedParamsModel length]) {
                    self.filterModel.sortType = associatedParamsModel;
                    title = model.title;
                    [self.sortButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
                } else {
                    self.filterModel.sortType = WMNearbyStoreSortTypeNone;
                    title = WMLocalizedString(@"98qt1uye", @"排序");
                    [self.sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
                }
                [self.sortButton setTitle:title forState:UIControlStateNormal];
            }
//            if (self.viewWillDisappear) {
//                self.viewWillDisappear(self);
//            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickSort:)]) {
                [self.delegate clickSort:self.filterModel];
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

- (void)clickOnFilter:(HDUIButton *)btn {

    if (btn.isSelected) {
        [self.currentSlideView dismissCompleted:nil];
        return;
    }
    @HDWeakify(self);
    void (^showActionView)(void) = ^{
        WMNearbyFilterBarContentView *view = [[WMNearbyFilterBarContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];

        for (WMNearbyFilterBarViewFilterModel *model in self.filterDataSource) {
            for (WMNearbyFilterBarViewFilterParamsModel *m in model.params) {
                m.isSelected = [self.filterModel.marketingTypes containsObject:m.value] || [self.filterModel.storeFeature containsObject:m.value];
            }
        }
        
        view.filterDataSource = self.filterDataSource;
        [view layoutyImmediately];
        
        WMCustomerSlideDownView *slideDownView = [[WMCustomerSlideDownView alloc] initWithStartOffsetY:kNavigationBarH + kRealWidth(36) + kRealWidth(84) - kRealWidth(48) customerView:view];
        slideDownView.slideDownViewWillAppear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.filterButton setSelected:YES];
        };
        slideDownView.slideDownViewWillDisappear = ^(WMCustomerSlideDownView *_Nonnull slideDownView) {
            [self.filterButton setSelected:NO];
        };
        slideDownView.cornerRadios = kRealWidth(8);
        self.currentSlideView = slideDownView;
        @HDWeakify(slideDownView);
        @HDWeakify(self);
        view.submitBlock = ^(NSArray<NSString *> *marketingTypes, NSArray<NSString *> *storeFeature) {
            @HDStrongify(self);
            @HDStrongify(slideDownView);
            self.filterModel.marketingTypes = marketingTypes;
            self.filterModel.storeFeature = storeFeature;
            
            if(marketingTypes.count + storeFeature.count <= 0) {
                [self.filterButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
            } else {
                [self.filterButton setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
            }
            [self.filterButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
            [self.filterButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
            
            NSInteger count1 = self.filterModel.marketingTypes.count;
            NSInteger count2 = self.filterModel.storeFeature.count;
            NSInteger count = count1 + count2;
            self.numberLabel.hidden = count <= 0;
            if (!self.numberLabel.hidden) {
                [self.filterButton setImage:nil forState:UIControlStateNormal];
                [self.filterButton setImage:nil forState:UIControlStateSelected];
                self.numberLabel.text = [NSString stringWithFormat:@"%ld",count];
            }
            
            [self setNeedsUpdateConstraints];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickFilter:)]) {
                [self.delegate clickFilter:self.filterModel];
            }
            
//            
//            if (self.viewWillDisappear) {
//                self.viewWillDisappear(self);
//            }
            [slideDownView dismissCompleted:nil];
        };

        if (self.viewWillAppear) {
            self.viewWillAppear(self);
        }

        [slideDownView show];
    };

    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:^{
            if(self.filterDataSource.count) {
                showActionView();
            }
        }];
    } else {
        if(self.filterDataSource.count) {
            showActionView();
        }
    }
}

#pragma mark - public methods
- (void)hideAllSlideDownView {
    if (self.currentSlideView) {
        [self.currentSlideView dismissCompleted:nil];
    }
}

#pragma mark - lazy load
- (UIImageView *)gl {
    if (!_gl) {
        _gl = UIImageView.new;
        _gl.image = [UIImage imageNamed:@"yn_storelist_navi_gran"];
    }
    return _gl;
}

- (UIScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = UIScrollView.new;
        _menuScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _menuScrollView.showsVerticalScrollIndicator = NO;
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.backgroundColor = UIColor.whiteColor;
        if (@available(iOS 11.0, *)) {
            _menuScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _menuScrollView;
}

- (WMStoreListMenuItemView *)allItemView {
    if (!_allItemView) {
        _allItemView = WMStoreListMenuItemView.new;
    }
    return _allItemView;
}

- (WMNearbyFilterModel *)filterModel {
    return _filterModel ?: ({ _filterModel = WMNearbyFilterModel.new; });
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.alpha = 1;
        _lineView.backgroundColor = HDAppTheme.WMColor.mainRed;
    }
    return _lineView;
}


/** @lazy sortButton */
- (HDUIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [[HDUIButton alloc] init];
        _sortButton.imagePosition = HDUIButtonImagePositionRight;
        _sortButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _sortButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _sortButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_sortButton setTitle:WMLocalizedString(@"98qt1uye", @"综合排序") forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
        [_sortButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(clickOnSort:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (HDUIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[HDUIButton alloc] init];
        _filterButton.imagePosition = HDUIButtonImagePositionRight;
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _filterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_filterButton setTitle:WMLocalizedString(@"wm_sort_Find_more", @"全部筛选") forState:UIControlStateNormal];
        [_filterButton setImage:[UIImage imageNamed:@"yn_home_u_new"] forState:UIControlStateNormal];
        [_filterButton setImage:[UIImage imageNamed:@"yn_home_d_new"] forState:UIControlStateSelected];
        [_filterButton setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(clickOnFilter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}


- (NSArray<WMStoreFilterTableViewCellModel *> *)sortTypeDataSource {
    if (!_sortTypeDataSource) {
        NSMutableArray<WMStoreFilterTableViewCellModel *> *dataSource = [NSMutableArray array];
        WMStoreFilterTableViewCellModel *model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"98qt1uye", @"综合排序") associatedParamsModel:@""];
        [dataSource addObject:model];

//        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"sort_distance", @"距离") associatedParamsModel:@"MS_004"];
        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Nearest", @"距离最近") associatedParamsModel:@"MS_004"];
        [dataSource addObject:model];

        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Best_sell", @"销量最高") associatedParamsModel:@"MS_001"];
        [dataSource addObject:model];

//        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"rating_high_to_low", @"评分：从高到低") associatedParamsModel:@"MS_003"];
        model = [WMStoreFilterTableViewCellModel modelWithTitle:WMLocalizedString(@"wm_sort_Good_rates", @"好评优先") associatedParamsModel:@"MS_003"];
        [dataSource addObject:model];

        [dataSource enumerateObjectsUsingBlock:^(WMStoreFilterTableViewCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.titleColor = HDAppTheme.WMColor.B3;
            obj.titleSelectColor = HDAppTheme.WMColor.mainRed;
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                obj.canSelect = YES;
                obj.titleFont = [HDAppTheme.WMFont wm_ForSize:14];
                obj.titleSelectFont = [HDAppTheme.WMFont wm_ForSize:14];
            } else {
                obj.canSelect = YES;
                obj.titleFont = [HDAppTheme.WMFont wm_boldForSize:17];
                obj.titleSelectFont = [HDAppTheme.WMFont wm_boldForSize:17];
            }
        }];
        _sortTypeDataSource = dataSource.copy;
    }

    return _sortTypeDataSource;
}

- (UILabel *)numberLabel {
    if(!_numberLabel) {
        _numberLabel = UILabel.new;
        _numberLabel.textColor = UIColor.sa_C1;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
//        _numberLabel.backgroundColor = UIColor.sa_C1;
        _numberLabel.layer.borderColor = UIColor.sa_C1.CGColor;
        _numberLabel.layer.borderWidth = 1;
        _numberLabel.layer.cornerRadius = 8;
        _numberLabel.font = HDAppTheme.font.sa_standard11M;
        _numberLabel.hidden = YES;
    }
    return _numberLabel;
}

@end


@interface WMStoreListMenuItemView ()

@end


@implementation WMStoreListMenuItemView

- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.iconLB];
    self.iconLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(22)];
    };
}

- (void)updateConstraints {
    [self.iconLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.right.mas_equalTo(2);
        make.top.mas_equalTo(54);
    }];
    [super updateConstraints];
}

- (void)setModel:(WMCategoryItem *)model {
    _model = model;

    self.titleLB.text = model.message.desc;
//    self.titleLB.text = @"sfajfklsdjfklasjfklsjfkl";
    self.titleLB.textColor = model.isSelected ? HDAppTheme.WMColor.mainRed : HDAppTheme.WMColor.B6;
    if (model.isLocalImage) {
        self.iconLB.image = [UIImage imageNamed:model.imagesUrl];
    } else {
        [self.iconLB sd_setImageWithURL:[NSURL URLWithString:model.imagesUrl] placeholderImage:HDHelper.placeholderImage];
    }
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 2;
        _titleLB.font = [HDAppTheme.WMFont wm_ForSize:12];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.userInteractionEnabled = NO;
    }
    return _titleLB;
}

- (UIImageView *)iconLB {
    if (!_iconLB) {
        _iconLB = UIImageView.new;
    }
    return _iconLB;
}


@end

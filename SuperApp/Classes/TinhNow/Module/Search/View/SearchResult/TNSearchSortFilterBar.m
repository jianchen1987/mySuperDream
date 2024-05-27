//
//  TNSearchSortFilterBar.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchSortFilterBar.h"
#import "TNSearchFilterPriceView.h"
#import "TNSearchFilterView.h"
#import "TNSearchSortFilterModel.h"
#import "TNSearchViewModel.h"
#import "TNSellerSearchViewModel.h"


@interface TNSearchSortFilterBar () <TNSearchFilterViewDelegate>
/// sortFilterModel
//@property (nonatomic, strong) TNSearchSortFilterModel *model;
/// 默认综合排序
@property (nonatomic, strong) HDUIButton *defaultSortButton;
/// 销量排序
@property (nonatomic, strong) HDUIButton *salesVolSortButton;
/// 加个排序
@property (nonatomic, strong) HDUIButton *priceSortButton;
/// 新品排序
//@property (nonatomic, strong) HDUIButton *latestSortButton;
/// 条件筛选
@property (nonatomic, strong) HDUIButton *filterButton;
/// 分割线
@property (nonatomic, strong) UIView *line;
/// 价格筛选
@property (nonatomic, strong) TNSearchFilterView *filterView;

@end


@implementation TNSearchSortFilterBar

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    [self initButtonState];
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)hd_setupViews {
    [self addSubview:self.salesVolSortButton];
    [self addSubview:self.priceSortButton];
    [self addSubview:self.defaultSortButton];
    [self addSubview:self.line];
    [self addSubview:self.filterButton];
    // 处理键盘相关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - Notification
- (BOOL)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardBounds.size.height;
    CGRect headRect = [self convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat headMaxY = headRect.origin.y + CGRectGetHeight(headRect);
    CGFloat filtViewHeight = self.filterView.filterContainerHeight;
    CGFloat leftHeight = kScreenHeight - headMaxY;
    if (self.clickShowFilterViewCallBack && leftHeight < (keyboardHeight + filtViewHeight) && self.filterView) { //键盘升起  计算需要升起的高度
        self.clickShowFilterViewCallBack(keyboardHeight + filtViewHeight - leftHeight);
        [self.filterView setNeedsUpdateConstraints];
    }

    return YES;
}
- (void)updateConstraints {
    [self.defaultSortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self);
    }];

    if (!self.salesVolSortButton.isHidden) {
        [self.salesVolSortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.defaultSortButton.mas_right).offset(20);
            make.centerY.equalTo(self);
        }];
    }

    [self.priceSortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.salesVolSortButton.isHidden) {
            make.left.equalTo(self.salesVolSortButton.mas_right).offset(20);
        } else {
            make.left.equalTo(self.defaultSortButton.mas_right).offset(20);
        }
        make.centerY.equalTo(self.defaultSortButton);
    }];

    //    [self.latestSortButton mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.priceSortButton.mas_right).offset(20);
    //        make.centerY.equalTo(self.salesVolSortButton);
    //    }];

    [self.filterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.defaultSortButton);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.filterButton.mas_left).offset(-15);
        make.centerY.equalTo(self.defaultSortButton);
        make.height.equalTo(self.defaultSortButton.mas_height);
        make.width.mas_equalTo(1);
    }];

    [super updateConstraints];
}
- (void)hideRightFilterBtn {
    self.filterButton.hidden = YES;
    self.line.hidden = YES;
}
- (void)hideSaleSortBtn {
    self.salesVolSortButton.hidden = YES;
    [self setNeedsUpdateConstraints];
}
#pragma mark - private methods
- (void)initButtonState {
    if ([self.viewModel.searchSortFilterModel.sortType isEqualToString:TNGoodsListSortTypeDefault]) {
        [self.defaultSortButton setSelected:YES];
        [self.salesVolSortButton setSelected:NO];
        [self.priceSortButton setSelected:NO];
    } else if ([self.viewModel.searchSortFilterModel.sortType isEqualToString:TNGoodsListSortTypeSalesDesc]) {
        [self.salesVolSortButton setSelected:YES];
        [self.priceSortButton setSelected:NO];
        [self.defaultSortButton setSelected:NO];
    } else if ([self.viewModel.searchSortFilterModel.sortType isEqualToString:TNGoodsListSortTypePriceAsc]) {
        [self.priceSortButton setSelected:YES];
        [self.salesVolSortButton setSelected:NO];
        [self.defaultSortButton setSelected:NO];
    } else if ([self.viewModel.searchSortFilterModel.sortType isEqualToString:TNGoodsListSortTypePriceDesc]) {
        [self.priceSortButton setSelected:YES];
        [self.salesVolSortButton setSelected:NO];
        [self.defaultSortButton setSelected:NO];
    }
    [self fixesFilterButtonStateWithOptions:self.viewModel.searchSortFilterModel.filter];
}

- (void)fixesFilterButtonStateWithOptions:(NSDictionary<TNSearchFilterOptions, NSObject *> *)options {
    __block BOOL selected = NO;
    [options enumerateKeysAndObjectsUsingBlock:^(TNSearchFilterOptions _Nonnull key, NSObject *_Nonnull obj, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:NSString.class]) {
            NSString *trueObj = (NSString *)obj;
            if ([key isEqualToString:TNSearchFilterOptionsStagePrice]) {
                if (HDIsStringNotEmpty(trueObj) && [trueObj boolValue]) {
                    selected = YES;
                    *stop = YES;
                }
            } else {
                if (HDIsStringNotEmpty(trueObj)) {
                    selected = YES;
                    *stop = YES;
                }
            }
        }
    }];
    [self.filterButton setSelected:selected];
}
#pragma mark - 拉取新数据
- (void)requestSearchData {
    if ([self.viewModel isKindOfClass:[TNSearchViewModel class]]) {
        TNSearchViewModel *sModel = (TNSearchViewModel *)self.viewModel;
        sModel.isNeedUpdateContentOffset = YES;
        [sModel requestNewData];
    } else if ([self.viewModel isKindOfClass:[TNSellerSearchViewModel class]]) {
        TNSellerSearchViewModel *sModel = (TNSellerSearchViewModel *)self.viewModel;
        [sModel getNewDataByResultType:TNSellerSearchResultTypeProduct];
    }
    if (self.clickFilterConditionCallBack) {
        self.clickFilterConditionCallBack();
    }
}
- (void)clickOnSortButton:(HDUIButton *)button {
    if ([button isEqual:self.defaultSortButton]) {
        if (![self.defaultSortButton isSelected]) {
            self.viewModel.searchSortFilterModel.sortType = TNGoodsListSortTypeDefault;
            [self.salesVolSortButton setSelected:NO];
            [self.priceSortButton setSelected:NO];
            [self.defaultSortButton setSelected:YES];
            [self requestSearchData];
        }
    } else if ([button isEqual:self.salesVolSortButton]) {
        if (![self.salesVolSortButton isSelected]) {
            self.viewModel.searchSortFilterModel.sortType = TNGoodsListSortTypeSalesDesc;
            [self.salesVolSortButton setSelected:YES];
            [self.priceSortButton setSelected:NO];
            [self.defaultSortButton setSelected:NO];
            [self requestSearchData];
        }
    } else if ([button isEqual:self.priceSortButton]) {
        if (![self.priceSortButton isSelected]) {
            self.viewModel.searchSortFilterModel.sortType = TNGoodsListSortTypePriceDesc;
            [self.priceSortButton setImage:[UIImage imageNamed:@"tinhnow-ic-sort-desc"] forState:UIControlStateSelected];
            [self.priceSortButton setSelected:YES];
            [self.salesVolSortButton setSelected:NO];
            [self.defaultSortButton setSelected:NO];
            [self requestSearchData];
        } else {
            if ([self.viewModel.searchSortFilterModel.sortType isEqualToString:TNGoodsListSortTypePriceAsc]) {
                self.viewModel.searchSortFilterModel.sortType = TNGoodsListSortTypePriceDesc;
                [self.priceSortButton setImage:[UIImage imageNamed:@"tinhnow-ic-sort-desc"] forState:UIControlStateSelected];
            } else {
                self.viewModel.searchSortFilterModel.sortType = TNGoodsListSortTypePriceAsc;
                [self.priceSortButton setImage:[UIImage imageNamed:@"tinhnow-ic-sort-asc"] forState:UIControlStateSelected];
            }
            [self requestSearchData];
        }
    }
}

- (void)clickOnFilterButton:(HDUIButton *)button {
    // 已经展开就不要处理
    if (self.filterView && self.filterView.showing) {
        return;
    }
    [self.filterButton setSelected:YES];

    self.filterView = [[TNSearchFilterView alloc] initWithView:self];
    self.filterView.delegate = self;
    TNSearchFilterPriceView *priceFilter = [[TNSearchFilterPriceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 30, 500)];
    NSString *lowest = (NSString *)[self.viewModel.searchSortFilterModel.filter objectForKey:TNSearchFilterOptionsPriceLowest];
    NSString *highest = (NSString *)[self.viewModel.searchSortFilterModel.filter objectForKey:TNSearchFilterOptionsPriceHighest];
    NSString *stagePrice = (NSString *)[self.viewModel.searchSortFilterModel.filter objectForKey:TNSearchFilterOptionsStagePrice];
    if (HDIsStringNotEmpty(lowest) && lowest.doubleValue > 0) {
        priceFilter.lowest = lowest;
    }
    if (HDIsStringNotEmpty(highest) && highest.doubleValue > 0) {
        priceFilter.highest = highest;
    }
    if (HDIsStringNotEmpty(stagePrice)) {
        priceFilter.stagePrice = stagePrice.boolValue;
    } else {
        priceFilter.stagePrice = NO;
    }

    [self.filterView addFilter:priceFilter];
    [self.filterView show];
}

- (void)setViewModel:(TNSearchBaseViewModel *)viewModel {
    _viewModel = viewModel;
    [self initButtonState];
    [self setNeedsUpdateConstraints];
}

#pragma mark - TNSearchFilterViewDelegate
- (void)TNSearchFilterView:(TNSearchFilterView *)filterView confirmWithFilterOptions:(NSDictionary<TNSearchFilterOptions, NSObject *> *)options {
    [self.viewModel.searchSortFilterModel.filter removeAllObjects];
    [self.viewModel.searchSortFilterModel.filter addEntriesFromDictionary:options];

    //纠正 输入的大小
    NSString *lowest = (NSString *)[self.viewModel.searchSortFilterModel.filter objectForKey:TNSearchFilterOptionsPriceLowest];
    NSString *highest = (NSString *)[self.viewModel.searchSortFilterModel.filter objectForKey:TNSearchFilterOptionsPriceHighest];
    if (highest.doubleValue < lowest.doubleValue) { //如果用户输入最高价低于最低价  就直接抹去最高价
        [self.viewModel.searchSortFilterModel.filter setObject:@"" forKey:TNSearchFilterOptionsPriceHighest];
    }
    [filterView dismiss];
    [self requestSearchData];
    [self fixesFilterButtonStateWithOptions:options];
}

- (void)TNSearchFilterView:(TNSearchFilterView *)filterView clickedOnCancelButton:(HDUIButton *)cancel {
    [filterView dismiss];
    [self fixesFilterButtonStateWithOptions:self.viewModel.searchSortFilterModel.filter];
}

- (void)TNSearchFilterView:(TNSearchFilterView *)filterView clickedOnResetButton:(HDUIButton *)reset {
    [filterView dismiss];
    [self.viewModel.searchSortFilterModel.filter removeAllObjects];
    [self requestSearchData];
    [self fixesFilterButtonStateWithOptions:self.viewModel.searchSortFilterModel.filter];
}
#pragma mark - lazy load
/** @lazy salesvolsortbutton */
- (HDUIButton *)salesVolSortButton {
    if (!_salesVolSortButton) {
        _salesVolSortButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_salesVolSortButton setTitle:TNLocalizedString(@"tn_button_sort_volume_title", @"Sales Volume") forState:UIControlStateNormal];
        _salesVolSortButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_salesVolSortButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_salesVolSortButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_salesVolSortButton addTarget:self action:@selector(clickOnSortButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _salesVolSortButton;
}
/** @lazy defaultSortButton */
- (HDUIButton *)defaultSortButton {
    if (!_defaultSortButton) {
        _defaultSortButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_defaultSortButton setTitle:TNLocalizedString(@"tn_filter_default", @"综合") forState:UIControlStateNormal];
        _defaultSortButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        ;
        [_defaultSortButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_defaultSortButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_defaultSortButton addTarget:self action:@selector(clickOnSortButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultSortButton;
}
/** @lazy priceButton */
- (HDUIButton *)priceSortButton {
    if (!_priceSortButton) {
        _priceSortButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _priceSortButton.imagePosition = HDUIButtonImagePositionRight;
        _priceSortButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        [_priceSortButton setTitle:TNLocalizedString(@"tn_button_sort_price_title", @"Price") forState:UIControlStateNormal];
        _priceSortButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        ;
        [_priceSortButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_priceSortButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_priceSortButton setImage:[UIImage imageNamed:@"tinhnow-ic-sort-disable"] forState:UIControlStateNormal];
        [_priceSortButton addTarget:self action:@selector(clickOnSortButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceSortButton;
}
/** @lazy latestSortButton */
//- (HDUIButton *)latestSortButton {
//    if (!_latestSortButton) {
//        _latestSortButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
//        [_latestSortButton setTitle:TNLocalizedString(@"QzFfj4CF", @"New Products") forState:UIControlStateNormal];
//        _latestSortButton.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
//        [_latestSortButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
//        [_latestSortButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
//        [_latestSortButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn){
//
//        }];
//    }
//    return _latestSortButton;
//}
/** @lazy filterButton */
- (HDUIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _filterButton.imagePosition = HDUIButtonImagePositionRight;
        _filterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        [_filterButton setTitle:TNLocalizedString(@"tn_button_filter_title", @"Filter") forState:UIControlStateNormal];
        _filterButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_filterButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_filterButton setImage:[UIImage imageNamed:@"tinhnow-ic-filter-normal"] forState:UIControlStateNormal];
        [_filterButton setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateSelected];
        [_filterButton setImage:[UIImage imageNamed:@"tinhnow-ic-filter-selected"] forState:UIControlStateSelected];
        [_filterButton addTarget:self action:@selector(clickOnFilterButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}
/** @lazy line */
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _line;
}

@end

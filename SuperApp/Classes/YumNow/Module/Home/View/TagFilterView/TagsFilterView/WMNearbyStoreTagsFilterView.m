//
//  WMNearbyStoreTagsFilterView.m
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMNearbyStoreTagsFilterView.h"
#import "SAOperationButton.h"
#import "SATableView.h"
#import "WMNearbyFilterModel.h"
#import "WMNearbyStoreTagsFilterTableViewCell.h"
#import "WMNearbyStoreTagsModel.h"


@interface WMNearbyStoreTagsFilterView () <UITableViewDelegate, UITableViewDataSource>
/// tableView
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 清空按钮
@property (nonatomic, strong) SAOperationButton *clearButton;
/// 完成按钮
@property (nonatomic, strong) SAOperationButton *completedButton;
/// 优惠活动
@property (nonatomic, strong) HDTableViewSectionModel *promotionsSection;
/// 商家服务
@property (nonatomic, strong) HDTableViewSectionModel *serviceSection;
/// 已经选中的标签
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedTags;

@end


@implementation WMNearbyStoreTagsFilterView

- (instancetype)initWithFrame:(CGRect)frame selectedTags:(NSArray<WMNearbyStoreTagsModel *> *)tags {
    self.selectedTags = [NSMutableArray arrayWithArray:tags];
    self = [super initWithFrame:frame];
    return self;
}

- (void)hd_setupViews {
    self.dataSource = @[self.serviceSection];
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tableView];
    [self addSubview:self.clearButton];
    [self addSubview:self.completedButton];
}

- (void)layoutyImmediately {
    CGFloat viewHeight = kRealHeight(20);
    [self.tableView successGetNewDataWithNoMoreData:YES];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    viewHeight += self.tableView.contentSize.height;
    viewHeight += kRealHeight(30);
    viewHeight += kRealHeight(45);

    self.tableView.frame = CGRectMake(0, kRealHeight(20), CGRectGetWidth(self.frame), self.tableView.contentSize.height);
    CGFloat buttonWidth = CGRectGetWidth(self.frame) / 2.0;
    self.clearButton.frame = CGRectMake(0, self.tableView.bottom + kRealHeight(30), buttonWidth, kRealHeight(45));
    self.completedButton.frame = CGRectMake(buttonWidth, self.tableView.bottom + kRealHeight(30), buttonWidth, kRealHeight(45));

    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), viewHeight);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (sectionModel.headerModel) {
        return 15.0f;
    } else {
        return 0.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    HDTableHeaderFootView *head = [HDTableHeaderFootView headerWithTableView:tableView];
    head.model = sectionModel.headerModel;
    return head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:WMNearbyStoreTagsFilterTableViewCellModel.class]) {
        WMNearbyStoreTagsFilterTableViewCell *cell = [WMNearbyStoreTagsFilterTableViewCell cellWithTableView:tableView];
        cell.model = model;
        @HDWeakify(self);
        cell.tagAddedHandler = ^(WMNearbyStoreTagsModel *_Nonnull tag) {
            @HDStrongify(self);
            [self.selectedTags addObject:tag.value];
        };
        cell.tagDeletedHandler = ^(WMNearbyStoreTagsModel *_Nonnull tag) {
            @HDStrongify(self);
            [self.selectedTags removeObject:tag.value];
        };
        return cell;
    } else {
        return UITableViewCell.new;
    }
}

#pragma mark - lazy load
/** @lazy tableview */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60.0f;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
    }
    return _tableView;
}
/** @lazy  clearButton */
- (SAOperationButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _clearButton.cornerRadius = 0;
        [_clearButton applyPropertiesWithBackgroundColor:UIColor.whiteColor];
        _clearButton.titleLabel.font = HDAppTheme.font.standard2Bold;
        [_clearButton setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [_clearButton setTitle:WMLocalizedString(@"home_clear_all", @"清空") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_clearButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.clearButtonClickedHandler) {
                self.clearButtonClickedHandler();
            }
        }];
    }
    return _clearButton;
}

/** @lazy completeButton */
- (SAOperationButton *)completedButton {
    if (!_completedButton) {
        _completedButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _completedButton.cornerRadius = 0;
        [_completedButton applyPropertiesWithBackgroundColor:HDAppTheme.color.mainColor];
        _completedButton.titleLabel.font = HDAppTheme.font.standard2Bold;
        [_completedButton setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [_completedButton setTitle:WMLocalizedString(@"wm_button_confirm", @"确认") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_completedButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.completeButtonClickedHandler) {
                self.completeButtonClickedHandler(self.selectedTags);
            }
        }];
    }
    return _completedButton;
}
/** @lazy promotionSection */
- (HDTableViewSectionModel *)promotionsSection {
    if (!_promotionsSection) {
        _promotionsSection = [[HDTableViewSectionModel alloc] init];
        NSMutableArray<WMNearbyStoreTagsModel *> *tags = NSMutableArray.new;
        WMNearbyStoreTagsModel *tag = WMNearbyStoreTagsModel.new;
        tag.key = WMLocalizedString(@"home_first_order_discount", @"首单立减");
        tag.value = WMNearbyStoreTagFirstOrder;
        if ([self.selectedTags containsObject:WMNearbyStoreTagFirstOrder]) {
            tag.selected = YES;
        } else {
            tag.selected = NO;
        }
        [tags addObject:tag];

        tag = WMNearbyStoreTagsModel.new;
        tag.key = WMLocalizedString(@"home_filter_discount", @"折扣优惠");
        tag.value = WMNearbyStoreTagDiscount;
        if ([self.selectedTags containsObject:WMNearbyStoreTagDiscount]) {
            tag.selected = YES;
        } else {
            tag.selected = NO;
        }
        [tags addObject:tag];

        tag = WMNearbyStoreTagsModel.new;
        tag.key = WMLocalizedString(@"money_off", @"满减优惠");
        tag.value = WMNearbyStoreTagOrderAmountFullBreak;
        if ([self.selectedTags containsObject:WMNearbyStoreTagOrderAmountFullBreak]) {
            tag.selected = YES;
        } else {
            tag.selected = NO;
        }
        [tags addObject:tag];

        tag = WMNearbyStoreTagsModel.new;
        tag.key = WMLocalizedString(@"1c8ZBMsK", @"特价商品");
        tag.value = WMNearbyStoreTagSpecialOffer;
        if ([self.selectedTags containsObject:WMNearbyStoreTagSpecialOffer]) {
            tag.selected = YES;
        } else {
            tag.selected = NO;
        }
        [tags addObject:tag];

        WMNearbyStoreTagsFilterTableViewCellModel *cellModel = WMNearbyStoreTagsFilterTableViewCellModel.new;
        cellModel.dataSource = [NSArray arrayWithArray:tags];

        _promotionsSection.list = @[cellModel];
        HDTableHeaderFootViewModel *head = HDTableHeaderFootViewModel.new;
        head.title = WMLocalizedString(@"home_offers", @"优惠活动");
        head.titleFont = HDAppTheme.font.standard3;
        head.titleColor = HDAppTheme.color.G1;
        head.backgroundColor = UIColor.whiteColor;

        _promotionsSection.headerModel = head;
    }
    return _promotionsSection;
}

- (HDTableViewSectionModel *)serviceSection {
    if (!_serviceSection) {
        _serviceSection = [[HDTableViewSectionModel alloc] init];
        NSMutableArray<WMNearbyStoreTagsModel *> *tags = NSMutableArray.new;
        WMNearbyStoreTagsModel *tag = WMNearbyStoreTagsModel.new;
        tag.key = WMLocalizedString(@"is_new_store", @"新店");
        tag.value = WMNearbyStoreTagNewStore;
        if ([self.selectedTags containsObject:WMNearbyStoreTagNewStore]) {
            tag.selected = YES;
        } else {
            tag.selected = NO;
        }
        [tags addObject:tag];

        tag = WMNearbyStoreTagsModel.new;
        tag.key = WMLocalizedString(@"home_free_delivery", @"免配送费");
        tag.value = WMNearbyStoreTagDeliveryFeeBreak;
        if ([self.selectedTags containsObject:WMNearbyStoreTagDeliveryFeeBreak]) {
            tag.selected = YES;
        } else {
            tag.selected = NO;
        }
        [tags addObject:tag];

        WMNearbyStoreTagsFilterTableViewCellModel *cellModel = WMNearbyStoreTagsFilterTableViewCellModel.new;
        cellModel.dataSource = [NSArray arrayWithArray:tags];

        _serviceSection.list = @[cellModel];
        HDTableHeaderFootViewModel *head = HDTableHeaderFootViewModel.new;
        head.title = WMLocalizedString(@"home_service", @"商家服务");
        head.titleFont = HDAppTheme.font.standard3;
        head.titleColor = HDAppTheme.color.G1;
        head.backgroundColor = UIColor.whiteColor;

        _serviceSection.headerModel = head;
    }
    return _serviceSection;
}

@end

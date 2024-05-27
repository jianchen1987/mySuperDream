//
//  PNMSVoucherFilterView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherFilterView.h"
#import "NSObject+HDKitCore.h"
#import "PNCollectionView.h"
#import "PNCommonUtils.h"
#import "PNMSBillFilterModel.h"
#import "PNMSFilterCurrencyCell.h"
#import "PNMSFilterDateCell.h"
#import "PNMSFilterStoreCell.h"
#import "PNSingleSelectedAlertView.h"
#import "SACollectionReusableView.h"
#import "UICollectionViewLeftAlignLayout.h"

static NSString *const kFilterSectionType = @"section_type";
static NSString *const kDateType = @"filter_date_type";
static NSString *const kStore = @"filter_store";
static NSString *const kOperator = @"filter_operator";


@interface PNMSVoucherFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) HDUIButton *resetButton;
@property (nonatomic, strong) HDUIButton *confirmButton;

@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSourceArray;
@end


@implementation PNMSVoucherFilterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.filterModel = [PNMSFilterModel new];
    }
    return self;
}

- (void)hd_setupViews {
    [self initData];
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];

    [self.contentView addSubview:self.resetButton];
    [self.contentView addSubview:self.confirmButton];

    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        self.cellHeight = self.collectionView.contentSize.height;

        CGFloat canShowHeight = self.hd_height * 0.8;
        if (self.cellHeight > canShowHeight) {
            self.cellHeight = canShowHeight;
        }

        [self setNeedsUpdateConstraints];
    }];

    //    if (VipayUser.shareInstance.storeDataQueryPower) {
    [self getStoreAllOperatorData:^{
        [self reloadData];
    }];
    //    }
}

- (void)updateConstraints {
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(self.cellHeight));
    }];

    [self.resetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.height.equalTo(@(kRealWidth(44)));
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(kRealWidth(10));
        make.width.equalTo(@(self.contentView.width * 0.4));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resetButton.mas_right);
        make.top.height.equalTo(self.resetButton);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    [super updateConstraints];
}

#pragma mark
- (void)tap {
    HDLog(@"tap");
    [self hidden];
}

- (void)showInSuperView:(UIView *)superview {
    if ([self.superview isEqual:superview]) {
        return;
    }

    [superview addSubview:self];

    [self reloadData];
}

- (void)reloadData {
    [self.dataSourceArray removeAllObjects];
    [self initData];
    [self.collectionView successGetNewDataWithNoMoreData:NO];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    //    self.cellHeight = self.collectionView.contentSize.height;

    HDLog(@"hd_height: %f -- %f", self.hd_height, self.cellHeight);
    //    CGFloat canShowHeight = self.hd_height - kRealWidth(44) - kRealWidth(10) - kRealWidth(15) - (kRealWidth(10) * (self.dataSourceArray.count - 1));
    //    if (self.cellHeight > canShowHeight) {
    //        self.cellHeight = canShowHeight;
    //    }
    //    HDLog(@"cellHeight: %f  canShowHeight: %f", self.cellHeight, canShowHeight);

    //    [self setNeedsUpdateConstraints];
}

- (void)hidden {
    [self removeFromSuperview];
}

- (void)resetAllStatus {
    for (HDTableViewSectionModel *sectionModel in self.dataSourceArray) {
        NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
        if ([type isEqualToString:kOperator] || [type isEqualToString:kStore]) {
            for (PNMSBillFilterModel *model in sectionModel.list) {
                model.isSelected = NO;
            }
            ///  将第一个设置为 选中
            PNMSBillFilterModel *firstModel = [sectionModel.list firstObject];
            firstModel.isSelected = YES;

            self.filterModel.currency = @"";
            self.filterModel.transType = PNTransTypeDefault;
            self.filterModel.transferStatus = PNOrderStatusAll;

            if ([type isEqualToString:kOperator]) {
                self.filterModel.operatorValue = firstModel.value;
            }

            if ([type isEqualToString:kStore]) {
                self.filterModel.storeNo = firstModel.value;
                self.filterModel.storeName = firstModel.titleName;
            }

        } else {
            for (PNMSBillFilterModel *model in sectionModel.list) {
                model.value = @"";
            }
        }
    }

    [self.collectionView successGetNewDataWithNoMoreData:NO];

    self.confirmButton.enabled = YES;
}

- (void)ruleLimit {
    NSString *startDate = @"";
    NSString *endDate = @"";
    for (HDTableViewSectionModel *sectionModel in self.dataSourceArray) {
        NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
        if ([type isEqualToString:kDateType]) {
            PNMSBillFilterModel *firstModel = [sectionModel.list firstObject];
            startDate = firstModel.value;

            PNMSBillFilterModel *lastModel = [sectionModel.list lastObject];
            endDate = lastModel.value;

            break;
        }
    }

    /**
     如果选择了开始时间，没有选择 结束时间， 则结束时间默认当天
     并且 时间跨度不能超过31天
    */
    if (WJIsStringNotEmpty(endDate)) {
        if (WJIsStringNotEmpty(startDate) && [PNCommonUtils getDiffenrenceByDate1:startDate date2:endDate] <= 31) {
            self.confirmButton.enabled = YES;
        } else {
            self.confirmButton.enabled = NO;
        }
    } else {
        if (WJIsStringEmpty(startDate)) {
            self.confirmButton.enabled = YES;
        } else {
            if ([PNCommonUtils getDiffenrenceByDate1:startDate date2:endDate] <= 31 && WJIsStringNotEmpty(endDate)) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        }
    }
}

- (void)handleSelectStore:(PNMSFilterStoreCell *)cell {
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:self.storeArray.count];
    [self.storeArray enumerateObjectsUsingBlock:^(PNMSBillFilterModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        model.name = obj.titleName;
        model.itemId = obj.value;
        if ([self.filterModel.storeNo isEqualToString:model.itemId]) {
            model.isSelected = YES;
        }
        [modelArray addObject:model];
    }];

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:modelArray title:PNLocalizedString(@"pn_Store", @"门店")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        cell.valueTitle = model.name;
        self.filterModel.storeNo = model.itemId;
        self.filterModel.storeName = model.name;

        @HDWeakify(self);
        [self getCurrentStoreOperatorData:^{
            @HDStrongify(self);
            [self reloadData];
        }];
    };
    [alertView show];
}

#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
    if ([type isEqualToString:kStore]) {
        return 1;
    } else {
        return sectionModel.list.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:indexPath.section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
    if ([type isEqualToString:kDateType]) {
        PNMSFilterDateCell *cell = [PNMSFilterDateCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        PNMSBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        cell.model = model;

        @HDWeakify(self);
        cell.selectDateBlock = ^(NSString *_Nonnull selectDate) {
            @HDStrongify(self);
            [self ruleLimit];
        };
        return cell;
    } else if ([type isEqualToString:kOperator]) {
        PNMSFilterCurrencyCell *cell = [PNMSFilterCurrencyCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:kOperator];
        PNMSBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        cell.model = model;
        return cell;
    } else if ([type isEqualToString:kStore]) {
        PNMSFilterStoreCell *cell = [PNMSFilterStoreCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:kStore];
        cell.valueTitle = self.filterModel.storeName;

        @HDWeakify(self);
        @HDWeakify(cell);
        cell.clickBtnBlock = ^{
            @HDStrongify(self);
            @HDStrongify(cell);
            [self handleSelectStore:cell];
        };
        return cell;
    } else {
        return UICollectionViewCell.new;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SACollectionReusableView *headerView = [SACollectionReusableView headerWithCollectionView:collectionView forIndexPath:indexPath];
        HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:indexPath.section];
        headerView.model = sectionModel.commonHeaderModel;
        return headerView;
    } else {
        return UICollectionReusableView.new;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:indexPath.section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
    if ([type isEqualToString:kDateType]) {
        CGFloat itemW = floor((kScreenWidth - kRealWidth(15) * 3) / 2.f);
        return CGSizeMake(itemW, kRealWidth(44));
    } else if ([type isEqualToString:kStore]) {
        return CGSizeMake(kScreenWidth - kRealWidth(30), kRealWidth(44));
    } else {
        return CGSizeMake(75, 32);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kRealWidth(21));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(20), kRealWidth(15));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:indexPath.section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
    if ([type isEqualToString:kOperator]) {
        for (PNMSBillFilterModel *model in sectionModel.list) {
            model.isSelected = NO;
        }
        PNMSBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        model.isSelected = YES;

        if ([type isEqualToString:kOperator]) {
            self.filterModel.operatorValue = model.value;
        }

        [self.collectionView successGetNewDataWithNoMoreData:NO];
    }
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(10);
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(70, 28);

        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        _collectionView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        [_collectionView registerClass:SACollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACollectionReusableView.class)];

        _collectionView.needRefreshFooter = false;
        _collectionView.needRefreshHeader = false;
    }
    return _collectionView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [HDAppTheme.PayNowColor.c000000 colorWithAlphaComponent:0.3];
        view.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [view addGestureRecognizer:tap];

        _backgroundView = view;
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _contentView = view;
    }
    return _contentView;
}

- (HDUIButton *)resetButton {
    if (!_resetButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"reset", @"重置") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        button.backgroundColor = HDAppTheme.PayNowColor.cF6F6F6;
        button.adjustsButtonWhenHighlighted = NO;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"click");
            [self resetAllStatus];
        }];

        _resetButton = button;
    }
    return _resetButton;
}

- (HDUIButton *)confirmButton {
    if (!_confirmButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.adjustsButtonWhenHighlighted = NO;
        /// MARK: 确认
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);

            [self hidden];
            for (HDTableViewSectionModel *sectionModel in self.dataSourceArray) {
                NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
                if ([type isEqualToString:kDateType]) {
                    PNMSBillFilterModel *firstModel = [sectionModel.list firstObject];
                    self.filterModel.startDate = firstModel.value;

                    PNMSBillFilterModel *lastModel = [sectionModel.list lastObject];
                    self.filterModel.endDate = lastModel.value;

                    break;
                }
            }

            !self.confirmBlock ?: self.confirmBlock(self.filterModel);
        }];

        _confirmButton = button;
    }
    return _confirmButton;
}

- (NSMutableArray *)dateTimeSource {
    NSMutableArray *arr = [NSMutableArray array];
    PNMSBillFilterModel *model = PNMSBillFilterModel.new;
    model.titleName = PNLocalizedString(@"select_start_date", @"选择开始日期");
    model.value = self.filterModel.startDate;
    [arr addObject:model];

    model = PNMSBillFilterModel.new;
    model.titleName = PNLocalizedString(@"select_end_date", @"选择结束日期");
    model.value = self.filterModel.endDate;
    [arr addObject:model];

    return arr;
}

- (void)setDefaultOperator:(NSMutableArray *)array {
    for (PNMSBillFilterModel *model in array) {
        if ([model.value isEqualToString:self.filterModel.operatorValue]) {
            model.isSelected = YES;
            break;
        }
    }
}

- (void)initData {
    /// 时间
    HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
    [sectionModel hd_bindObjectWeakly:kDateType forKey:kFilterSectionType];
    SACollectionReusableViewModel *headerModel = SACollectionReusableViewModel.new;
    headerModel.title = PNLocalizedString(@"select_date_type", @"查询日期");
    headerModel.tag = PNLocalizedString(@"select_date_type_tips", @"起止日期跨度不能超过1个月");
    headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
    headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
    headerModel.tagColor = HDAppTheme.PayNowColor.c9599A2;
    headerModel.tagFont = HDAppTheme.PayNowFont.standard12;
    headerModel.tagBackgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    sectionModel.commonHeaderModel = headerModel;

    sectionModel.list = [self dateTimeSource];
    [self.dataSourceArray addObject:sectionModel];

    /// 门店
    if (self.storeArray.count > 0) {
        sectionModel = HDTableViewSectionModel.new;
        [sectionModel hd_bindObjectWeakly:kStore forKey:kFilterSectionType];

        headerModel = SACollectionReusableViewModel.new;
        headerModel.title = PNLocalizedString(@"pn_Store", @"门店");
        headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
        headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
        sectionModel.commonHeaderModel = headerModel;

        sectionModel.list = self.storeArray;

        [self.dataSourceArray addObject:sectionModel];
    }

    /// 操作员
    if (self.operatorArray.count > 0) {
        sectionModel = HDTableViewSectionModel.new;
        [sectionModel hd_bindObjectWeakly:kOperator forKey:kFilterSectionType];

        headerModel = SACollectionReusableViewModel.new;
        headerModel.title = PNLocalizedString(@"pn_Operator", @"操作员");
        headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
        headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
        sectionModel.commonHeaderModel = headerModel;

        [self setDefaultOperator:self.operatorArray];

        sectionModel.list = self.operatorArray;

        [self.dataSourceArray addObject:sectionModel];
    }
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end

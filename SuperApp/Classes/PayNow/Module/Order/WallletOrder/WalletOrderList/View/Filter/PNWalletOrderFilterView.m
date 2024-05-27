//
//  PNFilterView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletOrderFilterView.h"
#import "NSObject+HDKitCore.h"
#import "PNBillFilterModel.h"
#import "PNCollectionView.h"
#import "PNCommonUtils.h"
#import "PNFilterCurrencyCell.h"
#import "PNFilterDateCell.h"
#import "SACollectionReusableView.h"
#import "UICollectionViewLeftAlignLayout.h"

static NSString *const kFilterSectionType = @"section_type";
static NSString *const kDateType = @"filter_date_type";
static NSString *const kBillType = @"filter_bill_type";
static NSString *const kCurrencyType = @"filter_currency_type";


@interface PNWalletOrderFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) HDUIButton *resetButton;
@property (nonatomic, strong) HDUIButton *confirmButton;
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSourceArray;

@end


@implementation PNWalletOrderFilterView

- (void)hd_setupViews {
    [self initData];
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];

    [self.contentView addSubview:self.resetButton];
    [self.contentView addSubview:self.confirmButton];
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
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(kRealWidth(5));
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

    [self.dataSourceArray removeAllObjects];
    [self initData];
    [self.collectionView successGetNewDataWithNoMoreData:NO];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    self.cellHeight = self.collectionView.contentSize.height;
    HDLog(@"cellHeight: %f", self.cellHeight);

    [self setNeedsUpdateConstraints];
}

- (void)hidden {
    [self removeFromSuperview];
}

- (void)resetAllStatus {
    for (HDTableViewSectionModel *sectionModel in self.dataSourceArray) {
        NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
        if ([type isEqualToString:kCurrencyType] || [type isEqualToString:kBillType]) {
            for (PNBillFilterModel *model in sectionModel.list) {
                model.isSelected = NO;
            }
            ///  将第一个设置为 选中
            PNBillFilterModel *firstModel = [sectionModel.list firstObject];
            firstModel.isSelected = YES;

        } else {
            for (PNBillFilterModel *model in sectionModel.list) {
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
            PNBillFilterModel *firstModel = [sectionModel.list firstObject];
            startDate = firstModel.value;

            PNBillFilterModel *lastModel = [sectionModel.list lastObject];
            endDate = lastModel.value;

            break;
        }
    }

    /**
     如果选择了开始时间，没有选择 结束时间， 则结束时间默认当天
     并且 时间跨度不能超过31天
    */
    if (WJIsStringNotEmpty(endDate)) {
        if (WJIsStringNotEmpty(startDate) && [PNCommonUtils getDiffenrenceByDate1:startDate date2:endDate] <= 365) {
            self.confirmButton.enabled = YES;
        } else {
            self.confirmButton.enabled = NO;
        }
    } else {
        if (WJIsStringEmpty(startDate)) {
            self.confirmButton.enabled = YES;
        } else {
            if ([PNCommonUtils getDiffenrenceByDate1:startDate date2:endDate] <= 365 && WJIsStringNotEmpty(endDate)) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        }
    }
}

#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:section];
    return sectionModel.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataSourceArray objectAtIndex:indexPath.section];
    NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
    if ([type isEqualToString:kDateType]) {
        PNFilterDateCell *cell = [PNFilterDateCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        PNBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        cell.model = model;

        @HDWeakify(self);
        cell.selectDateBlock = ^(NSString *_Nonnull selectDate) {
            @HDStrongify(self);
            [self ruleLimit];
        };
        return cell;
    } else if ([type isEqualToString:kBillType]) {
        PNFilterCurrencyCell *cell = [PNFilterCurrencyCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:kBillType];
        PNBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        cell.model = model;
        return cell;
    } else if ([type isEqualToString:kCurrencyType]) {
        PNFilterCurrencyCell *cell = [PNFilterCurrencyCell cellWithCollectionView:collectionView forIndexPath:indexPath identifier:kCurrencyType];
        PNBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        cell.model = model;
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
    if ([type isEqualToString:kCurrencyType] || [type isEqualToString:kBillType]) {
        for (PNBillFilterModel *model in sectionModel.list) {
            model.isSelected = NO;
        }
        PNBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];
        model.isSelected = YES;

        if ([type isEqualToString:kCurrencyType]) {
            self.currency = model.value;
        }
        if ([type isEqualToString:kBillType]) {
            self.transType = model.value;
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
                    PNBillFilterModel *firstModel = [sectionModel.list firstObject];
                    self.startDate = firstModel.value;

                    PNBillFilterModel *lastModel = [sectionModel.list lastObject];
                    self.endDate = lastModel.value;

                    break;
                }
            }

            !self.confirmBlock ?: self.confirmBlock(self.startDate, self.endDate, self.transType, self.currency);
        }];

        _confirmButton = button;
    }
    return _confirmButton;
}

- (NSMutableArray<PNBillFilterModel *> *)billTypeDataSource {
    /**
     PNWalletListFilterType const  = @"03";          ///< 03 提现
     PNWalletListFilterType const  = @"04";            ///< 04 转账
     PNWalletListFilterType const  = @"05";            ///< 05 汇兑
     PNWalletListFilterType const  = @"06";          ///< 06 结算
     PNWalletListFilterType const  = @"07";    ///< 07 分录调帐
     PNWalletListFilterType const  = @"08";     ///< 08:自主调帐
     PNWalletListFilterType const  = @"09";              ///< 09 退款
     PNWalletListFilterType const  = @"10";           ///< 10 营销

     */
    NSMutableArray *arr = [NSMutableArray array];
    PNBillFilterModel *model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_All];
    model.value = PNWalletListFilterType_All;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Consumption];
    model.value = PNWalletListFilterType_Consumption;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Recharge];
    model.value = PNWalletListFilterType_Recharge;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Withdrawal];
    model.value = PNWalletListFilterType_Withdrawal;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Transfer];
    model.value = PNWalletListFilterType_Transfer;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Exchange];
    model.value = PNWalletListFilterType_Exchange;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Settlement];
    model.value = PNWalletListFilterType_Settlement;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Entry_Adjustment];
    model.value = PNWalletListFilterType_Entry_Adjustment;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Self_Adjustment];
    model.value = PNWalletListFilterType_Self_Adjustment;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Refund];
    model.value = PNWalletListFilterType_Refund;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Marketing];
    model.value = PNWalletListFilterType_Marketing;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getWalletOrderListFilterTypeName:PNWalletListFilterType_Credit];
    model.value = PNWalletListFilterType_Credit;
    [arr addObject:model];

    [self setDefaultTransType:arr];

    return arr;
}

- (void)setDefaultTransType:(NSMutableArray *)array {
    for (PNBillFilterModel *model in array) {
        if ([model.value isEqualToString:self.transType]) {
            model.isSelected = YES;
            break;
        }
    }
}

- (NSMutableArray *)currencyDataSource {
    NSMutableArray *arr = [NSMutableArray array];
    PNBillFilterModel *model = PNBillFilterModel.new;
    model.titleName = PNLocalizedString(@"TRANS_TYPE_ALL", @"所有");
    model.value = @"";
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = PNCurrencyTypeUSD;
    model.value = PNCurrencyTypeUSD;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = PNCurrencyTypeKHR;
    model.value = PNCurrencyTypeKHR;
    [arr addObject:model];

    [self setDefaultCurrency:arr];

    return arr;
}

- (void)setDefaultCurrency:(NSMutableArray *)array {
    for (PNBillFilterModel *model in array) {
        if ([model.value isEqualToString:self.currency]) {
            model.isSelected = YES;
            break;
        }
    }
}

- (NSMutableArray *)dateTimeSource {
    NSMutableArray *arr = [NSMutableArray array];
    PNBillFilterModel *model = PNBillFilterModel.new;
    model.titleName = PNLocalizedString(@"select_start_date", @"选择开始日期");
    model.value = self.startDate;
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = PNLocalizedString(@"select_end_date", @"选择结束日期");
    model.value = self.endDate;
    [arr addObject:model];

    return arr;
}

- (void)initData {
    HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
    [sectionModel hd_bindObjectWeakly:kDateType forKey:kFilterSectionType];
    SACollectionReusableViewModel *headerModel = SACollectionReusableViewModel.new;
    headerModel.title = PNLocalizedString(@"select_date_type", @"查询日期");
    headerModel.tag = PNLocalizedString(@"WMg7NK01", @"起止日期跨度不能超过1年");
    headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
    headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
    headerModel.tagColor = HDAppTheme.PayNowColor.c9599A2;
    headerModel.tagFont = HDAppTheme.PayNowFont.standard12;
    headerModel.tagBackgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    sectionModel.commonHeaderModel = headerModel;

    sectionModel.list = [self dateTimeSource];
    [self.dataSourceArray addObject:sectionModel];

    sectionModel = HDTableViewSectionModel.new;
    [sectionModel hd_bindObjectWeakly:kBillType forKey:kFilterSectionType];
    headerModel = SACollectionReusableViewModel.new;
    headerModel.title = PNLocalizedString(@"trans_type", @"交易类型");
    headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
    headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
    sectionModel.commonHeaderModel = headerModel;

    sectionModel.list = [self billTypeDataSource];

    [self.dataSourceArray addObject:sectionModel];

    sectionModel = HDTableViewSectionModel.new;
    [sectionModel hd_bindObjectWeakly:kCurrencyType forKey:kFilterSectionType];

    headerModel = SACollectionReusableViewModel.new;
    headerModel.title = PNLocalizedString(@"trans_currency", @"交易币种");
    headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
    headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
    sectionModel.commonHeaderModel = headerModel;

    sectionModel.list = [self currencyDataSource];
    [self.dataSourceArray addObject:sectionModel];
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end

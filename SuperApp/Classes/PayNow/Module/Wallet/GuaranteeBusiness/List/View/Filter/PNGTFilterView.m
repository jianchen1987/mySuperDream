//
//  PNGTFilterView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGTFilterView.h"
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


@interface PNGTFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) HDUIButton *resetButton;
@property (nonatomic, strong) HDUIButton *confirmButton;
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSourceArray;

@end


@implementation PNGTFilterView

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

    //    self.cellHeight = self.collectionView.contentSize.height;
    //    HDLog(@"cellHeight: %f", self.cellHeight);
    //
    //    [self setNeedsUpdateConstraints];
}

- (void)hidden {
    [self removeFromSuperview];
}

- (void)resetAllStatus {
    for (HDTableViewSectionModel *sectionModel in self.dataSourceArray) {
        NSString *type = [sectionModel hd_getBoundObjectForKey:kFilterSectionType];
        if ([type isEqualToString:kBillType]) {
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
    if ([type isEqualToString:kBillType]) {
        PNBillFilterModel *model = [sectionModel.list objectAtIndex:indexPath.item];

        ///
        if ([model.value isEqualToString:[NSString stringWithFormat:@"%zd", PNGuarateenStatus_ALL]]) {
            for (PNBillFilterModel *model in sectionModel.list) {
                model.isSelected = NO;
            }
            model.isSelected = YES;
            [self.statusArray removeAllObjects];
            [self.statusArray addObject:@(PNGuarateenStatus_ALL)];
        } else {
            model.isSelected = !model.isSelected;
            if (model.isSelected) {
                if (![self.statusArray containsObject:@(model.value.integerValue)]) {
                    [self.statusArray addObject:@(model.value.integerValue)];
                }

                /// 将所有 这个选项取消掉 选中状态
                PNBillFilterModel *firstModel = [sectionModel.list objectAtIndex:0];
                firstModel.isSelected = NO;
                [self.statusArray removeObject:@(PNGuarateenStatus_ALL)];
            } else {
                [self.statusArray removeObject:@(model.value.integerValue)];

                /// 都全部取消掉之后就默认帮忙选中 所有
                if (self.statusArray.count == 0) {
                    PNBillFilterModel *firstModel = [sectionModel.list objectAtIndex:0];
                    firstModel.isSelected = YES;
                    [self.statusArray addObject:@(PNGuarateenStatus_ALL)];
                }
            }
        }
    }

    [self.collectionView successGetNewDataWithNoMoreData:NO];
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

            !self.confirmBlock ?: self.confirmBlock(self.startDate, self.endDate, self.statusArray);
        }];

        _confirmButton = button;
    }
    return _confirmButton;
}

/*
 PNGuarateenStatus_ALL = 0,                          ///< 0 所有
 PNGuarateenStatus_UNCONFIRMED = 10,                 ///< 10 待确认
 PNGuarateenStatus_UNPAID = 11,                      ///< 11 待付款
 PNGuarateenStatus_PENDING = 12,                     ///< 12 待完成
 PNGuarateenStatus_COMPLETED = 13,                   ///< 13 已完成
 PNGuarateenStatus_CANCELED = 14,                    ///< 14 已取消
 PNGuarateenStatus_REFUND_APPLY = 15,                ///< 15 买方申请退款
 PNGuarateenStatus_REFUND_REJECT = 16,               ///< 16 卖方拒绝退款
 PNGuarateenStatus_REFUND_APPEAL = 17,               ///< 17 买方申述
 PNGuarateenStatus_APPEAL_REJECT = 18,               ///< 18 申述驳回
 PNGuarateenStatus_REFUNDED = 19,                    ///< 19 已退款
 */
- (NSMutableArray<PNBillFilterModel *> *)billTypeDataSource {
    NSMutableArray *arr = [NSMutableArray array];
    PNBillFilterModel *model = PNBillFilterModel.new;
    model.titleName = PNLocalizedString(@"TRANS_TYPE_ALL", @"所有");
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_ALL];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_UNCONFIRMED];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_UNCONFIRMED];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_UNPAID];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_UNPAID];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_PENDING];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_PENDING];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_COMPLETED];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_COMPLETED];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_CANCELED];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_CANCELED];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_REFUNDED];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_REFUNDED];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_REFUND_APPLY];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_REFUND_APPLY];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_REFUND_REJECT];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_REFUND_REJECT];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_REFUND_APPEAL];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_REFUND_APPEAL];
    [arr addObject:model];

    model = PNBillFilterModel.new;
    model.titleName = [PNCommonUtils getGuarateenStatusName:PNGuarateenStatus_APPEAL_REJECT];
    model.value = [NSString stringWithFormat:@"%zd", PNGuarateenStatus_APPEAL_REJECT];
    [arr addObject:model];

    [self setDefaultTransType:arr];

    return arr;
}

- (void)setDefaultTransType:(NSMutableArray *)array {
    for (PNBillFilterModel *model in array) {
        for (NSNumber *itemStatus in self.statusArray) {
            if (model.value.integerValue == itemStatus.integerValue) {
                model.isSelected = YES;
                break;
            }
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
    headerModel.tag = PNLocalizedString(@"select_date_type_tips", @"起止日期跨度不能超过1个月");
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
    headerModel.title = PNLocalizedString(@"pn_bill_status", @"缴费状态");
    headerModel.titleColor = HDAppTheme.PayNowColor.c343B4D;
    headerModel.titleFont = [HDAppTheme.PayNowFont fontMedium:15];
    sectionModel.commonHeaderModel = headerModel;
    sectionModel.list = [self billTypeDataSource];

    [self.dataSourceArray addObject:sectionModel];
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end

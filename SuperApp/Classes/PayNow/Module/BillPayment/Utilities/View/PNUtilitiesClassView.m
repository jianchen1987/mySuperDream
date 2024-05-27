//
//  PNUtilitiesClassView.m
//  SuperApp  账单
//
//  Created by xixi_wen on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUtilitiesClassView.h"
#import "NSObject+HDKitCore.h"
#import "PNCollectionView.h"
#import "PNFunctionCellModel.h"
#import "PNNotifyView.h"
#import "PNRecentItemCell.h"
#import "PNToQueryModel.h"
#import "PNUtilitiesClassCell.h"
#import "PNUtilitiesViewModel.h"
#import "SACollectionReusableView.h"
#import "SACollectionViewSectionModel.h"


@interface PNUtilitiesClassView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) PNUtilitiesViewModel *viewModel;
@property (nonatomic, strong) PNNotifyView *notifyView;

@end


@implementation PNUtilitiesClassView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.viewModel getAllBillCategory];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.collectionView successGetNewDataWithNoMoreData:NO];
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.notifyView];
    [self addSubview:self.collectionView];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeBillPayment];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}

- (void)updateConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(self.viewController.hd_navigationBar.mas_bottom);
        }];
    }

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        if (!self.notifyView.hidden) {
            make.top.mas_equalTo(self.notifyView.mas_bottom);
        } else {
            make.top.mas_equalTo(self.viewController.hd_navigationBar.mas_bottom);
        }
        make.bottom.mas_equalTo(iPhoneXSeries ? @(-kiPhoneXSeriesSafeBottomHeight) : @(-20));
    }];

    [super updateConstraints];
}

#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kUtilitiesTag];

    if ([tag isEqualToString:Tag_utilities]) {
        return 1;
    } else {
        return sectionModel.list.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kUtilitiesTag];
    if ([tag isEqualToString:Tag_utilities]) {
        PNUtilitiesClassCell *cell = [PNUtilitiesClassCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.dataArray = [NSMutableArray arrayWithArray:sectionModel.list];
        return cell;
    } else {
        // Tag_recent_payment
        PNRecentItemCell *cell = [PNRecentItemCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.itemModel = [sectionModel.list objectAtIndex:indexPath.item];
        cell.isLast = (indexPath.item == sectionModel.list.count - 1);
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    SACollectionViewSectionModel *model = self.viewModel.dataSource[section];
    if (model.headerModel != nil) {
        return CGSizeMake(kScreenWidth, kRealWidth(50));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kUtilitiesTag];

    if ([tag isEqualToString:Tag_utilities]) {
        if (sectionModel.list.count > 0) {
            PNUtilitiesClassCell *cell = [PNUtilitiesClassCell cellWithCollectionView:collectionView forIndexPath:indexPath];
            cell.dataArray = [NSMutableArray arrayWithArray:sectionModel.list];
            return CGSizeMake(kScreenWidth, [cell collectionViewSizeHeight]);
        } else {
            return CGSizeMake(0, 0);
        }
    } else {
        return CGSizeMake(kScreenWidth, kRealWidth(65));
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SACollectionReusableView *view = [SACollectionReusableView headerWithCollectionView:collectionView forIndexPath:indexPath];
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    view.model = (SACollectionReusableViewModel *)sectionModel.headerModel;
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kUtilitiesTag];

    if ([tag isEqualToString:Tag_recent_payment] && [cell isKindOfClass:PNRecentItemCell.class]) {
        PNRecentItemCell *recentCell = (PNRecentItemCell *)cell;
        [recentCell layoutIfNeeded];

        CGFloat radius = kRealWidth(10);
        if (sectionModel.list.count == 1) {
            // 总数是一行
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:recentCell.bgView.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(radius, radius)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = recentCell.bgView.bounds;
            maskLayer.path = maskPath.CGPath;
            recentCell.bgView.layer.mask = maskLayer;
        } else {
            // 当前总数 不止1行
            if (indexPath.row == 0) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:recentCell.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                     cornerRadii:CGSizeMake(radius, radius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = recentCell.bgView.bounds;
                maskLayer.path = maskPath.CGPath;
                recentCell.bgView.layer.mask = maskLayer;

            } else if (indexPath.row == (sectionModel.list.count - 1)) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:recentCell.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                     cornerRadii:CGSizeMake(radius, radius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = recentCell.bgView.bounds;
                maskLayer.path = maskPath.CGPath;
                recentCell.bgView.layer.mask = maskLayer;
            } else {
                recentCell.bgView.layer.mask = nil;
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = [self.viewModel.dataSource objectAtIndex:indexPath.section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kUtilitiesTag];

    if ([tag isEqualToString:Tag_recent_payment]) {
        PNRecentBillListItemModel *itemModel = [sectionModel.list objectAtIndex:indexPath.item];
        if (itemModel) {
            if (itemModel.paymentCategory == PNPaymentCategoryGame) {
                //娱乐缴费的暂时没有快捷支付
            } else {
                PNToQueryModel *toModel = [[PNToQueryModel alloc] init];
                NSString *customerCode = itemModel.billCode;
                if ([customerCode rangeOfString:@"-"].location != NSNotFound) {
                    NSArray *arr = [customerCode componentsSeparatedByString:@"-"];
                    if (arr.count > 1) {
                        customerCode = [arr objectAtIndex:1];
                    }
                }

                toModel.customerCode = customerCode;
                toModel.paymentCategory = itemModel.paymentCategory;
                toModel.payTo = [NSString stringWithFormat:@"%@-%@", itemModel.supplierCode, itemModel.supplierName];
                toModel.apiCredential = itemModel.apiCredential;
                toModel.billerCode = itemModel.supplierCode;
                NSDictionary *dict = [toModel yy_modelToJSONObject];

                [HDMediator.sharedInstance navigaveToPayNowQueryWaterPaymentVC:dict];
            }
        }
    }
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.needRefreshHeader = true;
        _collectionView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        _collectionView.needRecognizeSimultaneously = NO;
        [_collectionView registerClass:SACollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACollectionReusableView.class)];
        [_collectionView registerClass:PNUtilitiesClassCell.class forCellWithReuseIdentifier:NSStringFromClass(PNUtilitiesClassCell.class)];
        [_collectionView registerClass:PNRecentItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PNRecentItemCell.class)];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_collectionView.mj_header;
        header.stateLabel.font = HDAppTheme.font.standard3;
        header.stateLabel.textColor = HDAppTheme.color.G3;

        MJRefreshAutoStateFooter *footer = (MJRefreshAutoStateFooter *)_collectionView.mj_footer;
        footer.automaticallyChangeAlpha = YES;
        footer.backgroundColor = UIColor.clearColor;

        @HDWeakify(self);
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getAllBillCategory];
        };
    }
    return _collectionView;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end

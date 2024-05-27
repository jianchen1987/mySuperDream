//
//  PNMSHomeView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSHomeView.h"
#import "PNCollectionView.h"
#import "PNFunctionCellModel.h"
#import "PNMSAccountIndexCell.h"
#import "PNMSFunctionCell.h"
#import "PNMSHomeViewModel.h"
#import "PNNotifyView.h"
#import "SACollectionReusableView.h"
#import "SACollectionViewSectionModel.h"


@interface PNMSHomeView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) PNMSHomeViewModel *viewModel;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) PNNotifyView *notifyView;
@end


@implementation PNMSHomeView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);

        NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeMerchantServices];
        if (WJIsStringNotEmpty(noticeContent)) {
            self.notifyView.content = noticeContent;
            self.notifyView.hidden = NO;
        } else {
            self.notifyView.hidden = YES;
        }

        [UIView performWithoutAnimation:^{
            [self.collectionView successGetNewDataWithNoMoreData:NO];
        }];

        [self setNeedsUpdateConstraints];
    }];
    if ([VipayUser hasWalletBalanceMenu]) {
        [self.viewModel getNewData];
    }
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.notifyView];
    [self addSubview:self.collectionView];
}

- (void)updateConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(self.viewController.hd_navigationBar.mas_bottom);
        }];
    }

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        if (!self.notifyView.hidden) {
            make.top.mas_equalTo(self.notifyView.mas_bottom);
        } else {
            make.top.mas_equalTo(self);
        }
    }];

    [super updateConstraints];
}

- (void)beginGetNewData {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section >= self.viewModel.dataSource.count) {
        return 0;
    }
    SACollectionViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if ([sectionModel.hd_associatedObject isEqualToString:kAccountFlag]) {
        return 1;
    } else {
        NSArray *list = self.viewModel.dataSource[section].list;
        return list.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.viewModel.dataSource.count) {
        return UICollectionViewCell.new;
    }
    SACollectionViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count) {
        return UICollectionViewCell.new;
    }

    NSString *associatedObjectStr = sectionModel.hd_associatedObject;
    if ([associatedObjectStr isEqualToString:kAccountFlag]) {
        PNMSAccountIndexCell *cell = [PNMSAccountIndexCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.dataArray = [NSMutableArray arrayWithArray:sectionModel.list];
        return cell;
    } else if ([associatedObjectStr isEqualToString:kTopFunctionFlag]) {
        id model = sectionModel.list[indexPath.row];
        PNMSFunctionCell *cell = [PNMSFunctionCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = (PNFunctionCellModel *)model;
        return cell;
    }

    return UICollectionViewCell.new;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SACollectionViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:PNFunctionCellModel.class]) {
        PNFunctionCellModel *fmodel = (PNFunctionCellModel *)model;
        if (fmodel.actionName.length > 0) {
            NSString *actionName = fmodel.actionName;
            //收款码
            if([actionName isEqualToString:@"merchantServicesReceiveCode"]) {
                PNAccountLevelUpgradeStatus status = VipayUser.shareInstance.upgradeStatus;
                PNUserLevel level = VipayUser.shareInstance.accountLevel;
//                if (level == PNUserLevelNormal
//                    && (status != PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING && status != PNAccountLevelUpgradeStatus_SENIOR_UPGRADING && status != PNAccountLevelUpgradeStatus_APPROVALING)) {
                if (level == PNUserLevelNormal){
                    [NAT showAlertWithMessage:PNLocalizedString(@"save_tips_level", @"该功能仅向已提交KYC认证的用户开放，如需使用请升级您的账户等级。")
                        confirmButtonTitle:PNLocalizedString(@"Go_to_upgrade", @"去升级") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            [HDMediator.sharedInstance navigaveToPayNowUpgradeAccountVC:@{@"needCall": @(YES)}];
                            [alertView dismiss];
                        }
                        cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            [alertView dismiss];
                        }];
                }else{
                    NSString *url = [NSString stringWithFormat:@"SuperApp://PayNow/%@", actionName];
                    [SAWindowManager openUrl:url withParameters:@{}];
                }
            }else{
                NSString *url = [NSString stringWithFormat:@"SuperApp://PayNow/%@", actionName];
                [SAWindowManager openUrl:url withParameters:@{}];
            }
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.viewModel.dataSource.count)
        return CGSizeZero;
    SACollectionViewSectionModel *sectionModel = self.viewModel.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return CGSizeZero;

    NSString *associatedObjectStr = sectionModel.hd_associatedObject;
    if ([associatedObjectStr isEqualToString:kAccountFlag]) {
        return CGSizeMake(kScreenWidth, kRealWidth(155));
    } else if ([associatedObjectStr isEqualToString:kTopFunctionFlag]) {
        CGFloat width = (kScreenWidth - kRealWidth(20)) / 3.f;
        return CGSizeMake(width, kRealWidth(120));
    }

    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    SACollectionViewSectionModel *sectionModel = self.viewModel.dataSource[section];
    if ([sectionModel.hd_associatedObject isEqualToString:kTopFunctionFlag]) {
        return UIEdgeInsetsMake(kRealWidth(24), kRealWidth(10), 0, kRealWidth(10));
    } else if ([sectionModel.hd_associatedObject isEqualToString:kAccountFlag]) {
        return UIEdgeInsetsMake(kRealWidth(24), 0, 0, 0);
    } else {
        return UIEdgeInsetsZero;
    }
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        //        flowLayout.estimatedItemSize = CGSizeMake(70, 23);

        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.needRefreshHeader = [VipayUser hasWalletBalanceMenu];
        _collectionView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _collectionView.needRecognizeSimultaneously = NO;

        [_collectionView registerClass:SACollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACollectionReusableView.class)];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_collectionView.mj_header;
        header.stateLabel.font = HDAppTheme.font.standard3;
        header.stateLabel.textColor = HDAppTheme.color.G3;

        MJRefreshAutoStateFooter *footer = (MJRefreshAutoStateFooter *)_collectionView.mj_footer;
        footer.automaticallyChangeAlpha = YES;
        footer.backgroundColor = UIColor.clearColor;

        @HDWeakify(self);
        _collectionView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self.viewModel getNewData];
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

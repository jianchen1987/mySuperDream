//
//  PNWalletView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNWalletView.h"
#import "PNAccountIndexCell.h"
#import "PNAcountCell.h"
#import "PNAlertWebView.h"
#import "PNBottomFunIndexCell.h"
#import "PNCollectionView.h"
#import "PNFunctionCell.h"
#import "PNFunctionCellModel.h"
#import "PNNotifyView.h"
#import "PNWalletBalanceCell.h"
#import "PNWalletHomeBannerCell.h"
#import "PNWalletHomeBannerModel.h"
#import "PNWalletLevelInfoCellView.h"
#import "PNWalletViewModel.h"
#import "SAApolloManager.h"
#import "SACollectionReusableView.h"
#import "SACollectionViewSectionModel.h"
#import "TNModifyCountAlertView.h"


@interface PNWalletView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) PNWalletViewModel *viewModel;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) HDUIButton *contactUsBtn; ///联系我们
@property (nonatomic, strong) SALabel *coolCashLabel;
@property (nonatomic, strong) PNNotifyView *notifyView;
@end


@implementation PNWalletView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.collectionView];
    [self addSubview:self.coolCashLabel];
    [self addSubview:self.notifyView];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        NSString *noticeContent = [PNCommonUtils getNotifiView:0];
        if (WJIsStringNotEmpty(noticeContent)) {
            self.notifyView.content = noticeContent;
            self.notifyView.hidden = NO;
        } else {
            self.notifyView.hidden = YES;
        }

        [self.viewModel resetDataSource];
        @HDStrongify(self);
        [UIView performWithoutAnimation:^{
            [self.collectionView successGetNewDataWithNoMoreData:NO];
        }];

        [self setNeedsUpdateConstraints];
    }];

    [self.viewModel getNewData];
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
        make.bottom.mas_equalTo(self.coolCashLabel.mas_top).offset(kRealWidth(-10));
    }];

    [self.coolCashLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(20)));
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
    } else if ([sectionModel.hd_associatedObject isEqualToString:kBottomFunctionFlag]) {
        return 1;
    } else if ([sectionModel.hd_associatedObject isEqualToString:kLevelInfoFlag]) {
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
    if ([associatedObjectStr isEqualToString:kLevelInfoFlag]) {
        PNWalletLevelInfoCellView *cell = [PNWalletLevelInfoCellView cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.refreshFlag = !cell.refreshFlag;
        return cell;
    } else if ([associatedObjectStr isEqualToString:kBottomFunctionFlag]) {
        PNBottomFunIndexCell *cell = [PNBottomFunIndexCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.dataArray = [NSMutableArray arrayWithArray:sectionModel.list];
        return cell;
    } else if ([associatedObjectStr isEqualToString:kAccountFlag]) {
        //        PNAccountIndexCell *cell = [PNAccountIndexCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        //        cell.dataArray = [NSMutableArray arrayWithArray:sectionModel.list];

        PNWalletBalanceCell *cell = [PNWalletBalanceCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        if (!WJIsArrayEmpty(sectionModel.list)) {
            cell.model = [sectionModel.list firstObject];
        }
        return cell;
    } else if ([associatedObjectStr isEqualToString:kTopFunctionFlag]) {
        id model = sectionModel.list[indexPath.row];
        PNFunctionCell *cell = [PNFunctionCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = (PNFunctionCellModel *)model;
        return cell;
    } else if ([associatedObjectStr isEqualToString:kBannerFlag]) {
        id model = sectionModel.list[indexPath.row];
        PNWalletHomeBannerCell *cell = [PNWalletHomeBannerCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = (PNWalletHomeBannerModel *)model;
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
            if ([actionName isEqualToString:@"pnScanner"]) {
                /// 扫码 共用到中台
                NSString *url = @"SuperApp://SuperApp/scanQRCode";
                [SAWindowManager openUrl:url withParameters:@{}];
            } else {
                //收款码
                if([actionName isEqualToString:@"receiveCode"]) {
                    
                    PNAccountLevelUpgradeStatus status = VipayUser.shareInstance.upgradeStatus;
                    PNUserLevel level = VipayUser.shareInstance.accountLevel;
//                    if (level == PNUserLevelNormal
//                        && (status != PNAccountLevelUpgradeStatus_INTERMEDIATE_UPGRADEING && status != PNAccountLevelUpgradeStatus_SENIOR_UPGRADING && status != PNAccountLevelUpgradeStatus_APPROVALING)) {
                    if (level == PNUserLevelNormal) {
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
    } else if ([model isKindOfClass:PNWalletHomeBannerModel.class]) {
        PNWalletHomeBannerModel *bannerModel = (PNWalletHomeBannerModel *)model;
        if ([SAWindowManager canOpenURL:bannerModel.routingUrl]) {
            [SAWindowManager openUrl:bannerModel.routingUrl withParameters:@{}];
        }
    } else if ([model isKindOfClass:PNWalletAcountModel.class]) {
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
    BOOL isShowTips = (VipayUser.shareInstance.accountLevel != PNUserLevelHonour) ? YES : NO;
    if ([associatedObjectStr isEqualToString:kLevelInfoFlag]) {
        return CGSizeMake(kScreenWidth, isShowTips ? kRealHeight(105) : kRealWidth(80));
    } else if ([associatedObjectStr isEqualToString:kBottomFunctionFlag]) {
        PNBottomFunIndexCell *cell = [PNBottomFunIndexCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.dataArray = [NSMutableArray arrayWithArray:sectionModel.list];
        return CGSizeMake(kScreenWidth, [cell collectionViewSizeHeight]);
    } else if ([associatedObjectStr isEqualToString:kAccountFlag]) {
        return CGSizeMake(kScreenWidth, kRealWidth(260));
    } else if ([associatedObjectStr isEqualToString:kTopFunctionFlag]) {
        CGFloat width = (kScreenWidth - kRealWidth(40)) / 3.f;
        return CGSizeMake(width, kRealWidth(65));
    } else if ([associatedObjectStr isEqualToString:kBannerFlag]) {
        /// 宽/高  345:108
        CGFloat width = kScreenWidth - kRealWidth(30);
        CGFloat height = width * 108 / 345.f;
        return CGSizeMake(width, height + kRealWidth(10));
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
    if ([sectionModel.hd_associatedObject isEqualToString:kBottomFunctionFlag]) {
        return UIEdgeInsetsMake(kRealWidth(20), 0, 0, 0);
    } else if ([sectionModel.hd_associatedObject isEqualToString:kTopFunctionFlag]) {
        return UIEdgeInsetsMake(0, kRealWidth(20), 0, kRealWidth(20));
    } else if ([sectionModel.hd_associatedObject isEqualToString:kAccountFlag]) {
        return UIEdgeInsetsMake(kRealWidth(20), 0, 0, 0);
    } else if ([sectionModel.hd_associatedObject isEqualToString:kBannerFlag]) {
        return UIEdgeInsetsMake(kRealWidth(20), 0, 0, 0);
    } else {
        return UIEdgeInsetsZero;
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

- (SALabel *)coolCashLabel {
    if (!_coolCashLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:12];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        label.text = SALocalizedString(@"Powered_by_CoolCash", @"服务由CoolCash提供支持");
        _coolCashLabel = label;
    }
    return _coolCashLabel;
}

- (PNWalletViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNWalletViewModel alloc] init];
    }
    return _viewModel;
}

- (HDUIButton *)contactUsBtn {
    if (!_contactUsBtn) {
        _contactUsBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_contactUsBtn setTitle:PNLocalizedString(@"pn_contact_us", @"联系我们") forState:0];
        [_contactUsBtn setImage:[UIImage imageNamed:@"telegram"] forState:0];
        [_contactUsBtn setTitleColor:[UIColor colorWithRed:59 / 255.0 green:170 / 255.0 blue:216 / 255.0 alpha:1] forState:0];
        _contactUsBtn.spacingBetweenImageAndTitle = kRealWidth(8);
        _contactUsBtn.titleLabel.font = HDAppTheme.PayNowFont.standard16;

        [_contactUsBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            //@"https://t.me/081547679"
            NSString *tgKey = [SAApolloManager getApolloConfigForKey:kApolloCoolcashTelegram];
            if (WJIsStringEmpty(tgKey)) {
                tgKey = @"wownow_cs_bot";
            }
            NSURL *tgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://t.me/%@", tgKey]];
            if (![UIApplication.sharedApplication canOpenURL:tgUrl]) {
                HDLog(@"未安装Tg");
                return;
            }
            [UIApplication.sharedApplication openURL:tgUrl options:@{} completionHandler:^(BOOL success){
            }];
        }];
    }
    return _contactUsBtn;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end

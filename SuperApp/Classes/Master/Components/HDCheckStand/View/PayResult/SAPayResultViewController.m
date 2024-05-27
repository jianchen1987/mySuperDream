//
//  SAPayResultViewController.m
//  SuperApp
//
//  Created by Chaos on 2020/8/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPayResultViewController.h"
#import "SACMSCollectionViewCell.h"
#import "SACouponRedemptionBannerView.h"
#import "SACouponRedemptionRspModel.h"
#import "SALotteryAlertViewPresenter.h"
#import "SAPayResultView.h"
#import "SAPayResultViewModel.h"
#import "SAQueryPaymentStateRspModel.h"


@interface SAPayResultViewController ()

/// view
@property (nonatomic, strong) SAPayResultView *resultView;
/// 优惠券容器
@property (nonatomic, strong) SACouponRedemptionBannerView *couponView;
/// paymentDto
@property (nonatomic, strong) SAPayResultViewModel *viewModel;
/// 完成按钮
@property (nonatomic, strong) HDUIButton *doneBTN;

///< 自定义模型
@property (nonatomic, strong) SACMSCustomCollectionCellModel *resultViewModel;
@property (nonatomic, strong) SACMSCustomCollectionCellModel *couponViewModel;
///< 数据源
@property (nonatomic, strong) NSArray<SACMSCustomCollectionCellModel *> *customDataSource;

///< 查询定时器
@property (nonatomic, strong) NSTimer *paymentStatusTimer;

@end


@implementation SAPayResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self.parameters = parameters;
    return [super initWithRouteParameters:parameters];
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];

    [self setHd_navLeftBarButtonItem:nil];
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.doneBTN]];
}

- (void)hd_setupViews {
    [super hd_setupViews];
    self.hd_interactivePopDisabled = true;

    self.paymentStatusTimer = [HDWeakTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestNewStatus) userInfo:nil repeats:YES];
    [self.paymentStatusTimer fire];
}

- (void)hd_bindViewModel {
    [super hd_bindViewModel];

    [self.resultView hd_bindViewModel];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"resultModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self paymentStatusChanged:self.viewModel.resultModel];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"couponRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.couponRspModel.list.count) {
            // 有券需要重新计算高度
            self.couponView.model = self.viewModel.couponRspModel;
            self.couponView.hidden = NO;
            self.couponViewModel.height = (kScreenWidth - kRealWidth(12)) * (118.0 / 363.0);
            [self reloadWithNoMoreData:NO];
        } else {
            self.couponView.hidden = YES;
            self.couponViewModel.height = 0;
        }
    }];
}

- (void)dealloc {
    [self.paymentStatusTimer invalidate];
    self.paymentStatusTimer = nil;
}

#pragma mark - DATA
- (void)requestNewStatus {
    [self.viewModel getNewData];
}

#pragma mark - event response
- (void)doneBtnAction {
    if (self.viewModel.doneClickBlock) {
        self.viewModel.doneClickBlock(self);
        return;
    }
    if ([self.viewModel.businessLine isEqualToString:SAClientTypeTinhNow]) { //需要回到电商模块首页
        [self.navigationController popToRootViewControllerAnimated:false];
        [HDMediator.sharedInstance navigaveToTinhNowController:nil];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)orderBtnAction {
    if (self.viewModel.orderClickBlock) {
        self.viewModel.orderClickBlock(self);
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:false];
    if ([self.viewModel.businessLine isEqualToString:SAClientTypeYumNow]) {
        [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": self.viewModel.orderNo, @"isFromOrderSubmit": @(1), @"isNeedQueryLottery": @(0)}];
    } else if ([self.viewModel.businessLine isEqualToString:SAClientTypeTinhNow]) {
        [SATalkingData trackEvent:@"[电商]支付结果_点击查看订单"];
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.viewModel.orderNo}];
    } else if ([self.viewModel.businessLine isEqualToString:SAClientTypePhoneTopUp]) {
        [HDMediator.sharedInstance navigaveToTopUpDetailViewController:@{@"orderNo": self.viewModel.orderNo, @"outPayOrderNo": self.viewModel.outPayOrderNo}];
    }
}

#pragma mark - private methods
- (void)autoJumpToOrderDetails {
    if (self.viewModel.orderClickBlock) {
        self.viewModel.orderClickBlock(self);
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:false];

    if ([self.viewModel.businessLine isEqualToString:SAClientTypeYumNow]) {
        [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": self.viewModel.orderNo, @"isFromOrderSubmit": @(1), @"isNeedQueryLottery": @(1)}];
    } else if ([self.viewModel.businessLine isEqualToString:SAClientTypeTinhNow]) {
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.viewModel.orderNo}];
    } else if ([self.viewModel.businessLine isEqualToString:SAClientTypePhoneTopUp]) {
        [HDMediator.sharedInstance navigaveToTopUpDetailViewController:@{@"orderNo": self.viewModel.orderNo, @"outPayOrderNo": self.viewModel.outPayOrderNo}];
    }
}

- (void)reCaculateViewHeight {
    if (self.resultViewModel.height != [self.resultView viewHeight]) {
        self.resultViewModel.height = [self.resultView viewHeight];
        [self reloadWithNoMoreData:NO];
    }
}

- (void)paymentStatusChanged:(SAQueryPaymentStateRspModel *)model {
    self.resultView.model = model;
    switch (model.payState) {
        case SAPaymentStateUnknown:
        case SAPaymentStateInit:
        case SAPaymentStateRefunding:
        case SAPaymentStatePaying:
            break;

        case SAPaymentStateRefunded:
        case SAPaymentStateClosed:
        case SAPaymentStatePayFail:
            [self.paymentStatusTimer invalidate];
            break;

        case SAPaymentStatePayed:
            [self.paymentStatusTimer invalidate];
            [self paymentSuccess];
            break;
    }
}

- (void)paymentSuccess {
    [self reCaculateViewHeight];

    if ([self.viewModel.businessLine isEqualToString:SAClientTypeYumNow] || [self.viewModel.businessLine isEqualToString:SAClientTypeTinhNow]) {
        [SALotteryAlertViewPresenter showLotteryAlertViewWithOrderNo:self.viewModel.orderNo completion:nil];
    }
    [self.viewModel autoCouponRedemptionSuccess:nil failure:nil];

    // 查询获得的积分数
    @HDWeakify(self);
    [self.viewModel queryHowManyWPontWillGetWithThisOrderCompletion:^{
        @HDStrongify(self);
        [self reCaculateViewHeight];
    }];
}

#pragma mark - OVEREWRITE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInArea:(CMSContainerCustomSection)customArea {
    if ([customArea isEqualToString:CMSContainerCustomSectionTop]) {
        return self.customDataSource.count;
    } else {
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath inArea:(CMSContainerCustomSection)customArea {
    SACMSCustomCollectionCell *cell = SACMSCustomCollectionCell.new;
    if ([customArea isEqualToString:CMSContainerCustomSectionTop]) {
        SACMSCustomCollectionCellModel *model = self.customDataSource[indexPath.row];
        cell = [SACMSCustomCollectionCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(nonnull UICollectionViewLayout *)collectionViewLayout
        sizeForItemAtRow:(NSUInteger)row
                  inArea:(nonnull CMSContainerCustomSection)customArea {
    if ([customArea isEqualToString:CMSContainerCustomSectionTop]) {
        SACMSCustomCollectionCellModel *model = self.customDataSource[row];
        return CGSizeMake(kScreenWidth, model.height);
    }

    return CGSizeZero;
}

#pragma mark - lazy load
- (SACMSCustomCollectionCellModel *)resultViewModel {
    if (!_resultViewModel) {
        _resultViewModel = [[SACMSCustomCollectionCellModel alloc] init];
        _resultViewModel.view = self.resultView;
        _resultViewModel.height = [self.resultView viewHeight];
    }
    return _resultViewModel;
}

- (SACMSCustomCollectionCellModel *)couponViewModel {
    if (!_couponViewModel) {
        _couponViewModel = [[SACMSCustomCollectionCellModel alloc] init];
        _couponViewModel.view = self.couponView;
        _couponViewModel.height = 0;
    }
    return _couponViewModel;
}

- (NSArray<SACMSCustomCollectionCellModel *> *)customDataSource {
    if (!_customDataSource) {
        _customDataSource = @[self.resultViewModel, self.couponViewModel];
    }
    return _customDataSource;
}

- (SAPayResultView *)resultView {
    if (!_resultView) {
        _resultView = [[SAPayResultView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _resultView.orderDetailClicked = ^{
            @HDStrongify(self);
            [self orderBtnAction];
        };
    }
    return _resultView;
}
/** @lazy viewmodel */
- (SAPayResultViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAPayResultViewModel alloc] init];
        _viewModel.orderNo = self.parameters[@"orderNo"];
        _viewModel.businessLine = self.parameters[@"businessLine"];
        _viewModel.merchantNo = self.parameters[@"merchantNo"];
        //        _viewModel.outPayOrderNo = self.parameters[@"outPayOrderNo"];
        _viewModel.doneClickBlock = self.parameters[@"doneClickBlock"];
        _viewModel.orderClickBlock = self.parameters[@"orderClickBlock"];
    }
    return _viewModel;
}

- (HDUIButton *)doneBTN {
    if (!_doneBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"complete", @"完成") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(12, 7, 12, 7);
        [button addTarget:self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _doneBTN = button;
    }
    return _doneBTN;
}

- (SACouponRedemptionBannerView *)couponView {
    if (!_couponView) {
        _couponView = SACouponRedemptionBannerView.new;
        _couponView.clientType = self.viewModel.businessLine;
        _couponView.hidden = YES;
    }
    return _couponView;
}

@end

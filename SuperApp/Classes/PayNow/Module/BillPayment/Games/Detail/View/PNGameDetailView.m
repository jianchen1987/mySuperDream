//
//  PNGameDetailView.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailView.h"
#import "HDCheckStandViewController.h"
#import "HDTransferOrderBuildRspModel.h"
#import "PNGameDetailCardCell.h"
#import "PNGameDetailInfoCell.h"
#import "PNGameDetailViewModel.h"
#import "PNGamePaymentAlertView.h"
#import "PNPaymentComfirmViewController.h"
#import "PNTableView.h"
#import "PNTransferFormCell.h"
#import "PNWaterPaymentResultViewController.h"
#import "PayHDTradeSubmitPaymentRspModel.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAInfoTableViewCell.h"
#import "UIViewController+NavigationController.h"


@interface PNGameDetailView () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate, PNPaymentComfirmViewControllerDelegate>
///
@property (strong, nonatomic) PNTableView *tableView;
/// 底部视图
@property (strong, nonatomic) UIView *bottomView;
///
@property (strong, nonatomic) PNOperationButton *submitBtn;
///
@property (strong, nonatomic) UIImageView *tipsImageView;
///
@property (strong, nonatomic) UILabel *tipsLabel;
///
@property (strong, nonatomic) PNGameDetailViewModel *viewModel;
@end


@implementation PNGameDetailView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupViews {
    self.backgroundColor = HexColor(0xF3F4FA);
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.tipsImageView];
    [self.bottomView addSubview:self.tipsLabel];
    [self.bottomView addSubview:self.submitBtn];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel getNewData];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.bottomView.hidden = NO;
        [self.tableView successGetNewDataWithNoMoreData:NO scrollToTop:NO];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"btnEnable" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.submitBtn.enabled = self.viewModel.btnEnable;
    }];
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    [self.tipsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(kRealWidth(8));
        make.top.equalTo(self.bottomView.mas_top).offset(kRealHeight(4));
        make.size.mas_equalTo(self.tipsImageView.image.size);
    }];
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsImageView.mas_right).offset(kRealWidth(4));
        make.top.equalTo(self.tipsImageView.mas_top).offset(2);
        make.right.lessThanOrEqualTo(self.bottomView.mas_right).offset(-kRealWidth(8));
    }];
    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.bottomView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(kRealHeight(4));
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-(kRealHeight(4) + kiPhoneXSeriesSafeBottomHeight));
        make.height.mas_equalTo(kRealHeight(48));
    }];
    [super updateConstraints];
}
#pragma mark -点击提交
- (void)clickSubmitBtn {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel queryBalanceAndExchangeCompletion:^(PNBalanceAndExchangeModel *_Nullable balanceModel) {
        @HDStrongify(self);
        [self dismissLoading];
        if (!HDIsObjectNil(balanceModel) && balanceModel.canExchange) {
            PNGamePaymentAlertView *alertView = [[PNGamePaymentAlertView alloc] initWithBalanceModel:balanceModel];
            @HDWeakify(self);
            alertView.choosePaymentMethodCallBack = ^(BOOL isUseWalletPay) {
                @HDStrongify(self);
                [self createOrderByType:isUseWalletPay];
            };
            [alertView show];
        } else {
            [self createOrderByType:NO];
        }
    }];
}
//下中台聚合单
- (void)createOrderByType:(BOOL)isUseWalletPay {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel createGameOrderByType:isUseWalletPay completion:^(PNGameSubmitOrderResponseModel *_Nullable responseModel) {
        [self dismissLoading];
        @HDStrongify(self);
        if (!HDIsObjectNil(responseModel)) {
            if (isUseWalletPay) {
                [self openWalletCashRegister:responseModel];
            } else {
                [self openAggregateCashRegister:responseModel];
            }
        }
    }];
}
#pragma mark - 打开中台收银台
- (void)openAggregateCashRegister:(PNGameSubmitOrderResponseModel *)model {
    @HDWeakify(self);
    [self.viewModel queryOrderInfoWithAggregationOrderNo:model.aggregateOrderNo completion:^(SAQueryOrderInfoRspModel *_Nullable rspModel) {
        @HDStrongify(self);
        if (!HDIsObjectNil(rspModel)) {
            HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
            buildModel.orderNo = model.aggregateOrderNo;
            buildModel.storeNo = rspModel.storeId;
            buildModel.merchantNo = rspModel.merchantNo;
            buildModel.payableAmount = model.totalPayableAmount;
            buildModel.businessLine = SAClientTypeBillPayment;
            HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
            checkStandVC.resultDelegate = self;
            [self.viewController presentViewController:checkStandVC animated:YES completion:nil];
        }
    }];
}
#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
    [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
        [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
        [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
        [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
    }];
}

#pragma mark PNPaymentComfirmViewControllerDelegte
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    PNWaterPaymentResultViewController *vc = [[PNWaterPaymentResultViewController alloc] initWithRouteParameters:@{@"tradeNo": rspModel.tradeNo}];
    [self.viewController.navigationController pushViewController:vc animated:YES removeSpecClass:self.viewController.class onlyOnce:YES];
    [controller removeFromParentViewController];
}

#pragma mark - 钱包收银台
- (void)openWalletCashRegister:(PNGameSubmitOrderResponseModel *)model {
    PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
    buildModel.tradeNo = model.tradeNo;
    buildModel.fromType = PNPaymentBuildFromType_Default;

    PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
    vc.delegate = self;
    [self.viewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
}

#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[PNGameCategoryModel class]]) {
        PNGameDetailInfoCell *cell = [PNGameDetailInfoCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:[PNTransferFormConfig class]]) {
        PNTransferFormCell *cell = [PNTransferFormCell cellWithTableView:tableView];
        cell.config = model;
        return cell;
    } else if ([model isKindOfClass:[PNGameDetailRspModel class]]) {
        PNGameDetailCardCell *cell = [PNGameDetailCardCell cellWithTableView:tableView];
        cell.model = model;
        @HDWeakify(self);
        cell.itemClickCallBack = ^(PNGameItemModel *_Nonnull item) {
            @HDStrongify(self);
            [self.viewModel updateSelectedItem:item];
        };
        return cell;
    } else if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.estimatedRowHeight = kRealHeight(80);
        _tableView.rowHeight = UITableViewAutomaticDimension;

        _tableView.backgroundColor = HexColor(0xF3F4FA);

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}
/** @lazy bottomView */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hd_borderWidth = 0.5;
        _bottomView.hd_borderColor = HDAppTheme.PayNowColor.lineColor;
        _bottomView.hd_borderPosition = HDViewBorderPositionTop;
        _bottomView.hidden = YES;
    }
    return _bottomView;
}
/** @lazy tipsImageView */
- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pn_game_submit_tips"]];
        [_tipsImageView sizeToFit];
    }
    return _tipsImageView;
}
/** @lazy tipsLabel */
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = HDAppTheme.PayNowFont.standard11;
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c999999;
        _tipsLabel.numberOfLines = 2;
        _tipsLabel.text = PNLocalizedString(@"pn_game_submit_tips", @"The Products are provided by Entertainment companies, WOWNOW only provides recharge services");
    }
    return _tipsLabel;
}
/** @lazy oprateBtn */
- (PNOperationButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_SUBMIT", @"提交") forState:UIControlStateNormal];
        _submitBtn.enabled = NO;
    }
    return _submitBtn;
}

@end

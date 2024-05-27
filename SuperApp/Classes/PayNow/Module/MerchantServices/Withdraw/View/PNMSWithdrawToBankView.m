//
//  PNMSWithdrawToBankView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawToBankView.h"
#import "HDPayOrderRspModel.h"
#import "PNCommonUtils.h"
#import "PNMSOrderDetailsController.h"
#import "PNMSTransferCreateOrderRspModel.h"
#import "PNMSWithdranBankInfoModel.h"
#import "PNMSWithdranBankListItemCell.h"
#import "PNMSWithdrawViewModel.h"
#import "PNOperationButton.h"
#import "PNPaymentComfirmViewController.h"
#import "PNTableView.h"
#import "PayPassWordTip.h"
#import "SAMoneyModel.h"


@interface PNMSWithdrawToBankView () <UITableViewDelegate, UITableViewDataSource, PNPaymentComfirmViewControllerDelegate>
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *addBtn;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;
@end


@implementation PNMSWithdrawToBankView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.tableView];
    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.addBtn];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        if (!self.bottomBgView.hidden) {
            make.bottom.mas_equalTo(self.bottomBgView.mas_top);
        } else {
            make.bottom.mas_equalTo(self);
        }
    }];

    if (!self.bottomBgView.hidden) {
        [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(kRealWidth(64) + kiPhoneXSeriesSafeBottomHeight));
        }];

        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomBgView.mas_left).offset(kRealWidth(20));
            make.right.mas_equalTo(self.bottomBgView.mas_right).offset(-kRealWidth(20));
            make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(12));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSWithdranBankListItemCell *cell = [PNMSWithdranBankListItemCell cellWithTableView:tableView];
    cell.model = [self.viewModel.dataSource objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSWithdranBankInfoModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    [self preCheck:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSWithdranBankInfoModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    return model.deleteAble;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSWithdranBankInfoModel *model = [self.viewModel.dataSource objectAtIndex:indexPath.row];
    @HDWeakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:TNLocalizedString(@"tn_delete", @"删除")
                                                                          handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
                                                                              @HDStrongify(self);
                                                                              [self.viewModel deleteBankCard:model];
                                                                          }];

    return @[deleteAction];
}

- (void)preCheck:(PNMSWithdranBankInfoModel *)model {
    [self.viewModel preCheck:^{
        PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
        buildModel.subTradeType = PNTradeSubTradeTypeMerchantToSelfBank;
        buildModel.fromType = PNPaymentBuildFromType_MerchantWithdraw;
        buildModel.isShowUnifyPayResult = NO;

        PNPaymentBuildWithdrawExtendModel *extendModel = [[PNPaymentBuildWithdrawExtendModel alloc] init];
        SAMoneyModel *amountModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", (NSInteger)(self.viewModel.amount.doubleValue * 100)] currency:self.viewModel.selectCurrency];

        extendModel.caseInAmount = amountModel;
        extendModel.participantCode = model.participantCode;
        extendModel.accountName = model.accountName;
        extendModel.accountNumber = model.accountNumber;
        extendModel.bankName = model.bankName;
        extendModel.operatorNo = self.viewModel.operatorNo;
        extendModel.merchantNo = self.viewModel.merchantNo;
        buildModel.extendWithdrawModel = extendModel;

        PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
        vc.delegate = self;
        [self.viewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
    }];
}

- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    HDPayOrderRspModel *payOrderRspModel = [HDPayOrderRspModel modelFromTradeSubmitPaymentRspModel:rspModel];
    [self paymentComplete:payOrderRspModel];
    [controller removeFromParentViewController];
}

#pragma mark - 支付完成
//支付完成 跳转到 交易详情
- (void)paymentComplete:(HDPayOrderRspModel *)rspModel {
    @HDWeakify(self);
    void (^clickedDoneBtnHandler)(BOOL) = ^(BOOL success) {
        @HDStrongify(self);
        [self.viewController.navigationController popToViewControllerClass:NSClassFromString(@"PNMSHomeController") animated:YES];
    };

    PNMSOrderDetailsController *vc = [[PNMSOrderDetailsController alloc] initWithRouteParameters:@{
        @"model": [rspModel yy_modelToJSONObject],
        @"viewType": @(1),
        @"merchantNo": self.viewModel.merchantNo,
        @"callback": clickedDoneBtnHandler,
        @"needBalance": @(1),
    }];

    [self.viewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"icon_withdraw_nodata_placeholder";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            HDLog(@"新增2");
            [self.viewModel getWitdrawBankList:NO];
        };
    }
    return _tableView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _bottomBgView = view;
    }
    return _bottomBgView;
}

- (PNOperationButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_addBtn setTitle:PNLocalizedString(@"pn_Add_bank_card", @"添加银行卡") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_addBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAddWithdrawBankCardVC:@{
                @"currency": self.viewModel.selectCurrency,
            }];
        }];
    }
    return _addBtn;
}
@end

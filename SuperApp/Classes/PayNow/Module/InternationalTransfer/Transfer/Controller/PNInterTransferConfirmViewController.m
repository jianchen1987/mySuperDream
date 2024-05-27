//
//  PNInterTransferConfirmViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferConfirmViewController.h"
#import "HDPayOrderRspModel.h"
#import "HDTransferOrderBuildRspModel.h"
#import "PNCommonUtils.h"
#import "PNInterTransferReciverModel.h"
#import "PNInterTransferResultViewController.h"
#import "PNInterTransferViewModel.h"
#import "PNPaymentComfirmViewController.h"
#import "PNTransListDTO.h"
#import "PNTransferSectionHeaderView.h"
#import "PayHDTradeBuildOrderRspModel.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAInfoTableViewCell.h"


@interface PNInterTransferConfirmViewController () <PNPaymentComfirmViewControllerDelegate>
///
@property (strong, nonatomic) PNInterTransferViewModel *viewModel;
@property (nonatomic, strong) PNTransListDTO *transDTO;
@end


@implementation PNInterTransferConfirmViewController

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupNavigation {
    if (self.viewModel.channel == PNInterTransferThunesChannel_Wechat) {
        self.boldTitle = PNLocalizedString(@"pn_transfer_to_wechat", @"转账到微信");
    } else {
        self.boldTitle = PNLocalizedString(@"pn_transfer_to_alipay", @"转账到支付宝");
    }
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.stepView setCurrentStep:2];
}

- (void)hd_bindViewModel {
    [self.viewModel initTransferConfirmData];
}

#pragma mark -下一步
- (void)clickOprateBtn {
    NSDictionary *dic = @{
        @"payeeNo": self.viewModel.confirmModel.mobile,
        @"amt": self.viewModel.confirmModel.payoutAmount.cent,
        @"cy": self.viewModel.confirmModel.payoutAmount.cy,
        @"bizType": PNTransferTypeToInternational,
        @"outBizNo": self.viewModel.confirmModel.orderNo,
        @"payeeAccountNo": self.viewModel.confirmModel.mobile,
        @"payeeAccountName": self.viewModel.confirmModel.fullName,
    };

    [self.view showloading];
    @HDWeakify(self);
    [self.transDTO outConfirmOrderWithParams:dic shouldAlertErrorMsgExceptSpecCode:YES success:^(HDTransferOrderBuildRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
        buildModel.tradeNo = rspModel.tradeNo;
        buildModel.fromType = PNPaymentBuildFromType_Default;

        PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
        vc.delegate = self;
        [self.navigationController pushViewControllerDiscontinuous:vc animated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark PNPaymentComfirmViewControllerDelegate
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    PNInterTransferResultViewController *resultVC = [[PNInterTransferResultViewController alloc] initWithRouteParameters:@{
        @"orderNo": self.viewModel.confirmModel.orderNo,
    }];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [newArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"PNInterTransferBaseViewController")]) {
            [newArr removeObject:obj];
        }

        if ([obj isKindOfClass:NSClassFromString(@"PNPaymentComfirmViewController")]) {
            [newArr removeObject:obj];
        }
    }];

    [newArr addObject:resultVC];
    [self.navigationController setViewControllers:newArr animated:YES];
}

#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.transConfirmDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transConfirmDataArr[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transConfirmDataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        PNTransferSectionHeaderView *headerView = [PNTransferSectionHeaderView headerWithTableView:tableView];
        //        headerView.title = sectionModel.headerModel.title;
        [headerView setTitle:sectionModel.headerModel.title rightImage:sectionModel.headerModel.rightButtonImage];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transConfirmDataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        return 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.transConfirmDataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

/** @lazy viewModel */
- (PNInterTransferViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNInterTransferViewModel alloc] init];
    }
    return _viewModel;
}

- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}
@end

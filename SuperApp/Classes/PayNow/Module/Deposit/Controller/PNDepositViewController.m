//
//  DepositVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNDepositViewController.h"
#import "PNDepositCell.h"
#import "PNDepositDTO.h"
#import "PNDepositModel.h"
#import "PNDepositRspModel.h"
#import "PNNotifyView.h"
#import "PNTableView.h"


@interface PNDepositViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray<PNDepositModel *> *dataSource;
@property (nonatomic, strong) SALabel *headLabel;
@property (nonatomic, strong) PNDepositDTO *depositDTO;
@property (nonatomic, strong) PNNotifyView *notifyView;

@end


@implementation PNDepositViewController
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.notifyView];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeDeposit];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}
#pragma mark - layout
- (void)updateViewConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (!self.notifyView.hidden) {
            make.top.equalTo(self.notifyView.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealHeight(15 / 2));
        }
    }];
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Deposit", @"入金");
}

- (void)hd_bindViewModel {
    [self.view showloading];
    @HDWeakify(self);
    [self.depositDTO queryDepositGuide:^(PNDepositRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self initData:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)hd_getNewData {
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 38.0f;
    } else {
        return 0.000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNDepositModel *model = self.dataSource[indexPath.row];
    PNDepositCell *cell = [PNDepositCell cellWithTableView:tableView];
    cell.model = model;
    cell.collecBlock = ^(PNDepositModel *model) {
        if (model.apptype == BakongApp) { //暂无URL Scheme，直接跳转App Store
            [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1440829141"];
        } else if (model.apptype == BankApp) {
            [HDMediator.sharedInstance navigaveToPayNowBankList:@{
                @"onlyRead": @(YES),
                @"navTitle": PNLocalizedString(@"View_support_bank", @"选择收款银行"),
            }];
        } else if (model.apptype == CoolCash_outlet) {
            [HDMediator.sharedInstance navigaveToPayNowCoolcashOutletVC:@{}];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableHeaderFootView *header = [HDTableHeaderFootView headerWithTableView:tableView];
    self.headLabel.text = [NSString stringWithFormat:@"%@%lu%@", PNLocalizedString(@"have", @""), (unsigned long)self.dataSource.count, PNLocalizedString(@"way_to_cash_in", @"")];
    [header addSubview:self.headLabel];
    [self.headLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header);
        make.top.mas_equalTo(header.mas_top).offset(kRealWidth(8));
        make.left.equalTo(header).offset(kRealWidth(15));
    }];
    return header;
}

#pragma mark
- (SALabel *)headLabel {
    if (!_headLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:17];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        _headLabel = label;
    }
    return _headLabel;
}

- (void)initData:(PNDepositRspModel *)rspModel {
    PNDepositModel *model;

    if (WJIsStringNotEmpty(rspModel.CoolCash)) {
        model = PNDepositModel.new;
        model.iconImgName = @"CoolCash";
        model.btnTitle = PNLocalizedString(@"coolcash_agent_outlet", @"CoolCash网点");
        //        model.detail = PNLocalizedString(@"Go_to_coolcash_agent_outlet", @"");
        model.detail = rspModel.CoolCash;
        model.apptype = CoolCash_outlet;
        [self.dataSource addObject:model];
    }

    if (WJIsStringNotEmpty(rspModel.Bakong)) {
        model = PNDepositModel.new;
        model.iconImgName = @"toBakong";
        //        model.detail = PNLocalizedString(@"Log_in_to_Bakong_app", @"前往Bakong APP");
        model.detail = rspModel.Bakong;
        model.btnTitle = [NSString stringWithFormat:@"%@ Bakong APP", PNLocalizedString(@"go_to", @"")];
        model.apptype = BakongApp;
        [self.dataSource addObject:model];
    }

    if (WJIsStringNotEmpty(rspModel.Bank)) {
        model = PNDepositModel.new;
        model.iconImgName = @"toBakong";
        //        model.detail = PNLocalizedString(@"Log_in_bank_app_or_financial_institution_app", @"");
        model.detail = rspModel.Bank;
        model.btnTitle = PNLocalizedString(@"View_support_bank", @"查看支持银行");
        model.apptype = BankApp;
        [self.dataSource addObject:model];
    }

    if (WJIsStringNotEmpty(rspModel.Other)) {
        model = PNDepositModel.new;
        model.iconImgName = @"pay_wownow_icon";
        //        model.detail = PNLocalizedString(@"Lof_in_WOWNOW_APP", @"");
        model.detail = rspModel.Other;

        [self.dataSource addObject:model];
    }

    [self.tableView successGetNewDataWithNoMoreData:NO];

    self.tableView.hidden = NO;
}

- (NSMutableArray<PNDepositModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }

    return _dataSource;
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.hidden = YES;
    }
    return _tableView;
}

- (PNDepositDTO *)depositDTO {
    if (!_depositDTO) {
        _depositDTO = [[PNDepositDTO alloc] init];
    }
    return _depositDTO;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end

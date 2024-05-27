//
//  TransListVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTransListViewController.h"
#import "HDPayeeInfoModel.h"
#import "PNNotifyView.h"
#import "PNTableView.h"
#import "PNTransAccountViewController.h"
#import "PNTransAmountViewController.h"
#import "PNTransListCell.h"
#import "PNTransListDTO.h"
#import "PNTransListModel.h"
#import "PNTransTypeCell.h"
#import "PNTransTypeDataModel.h"
#import "PNTransTypeModel.h"
#import "SAAppEnvManager.h"
#import <HDTableViewSectionModel.h>


@interface PNTransListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
@property (nonatomic, strong) HDTableViewSectionModel *headerModel;
@property (nonatomic, strong) PNTransListDTO *transDTO;
@property (nonatomic, strong) PNNotifyView *notifyView;
@end


@implementation PNTransListViewController
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.notifyView];
    [self.view addSubview:self.tableView];
    [self getConfig];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeTransfer];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getConfig];
    };
}

- (void)getConfig {
    [self.dataSource removeAllObjects];
    [self showloading];
    @HDWeakify(self);

    [self.transDTO getPayNowTransListConfig:^(NSArray *_Nonnull array) {
        @HDStrongify(self);
        NSArray *arr = array;
        NSMutableArray *typeArr = [NSMutableArray arrayWithCapacity:0];
        HDTableViewSectionModel *transferSectionModel = [HDTableViewSectionModel new];
        PNTransTypeModel *typeModel = PNTransTypeModel.new;
        for (int i = 0; i < arr.count; i++) {
            PNTransTypeDataModel *model = [PNTransTypeDataModel yy_modelWithJSON:arr[i]];
            // 1001-转账到个人 1002-转账到bakong 1003-转账到银行 1010-转到手机号 1005-国际转账
            PNTransferType bizType = model.bizType;
            if ([bizType isEqualToString:PNTransferTypeToCoolcash]) {
                typeModel = PNTransTypeModel.new;
                typeModel.logoPath = model.logoPath;
                typeModel.title = PNLocalizedString(@"VIEW_TEXT_TRANSFER_TO_ACC", @"转到CoolCash账号");
                typeModel.type = PNTradeSubTradeTypeToCoolCash;
                [typeArr addObject:typeModel];
            } else if ([bizType isEqualToString:PNTransferTypePersonalToBaKong]) {
                typeModel = PNTransTypeModel.new;
                typeModel.logoPath = model.logoPath;
                typeModel.title = PNLocalizedString(@"transfer_bakong", @"转账到bakong");
                typeModel.type = PNTradeSubTradeTypeToBakong;
                [typeArr addObject:typeModel];
            } else if ([bizType isEqualToString:PNTransferTypePersonalToBank]) {
                typeModel = PNTransTypeModel.new;
                typeModel.logoPath = model.logoPath;
                typeModel.title = PNLocalizedString(@"transfer_bank", @"转账到银行");
                typeModel.type = PNTradeSubTradeTypeToBank;
                [typeArr addObject:typeModel];
            } else if ([bizType isEqualToString:PNTransferTypeToPhone]) {
                typeModel = PNTransTypeModel.new;
                typeModel.logoPath = model.logoPath;
                typeModel.title = PNLocalizedString(@"pn_transfer_phone_number2", @"转账到手机号");
                typeModel.type = PNTradeSubTradeTypeToPhone;
                [typeArr addObject:typeModel];
            } else if ([bizType isEqualToString:PNTransferTypeToInternational]) {
                typeModel = PNTransTypeModel.new;
                typeModel.logoPath = model.logoPath;
                typeModel.title = PNLocalizedString(@"unSuGzr5", @"国际转账");
                typeModel.type = PNTradeSubTradeTypeToInternational;
                [typeArr addObject:typeModel];
            }
        }
        transferSectionModel.list = typeArr;
        [self.dataSource addObject:transferSectionModel];

        [self.tableView successGetNewDataWithNoMoreData:NO];

        [self queryTransferUser];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.tableView failGetNewData];
    }];
}

//获取最近转账联系人
- (void)queryTransferUser {
    [self showloading];
    @HDWeakify(self);
    [self.transDTO getPayNowTransferUser:^(NSArray *_Nonnull array) {
        @HDStrongify(self);
        [self dismissLoading];
        NSArray *arr = array;
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < arr.count; i++) {
            PNTransListModel *model = [PNTransListModel yy_modelWithJSON:arr[i]];
            if (HDIsStringNotEmpty(model.headUrl)) {
                NSString *urlStr = [NSString stringWithFormat:@"%@/files/app/%@", [SAAppEnvManager sharedInstance].appEnvConfig.payFileServer, model.headUrl];
                model.headUrl = urlStr;
            }
            [marr addObject:model];
        }
        if (marr.count > 0) {
            if (![self.dataSource containsObject:self.headerModel]) {
                [self.dataSource addObject:self.headerModel];
            }
            self.headerModel.list = marr;
        }
        [self.tableView successGetNewDataWithNoMoreData:NO];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.tableView failGetNewData];
    }];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账");
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *model = self.dataSource[section];
    return model.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 1) {
        return 70.0f;
    } else {
        return 70.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *section = self.dataSource[indexPath.section];
    id model = section.list[indexPath.row];
    if ([model isKindOfClass:PNTransTypeModel.class]) {
        PNTransTypeCell *cell = [PNTransTypeCell cellWithTableView:tableView];
        cell.model = (PNTransTypeModel *)model;
        return cell;
    } else if ([model isKindOfClass:PNTransListModel.class]) {
        PNTransListCell *cell = [PNTransListCell cellWithTableView:tableView];
        cell.model = (PNTransListModel *)model;
        @HDWeakify(self);
        cell.collecBlock = ^(PNTransListModel *model) {
            @HDStrongify(self);
            HDLog(@"收藏");
            [self flat:model];
        };

        return cell;
    }
    return UITableViewCell.new;
}

///收藏 点击收藏
- (void)flat:(PNTransListModel *)model {
    [self showloading];
    @HDWeakify(self);
    [self.transDTO userCollectAction:model.flag rivalNo:model.mobilePhone bizType:model.bizEntity success:^{
        @HDStrongify(self);
        [self dismissLoading];
        if (model.flag == 0) {
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"flat", @"该账号收藏成功！") type:HDTopToastTypeInfo];
        } else {
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"cancel_flat", @"该账号已取消收藏！") type:HDTopToastTypeInfo];
        }

        [self queryTransferUser];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *secion = self.dataSource[indexPath.section];
    id model = secion.list[indexPath.row];
    if ([model isKindOfClass:PNTransTypeModel.class]) {
        PNTransTypeModel *typeModel = (PNTransTypeModel *)model;
        switch (typeModel.type) {
            case PNTradeSubTradeTypeToCoolCash: {
                PNTransAccountViewController *vc = [[PNTransAccountViewController alloc] initWithRouteParameters:nil];
                vc.pageType = PNTradeSubTradeTypeToCoolCash;
                [SAWindowManager navigateToViewController:vc parameters:@{}];
            } break;
            case PNTradeSubTradeTypeToBakong: {
                PNTransAccountViewController *vc = [[PNTransAccountViewController alloc] initWithRouteParameters:nil];
                vc.pageType = PNTradeSubTradeTypeToBakong;
                [SAWindowManager navigateToViewController:vc parameters:@{}];
            } break;
            case PNTradeSubTradeTypeToPhone: {
                [HDMediator.sharedInstance navigaveToPayNowTransToPhoneVC:@{}];
            } break;
            case PNTradeSubTradeTypeToBank: {
                [HDMediator.sharedInstance navigaveToPayNowBankList:@{}];
            } break;
            case PNTradeSubTradeTypeToInternational: {
                [HDMediator.sharedInstance navigaveToInternationalTransferIndexVC:@{}];
            } break;
            default:
                break;
        }

    } else if ([model isKindOfClass:PNTransListModel.class]) {
        PNTransListModel *transListModel = (PNTransListModel *)model;
        if ([transListModel.bizEntity isEqualToString:PNTransferTypeToPhone]) {
            NSString *phoneStr = transListModel.mobilePhone;
            if ([phoneStr hasPrefix:@"8550"]) {
                phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
            }
            [HDMediator.sharedInstance navigaveToPayNowTransToPhoneVC:@{@"phoneNumber": phoneStr}];
            return;
        }

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];

        PNTransferType type = transListModel.bizEntity;
        if ([type isEqualToString:PNTransferTypeToCoolcash]) {
            vc.pageType = PNTradeSubTradeTypeToCoolCash;
            [dic setDictionary:@{@"payeeMobile": transListModel.mobilePhone}];
        } else if ([type isEqualToString:PNTransferTypePersonalToBaKong]) {
            vc.pageType = PNTradeSubTradeTypeToBakong;
            [dic setDictionary:@{@"payeeMp": transListModel.mobilePhone, @"retry_forbidden": @"true"}];
        } else if ([type isEqualToString:PNTransferTypePersonalToBank]) {
            vc.pageType = PNTradeSubTradeTypeToBank;
            [dic setDictionary:@{@"bankAccount": transListModel.mobilePhone, @"bankCode": transListModel.bankCode}];
        } else {
            vc.pageType = PNTradeSubTradeTypeToCoolCash;
            [dic setDictionary:@{@"payeeMobile": transListModel.mobilePhone}];
        }

        [self showloading];
        @HDWeakify(self);
        [self.transDTO getPayeeInfo:dic bizType:transListModel.bizEntity success:^(HDPayeeInfoModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];
            HDPayeeInfoModel *payeeInfo = rspModel;
            payeeInfo.payeeLoginName = transListModel.mobilePhone;
            payeeInfo.participantCode = transListModel.bankCode;
            payeeInfo.headUrl = transListModel.headUrl;
            vc.payeeBankName = transListModel.bankName; //银行名称
            vc.payeeInfo = payeeInfo;
            [SAWindowManager navigateToViewController:vc parameters:@{}];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < 1) {
        return 0.00001;
    } else {
        return 50.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < 1) {
        return UIView.new;
    }
    HDTableViewSectionModel *model = self.dataSource[section];
    HDTableHeaderFootView *header = [HDTableHeaderFootView headerWithTableView:tableView];
    header.model = model.headerModel;
    return header;
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
        if (!self.notifyView.hidden) {
            make.top.equalTo(self.notifyView.mas_bottom).offset(kRealWidth(10));
            ;
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(10));
        }
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }

    return _dataSource;
}

- (HDTableViewSectionModel *)headerModel {
    if (!_headerModel) {
        HDTableHeaderFootViewModel *recentsHeadModel = [HDTableHeaderFootViewModel new];
        recentsHeadModel.title = PNLocalizedString(@"Recent_transfer", @"最近转账");
        recentsHeadModel.titleColor = [HDAppTheme.color G1];
        recentsHeadModel.backgroundColor = [UIColor clearColor];
        recentsHeadModel.titleFont = [HDAppTheme.font boldForSize:15];
        recentsHeadModel.marginToBottom = 15;
        _headerModel = [HDTableViewSectionModel new];
        _headerModel.headerModel = recentsHeadModel;
        _headerModel.list = @[];
    }

    return _headerModel;
}

- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end

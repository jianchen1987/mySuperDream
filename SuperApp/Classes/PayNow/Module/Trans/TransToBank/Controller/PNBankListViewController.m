//
//  bankListVC.m
//  ViPay
//
//  Created by Quin on 2021/8/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNBankListViewController.h"
#import "PNBankCardInputViewController.h"
#import "PNBankDTO.h"
#import "PNBankListCell.h"
#import "PNBankListHeaderView.h"
#import "PNBankListModel.h"
#import "PNTableView.h"


@interface PNBankListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PNTableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSource;     //展示数据【搜索会变动】
@property (nonatomic, strong) NSMutableArray *baseDataSource; //原始数据
@property (nonatomic, strong) PNBankDTO *bankDTO;
@property (nonatomic, copy) void (^selectBlock)(PNBankListModel *model);
@end


@implementation PNBankListViewController
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.onlyRead = NO;
        if ([parameters.allKeys containsObject:@"onlyRead"]) {
            self.onlyRead = [[parameters objectForKey:@"onlyRead"] boolValue];
        }

        self.navTitle = @"";
        if ([parameters.allKeys containsObject:@"navTitle"]) {
            self.navTitle = [parameters objectForKey:@"navTitle"];
        }

        self.selectBlock = [parameters objectForKey:@"callBack"];
    }

    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    if (WJIsStringNotEmpty(self.navTitle)) {
        self.boldTitle = self.navTitle;
    } else {
        self.boldTitle = PNLocalizedString(@"Select_receiving_bank", @"选择收款银行");
    }

    [self.view addSubview:self.tableview];

    [self getBankList];
    @HDWeakify(self);
    self.tableview.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getBankList];
    };
}

- (void)getBankList {
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.baseDataSource = [[NSMutableArray alloc] initWithCapacity:0];

    [self showloading];
    @HDWeakify(self);
    [self.bankDTO getBankList:^(NSArray *_Nonnull array) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.baseDataSource setArray:array];
        [self.dataSource setArray:array];
        [self.tableview successGetNewDataWithNoMoreData:NO];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.tableview failGetNewData];
    }];
}

- (void)updateViewConstraints {
    [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBankListModel *model = [PNBankListModel yy_modelWithJSON:self.dataSource[indexPath.row]];
    PNBankListCell *cell = [PNBankListCell cellWithTableView:tableView];
    cell.model = model;
    if (indexPath.row == self.dataSource.count - 1) {
        cell.lineview.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.onlyRead) {
        return;
    }

    PNBankListModel *model = [PNBankListModel yy_modelWithJSON:self.dataSource[indexPath.row]];

    if (self.selectBlock) {
        self.selectBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    PNBankCardInputViewController *bankCardInputVc = [[PNBankCardInputViewController alloc] init];
    bankCardInputVc.model = model;
    [self.navigationController pushViewController:bankCardInputVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealWidth(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(65);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNBankListHeaderView *header = [PNBankListHeaderView headerWithTableView:tableView];
    __weak __typeof(self) weakSelf = self;
    header.inputHandler = ^(NSString *text) {
        HDLog(@"===%@", text);
        [weakSelf screenData:text];
    };
    return header;
}

#pragma mark 筛选过滤
- (void)screenData:(NSString *)text {
    [self.dataSource removeAllObjects];
    if (text.length <= 0) {
        [self.dataSource setArray:self.baseDataSource];
        [self.tableview successGetNewDataWithNoMoreData:NO];
        return;
    }
    for (int i = 0; i < self.baseDataSource.count; i++) {
        PNBankListModel *model = [PNBankListModel yy_modelWithJSON:self.baseDataSource[i]];
        if ([model.bin.uppercaseString rangeOfString:text.uppercaseString].location != NSNotFound) {
            [self.dataSource addObject:self.baseDataSource[i]];
        }
    }
    [self.tableview successGetNewDataWithNoMoreData:NO];
}

#pragma mark - config
- (BOOL)shouldHideNavigationBarBottomShadow {
    return NO;
}

- (PNTableView *)tableview {
    if (!_tableview) {
        _tableview = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _tableview.sectionHeaderTopPadding = 0;
        }
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.needRefreshHeader = true;
        _tableview.needRefreshFooter = false;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.showsVerticalScrollIndicator = NO;
    }
    return _tableview;
}

- (PNBankDTO *)bankDTO {
    if (!_bankDTO) {
        _bankDTO = [[PNBankDTO alloc] init];
    }
    return _bankDTO;
}
@end

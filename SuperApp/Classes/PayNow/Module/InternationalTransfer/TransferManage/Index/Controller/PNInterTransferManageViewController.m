//
//  PNInterTransferManageViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferManageViewController.h"
#import "PNTableView.h"
#import "SAInfoTableViewCell.h"


@interface PNInterTransferManageViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) NSMutableArray *dataArr;

@end


@implementation PNInterTransferManageViewController
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"fdYrGIFb", @"转账管理");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self initListData];
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (SAInfoViewModel *)getDefaultInfoViewModel {
    SAInfoViewModel *infoModel = SAInfoViewModel.new;
    infoModel.keyColor = HDAppTheme.PayNowColor.c333333;
    infoModel.keyFont = [HDAppTheme.PayNowFont fontSemibold:14];
    infoModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
    infoModel.rightButtonImagePosition = HDUIButtonImagePositionRight;
    infoModel.rightButtonTitle = @" ";
    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(12), kRealWidth(18), kRealWidth(12));
    infoModel.lineWidth = 0;
    return infoModel;
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        return cell;
    }
    return UITableViewCell.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = model;
        !trueModel.eventHandler ?: trueModel.eventHandler();
    }
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}

/** @lazy dataArr */
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)initListData {
    HDTableViewSectionModel *sectionModel;
    /// 转账收款人
    sectionModel = [[HDTableViewSectionModel alloc] init];
    SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
    infoModel.leftImage = [UIImage imageNamed:@"pn_interTransfer_rec_icon"];
    infoModel.keyText = PNLocalizedString(@"2EPMI0Ro", @"国际转账收款人");
    infoModel.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToInternationalTransferReciverInfoListVC:@{}];
    };
    sectionModel.list = @[infoModel];
    [self.dataArr addObject:sectionModel];

    /// 转账手续费
    sectionModel = [[HDTableViewSectionModel alloc] init];
    infoModel = [self getDefaultInfoViewModel];
    infoModel.leftImage = [UIImage imageNamed:@"pn_interTransfer_charge_icon"];
    infoModel.keyText = PNLocalizedString(@"Service_Charge", @"转账手续费");
    infoModel.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToInternationalTransferRateVC:@{}];
    };
    sectionModel.list = @[infoModel];
    [self.dataArr addObject:sectionModel];

    /// 转账限额
    sectionModel = [[HDTableViewSectionModel alloc] init];
    infoModel = [self getDefaultInfoViewModel];
    infoModel.leftImage = [UIImage imageNamed:@"pn_interTransfer_limit_icon"];
    infoModel.keyText = PNLocalizedString(@"pn_inter_transfer_limit", @"转账限额");
    infoModel.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToInternationalTransferLimitVC:@{}];
    };
    sectionModel.list = @[infoModel];
    [self.dataArr addObject:sectionModel];
}
@end

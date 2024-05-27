//
//  PNInterTransferResultViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferResultViewController.h"
#import "PNInterTransRecordModel.h"
#import "PNInterTransferDTO.h"
#import "PNInterTransferStatusCell.h"
#import "PNTableView.h"
#import "SAInfoTableViewCell.h"


@interface PNInterTransferResultViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (nonatomic, strong) NSString *orderNo;

@property (nonatomic, strong) PNInterTransferDTO *interTransferDTO;
@property (nonatomic, strong) PNInterTransRecordModel *model;

@property (nonatomic, strong) dispatch_source_t timer;                 ///< 定时获取数据
@property (nonatomic, assign) BOOL isTimerRunning;                     ///< 定时器是否正在运行
@property (nonatomic, strong) dispatch_source_t querWithDrawCodeTimer; ///< 定时获取数据 - 查询提现码
@property (nonatomic, assign) BOOL isFrist;

@end


@implementation PNInterTransferResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
        self.isFrist = YES;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopQueryOrderStatusTimer];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"unSuGzr5", @"国际转账");
}

- (void)hd_bindViewModel {
    if (WJIsStringNotEmpty(self.orderNo)) {
        [self startQueryOrderStatusTimer];
    }
}

- (void)getData {
    if (self.isFrist) {
        [self.view showloading];
    }
    @HDWeakify(self);
    [self.interTransferDTO getPayResultWithOrderNo:self.orderNo success:^(PNInterTransRecordModel *_Nonnull confirmModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.tableView.hidden = NO;
        self.model = confirmModel;
        [self reSetData];
        [self.tableView successGetNewDataWithNoMoreData:NO];
        self.isFrist = NO;
        if (self.model.status > PNInterTransferOrderStatusFinish) { ///进行轮询
            [self stopQueryOrderStatusTimer];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
}

#pragma mark 定时器
// 停止定时器
- (void)stopQueryOrderStatusTimer {
    if (_timer && _isTimerRunning) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        _isTimerRunning = NO;
    }
}

// 开启定时器
- (void)startQueryOrderStatusTimer {
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建一个 timer 类型定时器
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    // 设置定时器的各种属性（何时开始，间隔多久执行）
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0);
    // 任务回调
    dispatch_source_set_event_handler(_timer, ^{
        // 查询结果
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getData];
        });
    });
    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    if (_timer && !_isTimerRunning) {
        dispatch_resume(_timer);
        _isTimerRunning = YES;
    }
}

- (void)reSetData {
    [self.dataArr removeAllObjects];

    PNInterTransferStatusCellModel *model = [[PNInterTransferStatusCellModel alloc] init];
    model.status = self.model.status;
    model.reason = self.model.reason;
    [self.dataArr addObject:model];

    SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"transfer_amount", @"转账金额");
    infoModel.valueText = self.model.payoutAmount.thousandSeparatorAmount;
    [self.dataArr addObject:infoModel];

    infoModel = [self getDefaultInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"cB3e7LW6", @"转账服务费");
    infoModel.valueText = self.model.serviceCharge.thousandSeparatorAmount;
    [self.dataArr addObject:infoModel];

    infoModel = [self getDefaultInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"detail_total_amount", @"支付金额");
    infoModel.valueText = self.model.totalPayoutAmount.thousandSeparatorAmount;
    [self.dataArr addObject:infoModel];

    infoModel = [self getDefaultInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"1wdZB3DT", @"转账费率");
    infoModel.valueText = self.model.exchangeRate;
    [self.dataArr addObject:infoModel];

    infoModel = [self getDefaultInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"JWRpnuek", @"预计到账金额");
    infoModel.valueText = self.model.receiverAmount.thousandSeparatorAmount;
    [self.dataArr addObject:infoModel];

    infoModel = [self getDefaultInfoViewModel];
    infoModel.keyText = PNLocalizedString(@"pn_txn_channel", @"交易渠道");
    infoModel.valueText = self.model.receiveChannel;
    [self.dataArr addObject:infoModel];
}

- (SAInfoViewModel *)getDefaultInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = HDAppTheme.PayNowFont.standard14;
    infoModel.keyColor = HDAppTheme.PayNowColor.c999999;
    infoModel.valueFont = HDAppTheme.PayNowFont.standard14;
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    infoModel.lineWidth = 0;
    infoModel.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(6), kRealWidth(12));
    return infoModel;
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArr[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:[PNInterTransferStatusCellModel class]]) {
        PNInterTransferStatusCell *cell = [PNInterTransferStatusCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
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
        _tableView.hidden = YES;

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

- (PNInterTransferDTO *)interTransferDTO {
    if (!_interTransferDTO) {
        _interTransferDTO = [[PNInterTransferDTO alloc] init];
    }
    return _interTransferDTO;
}
@end

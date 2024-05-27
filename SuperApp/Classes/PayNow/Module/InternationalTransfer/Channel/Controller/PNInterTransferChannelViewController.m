//
//  PNInterTransferChannelViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferChannelViewController.h"
#import "PNInterTransferAmountViewController.h"
#import "PNInterTransferChannelCell.h"
#import "PNInterTransferChannelDTO.h"
#import "PNInterTransferChannelModel.h"
#import "PNInterTransferDTO.h"
#import "PNInterTransferQueryAllRateRspModel.h"
#import "PNInterTransferViewModel.h"
#import "PNTableView.h"


@interface PNInterTransferChannelViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) PNInterTransferChannelDTO *channelDTO;
@property (nonatomic, strong) NSMutableArray<PNInterTransferChannelModel *> *dataSource;
@property (nonatomic, strong) PNInterTransferDTO *transferDTO;
@end


@implementation PNInterTransferChannelViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"unSuGzr5", @"国际转账");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.view addSubview:self.tableView];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)getData {
    [self.view showloading];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t _sema = dispatch_semaphore_create(1);

        HDLog(@"开始调用");
        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        @HDWeakify(self);
        [self.channelDTO getChannelListSuccess:^(NSArray<PNInterTransferChannelModel *> *_Nonnull array) {
            @HDStrongify(self);
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
            [self.tableView successGetNewDataWithNoMoreData:NO];

            dispatch_semaphore_signal(_sema);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self.channelDTO getAllRateSuccess:^(PNInterTransferQueryAllRateRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            dispatch_semaphore_signal(_sema);

            for (PNInterTransferChannelModel *model in self.dataSource) {
                if (model.channel == PNInterTransferThunesChannel_Wechat) {
                    model.rateModel = rspModel.wechatRateInfo;
                } else if (model.channel == PNInterTransferThunesChannel_Alipay) {
                    model.rateModel = rspModel.alipayRateInfo;
                }
            }
            [self.tableView successGetNewDataWithNoMoreData:NO];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            dispatch_semaphore_signal(_sema);
        }];
    });
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNInterTransferChannelCell *cell = [PNInterTransferChannelCell cellWithTableView:tableView];
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNInterTransferChannelModel *model = [self.dataSource objectAtIndex:indexPath.row];

    [self checkPayer:model.channel];
}

- (void)checkPayer:(PNInterTransferThunesChannel)channel {
    [self.view showloading];

    @HDWeakify(self);
    [self.transferDTO openInterTransferAccount:@"" channel:channel success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        PNInterTransferViewModel *viewModel = [[PNInterTransferViewModel alloc] init];

        viewModel.channel = channel;
        PNInterTransferAmountViewController *amountVC = [[PNInterTransferAmountViewController alloc] initWithViewModel:viewModel];
        [SAWindowManager navigateToViewController:amountVC];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self getData];
        };
    }
    return _tableView;
}

- (PNInterTransferChannelDTO *)channelDTO {
    if (!_channelDTO) {
        _channelDTO = [[PNInterTransferChannelDTO alloc] init];
    }
    return _channelDTO;
}

- (NSMutableArray<PNInterTransferChannelModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNInterTransferDTO *)transferDTO {
    if (!_transferDTO) {
        _transferDTO = [[PNInterTransferDTO alloc] init];
    }
    return _transferDTO;
}
@end

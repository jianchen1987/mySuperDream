//
//  SAUserBillRefundReceiveInfoView.m
//  SuperApp
//
//  Created by seeu on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillRefundReceiveInfoView.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "SAUserBillDTO.h"


@interface SAUserBillRefundReceiveInfoView () <UITableViewDelegate, UITableViewDataSource>

///< tableview
@property (nonatomic, strong) SATableView *tableView;
///< datasource
@property (nonatomic, strong) NSArray<SAInfoViewModel *> *dataSource;

@end


@implementation SAUserBillRefundReceiveInfoView

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - data

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    SAInfoViewModel *model = self.dataSource[indexPath.row];
    SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.tableView.contentSize.height + 45);
    self.tableView.frame = self.bounds;
}

#pragma mark - public methods
- (void)setModel:(SAUserBillRefundReceiveAccountModel *)model {
    _model = model;

    void (^configModel)(SAInfoViewModel *) = ^void(SAInfoViewModel *model) {
        model.valueAlignmentToOther = NSTextAlignmentLeft;
        model.keyFont = HDAppTheme.font.standard2Bold;
        model.keyColor = HDAppTheme.color.G1;

        model.valueFont = HDAppTheme.font.standard2;
        model.lineWidth = 0;
    };

    NSMutableArray<SAInfoViewModel *> *infos = [[NSMutableArray alloc] initWithCapacity:3];
    SAInfoViewModel *infoModel = SAInfoViewModel.new;
    infoModel.keyText = SALocalizedString(@"refund_receiver_info_channel", @"收款渠道");
    infoModel.valueText = model.paymentChannel;
    configModel(infoModel);
    [infos addObject:infoModel];

    infoModel = SAInfoViewModel.new;
    infoModel.keyText = SALocalizedString(@"refund_receiver_info_account", @"收款账号");
    infoModel.valueText = model.receiveAccount;
    configModel(infoModel);
    [infos addObject:infoModel];

    infoModel = SAInfoViewModel.new;
    infoModel.keyText = SALocalizedString(@"refund_receiver_info_receiver", @"收款人");
    infoModel.valueText = model.receiveName;
    configModel(infoModel);
    [infos addObject:infoModel];

    self.dataSource = infos;
    [self.tableView successGetNewDataWithNoMoreData:YES];

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.bounces = false;
    }
    return _tableView;
}

@end

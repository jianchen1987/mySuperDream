//
//  PNLuckyPacketView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLuckyPacketView.h"
#import "PNLuckyPacketItemView.h"
#import "PNLuckyPacketViewModel.h"
#import "PNNotifyView.h"
#import "PNPacketMessageListItemModel.h"
#import "PNPacketOpenViewController.h"
#import "PNRecentPacketRecordsCell.h"
#import "PNRecentPacketRecordsHeaderView.h"
#import "PNTableView.h"


@interface PNLuckyPacketView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNLuckyPacketViewModel *viewModel;
@property (nonatomic, strong) UIImageView *imageBgView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) PNLuckyPacketItemView *randomItemView;
@property (nonatomic, strong) PNLuckyPacketItemView *pwdItemView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) PNNotifyView *notifyView;
@end


@implementation PNLuckyPacketView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.imageBgView];
    [self addSubview:self.topBgView];
    [self.topBgView addSubview:self.randomItemView];
    [self.topBgView addSubview:self.pwdItemView];
    [self addSubview:self.tableView];

    [self addSubview:self.notifyView];
    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeRedPacket];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)updateConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(self.viewController.hd_navigationBar.mas_bottom);
        }];
    }

    [self.imageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.size.mas_equalTo(self.imageBgView.image.size);
    }];

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        if (!self.notifyView.hidden) {
            make.top.mas_equalTo(self.notifyView.mas_bottom).offset(kRealWidth(48));
        } else {
            make.top.mas_equalTo(self.mas_top).offset(kNavigationBarH + kRealWidth(48));
        }
    }];

    [self.randomItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_left).offset(kRealWidth(8));
        make.right.mas_equalTo(self.topBgView.mas_right).offset(-kRealWidth(8));
        make.top.mas_equalTo(self.topBgView.mas_top).offset(kRealWidth(20));
    }];

    [self.pwdItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.randomItemView);
        make.top.mas_equalTo(self.randomItemView.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.topBgView.mas_bottom).offset(-kRealWidth(20));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNRecentPacketRecordsCell *cell = [PNRecentPacketRecordsCell cellWithTableView:tableView];
    cell.model = [self.viewModel.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNRecentPacketRecordsHeaderView *headerView = [PNRecentPacketRecordsHeaderView headerWithTableView:tableView];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketMessageListItemModel *model = [self.viewModel.dataSourceArray objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToOpenPacketVC:@{
        @"packetId": model.packetId,
    }];
}

#pragma mark
- (UIImageView *)imageBgView {
    if (!_imageBgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_packet_bg"];
        _imageBgView = imageView;
    }
    return _imageBgView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _topBgView = view;
    }
    return _topBgView;
}

- (PNLuckyPacketItemView *)randomItemView {
    if (!_randomItemView) {
        _randomItemView = [[PNLuckyPacketItemView alloc] init];

        PNLuckyPacketItemModel *model = [[PNLuckyPacketItemModel alloc] init];
        model.icon = [UIImage imageNamed:@"pn_icon_send_random"];
        model.titleStr = PNLocalizedString(@"pn_i_want_send_red_packet", @"我要发红包（拼）");
        model.contentStr = PNLocalizedString(@"pn_Each_package_of_amount_is_divided_randomly", @"普通红包，单个红包金额随机生成");
        model.bgColor = [UIColor hd_colorWithHexString:@"#FECCD6"];

        _randomItemView.model = model;

        _randomItemView.btnClickBlock = ^{
            HDLog(@"随机红包");
            [HDMediator.sharedInstance navigaveToHandOutPacketVC:@{
                @"type": @(PNPacketType_Nor),
            }];
        };
    }
    return _randomItemView;
}

- (PNLuckyPacketItemView *)pwdItemView {
    if (!_pwdItemView) {
        _pwdItemView = [[PNLuckyPacketItemView alloc] init];

        PNLuckyPacketItemModel *model = [[PNLuckyPacketItemModel alloc] init];
        model.icon = [UIImage imageNamed:@"pn_icon_send_pwd"];
        model.titleStr = PNLocalizedString(@"pn_lucky_packet", @"口令红包");
        model.contentStr = PNLocalizedString(@"pn_input_packet_number", @"输入红包口令领取");
        model.bgColor = [UIColor hd_colorWithHexString:@"#FEE0CC"];

        _pwdItemView.model = model;

        _pwdItemView.btnClickBlock = ^{
            HDLog(@"口令红包");
            [HDMediator.sharedInstance navigaveToHandOutPacketVC:@{
                @"type": @(PNPacketType_Password),
            }];
        };
    }
    return _pwdItemView;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.estimatedSectionHeaderHeight = 80;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}

@end

//
//  PNPacketRecordDetailsViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordDetailsViewController.h"
#import "PNPacketDetailModel.h"
#import "PNPacketRecordCountSection.h"
#import "PNPacketRecordDTO.h"
#import "PNPacketRecordDetailCell.h"
#import "PNPacketRecordDetailsHeaderView.h"
#import "PNPacketRecordDetailsPasswordView.h"
#import "PNTableView.h"


@interface PNPacketRecordDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *imageBgView;
@property (nonatomic, strong) PNPacketRecordDetailsHeaderView *headerView;
@property (nonatomic, strong) PNPacketRecordDetailsPasswordView *passwordView;
@property (nonatomic, strong) HDUIButton *recordListBtn;
@property (nonatomic, strong) SALabel *packetIdLabel;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, strong) PNPacketRecordDTO *recordDetailDTO;
@property (nonatomic, copy) NSString *viewType;
@property (nonatomic, copy) NSString *packetId;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) PNPacketDetailModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation PNPacketRecordDetailsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.packetId = [parameters objectForKey:@"packetId"];
        self.viewType = [parameters objectForKey:@"viewType"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_packet_detail", @"红包详情");
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (void)hd_bindViewModel {
    self.currentPage = 1;
    [self getData];
}

- (void)getData {
    [self.view showloading];
    @HDWeakify(self);
    [self.recordDetailDTO getPacketDetail:self.packetId page:self.currentPage success:^(PNPacketDetailModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = rspModel;

        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];

            self.headerView.model = self.model;
            if (rspModel.packetType == PNPacketType_Password && [self.viewType isEqualToString:@"send"]) {
                self.passwordView.password = rspModel.packetKey;
                self.passwordView.hidden = NO;
                [self.view setNeedsUpdateConstraints];
            }

            if (rspModel.records.count) {
                self.dataSource = [NSMutableArray arrayWithArray:rspModel.records];
                [self.tableView successGetNewDataWithNoMoreData:NO];
            } else {
                [self.tableView successGetNewDataWithNoMoreData:YES];
            }

        } else {
            if (rspModel.records.count) {
                [self.dataSource addObjectsFromArray:rspModel.records];
                [self.tableView successLoadMoreDataWithNoMoreData:NO];
            } else {
                [self.tableView successLoadMoreDataWithNoMoreData:YES];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.imageBgView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.recordListBtn];
    [self.view addSubview:self.packetIdLabel];
}

- (void)updateViewConstraints {
    [self.imageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.size.mas_equalTo(self.imageBgView.image.size);
    }];

    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.view.mas_top).offset(kNavigationBarH + kRealWidth(24));
    }];

    if (!self.passwordView.hidden) {
        [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerView);
            make.top.mas_equalTo(self.headerView.mas_bottom).offset(kRealWidth(20));
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (!self.passwordView.hidden) {
            make.top.mas_equalTo(self.passwordView.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.mas_equalTo(self.headerView.mas_bottom).offset(kRealWidth(20));
        }
        make.bottom.mas_equalTo(self.recordListBtn.mas_top).offset(-kRealWidth(20));
    }];

    [self.recordListBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.packetIdLabel.mas_top).offset(-kRealWidth(12));
    }];

    [self.packetIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kRealWidth(20));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketRecordDetailCell *cell = [PNPacketRecordDetailCell cellWithTableView:tableView];
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNPacketRecordCountSection *headerView = [PNPacketRecordCountSection headerWithTableView:tableView];
    headerView.model = self.model;
    return headerView;
}

#pragma mark
- (UIImageView *)imageBgView {
    if (!_imageBgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_packet_records_bg"];
        _imageBgView = imageView;
    }
    return _imageBgView;
}

- (PNPacketRecordDetailsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PNPacketRecordDetailsHeaderView alloc] init];
        _headerView.viewType = self.viewType;
    }
    return _headerView;
}

- (PNPacketRecordDetailsPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[PNPacketRecordDetailsPasswordView alloc] init];
        _passwordView.hidden = YES;
    }
    return _passwordView;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 47;

        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }

        @HDWeakify(self);
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.currentPage++;
            [self getData];
        };
    }
    return _tableView;
}

- (HDUIButton *)recordListBtn {
    if (!_recordListBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_check_red_packet_record", @"查看红包记录") forState:0];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"#0085FF"] forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard11;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToLuckPacketRecordsVC:@{}];
        }];

        _recordListBtn = button;
    }
    return _recordListBtn;
}

- (SALabel *)packetIdLabel {
    if (!_packetIdLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"pn_red_packet_no", @"红包编号:"), self.packetId];
        _packetIdLabel = label;
    }
    return _packetIdLabel;
}

- (PNPacketRecordDTO *)recordDetailDTO {
    if (!_recordDetailDTO) {
        _recordDetailDTO = [[PNPacketRecordDTO alloc] init];
    }
    return _recordDetailDTO;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

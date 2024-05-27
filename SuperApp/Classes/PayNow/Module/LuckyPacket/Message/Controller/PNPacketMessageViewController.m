//
//  PNPacketMessageViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketMessageViewController.h"
#import "NSDate+Extension.h"
#import "PNPacketListItemCell.h"
#import "PNPacketMessageDTO.h"
#import "PNPacketMessageListRspModel.h"
#import "PNSingleSelectedAlertView.h"
#import "PNTableView.h"


@interface PNPacketMessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *imageBgView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) HDUIButton *statuBtn;
@property (nonatomic, strong) HDUIButton *dateBtn;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) PNPacketMessageStatus currentSelectStatus;
@property (nonatomic, strong) NSString *currentSelectDateYear;
@property (nonatomic, strong) PNPacketMessageDTO *messageDTO;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end


@implementation PNPacketMessageViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.currentSelectStatus = PNPacketMessageStatus_UNCLAIMED;
        self.currentSelectDateYear = [NSString stringWithFormat:@"%zd", [NSDate.date year]];

        self.currentPage = 2;
    }
    return self;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_packet_message_title", @"红包消息");
}

- (void)hd_bindViewModel {
    //    [self.tableView.mj_header beginRefreshing];
    self.currentPage = 1;
    [self getData];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self.view addSubview:self.imageBgView];
    [self.view addSubview:self.topBgView];
    [self.topBgView addSubview:self.statuBtn];
    [self.topBgView addSubview:self.dateBtn];
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [self.imageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.size.mas_equalTo(self.imageBgView.image.size);
    }];

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(16));
    }];

    [self.statuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_left).offset(kRealWidth(16));
        make.top.bottom.equalTo(self.topBgView);
        make.height.equalTo(@(kRealWidth(28)));
    }];

    [self.dateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topBgView.mas_right).offset(-kRealWidth(16));
        make.top.equalTo(self.statuBtn);
        make.height.equalTo(@(kRealWidth(28)));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(30));
        //        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(30));

        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    NSString *startDate = [NSString stringWithFormat:@"01/01/%@ 00:00:00", self.currentSelectDateYear];
    NSString *endDate = [NSString stringWithFormat:@"31/12/%@ 23:59:59", self.currentSelectDateYear];

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *startDateInterval = [NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:startDate] timeIntervalSince1970] * 1000];
    NSString *endDateInterval = [NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:endDate] timeIntervalSince1970] * 1000];

    NSDictionary *dict =
        @{@"orderType": @(0), @"pageSize": @(10), @"pageNum": @(self.currentPage), @"startTime": startDateInterval, @"endTime": endDateInterval, @"lpMessageStatus": @(self.currentSelectStatus)};

    [self.messageDTO packetMessageList:dict success:^(PNPacketMessageListRspModel *_Nonnull rspModel) {
        if (self.currentPage == 1) {
            [self.dataSourceArray removeAllObjects];
            if (rspModel.list.count) {
                self.headerView.hidden = NO;
                self.dataSourceArray = [NSMutableArray arrayWithArray:rspModel.list];
                [self.tableView successGetNewDataWithNoMoreData:NO];
            } else {
                self.headerView.hidden = YES;
                [self.tableView successGetNewDataWithNoMoreData:YES];
            }
        } else {
            if (rspModel.list.count) {
                [self.dataSourceArray addObjectsFromArray:rspModel.list];
                [self.tableView successLoadMoreDataWithNoMoreData:NO];
            } else {
                [self.tableView successLoadMoreDataWithNoMoreData:YES];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

#pragma mark
- (void)handleStatusAlerView {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = [PNCommonUtils packetStatusName:PNPacketMessageStatus_UNCLAIMED];
    model.itemId = [NSString stringWithFormat:@"%zd", PNPacketMessageStatus_UNCLAIMED];
    if (self.currentSelectStatus == [model.itemId integerValue]) {
        model.isSelected = YES;
    }

    PNSingleSelectedModel *model2 = [[PNSingleSelectedModel alloc] init];
    model2.name = [PNCommonUtils packetStatusName:PNPacketMessageStatus_PARTIAL_RECEIVE];
    model2.itemId = [NSString stringWithFormat:@"%zd", PNPacketMessageStatus_PARTIAL_RECEIVE];
    if (self.currentSelectStatus == [model2.itemId integerValue]) {
        model2.isSelected = YES;
    }

    PNSingleSelectedModel *model3 = [[PNSingleSelectedModel alloc] init];
    model3.name = [PNCommonUtils packetStatusName:PNPacketMessageStatus_EXPIRED];
    model3.itemId = [NSString stringWithFormat:@"%zd", PNPacketMessageStatus_EXPIRED];
    ;
    if (self.currentSelectStatus == [model3.itemId integerValue]) {
        model3.isSelected = YES;
    }

    PNSingleSelectedModel *model4 = [[PNSingleSelectedModel alloc] init];
    model4.name = [PNCommonUtils packetStatusName:PNPacketMessageStatus_NO_WAITING];
    model4.itemId = [NSString stringWithFormat:@"%zd", PNPacketMessageStatus_NO_WAITING];
    if (self.currentSelectStatus == [model4.itemId integerValue]) {
        model4.isSelected = YES;
    }

    NSArray *arr = @[model, model2, model3, model4];

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:arr title:PNLocalizedString(@"please_select", @"请选择")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        self.currentSelectStatus = model.itemId.integerValue;

        [self.statuBtn setTitle:model.name forState:UIControlStateNormal];
        [self.tableView.mj_header beginRefreshing];
    };
    [alertView show];
}

- (void)handleYearAlerView {
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger endYear = [NSDate.date year];
    for (NSInteger i = 2022; i <= endYear; i++) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        NSString *iStr = [NSString stringWithFormat:@"%zd", i];
        model.name = [self setYearStr:iStr];
        model.itemId = iStr;
        if ([self.currentSelectDateYear isEqualToString:model.itemId]) {
            model.isSelected = YES;
        }

        [arr addObject:model];
    }

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:arr title:PNLocalizedString(@"pn_select_year", @"请选择年份")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        self.currentSelectDateYear = model.itemId;

        [self.dateBtn setTitle:model.name forState:UIControlStateNormal];
        [self.tableView.mj_header beginRefreshing];
    };
    [alertView show];
}

- (NSString *)setYearStr:(NSString *)year {
    //    return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_YEAR", @"年"), year];
    return year;
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketListItemCell *cell = [PNPacketListItemCell cellWithTableView:tableView];
    cell.model = [self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketMessageListItemModel *model = [self.dataSourceArray objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToOpenPacketVC:@{
        @"packetId": model.packetId,
    }];
}

#pragma mark
- (UIImageView *)imageBgView {
    if (!_imageBgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_packet_bg_2"];
        _imageBgView = imageView;
    }
    return _imageBgView;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        //        _tableView.tableHeaderView = self.headerView;

        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_tableView.mj_header;
        header.stateLabel.textColor = [UIColor whiteColor];
        header.backgroundColor = UIColor.clearColor;
        header.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.currentPage = 1;
            [self getData];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.currentPage++;
            [self getData];
        };
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(16))];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(16)];
        };
        view.hidden = YES;
        _headerView = view;
    }
    return _headerView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        UIView *view = [[UIView alloc] init];
        //        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _topBgView = view;
    }
    return _topBgView;
}

- (HDUIButton *)statuBtn {
    if (!_statuBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_Not_open", @"未领取") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        button.imagePosition = HDUIButtonImagePositionRight;
        [button setImage:[UIImage imageNamed:@"pn_packet_btn_down_white"] forState:0];
        button.adjustsButtonWhenHighlighted = NO;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(8));
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(12));
        button.layer.cornerRadius = kRealWidth(14);
        button.layer.borderColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
        button.layer.borderWidth = 1;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click status");
            @HDStrongify(self);
            [self handleStatusAlerView];
        }];

        _statuBtn = button;
    }
    return _statuBtn;
}

- (HDUIButton *)dateBtn {
    if (!_dateBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self setYearStr:self.currentSelectDateYear] forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        button.imagePosition = HDUIButtonImagePositionRight;
        [button setImage:[UIImage imageNamed:@"pn_packet_btn_down_white"] forState:0];
        button.adjustsButtonWhenHighlighted = NO;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(8));
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(12));
        button.layer.cornerRadius = kRealWidth(14);
        button.layer.borderColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
        button.layer.borderWidth = 1;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self handleYearAlerView];
        }];

        _dateBtn = button;
    }
    return _dateBtn;
}

- (PNPacketMessageDTO *)messageDTO {
    if (!_messageDTO) {
        _messageDTO = [[PNPacketMessageDTO alloc] init];
    }
    return _messageDTO;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
@end

//
//  SAMessagesViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASystemMessageViewController.h"
#import "HDMediator+GroupOn.h"
#import "NSDate+SAExtension.h"
#import "SAMessageDTO.h"
#import "SAMessageManager.h"
#import "SAMissingNotificationTipView.h"
#import "SAOrderNotLoginView.h"
#import "SASystemMessageTableViewCell.h"
#import "SATableView.h"


@interface SASystemMessageViewController () <UITableViewDelegate, UITableViewDataSource>
/// 头部
@property (nonatomic, strong) SAMissingNotificationTipView *headerView;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 默认数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 原始数据源
@property (nonatomic, strong) NSMutableArray<SASystemMessageModel *> *originDataSource;
/// DTO
@property (nonatomic, strong) SAMessageDTO *messageDTO;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// 全部已读按钮
@property (nonatomic, strong) HDUIButton *readAllBTN;

@end


@implementation SASystemMessageViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.clientType = [parameters objectForKey:@"clientType"];
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"messages", @"消息");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.readAllBTN]];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.notSignInView];

    [self applicationBecomeActive];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };

    [self.tableView getNewData];

    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    [SATalkingData trackEvent:@"系统消息列表_进入" label:@"" parameters:@{@"来源": HDIsStringNotEmpty(self.clientType) ? self.clientType : @"WOWNOW"}];
}

- (void)hd_languageDidChanged {
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"pg_label_msg_need_login", @"登录后可查看消息");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - event response
- (void)clickReadAllHandler {
    [self showloading];

    [SAMessageManager.share updateMessageReadStateWithMessageNo:@"" messageType:SAAppInnerMessageTypePersonal];

    //    @HDWeakify(self);
    //    [self.messageDTO updateMessageStatusToReadWithClientType:self.clientType
    //        sendSerialNumber:nil
    //        success:^{
    //            @HDStrongify(self);
    //            [self dismissLoading];
    //        }
    //        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
    //            @HDStrongify(self);
    //            [self dismissLoading];
    //        }];

    for (HDTableViewSectionModel *sectionModel in self.dataSource) {
        for (id model in sectionModel.list) {
            if (![model isKindOfClass:SASystemMessageModel.class]) {
                continue;
            }
            SASystemMessageModel *trueModel = (SASystemMessageModel *)model;
            trueModel.readStatus = SAStationLetterReadStatusRead;
        }
    }
    [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.hidden];

    [SATalkingData trackEvent:@"全部已读_点击" label:@"" parameters:@{}];
}

#pragma mark - Notification
- (void)applicationBecomeActive {
    if (!SAGeneralUtil.isNotificationEnable) {
        self.tableView.tableHeaderView = self.headerView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)userLoginHandler {
    self.notSignInView.hidden = true;
    [self.tableView getNewData];
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
}
#pragma mark - Data
- (void)getNewData {
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    if (!SAUser.hasSignedIn) {
        [self.tableView successGetNewDataWithNoMoreData:false];
        return;
    }

    @HDWeakify(self);
    [self.messageDTO getMessageListWithClientType:self.clientType type:SAAppInnerMessageTypeAll pageSize:10 page:pageNo success:^(SASystemMessageRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        // 修正 number
        self.currentPageNo = rspModel.pageNum;
        NSArray<SASystemMessageModel *> *list = rspModel.list;
        if (pageNo == 1) {
            [self.originDataSource removeAllObjects];
            if (list.count) {
                [self.originDataSource addObjectsFromArray:list];
            }
            @HDWeakify(self);
            [self dealingWithOriginDataSourceCompletion:^(NSMutableArray<HDTableViewSectionModel *> *dataSource) {
                @HDStrongify(self);
                self.dataSource = dataSource;
                [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            }];

        } else {
            if (list.count) {
                [self.originDataSource addObjectsFromArray:list];
            }
            @HDWeakify(self);
            [self dealingWithOriginDataSourceCompletion:^(NSMutableArray<HDTableViewSectionModel *> *dataSource) {
                @HDStrongify(self);
                self.dataSource = dataSource;
                [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }];
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        pageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SASystemMessageModel.class]) {
        SASystemMessageTableViewCell *cell = [SASystemMessageTableViewCell cellWithTableView:tableView];
        SASystemMessageModel *trueModel = (SASystemMessageModel *)model;
        trueModel.showBottomLine = indexPath.row != sectionModel.list.count - 1;
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard3;
    model.titleColor = HDAppTheme.color.G3;
    model.marginToBottom = -1;
    model.backgroundColor = HDAppTheme.color.G5;
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HDTableViewSectionModel *sectioModel = self.dataSource[indexPath.section];
    id model = sectioModel.list[indexPath.row];
    if ([model isKindOfClass:SASystemMessageModel.class]) {
        @HDWeakify(self);
        void (^defaultAction)(SASystemMessageModel *) = ^void(SASystemMessageModel *model) {
            @HDStrongify(self);
            if (HDIsStringEmpty(model.linkAddress)) {
                [HDMediator.sharedInstance navigaveToMessageDetailController:@{@"sendSerialNumber": model.sendSerialNumber, @"clientType": self.clientType}];
            } else {
                [SAWindowManager openUrl:model.linkAddress withParameters:nil];
            }
        };

        SASystemMessageModel *trueModel = (SASystemMessageModel *)model;
        // 有明确类型的，可以认为是boss发送，有link就跳，没有就展示详情
        if (trueModel.messageType == SAMessageTypeSystem || trueModel.messageType == SAMessageTypeNotice || trueModel.messageType == SAMessageTypeCoupon) {
            defaultAction(trueModel);
        } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem] && trueModel.messageType == SAMessageTypeGroup) {
            // 跳到团购订单页
            [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": trueModel.bizNo, @"from": @"SuppAppHome"}];
        } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem]) {
            // type 为空，为业务方发送的消息
            // 如果bizNo 有值，且不等于System Message，为外卖消息,跳到订单页
            [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": trueModel.bizNo}];
        } else {
            defaultAction(trueModel);
        }

        // 如果消息未读，更新为已读
        if (trueModel.readStatus == SAStationLetterReadStatusUnread) {
            [SAMessageManager.share updateMessageReadStateWithMessageNo:trueModel.sendSerialNumber messageType:SAAppInnerMessageTypePersonal];
            trueModel.readStatus = SAStationLetterReadStatusRead;
            // 刷新
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }

        // 埋点
        [SATalkingData trackEvent:@"系统消息列表_点击" label:@"" parameters:@{@"messageNo": trueModel.messageNo, @"link": HDIsStringNotEmpty(trueModel.linkAddress) ? trueModel.linkAddress : @""}];
    }
}

#pragma mark - private methods
/// 异步处理数据
/// @param completion 处理完成
- (void)dealingWithOriginDataSourceCompletion:(void (^)(NSMutableArray<HDTableViewSectionModel *> *))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray<HDTableViewSectionModel *> *dataSource = [NSMutableArray array];
        @autoreleasepool {
            // 先把原始数据排序
            [self.originDataSource sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(SASystemMessageModel *_Nonnull obj1, SASystemMessageModel *_Nonnull obj2) {
                return [obj1.sendTime compare:obj2.sendTime] == NSOrderedAscending;
            }];

            // 获取所有时间值
            NSArray<NSDate *> *sendDateArray = [[self.originDataSource valueForKey:@"sendTime"] mapObjectsUsingBlock:^NSDate *_Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:obj.integerValue / 1000.0];
                return date;
            }];

            // 按日期去重
            NSMutableDictionary<NSString *, NSDate *> *tmpDict = [NSMutableDictionary dictionary];
            for (NSDate *date in sendDateArray) {
                NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy"];
                [tmpDict setObject:date forKey:dateStr];
            }

            // 日期排序
            NSArray<NSDate *> *filterSendDateArray = [tmpDict.allValues sortedArrayUsingComparator:^NSComparisonResult(NSDate *_Nonnull obj1, NSDate *_Nonnull obj2) {
                return obj1.timeIntervalSince1970 < obj2.timeIntervalSince1970;
            }];

            [filterSendDateArray enumerateObjectsUsingBlock:^(NSDate *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSArray<SASystemMessageModel *> *array = [self.originDataSource hd_filterWithBlock:^BOOL(SASystemMessageModel *_Nonnull item) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:item.sendTime.integerValue / 1000.0];
                    return [date sa_isSameDay:obj];
                }];

                HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
                headerModel.title = [obj sa_isToday] ? SALocalizedString(@"today", @"今天") : [SAGeneralUtil getDateStrWithDate:obj format:@"dd/MM/yyyy"];

                HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
                sectionModel.list = array;
                sectionModel.headerModel = headerModel;

                [dataSource addObject:sectionModel];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(dataSource);
        });
    });
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (SAMessageDTO *)messageDTO {
    return _messageDTO ?: ({ _messageDTO = SAMessageDTO.new; });
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (SAMissingNotificationTipView *)headerView {
    if (!_headerView) {
        _headerView = SAMissingNotificationTipView.new;
        SAMissingNotificationTipModel *model = SAMissingNotificationTipModel.new;
        model.shouldFittingSize = true;
        _headerView.model = model;
    }
    return _headerView;
}

- (NSMutableArray<SASystemMessageModel *> *)originDataSource {
    if (!_originDataSource) {
        _originDataSource = [NSMutableArray array];
    }
    return _originDataSource;
}

- (SAOrderNotLoginView *)notSignInView {
    if (!_notSignInView) {
        _notSignInView = SAOrderNotLoginView.new;
        _notSignInView.hidden = SAUser.hasSignedIn;
        _notSignInView.clickedSignInSignUpBTNBlock = ^{
            [SAWindowManager switchWindowToLoginViewController];
        };
    }
    return _notSignInView;
}

- (HDUIButton *)readAllBTN {
    if (!_readAllBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"message_read_all", @"全部已读") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button sizeToFit];
        [button addTarget:self action:@selector(clickReadAllHandler) forControlEvents:UIControlEventTouchUpInside];
        _readAllBTN = button;
    }
    return _readAllBTN;
}
@end

//
//  SAMessageCenterListViewController.m
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageCenterListViewController.h"
#import "HDMediator+GroupOn.h"
#import "LKDataRecord.h"
#import "NSDate+SAExtension.h"
#import "SAMessageCenterListTableViewCell+Skeleton.h"
#import "SAMessageCenterListTableViewCell.h"
#import "SAMessageCenterListTableViewHeaderView.h"
#import "SAMessageDTO.h"
#import "SAMessageManager.h"
#import "SANavigationController.h"
#import "SARichMessageDetailsViewController.h"
#import "SATableView.h"


@interface SAMessageCenterListViewController () <UITableViewDelegate, UITableViewDataSource, SAMessageManagerDelegate>
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
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;
@end


@implementation SAMessageCenterListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.clientType = [parameters objectForKey:@"clientType"];
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };

    [self.tableView successGetNewDataWithNoMoreData:YES];
    [self getNewData];
    [SAMessageManager.share addListener:self];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(receiveNotifications:) name:kNotificationNameNewMessages object:nil];
}

- (void)hd_languageDidChanged {
    [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.isHidden];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.top.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameNewMessages object:nil];
    [SAMessageManager.share removeListener:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([self.messageType isEqualToString:SAAppInnerMessageTypeMarketing]) {
        [SATalkingData trackEvent:@"新版_营销消息列表_进入" label:@"" parameters:@{}];
    } else if ([self.messageType isEqualToString:SAAppInnerMessageTypePersonal]) {
        [SATalkingData trackEvent:@"新版_个人消息列表_进入" label:@"" parameters:@{}];
    }
}

#pragma mark - Notification
- (void)userLoginHandler {
    [self.tableView getNewData];
}

- (void)userLogoutHandler {
    [self.dataSource removeAllObjects];
    [self.originDataSource removeAllObjects];
    [self.tableView successGetNewDataWithNoMoreData:YES];
}

- (void)receiveNotifications:(NSNotification *)notify {
    if ([SAUser hasSignedIn]) {
        [self getNewData];
    }
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
    [self.messageDTO getMessageListWithClientType:self.clientType type:self.messageType pageSize:10 page:pageNo success:^(SASystemMessageRspModel *_Nonnull rspModel) {
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
        [self.dataSource enumerateObjectsUsingBlock:^(HDTableViewSectionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSArray *list = [NSArray arrayWithArray:obj.list];
            obj.list = [list hd_filterWithBlock:^BOOL(id _Nonnull item) {
                return ![item isKindOfClass:SAMessageCenterListCellSkeletonModel.class];
            }];
        }];
        if (pageNo == 1) {
            [self.tableView failGetNewData];
        } else {
            [self.tableView failLoadMoreData];
        }
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
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    SAMessageCenterListTableViewCell *cell = [SAMessageCenterListTableViewCell cellWithTableView:tableView];
    if ([model isKindOfClass:SASystemMessageModel.class]) {
        SASystemMessageModel *trueModel = (SASystemMessageModel *)model;
        trueModel.showBottomLine = indexPath.row != sectionModel.list.count - 1;
        cell.model = trueModel;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    SAMessageCenterListTableViewHeaderView *headView = [SAMessageCenterListTableViewHeaderView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    headView.text = model.title;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *secionModel = self.dataSource[indexPath.section];
    id model = secionModel.list[indexPath.row];
    if ([model isKindOfClass:SAMessageCenterListCellSkeletonModel.class]) {
        [cell hd_beginSkeletonAnimation];
    } else {
        [cell hd_endSkeletonAnimation];
    }
}

- (NSString *)nameOfSource {
    return [NSString stringWithFormat:@"%@.%@", HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表", self.messageType == SAAppInnerMessageTypePersonal ? @"个人" : @"优惠"];
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
                SARichMessageDetailsViewController *vc = [[SARichMessageDetailsViewController alloc] initWithRouteParameters:@{
                    @"source" : [self nameOfSource],
                    @"associatedId" : self.viewModel.associatedId
                }];
                vc.model = model;
                SANavigationController *nav = [SANavigationController rootVC:vc];
                nav.modalPresentationStyle = UIModalPresentationPageSheet;
                [self presentViewController:nav animated:YES completion:nil];
            } else {
                [SAWindowManager openUrl:model.linkAddress withParameters:@{
                    @"source" : [self nameOfSource],
                    @"associatedId" : self.viewModel.associatedId
                }];
            }
        };

        SASystemMessageModel *trueModel = model;
        if (trueModel.messageContentType == SAAppInnerMessageContentTypeRichText) {
            SARichMessageDetailsViewController *vc = [[SARichMessageDetailsViewController alloc] initWithRouteParameters:@{
                @"source" : [self nameOfSource],
                @"associatedId" : self.viewModel.associatedId
            }];
            vc.model = trueModel;
            SANavigationController *nav = [SANavigationController rootVC:vc];
            nav.modalPresentationStyle = UIModalPresentationPageSheet;
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            // 有明确类型的，可以认为是boss发送，有link就跳，没有就展示详情
            if (trueModel.messageType == SAMessageTypeSystem || trueModel.messageType == SAMessageTypeNotice || trueModel.messageType == SAMessageTypeCoupon) {
                defaultAction(trueModel);
                
            } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem] && trueModel.messageType == SAMessageTypeGroup) {
                // 跳到团购订单页
                [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": trueModel.bizNo, @"from": @"SuppAppHome"}];
                
            } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem]) {
                // type 为空，为业务方发送的消息
                // 如果bizNo 有值，且不等于System Message，为外卖消息,跳到订单页
                ///跳转修改地址
                if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow] && ([trueModel.messageNo isEqualToString:@"MCO025"] || [trueModel.messageNo isEqualToString:@"MCO024"])) {
                    [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{@"orderNo": trueModel.bizNo}];
                    
                } else if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow]
                           && ([trueModel.messageNo isEqualToString:@"MCO019"] || [trueModel.messageNo isEqualToString:@"MCO018"] || [trueModel.messageNo isEqualToString:@"MCO017"])) {
                    [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{@"orderNo": trueModel.bizNo}];
                    
                } else if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow] && [trueModel.messageNo isEqualToString:@"MCO027"]) {
                    [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/slow-pay"}];
                    
                } else {
                    [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": trueModel.bizNo}];
                    
                }
            } else if (HDIsStringNotEmpty(trueModel.messageNo) && [trueModel.messageNo isEqualToString:@"PCO020"]) { //意见详情
                NSString *jsonStr = trueModel.expand;
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                if (dic && [dic isKindOfClass:NSDictionary.class]) {
                    NSString *suggestionInfoId = [NSString stringWithFormat:@"%@", dic[@"suggestionInfoId"]];
                    if (HDIsStringNotEmpty(suggestionInfoId))
                        [HDMediator.sharedInstance navigaveToSuggestionDetailViewController:@{@"suggestionInfoId": suggestionInfoId}];
                }
            } else {
                defaultAction(trueModel);
            }
        }

        // 如果消息未读，更新为已读
        if (trueModel.readStatus == SAStationLetterReadStatusUnread) {
            [SAMessageManager.share updateMessageReadStateWithMessageNo:trueModel.sendSerialNumber messageType:self.messageType];
            trueModel.readStatus = SAStationLetterReadStatusRead;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }

        if ([self.messageType isEqualToString:SAAppInnerMessageTypeMarketing]) {
            [SATalkingData trackEvent:@"新版_营销消息列表_点击" label:@"" parameters:@{@"messageNo": trueModel.messageNo}];
            [LKDataRecord.shared traceEvent:@"click_message_list" name:@"营销" parameters:@{@"messageNo": trueModel.messageNo}
                                        SPM:[LKSPM SPMWithPage:@"SACouponMessageViewController" area:@"" node:[NSString stringWithFormat:@"node@%zd", indexPath.row]]];
        } else if ([self.messageType isEqualToString:SAAppInnerMessageTypePersonal]) {
            [SATalkingData trackEvent:@"新版_个人消息列表_点击" label:@"" parameters:@{@"messageNo": trueModel.messageNo}];
            [LKDataRecord.shared traceEvent:@"click_message_list" name:@"个人" parameters:@{@"messageNo": trueModel.messageNo}
                                        SPM:[LKSPM SPMWithPage:@"SAPersonalMessageViewController" area:@"" node:[NSString stringWithFormat:@"node@%zd", indexPath.row]]];
        }
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

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - SAMessageManagerDelegate
- (void)allMessageReaded {
    for (HDTableViewSectionModel *section in self.dataSource) {
        for (id model in section.list) {
            if ([model isKindOfClass:SASystemMessageModel.class]) {
                SASystemMessageModel *trueMdel = model;
                trueMdel.readStatus = SAStationLetterReadStatusRead;
            }
        }
    }

    [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.hidden];
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
        _tableView.estimatedRowHeight = 60;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

- (SAMessageDTO *)messageDTO {
    return _messageDTO ?: ({ _messageDTO = SAMessageDTO.new; });
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        HDTableViewSectionModel *model = HDTableViewSectionModel.new;
        model.list = @[
            SAMessageCenterListCellSkeletonModel.new,
            SAMessageCenterListCellSkeletonModel.new,
            SAMessageCenterListCellSkeletonModel.new,
            SAMessageCenterListCellSkeletonModel.new,
            SAMessageCenterListCellSkeletonModel.new
        ];

        _dataSource = [[NSMutableArray alloc] initWithArray:@[model]];
    }
    return _dataSource;
}

- (NSMutableArray<SASystemMessageModel *> *)originDataSource {
    if (!_originDataSource) {
        _originDataSource = [NSMutableArray array];
    }
    return _originDataSource;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end

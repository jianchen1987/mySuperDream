//
//  SAMCListViewController.m
//  SuperApp
//
//  Created by Tia on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMCListViewController.h"
#import "HDMediator+GroupOn.h"
#import "LKDataRecord.h"
#import "NSDate+SAExtension.h"
#import "SAMessageCenterListTableViewCell+Skeleton.h"
#import "SAMCListCell.h"
#import "SAMessageCenterListTableViewHeaderView.h"
#import "SAMessageDTO.h"
#import "SAMessageManager.h"
#import "SANavigationController.h"
#import "SARichMessageDetailsViewController.h"
#import "SATableView.h"


@interface SAMCListViewController () <UITableViewDelegate, UITableViewDataSource, SAMessageManagerDelegate>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 原始数据源
@property (nonatomic, strong) NSMutableArray<SASystemMessageModel *> *originDataSource;
/// DTO
@property (nonatomic, strong) SAMessageDTO *messageDTO;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;

@property (nonatomic, strong) HDUIButton *readBtn;

///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation SAMCListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.clientType = [parameters objectForKey:@"clientType"];
    return self;
}

- (void)hd_setupNavigation {
    if ([self.messageType isEqualToString:SAAppInnerMessageTypeMarketing]) {
        self.boldTitle = SALocalizedString(@"mc_Promotions", @"活动优惠");
    } else {
        self.boldTitle = SALocalizedString(@"mc_Personal_information", @"个人信息");
    }
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.readBtn]];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;
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
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.width.bottom.centerX.equalTo(self.view);
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

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}


#pragma mark - Notification
- (void)userLoginHandler {
    [self.tableView getNewData];
}

- (void)userLogoutHandler {
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

            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];


        } else {
            if (list.count) {
                [self.originDataSource addObjectsFromArray:list];
            }
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        if (pageNo == 1) {
            [self.tableView failGetNewData];
        } else {
            [self.tableView failLoadMoreData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.originDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMCListCell *cell = [SAMCListCell cellWithTableView:tableView];
    cell.model = self.originDataSource[indexPath.row];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    HDTableViewSectionModel *secionModel = self.originDataSource[indexPath.section];
//    id model = secionModel.list[indexPath.row];
//    if ([model isKindOfClass:SAMessageCenterListCellSkeletonModel.class]) {
//        [cell hd_beginSkeletonAnimation];
//    } else {
//        [cell hd_endSkeletonAnimation];
//    }
//}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SASystemMessageModel *model = self.originDataSource[indexPath.row];
    if ([model isKindOfClass:SASystemMessageModel.class]) {
        @HDWeakify(self);
        void (^defaultAction)(SASystemMessageModel *) = ^void(SASystemMessageModel *model) {
            @HDStrongify(self);
            if (HDIsStringEmpty(model.linkAddress)) {
                SARichMessageDetailsViewController *vc = [[SARichMessageDetailsViewController alloc] initWithRouteParameters:@{
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                    @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : model.messageNo
                }];
                vc.model = model;
                SANavigationController *nav = [SANavigationController rootVC:vc];
                nav.modalPresentationStyle = UIModalPresentationPageSheet;
                [self presentViewController:nav animated:YES completion:nil];
            } else {
                [SAWindowManager openUrl:model.linkAddress withParameters:@{
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                    @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : model.messageNo
                }];
            }
        };

        SASystemMessageModel *trueModel = model;
        if (trueModel.messageContentType == SAAppInnerMessageContentTypeRichText) {
            SARichMessageDetailsViewController *vc = [[SARichMessageDetailsViewController alloc] initWithRouteParameters:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
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
                [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{
                    @"orderNo": trueModel.bizNo,
                    @"from": @"SuppAppHome",
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                    @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                }];
                
            } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem]) {
                // type 为空，为业务方发送的消息
                // 如果bizNo 有值，且不等于System Message，为外卖消息,跳到订单页
                ///跳转修改地址
                if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow] && ([trueModel.messageNo isEqualToString:@"MCO025"] || [trueModel.messageNo isEqualToString:@"MCO024"])) {
                    [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{
                        @"orderNo": trueModel.bizNo,
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                    }];
                    
                } else if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow]
                           && ([trueModel.messageNo isEqualToString:@"MCO019"] || [trueModel.messageNo isEqualToString:@"MCO018"] || [trueModel.messageNo isEqualToString:@"MCO017"])) {
                    [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{
                        @"orderNo": trueModel.bizNo,
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                    }];
                    
                } else if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow] && [trueModel.messageNo isEqualToString:@"MCO027"]) {
                    [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/slow-pay"}];
                } else {
                    [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{
                        @"orderNo": trueModel.bizNo,
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                    }];
                }
            } else if (HDIsStringNotEmpty(trueModel.messageNo) && [trueModel.messageNo isEqualToString:@"PCO020"]) { //意见详情
                NSString *jsonStr = trueModel.expand;
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                if (dic && [dic isKindOfClass:NSDictionary.class]) {
                    NSString *suggestionInfoId = [NSString stringWithFormat:@"%@", dic[@"suggestionInfoId"]];
                    if (HDIsStringNotEmpty(suggestionInfoId))
                        [HDMediator.sharedInstance navigaveToSuggestionDetailViewController:@{
                            @"suggestionInfoId": suggestionInfoId,
                            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息列表"] : @"消息列表",
                            @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                        }];
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


#pragma mark - SAMessageManagerDelegate
- (void)allMessageReaded {
    for (SASystemMessageModel *model in self.originDataSource) {
        model.readStatus = SAStationLetterReadStatusRead;
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
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return _tableView;
}

- (SAMessageDTO *)messageDTO {
    return _messageDTO ?: ({ _messageDTO = SAMessageDTO.new; });
}


- (NSMutableArray<SASystemMessageModel *> *)originDataSource {
    if (!_originDataSource) {
        _originDataSource = [NSMutableArray array];
    }
    return _originDataSource;
}

- (HDUIButton *)readBtn {
    if (!_readBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"mc_All_Seen", @"已读") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard14M;
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (!self.originDataSource.count)
                return;

            HDLog(@"%@ 点击已读", self.boldTitle);
            [SAMessageManager.share updateMessageReadStateWithMessageType:self.messageType];
            for (SASystemMessageModel *model in self.originDataSource) {
                model.readStatus = SAStationLetterReadStatusRead;
            }
            [self.tableView successGetNewDataWithNoMoreData:self.tableView.mj_footer.hidden];
        }];
        _readBtn = button;
    }
    return _readBtn;
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

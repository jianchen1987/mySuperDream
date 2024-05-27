//
//  SANewMessageCenterViewController.m
//  SuperApp
//
//  Created by Tia on 2023/5/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SANewMessageCenterViewController.h"
#import "SAMessageCenterHeaderView.h"
#import "SAMessageManager.h"
#import "SATableView.h"
#import "SAMessageCenterCell.h"
#import "SAMessageDTO.h"
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>
#import "SAMessageModel.h"
#import "LKDataRecord.h"
#import "SARichMessageDetailsViewController.h"
#import "HDMediator+GroupOn.h"
#import "SAMCListViewController.h"
#import "SAMCChatListViewController.h"
#import "SAAppSwitchManager.h"
#import "SAImDelegateManager.h"
#import "SAOrderNotLoginView.h"
#import "SAMessageCenterListModel.h"
#import "SAMessageCenterCell+Skeleton.h"


@interface SANewMessageCenterViewController () <SAMessageManagerDelegate,
                                                SAMessageCenterTableHeaderFooterViewDelegate,
                                                KSInstMsgChatProtocol,
                                                KSInstMsgConversationProtocol,
                                                UITableViewDelegate,
                                                UITableViewDataSource>

/// 头部UI
@property (nonatomic, strong) SAMessageCenterHeaderView *headerView;

@property (nonatomic, strong) SATableView *tableView;
/// 未读数组
@property (nonatomic, strong) NSArray *unreadCountArr;

@property (nonatomic, strong) SAMessageDTO *messageDTO;
/// 活动优惠原始数据源
@property (nonatomic, strong) NSMutableArray *actionDataSource;
/// 个人信息原始数据源
@property (nonatomic, strong) NSMutableArray *infoDataSource;
/// 聊天记录原始数据源
@property (nonatomic, strong) NSMutableArray *chatDataSource;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// 推送开启提示
@property (nonatomic, strong) HDAnnouncementView *tipsView;
///  提示配置
@property (nonatomic, strong) HDAnnouncementViewConfig *tipsConfig;
/// 设置
@property (nonatomic, strong) SAOperationButton *settingBtn;

///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation SANewMessageCenterViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    SAClientType clientType = [parameters objectForKey:@"clientType"];
    self.clientType = HDIsStringNotEmpty(clientType) ? clientType : SAClientTypeMaster;

    return self;
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 3;

    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;

    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };

    [self.view addSubview:self.tipsView];
    [self.view addSubview:self.settingBtn];
    [self.view addSubview:self.notSignInView];

    [self applicationBecomeActive];


    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    [KSInstMsgManager.share addChatListener:self];
    [KSInstMsgManager.share addConversationListener:self];

    [SAMessageManager.share addListener:self];

    self.headerView.readButton.hidden = ![SAUser hasSignedIn];

    [self updateUnreadCount];
}

- (void)hd_setupNavigation {
    [self setHd_statusBarStyle:UIStatusBarStyleDefault];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [KSInstMsgManager.share removeChatListener:self];
    [KSInstMsgManager.share removeConversationListener:self];
    [SAMessageManager.share removeListener:self];
}

- (void)hd_languageDidChanged {
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"pg_label_msg_need_login", @"登录后可查看消息");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }

    if (!self.tipsView.isHidden) {
        self.tipsConfig.text = SALocalizedString(@"privacy_notification_tips", @"开启通知，随时获取订单信息、优惠信息开启通知，随时获取订单信息、优惠信息。");
        self.tipsView.config = self.tipsConfig;
        [self.settingBtn setTitle:SALocalizedString(@"O3N3zScm", @"去开启") forState:UIControlStateNormal];
    }

    self.headerView.titleLabel.text = SALocalizedString(@"mc_Information", @"消息");
    [self.headerView.readButton setTitle:SALocalizedString(@"mc_All_Seen", @"全部已读") forState:UIControlStateNormal];
}


- (void)updateViewConstraints {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_offset(kStatusBarH + 42 + 54);
    }];

    if (!self.tipsView.isHidden) {
        [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(kStatusBarH + 54 + 4);
            make.height.mas_equalTo(36.5);
        }];

        [self.settingBtn sizeToFit];
        [self.settingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tipsView.mas_centerY);
            make.right.equalTo(self.tipsView.mas_right).offset(-kRealWidth(15));
        }];
    }

    CGFloat margin = 12;

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipsView.isHidden) {
            make.top.equalTo(self.tipsView.mas_bottom).offset(8);
        } else {
            make.top.mas_equalTo(kStatusBarH + 54 + 4);
        }
        make.bottom.equalTo(self.view);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarH + 54 + 4);
        make.left.right.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)hd_getNewData {
    if ([SAUser hasSignedIn]) {
        [self getNewData];
    } else {
        [self userLogoutHandler];
    }
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - Data
- (void)updateUnreadCount {
    @HDWeakify(self);
    [SAMessageManager.share getUnreadMessageCount:^(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *_Nonnull details) {
        @HDStrongify(self);
        self.unreadCountArr = @[details[SAAppInnerMessageTypeMarketing], details[SAAppInnerMessageTypePersonal], details[SAAppInnerMessageTypeChat]];
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}


- (void)getNewData {
    [self getData];
}

- (void)getData {
    if (!SAUser.hasSignedIn) {
        [self.tableView successGetNewDataWithNoMoreData:false];
        return;
    }


    @HDWeakify(self);
    [SAMessageManager.share getMessageListForMessageCenterWithClientType:self.clientType success:^(NSArray<SAMessageCenterListModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.actionDataSource removeAllObjects];
        [self.infoDataSource removeAllObjects];
        for (SAMessageCenterListModel *model in list) {
            if ([model.businessMessageType isEqualToString:SAAppInnerMessageTypeMarketing]) {
                NSArray<SASystemMessageModel *> *list = model.messageRespList;
                if (list.count) {
                    [self.actionDataSource addObjectsFromArray:list];
                }
            } else if ([model.businessMessageType isEqualToString:SAAppInnerMessageTypePersonal]) {
                NSArray<SASystemMessageModel *> *list = model.messageRespList;
                if (list.count) {
                    [self.infoDataSource addObjectsFromArray:list];
                }
            }
        }
        [self.tableView successGetNewDataWithNoMoreData:NO];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.actionDataSource removeAllObjects];
        [self.infoDataSource removeAllObjects];
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];

    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}


- (void)getConversationsCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [KSInstMsgManager.share getAllConversationsWithCompletion:^(NSArray<KSInstMsgConversation *> *_Nonnull conversations) {
        @HDStrongify(self);
        [self.chatDataSource removeAllObjects];
        for (KSInstMsgConversation *conversation in conversations) {
            SAMessageModel *model = SAMessageModel.new;

            if (conversation.type == KSConversationSingle) {
                model.headImgUrl = conversation.roster.avatarUrl;
                switch (conversation.roster.role) {
                    case KSInstMsgRoleTinhNowMerchant:
                        model.headPlaceholderImage = [UIImage imageNamed:@"head_placeholder_tinhnow"];
                        model.headImgUrl = @"";
                        break;
                    case KSInstMsgRoleYumNowMerchant:
                        model.headPlaceholderImage = [UIImage imageNamed:@"head_placeholder_yumnow"];
                        model.headImgUrl = @"";
                        break;
                    case KSInstMsgRoleRider:
                        model.headPlaceholderImage = [UIImage imageNamed:@"head_placeholder_rider"];
                        model.headImgUrl = @"";
                        break;
                    case KSInstMsgRolePlatformService:
                        model.headPlaceholderImage = [UIImage imageNamed:@"head_placeholder_platform"];
                        model.headImgUrl = @"";
                        break;
                    default:
                        model.headPlaceholderImage = [UIImage imageNamed:@"head_placeholder_default"];
                        break;
                }
                model.title = conversation.roster.nickName;
                model.isGroup = NO;
            } else if (conversation.type == KSConversationGroup) {
                model.headImgUrl = conversation.faceUrl;
                model.title = conversation.showName;
                model.isGroup = YES;
            } else {
                model.headImgUrl = conversation.faceUrl;
                model.title = conversation.showName;
                model.isGroup = NO;
            }

            if (!HDIsObjectNil(conversation.lastMessage)) {
                switch (conversation.lastMessage.type) {
                    case KSMessageContentTypeFile:
                        model.content = SALocalizedString(@"message_placeholder_file", @"[文件]");
                        break;
                    case KSMessageContentTypeImage:
                        model.content = SALocalizedString(@"message_placeholder_image", @"[图片]");
                        break;
                    case KSMessageContentTypeVideo:
                        model.content = SALocalizedString(@"message_placeholder_video", @"[视频]");
                        break;
                    case KSMessageContentTypeVoice:
                        model.content = SALocalizedString(@"message_placeholder_voice", @"[语音]");
                        break;
                    case KSMessageContentTypeLocation:
                        model.content = SALocalizedString(@"message_placeholder_location", @"[位置]");
                        break;
                    case KSMessageContentTypeText:
                        model.content = conversation.lastMessage.content;
                        break;
                    case KSMessageContentTypeGroupCreated:
                        model.content = SALocalizedString(@"", @"");
                        break;
                    case KSMessageContentTypeGroupDismiss:
                        model.content = SALocalizedString(@"order_completed", @"[订单已结束]");
                        break;
                    case KSMessageContentTypeInvitedCustomerServiceJoin:
                    case KSMessageContentTypeMemberKicked:
                    case KSMessageContentTypeMemberInvited:
                    case KSMessageContentTypeCustomerEndService:
                        model.content = conversation.lastMessage.content;
                        break;
                    case KSMessageContentTypeAdvancedRevoke:
                        if (conversation.lastMessage.isSender) {
                            model.content = SALocalizedString(@"Recall_tip2", @"你撤回一条消息");
                        } else {
                            if (conversation.type == KSConversationSingle) {
                                model.content = [NSString stringWithFormat:@"\"%@\" %@", conversation.roster.recallShowName, SALocalizedString(@"Recall_tip1", @"撤回一条消息")];
                            } else if (conversation.type == KSConversationGroup) {
                                model.content = conversation.lastMessage.content;
                            }
                        }
                        break;
                    case KSMessageContentTypeCallKitCenter:

                        model.content = SALocalizedString(@"mc_voice_call", @"[语音通话]");
                        break;
                    default:
                        model.content = SALocalizedString(@"message_placeholder_unknow", @"[未知消息]");
                        break;
                }
                model.sendDate = conversation.lastMessage.serverTimestamp / 1000.0;
            } else {
                model.content = @"";
                model.sendDate = 0;
            }
            model.bubble = conversation.unreadNumber;
            model.associatedObject = conversation;
            [self.chatDataSource addObject:model];
        }
        !completion ?: completion();
    }];
}

#pragma mark - listener
- (void)unreadMessageCountChanged:(NSUInteger)count details:(NSDictionary<SAAppInnerMessageType, NSNumber *> *)details {
    NSArray *oldUnreadCountArr = self.unreadCountArr.mutableCopy;
    self.unreadCountArr = @[details[SAAppInnerMessageTypeMarketing], details[SAAppInnerMessageTypePersonal], details[SAAppInnerMessageTypeChat]];
    BOOL needRefresh = NO;
    if (oldUnreadCountArr.count == 3) {
        for (NSInteger i = 0; i < 2; i++) { //只比对前两组数字
            NSInteger on = [oldUnreadCountArr[i] integerValue];
            NSInteger nn = [self.unreadCountArr[i] integerValue];
            if (on < nn) { // 说明有新的未读消息，这个时候需要筛选列表
                needRefresh = YES;
                break;
                ;
            }
        }
    }
    if (needRefresh) {
        [self getNewData];
    }
}

#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
    self.tableView.hidden = false;
    self.headerView.readButton.hidden = false;
    //延迟1秒，考虑im登录成功需要时间，再刷新一次UI;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getNewData];
    });
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
    self.tableView.hidden = true;
    self.headerView.readButton.hidden = true;
}

- (void)applicationBecomeActive {
    if (!SAGeneralUtil.isNotificationEnable) {
        self.tipsView.hidden = NO;
        self.settingBtn.hidden = NO;
    } else {
        self.tipsView.hidden = YES;
        self.settingBtn.hidden = YES;
    }
    [self.view setNeedsUpdateConstraints];
}

#pragma mark action
- (void)clickOnSetting:(SAOperationButton *)button {
    [HDSystemCapabilityUtil openAppSystemSettingPage];
}

#pragma mark - SAMessageCenterTableHeaderFooterViewDelegate
- (void)headerViewClick:(SAMessageCenterTableHeaderFooterView *)headerView {
    if (headerView.section == 0 || headerView.section == 1) {
        SAMCListViewController *vc = [[SAMCListViewController alloc] initWithRouteParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.messageType = SAAppInnerMessageTypeMarketing;
        if (headerView.section == 1) {
            vc.messageType = SAAppInnerMessageTypePersonal;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (headerView.section == 2) {
        SAMCChatListViewController *vc = SAMCChatListViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - KSInstMsgChatProtocol
- (void)conversationTotalCountChanged:(NSInteger)unreadCount {
    HDLog(@"未读消息数:%zd", unreadCount);
    @HDWeakify(self);
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}

- (void)loadAllConversationDidFinished {
    HDLog(@"会话加载完啦!");
}

- (void)revokedMessage:(KSMessageModel *)message {
    HDLog(@"撤回消息了");
    @HDWeakify(self);
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:NO];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return self.actionDataSource.count;
    if (section == 1)
        return self.infoDataSource.count;
    if (section == 2)
        return self.chatDataSource.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 0 && self.actionDataSource.count) || (section == 1 && self.infoDataSource.count) || (section == 2 && self.chatDataSource.count))
        return 48;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((section == 0 && self.actionDataSource.count) || (section == 1 && self.infoDataSource.count) || (section == 2 && self.chatDataSource.count))
        return 8;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMessageCenterCell *cell = [SAMessageCenterCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    id model = nil;
    if (indexPath.section == 0) {
        model = self.actionDataSource[indexPath.row];
    } else if (indexPath.section == 1) {
        model = self.infoDataSource[indexPath.row];
    } else if (indexPath.section == 2) {
        model = self.chatDataSource[indexPath.row];
    }

    if (indexPath.section == 0) {
        cell.isLastCell = indexPath.row == self.actionDataSource.count - 1;
        if ([model isKindOfClass:SASystemMessageModel.class])
            cell.model = model;
    } else if (indexPath.section == 1) {
        cell.isLastCell = indexPath.row == self.infoDataSource.count - 1;
        if ([model isKindOfClass:SASystemMessageModel.class])
            cell.model = model;
    } else if (indexPath.section == 2) {
        cell.isLastCell = indexPath.row == self.chatDataSource.count - 1;
        if ([model isKindOfClass:SAMessageModel.class])
            cell.chatModel = model;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SAMessageCenterTableHeaderFooterView *headerView = [SAMessageCenterTableHeaderFooterView headerWithTableView:tableView];
    if (self.unreadCountArr.count > section) {
        headerView.number = [self.unreadCountArr[section] integerValue];
    } else {
        headerView.number = 0;
    }
    headerView.section = section;
    headerView.delegate = self;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLog(@"%@", indexPath);

    id model = nil;
    if (indexPath.section == 0) {
        model = self.actionDataSource[indexPath.row];
    } else if (indexPath.section == 1) {
        model = self.infoDataSource[indexPath.row];
    } else if (indexPath.section == 2) {
        model = self.chatDataSource[indexPath.row];
    }

    if (indexPath.section == 0 || indexPath.section == 1) {
        if ([model isKindOfClass:SASystemMessageModel.class]) {
            @HDWeakify(self);
            void (^defaultAction)(SASystemMessageModel *) = ^void(SASystemMessageModel *model) {
                @HDStrongify(self);
                if (HDIsStringEmpty(model.linkAddress)) {
                    SARichMessageDetailsViewController *vc = [[SARichMessageDetailsViewController alloc] initWithRouteParameters:@{
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : model.messageNo
                    }];
                    vc.model = model;
                    SANavigationController *nav = [SANavigationController rootVC:vc];
                    nav.modalPresentationStyle = UIModalPresentationPageSheet;
                    [self presentViewController:nav animated:YES completion:nil];
                } else {
                    [SAWindowManager openUrl:model.linkAddress withParameters:@{
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : model.messageNo
                    }];
                }
            };

            SASystemMessageModel *trueModel = model;
            if (trueModel.messageContentType == SAAppInnerMessageContentTypeRichText) {
                SARichMessageDetailsViewController *vc = [[SARichMessageDetailsViewController alloc] initWithRouteParameters:@{
                    @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
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
                        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
                        @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                    }];
                    
                } else if (HDIsStringNotEmpty(trueModel.bizNo) && ![trueModel.bizNo isEqualToString:SAStationLetterTypeSystem]) {
                    // type 为空，为业务方发送的消息
                    // 如果bizNo 有值，且不等于System Message，为外卖消息,跳到订单页
                    ///跳转修改地址
                    if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow] && ([trueModel.messageNo isEqualToString:@"MCO025"] || [trueModel.messageNo isEqualToString:@"MCO024"])) {
                        [HDMediator.sharedInstance navigaveToModifyOrderAddressHistoryViewController:@{
                            @"orderNo": trueModel.bizNo,
                            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
                            @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                        }];
                        
                    } else if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow]
                               && ([trueModel.messageNo isEqualToString:@"MCO019"] || [trueModel.messageNo isEqualToString:@"MCO018"] || [trueModel.messageNo isEqualToString:@"MCO017"])) {
                        [HDMediator.sharedInstance navigaveToFeedBackHistoryController:@{
                            @"orderNo": trueModel.bizNo,
                            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
                            @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                        }];
                        
                    } else if ([trueModel.businessLine isEqualToString:SAClientTypeYumNow] && [trueModel.messageNo isEqualToString:@"MCO027"]) {
                        [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/slow-pay"}];
                        
                    } else {
                        [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{
                            @"orderNo": trueModel.bizNo,
                            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
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
                                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息中心"] : @"消息中心",
                                @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : trueModel.messageNo
                            }];
                    }
                    
                } else {
                    defaultAction(trueModel);
                }
            }


            // 如果消息未读，更新为已读
            if (trueModel.readStatus == SAStationLetterReadStatusUnread) {
                [SAMessageManager.share updateMessageReadStateWithMessageNo:trueModel.sendSerialNumber
                                                                messageType:indexPath.section == 0 ? SAAppInnerMessageTypeMarketing : SAAppInnerMessageTypePersonal];
                trueModel.readStatus = SAStationLetterReadStatusRead;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }

            if (indexPath.section == 0) {
                [SATalkingData trackEvent:@"新版_营销消息列表_点击" label:@"" parameters:@{@"messageNo": trueModel.messageNo}];
                [LKDataRecord.shared traceEvent:@"click_message_list" name:@"营销" parameters:@{@"messageNo": trueModel.messageNo}
                                            SPM:[LKSPM SPMWithPage:@"SACouponMessageViewController" area:@"" node:[NSString stringWithFormat:@"node@%zd", indexPath.row]]];
            } else if (indexPath.section == 1) {
                [SATalkingData trackEvent:@"新版_个人消息列表_点击" label:@"" parameters:@{@"messageNo": trueModel.messageNo}];
                [LKDataRecord.shared traceEvent:@"click_message_list" name:@"个人" parameters:@{@"messageNo": trueModel.messageNo}
                                            SPM:[LKSPM SPMWithPage:@"SAPersonalMessageViewController" area:@"" node:[NSString stringWithFormat:@"node@%zd", indexPath.row]]];
            }
        }
    } else if (indexPath.section == 2) {
        if ([model isKindOfClass:SAMessageModel.class]) {
            SAMessageModel *trueModel = (SAMessageModel *)model;
            if (trueModel.isGroup) {
                KSInstMsgConversation *conversation = (KSInstMsgConversation *)trueModel.associatedObject;
                KSChatConfig *config = KSChatConfig.new;

                NSString *voiceCallSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchIMVoiceCall];
                if (HDIsStringNotEmpty(voiceCallSwitch) && [voiceCallSwitch.lowercaseString isEqualToString:@"on"]) {
                    config.supportTools = config.supportTools | KSChatSupportToolsOrder | KSChatSupportToolsVoiceCall;
                } else {
                    config.supportTools = config.supportTools | KSChatSupportToolsOrder;
                }

                KSGroupChatVC *vc = [[KSGroupChatVC alloc] initWithGroupID:conversation.groupID conversation:conversation config:config];
                vc.delegate = [SAImDelegateManager shared];
                vc.orderListDelegate = [SAImDelegateManager shared];

                [SAWindowManager navigateToViewController:vc];
            } else {
                KSInstMsgConversation *conversation = (KSInstMsgConversation *)trueModel.associatedObject;
                KSChatConfig *config = KSChatConfig.new;
                //            config.phoneNo = @"12312312";
                config.supportTools = config.supportTools | KSChatSupportToolsOrder;
                KSChatVC *vc = [[KSChatVC alloc] initWithRoster:conversation.roster conversation:conversation config:config];
                vc.delegate = [SAImDelegateManager shared];
                vc.orderListDelegate = [SAImDelegateManager shared];

                [SAWindowManager navigateToViewController:vc];
            }

            [LKDataRecord.shared traceEvent:@"click_message_list" name:@"聊天" parameters:nil SPM:[LKSPM SPMWithPage:@"SAChatMessageViewController" area:@""
                                                                                                                node:[NSString stringWithFormat:@"node@%zd", indexPath.row]]];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    if (indexPath.section == 0) {
        model = self.actionDataSource[indexPath.row];
    } else if (indexPath.section == 1) {
        model = self.infoDataSource[indexPath.row];
    } else if (indexPath.section == 2) {
        model = self.chatDataSource[indexPath.row];
    }
    if ([model isKindOfClass:SAMessageCenterCellSkeletonModel.class]) {
        [cell hd_beginSkeletonAnimation];
    } else {
        [cell hd_endSkeletonAnimation];
    }
}


#pragma mark - lazy load
- (SAMessageCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = SAMessageCenterHeaderView.new;
        @HDWeakify(self);
        _headerView.allRealClickBlock = ^{
            @HDStrongify(self);
            HDLog(@"点击全部已读");
            if (![SAUser hasSignedIn])
                return;
            if (!self.actionDataSource.count && !self.infoDataSource.count && !self.chatDataSource.count)
                return;

            @HDWeakify(self);
            [SAMessageManager.share updateAllMessageReadedWithCompletion:^{
                @HDStrongify(self);
                // im返回未读数有一定延迟，此处不刷新列表，直接把未读标识改成已读处理
                for (SASystemMessageModel *model in self.actionDataSource) {
                    model.readStatus = SAStationLetterReadStatusRead;
                }

                for (SASystemMessageModel *model in self.infoDataSource) {
                    model.readStatus = SAStationLetterReadStatusRead;
                }

                for (SAMessageModel *model in self.chatDataSource) {
                    model.bubble = 0;
                }

                [self.tableView successGetNewDataWithNoMoreData:NO];
            }];

            [LKDataRecord.shared traceEvent:@"click_messageCenter_readAll_button" name:@"点击全部已读" parameters:nil SPM:[LKSPM SPMWithPage:@"SAMessageCenterViewController" area:@"" node:@""]];
        };
    }
    return _headerView;
}

- (SATableView *)tableView {
    if (!_tableView) {
        SATableView *tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColor.clearColor;
        tableView.needRefreshHeader = true;
        tableView.needRefreshFooter = false;
        _tableView = tableView;
    }
    return _tableView;
}

- (SAMessageDTO *)messageDTO {
    if (!_messageDTO) {
        _messageDTO = [[SAMessageDTO alloc] init];
    }
    return _messageDTO;
}

- (NSMutableArray *)actionDataSource {
    if (!_actionDataSource) {
        _actionDataSource = NSMutableArray.new;
        for (NSInteger i = 0; i < 3; i++) {
            [_actionDataSource addObject:SAMessageCenterCellSkeletonModel.new];
        }
    }
    return _actionDataSource;
}

- (NSMutableArray *)infoDataSource {
    if (!_infoDataSource) {
        _infoDataSource = NSMutableArray.new;
        for (NSInteger i = 0; i < 1; i++) {
            [_infoDataSource addObject:SAMessageCenterCellSkeletonModel.new];
        }
    }
    return _infoDataSource;
}

- (NSMutableArray *)chatDataSource {
    if (!_chatDataSource) {
        _chatDataSource = NSMutableArray.new;
        for (NSInteger i = 0; i < 6; i++) {
            [_chatDataSource addObject:SAMessageCenterCellSkeletonModel.new];
        }
    }
    return _chatDataSource;
}

- (SAOrderNotLoginView *)notSignInView {
    if (!_notSignInView) {
        _notSignInView = SAOrderNotLoginView.new;
        _notSignInView.hidden = SAUser.hasSignedIn;
        _notSignInView.backgroundColor = UIColor.clearColor;
        _notSignInView.clickedSignInSignUpBTNBlock = ^{
            [SAWindowManager switchWindowToLoginViewController];
        };
    }
    return _notSignInView;
}

/** @lazy tipsview */
- (HDAnnouncementView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[HDAnnouncementView alloc] init];
    }
    return _tipsView;
}

/** @lazy tipsConfig */
- (HDAnnouncementViewConfig *)tipsConfig {
    if (!_tipsConfig) {
        _tipsConfig = [[HDAnnouncementViewConfig alloc] init];
        _tipsConfig.textFont = HDAppTheme.font.standard4;
        _tipsConfig.textColor = [UIColor hd_colorWithHexString:@"#2F2F2F"];
        _tipsConfig.trumpetImage = [UIImage imageNamed:@"message_push_alert"];
        _tipsConfig.backgroundColor = [UIColor hd_colorWithHexString:@"#FFE4E4"];
        _tipsConfig.trumpetToTextMargin = 7;
        _tipsConfig.contentInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, 90);
    }
    return _tipsConfig;
}

/** @lazy settignbtn */
- (SAOperationButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_settingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_settingBtn setTitle:SALocalizedString(@"O3N3zScm", @"去开启") forState:UIControlStateNormal];
        _settingBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _settingBtn.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        [_settingBtn applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#CA0000"]];
        [_settingBtn addTarget:self action:@selector(clickOnSetting:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.cornerRadius = 3.0f;
    }
    return _settingBtn;
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

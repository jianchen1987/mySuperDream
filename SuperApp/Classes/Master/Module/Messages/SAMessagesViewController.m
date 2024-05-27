//
//  SAMessagesViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMessagesViewController.h"
#import "NSDate+SAExtension.h"
#import "SAMessageDTO.h"
#import "SAMessageManager.h"
#import "SAMessageSkeletonModel.h"
#import "SAMessageTableViewCell.h"
#import "SAMissingNotificationTipView.h"
#import "SAOrderNotLoginView.h"
#import "SASystemMessageTableViewCell.h"
#import "SATableView.h"
#import "TNIMManagerHander.h"
#import <KSInstantMessagingKit/KSChatVC.h>
#import <KSInstantMessagingKit/KSInstMsgConfig.h>
#import <KSInstantMessagingKit/KSInstMsgConversation.h>
#import <KSInstantMessagingKit/KSInstMsgManager.h>
#import <KSInstantMessagingKit/KSMessageModel.h>
#import <KSInstantMessagingKit/KSRoster.h>


@interface SAMessagesViewController () <UITableViewDelegate, UITableViewDataSource, KSInstMsgChatProtocol, SAMessageManagerDelegate>
/// 头部
@property (nonatomic, strong) SAMissingNotificationTipView *headerView;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 默认数据源
@property (nonatomic, strong) NSMutableArray<SAMessageModel *> *dataSource;
/// 会话
@property (nonatomic, strong) NSMutableArray<SAMessageModel *> *conversations;
/// DTO
@property (nonatomic, strong) SAMessageDTO *messageDTO;

@property (nonatomic, strong) dispatch_group_t taskGroup; ///< 队列组
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;

@property (nonatomic, strong) SAMessageModel *systemNotify; ///< 系统通知

@end


@implementation SAMessagesViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    SAClientType clientType = [parameters objectForKey:@"clientType"];
    self.clientType = HDIsStringNotEmpty(clientType) ? clientType : SAClientTypeMaster;

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"messages", @"消息");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.notSignInView];

    [self applicationBecomeActive];
    self.miniumGetNewDataDuration = 5.0;

    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
#warning 内存泄漏
    [KSInstMsgManager.share addChatListener:self];
    [SAMessageManager.share addListener:self];

    //埋点
    [SATalkingData trackEvent:@"消息列表_进入" label:@"" parameters:@{@"来源": HDIsStringNotEmpty(self.clientType) ? self.clientType : @"WOWNOW"}];
}

- (void)dealloc {
    [KSInstMsgManager.share removeChatListener:self];
    [SAMessageManager.share removeListener:self];
}

- (void)hd_languageDidChanged {
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"pg_label_msg_need_login", @"登录后可查看消息");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }
    self.systemNotify.title = SALocalizedString(@"title_system_notify", @"系统通知");
    [self.tableView successGetNewDataWithNoMoreData:NO];
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

- (void)hd_getNewData {
    [self getNewData];
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
    [self.dataSource removeAllObjects];
    [self.tableView successGetNewDataWithNoMoreData:YES];
}
#pragma mark - Data
- (void)getNewData {
    if (!SAUser.hasSignedIn) {
        [self.tableView successGetNewDataWithNoMoreData:false];
        return;
    }
    @HDWeakify(self);
    dispatch_group_enter(self.taskGroup);
    [self getSystemNotificationsCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [SAMessageManager.share getUnreadMessageCount:^(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *_Nonnull details) {
        @HDStrongify(self);
        self.systemNotify.bubble = details[SAAppInnerMessageTypeMarketing].integerValue + details[SAAppInnerMessageTypePersonal].integerValue;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    //    [self getSystemNotificationUnreadCountCompletion:^{
    //        @HDStrongify(self);
    //        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    //    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        [self reloadData];
    });

    // IM 会话获取比较慢，单独请求不阻塞其他内容
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self reloadData];
    }];
}

- (void)getSystemNotificationsCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.messageDTO getMessageListWithClientType:SAClientTypeMaster type:nil pageSize:1 page:1 success:^(SASystemMessageRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (rspModel.list.count > 0) {
            SASystemMessageModel *model = rspModel.list.firstObject;
            self.systemNotify.content = model.messageContent.desc;
            self.systemNotify.sendDate = model.sendTime.integerValue / 1000.0;
        } else {
            self.systemNotify.content = @"";
            self.systemNotify.sendDate = 0;
        }
        !completion ?: completion();
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !completion ?: completion();
    }];
}

//- (void)getSystemNotificationUnreadCountCompletion:(void (^)(void))completion {
//    @HDWeakify(self);
//    [self.messageDTO getUnreadStationMessageCountWithClientType:self.clientType
//        success:^(NSUInteger station, NSUInteger im) {
//            @HDStrongify(self);
//            self.systemNotify.bubble = station;
//            !completion ?: completion();
//        }
//        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
//            !completion ?: completion();
//        }];
//
//}

- (void)getConversationsCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [KSInstMsgManager.share getAllConversationsWithCompletion:^(NSArray<KSInstMsgConversation *> *_Nonnull conversations) {
        @HDStrongify(self);
        [self.conversations removeAllObjects];
        for (KSInstMsgConversation *conversation in conversations) {
            SAMessageModel *model = SAMessageModel.new;
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
            switch (conversation.lastMessage.contentType) {
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
                default:
                    model.content = SALocalizedString(@"message_placeholder_unknow", @"[未知消息]");
                    break;
            }
            model.bubble = conversation.unreadNumber;
            model.sendDate = conversation.lastMessage.serverTimestamp / 1000.0;
            model.associatedObject = conversation;
            [self.conversations addObject:model];
        }
        !completion ?: completion();
    }];
}

- (void)reloadData {
    NSMutableArray<SAMessageModel *> *tmp = NSMutableArray.new;
    if (self.systemNotify) {
        [tmp addObject:self.systemNotify];
    }
    if (self.conversations.count > 0) {
        [tmp addObjectsFromArray:self.conversations];
    }
    self.dataSource = [tmp mutableCopy];
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SAMessageTableViewCell *cell = [SAMessageTableViewCell cellWithTableView:tableView];
    if ([model isKindOfClass:SAMessageModel.class]) {
        cell.model = model;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SAMessageModel.class]) {
        SAMessageModel *trueModel = model;
        if ([trueModel isEqual:self.systemNotify]) {
            [HDMediator.sharedInstance navigaveToSystemMessageViewController:@{@"clientType": self.clientType}];
        } else if ([trueModel.associatedObject isKindOfClass:KSInstMsgConversation.class]) {
            KSInstMsgConversation *conversation = (KSInstMsgConversation *)trueModel.associatedObject;
            KSChatConfig *config = KSChatConfig.new;
            KSChatVC *vc = [[KSChatVC alloc] initWithRoster:conversation.roster config:config];
            vc.delegate = TNIMManagerHander.sharedInstance;
            [SAWindowManager navigateToViewController:vc];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SALocalizedString(@"cart_delete", @"删除");
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SAMessageModel.class]) {
        SAMessageModel *trueModel = model;
        if (trueModel.associatedObject && [trueModel.associatedObject isKindOfClass:KSInstMsgConversation.class]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id model = self.dataSource[indexPath.row];
        if ([model isKindOfClass:SAMessageModel.class]) {
            SAMessageModel *trueModel = model;
            if (trueModel.associatedObject && [trueModel.associatedObject isKindOfClass:KSInstMsgConversation.class]) {
                KSInstMsgConversation *conversationModel = (KSInstMsgConversation *)trueModel.associatedObject;
                [KSInstMsgManager.share deleteConversactionWithConversactionId:conversationModel.conversationId];
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.conversations removeObjectAtIndex:indexPath.row - 1];

                //                @HDWeakify(self);
                //                [self getSystemNotificationUnreadCountCompletion:^{
                //                    @HDStrongify(self);
                //                    [self reloadData];
                //                }];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:SAMessageSkeletonModel.class]) {
        [cell hd_beginSkeletonAnimation];
    } else {
        [cell hd_endSkeletonAnimation];
    }
}

#pragma mark - KSInstMsgChatProtocol
- (void)receivedMessages:(NSArray<KSMessageModel *> *)messages {
    HDLog(@"收到新的消息啦");
    [self getConversationsCompletion:^{
        [self reloadData];
    }];
}

//- (void)conversationTotalCountChanged:(NSInteger)unreadCount {
//    HDLog(@"未读消息数:%zd", unreadCount);
//    @HDWeakify(self);
//    [self getConversationsCompletion:^{
//        @HDStrongify(self);
//        [self reloadData];
//    }];
//}

- (void)unreadMessageCountChanged:(NSUInteger)count details:(NSDictionary<SAAppInnerMessageType, NSNumber *> *)details {
    self.systemNotify.bubble = details[SAAppInnerMessageTypeMarketing].integerValue + details[SAAppInnerMessageTypePersonal].integerValue;
    [self reloadData];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (SAMessageDTO *)messageDTO {
    return _messageDTO ?: ({ _messageDTO = SAMessageDTO.new; });
}

- (NSMutableArray<SAMessageModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource =
            [[NSMutableArray alloc] initWithArray:@[SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new]];
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

- (NSMutableArray<SAMessageModel *> *)conversations {
    if (!_conversations) {
        _conversations = [[NSMutableArray alloc] initWithArray:@[SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new]];
    }
    return _conversations;
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

/** @lazy taskgroup */
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (SAMessageModel *)systemNotify {
    if (!_systemNotify) {
        _systemNotify = [[SAMessageModel alloc] init];
        _systemNotify.headPlaceholderImage = [UIImage imageNamed:@"system_message_icon"];
        _systemNotify.content = @"";
        _systemNotify.sendDate = 0;
    }
    return _systemNotify;
}

@end

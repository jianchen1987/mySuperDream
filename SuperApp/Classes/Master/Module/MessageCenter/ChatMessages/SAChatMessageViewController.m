//
//  SAChatMessageViewController.m
//  SuperApp
//
//  Created by seeu on 2021/7/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChatMessageViewController.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SAImDelegateManager.h"
#import "SAMessageModel.h"
#import "SAMessageSkeletonModel.h"
#import "SAMessageTableViewCell.h"
#import "SATableView.h"
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>


@interface SAChatMessageViewController () <UITableViewDelegate, UITableViewDataSource, KSInstMsgChatProtocol>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 默认数据源
@property (nonatomic, strong) NSMutableArray<SAMessageModel *> *dataSource;

@end


@implementation SAChatMessageViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    SAClientType clientType = [parameters objectForKey:@"clientType"];
    self.clientType = HDIsStringNotEmpty(clientType) ? clientType : SAClientTypeMaster;

    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];

    self.miniumGetNewDataDuration = 5.0;

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
    [KSInstMsgManager.share addChatListener:self];
}

- (void)dealloc {
    [KSInstMsgManager.share removeChatListener:self];
}

- (void)hd_languageDidChanged {
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.top.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)hd_getNewData {
    [self getNewData];
}

#pragma mark - Notification

- (void)userLoginHandler {
    [self getNewData];
}

- (void)userLogoutHandler {
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
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)getConversationsCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [KSInstMsgManager.share getAllConversationsWithCompletion:^(NSArray<KSInstMsgConversation *> *_Nonnull conversations) {
        @HDStrongify(self);
        [self.dataSource removeAllObjects];
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
            [self.dataSource addObject:model];
        }
        !completion ?: completion();
    }];
}

#pragma mark - UITableViewDataSource
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
            KSInstMsgConversation *conversationModel = (KSInstMsgConversation *)trueModel.associatedObject;

            [KSInstMsgManager.share deleteConversactionWithConversactionId:conversationModel.conversationId];
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            @HDWeakify(self);
            [self getConversationsCompletion:^{
                @HDStrongify(self);
                [self.tableView successGetNewDataWithNoMoreData:YES];
            }];
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
    @HDWeakify(self);
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)conversationTotalCountChanged:(NSInteger)unreadCount {
    HDLog(@"未读消息数:%zd", unreadCount);
    @HDWeakify(self);
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

- (void)loadAllConversationDidFinished {
    HDLog(@"会话加载完啦!");
}

- (void)revokedMessage:(KSMessageModel *)message {
    @HDWeakify(self);
    [self getConversationsCompletion:^{
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES];
    }];
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
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

- (NSMutableArray<SAMessageModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource =
            [[NSMutableArray alloc] initWithArray:@[SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new, SAMessageSkeletonModel.new]];
    }
    return _dataSource;
}

@end

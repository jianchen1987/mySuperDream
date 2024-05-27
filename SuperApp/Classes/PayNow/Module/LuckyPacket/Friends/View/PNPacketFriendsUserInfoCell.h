//
//  PNPacketFriendsUserInfoCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNPacketFriendsUserModel;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kFriendsSectionFlag = @"friends_Section_Flag";
static NSString *const kNearFlag = @"friends_section_near_flag";
static NSString *const kSelectedFlag = @"friends_section_selected_flag";

typedef void (^SelectBlock)(PNPacketFriendsUserModel *model);


@interface PNPacketFriendsUserInfoCell : PNTableViewCell
@property (nonatomic, copy) NSString *friendsSectionFlag;
@property (nonatomic, strong) PNPacketFriendsUserModel *model;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic, assign) BOOL isLastCell;
/// 是否单选
@property (nonatomic, assign) BOOL isSingle;

@end

NS_ASSUME_NONNULL_END

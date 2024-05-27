//
//  PNPacketFriendsUserModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketFriendsUserModel : PNModel
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userNo;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, strong) NSArray<PNPacketFriendsUserModel *> *otherUser;

/// 业务处理属性
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isMe;
@end

NS_ASSUME_NONNULL_END

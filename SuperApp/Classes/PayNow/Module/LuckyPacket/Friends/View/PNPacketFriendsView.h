//
//  PNPacketFriendsView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

@class PNPacketFriendsUserModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickCloseBtnBlock)(void);


@interface PNPacketFriendsView : PNView

@property (nonatomic, copy) void (^completion)(NSArray<PNPacketFriendsUserModel *> *loginNameArray);

@property (nonatomic, copy) ClickCloseBtnBlock closeBlock;

- (instancetype)initWithFrame:(CGRect)frame handOutPacketNum:(NSInteger)handOutPacketNum;
@end

NS_ASSUME_NONNULL_END

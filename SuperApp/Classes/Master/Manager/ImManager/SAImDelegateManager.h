//
//  SAImDelegateManager.h
//  SuperApp
//
//  Created by seeu on 2021/8/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSInstantMessagingKit/KSChatUI.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAImDelegateManager : NSObject <KSChatViewControllerDelegate, KSChatViewOrderDataSource>

+ (instancetype)shared;

- (instancetype)init __attribute__((unavailable("Use +share instead.")));

@end

NS_ASSUME_NONNULL_END

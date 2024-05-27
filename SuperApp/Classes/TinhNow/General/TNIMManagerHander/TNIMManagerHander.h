//
//  TNIMManagerHander.h
//  SuperApp
//
//  Created by xixi on 2021/5/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNIMManagerHander : TNModel <KSChatViewControllerDelegate>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

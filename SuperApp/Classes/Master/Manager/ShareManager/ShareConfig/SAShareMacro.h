//
//  HDShareMarco.h
//  customer
//
//  Created by seeu on 2019/5/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *SAShareChannel NS_STRING_ENUM;

FOUNDATION_EXPORT SAShareChannel const SAShareChannelMessenger;      ///< Messenger
FOUNDATION_EXPORT SAShareChannel const SAShareChannelFacebook;       ///< Facebook
FOUNDATION_EXPORT SAShareChannel const SAShareChannelWechatSession;  ///< 微信好友
FOUNDATION_EXPORT SAShareChannel const SAShareChannelWechatTimeline; ///< 微信朋友圈
FOUNDATION_EXPORT SAShareChannel const SAShareChannelTwitter;        ///< Twitter
FOUNDATION_EXPORT SAShareChannel const SAShareChannelInstagram;      ///< Instagram
FOUNDATION_EXPORT SAShareChannel const SAShareChannelLine;           ///< Line
FOUNDATION_EXPORT SAShareChannel const SAShareChannelTelegram;       ///< Telegram
FOUNDATION_EXPORT SAShareChannel const SAShareChannelMore;           ///< 更多

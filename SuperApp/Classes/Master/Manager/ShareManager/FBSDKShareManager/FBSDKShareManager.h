//
//  FBSDKShareManager.h
//  SuperApp
//
//  Created by Chaos on 2020/12/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShareObject.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface FBSDKShareManager : NSObject

+ (instancetype)sharedManager;

// 分享到Facebook，传入的shareObject的thumbImage或shareImage需要是UIImage类型(外部做好转换在传入)
- (void)sendShareInFacebook:(SAShareObject *)shareObject completion:(void (^__nullable)(BOOL success))completion;

// 分享到Messenger，传入的shareObject的thumbImage或shareImage需要是UIImage类型(外部做好转换在传入)
- (void)sendShareInMessenger:(SAShareObject *)shareObject completion:(void (^__nullable)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END

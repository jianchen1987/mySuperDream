//
//  SAShareManager.h
//  ViPay
//
//  Created by seeu on 2019/5/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAShareImageObject.h"
#import "SAShareMacro.h"
#import "SAShareObject.h"
#import "SAShareWebpageObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAShareManager : NSObject

+ (void)shareObject:(SAShareObject *)shareObject inChannel:(SAShareChannel)channel completion:(void (^__nullable)(BOOL success, NSString *_Nullable shareChannel))completion;

@end

NS_ASSUME_NONNULL_END

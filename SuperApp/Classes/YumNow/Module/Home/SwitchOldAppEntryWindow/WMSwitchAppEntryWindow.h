//
//  WMSwitchAppEntryWindow.h
//  SuperApp
//
//  Created by seeu on 2020/9/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMSwitchAppViewController : UIViewController
@end


@interface WMSwitchAppEntryWindow : UIView

+ (instancetype)sharedInstance;
- (void)expand;
- (void)shrink;
@end

NS_ASSUME_NONNULL_END

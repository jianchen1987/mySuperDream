//
//  WMUIButton.h
//  SuperApp
//
//  Created by wmz on 2022/3/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMUIButton : HDUIButton
///发生了改变
@property (nonatomic, assign, getter=isChange) BOOL change;

@end

NS_ASSUME_NONNULL_END

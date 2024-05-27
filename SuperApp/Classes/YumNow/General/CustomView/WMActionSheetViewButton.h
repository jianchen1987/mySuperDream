//
//  WMActionSheetViewButton.h
//  SuperApp
//
//  Created by wmz on 2022/3/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMActionSheetViewButton : HDActionSheetViewButton

+ (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(HDActionSheetViewButtonType)type handler:(HDActionSheetViewButtonHandler)handler;

@end

NS_ASSUME_NONNULL_END

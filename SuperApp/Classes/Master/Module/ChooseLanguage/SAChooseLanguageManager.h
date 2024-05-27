//
//  SAChooseLanguageManager.h
//  SuperApp
//
//  Created by VanJay on 2020/9/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAChooseLanguageManager : NSObject

/// 内部决定是否显示\隐藏选择语言窗口
+ (void)adjustShouldShowChooseLanguageWindow;
/// 是否正在展示
+ (BOOL)isVisible;
@end

NS_ASSUME_NONNULL_END

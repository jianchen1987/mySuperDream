//
//  SAChooseLanguageViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/9/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAChooseLanguageViewController : SAViewController
/// 动作完成，告知外部
@property (nonatomic, copy) void (^actionCompletionBlock)(void);
@end

NS_ASSUME_NONNULL_END

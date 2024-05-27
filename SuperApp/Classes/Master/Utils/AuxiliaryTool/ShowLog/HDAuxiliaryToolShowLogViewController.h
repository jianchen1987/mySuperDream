//
//  HDAuxiliaryToolShowLogViewController.h
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAuxiliaryToolShowLogViewController : UIViewController
- (void)logStr:(NSString *)str;
- (void)setLogCanScroll:(BOOL)canScroll;
- (void)setLogTextViewAlpha:(CGFloat)alpha;
- (void)clearLog;

@property (nonatomic, strong, readonly) UITextView *textView; ///< 控制器显示
@end

NS_ASSUME_NONNULL_END

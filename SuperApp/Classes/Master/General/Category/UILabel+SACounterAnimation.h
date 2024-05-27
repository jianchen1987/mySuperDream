//
//  UILabel+SACounterAnimation.h
//  SuperApp
//
//  Created by Tia on 2022/5/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import <UIKit/UIKit.h>

typedef void (^SACompletionBlock)(CGFloat endNumber, NSString *_Nonnull symbol);

typedef void (^SACurrentNumberBlock)(CGFloat currentNumber, NSString *_Nonnull symbol);

typedef NSString *_Nonnull (^SAFormatBlock)(CGFloat currentNumber, NSString *_Nonnull symbol);

typedef NSAttributedString *_Nonnull (^SAAttributedFormatBlock)(CGFloat currentNumber, NSString *_Nonnull symbol);

typedef NS_ENUM(NSUInteger, SACounterAnimationOptions) {
    /** 由慢到快,再由快到慢*/
    SACounterAnimationOptionCurveEaseInOut = 1,
    /** 由慢到快*/
    SACounterAnimationOptionCurveEaseIn,
    /** 由快到慢*/
    SACounterAnimationOptionCurveEaseOut,
    /** 匀速*/
    SACounterAnimationOptionCurveLinear
};

NS_ASSUME_NONNULL_BEGIN


@interface UILabel (SACounterAnimation)

@property (nonatomic, assign) SACounterAnimationOptions animationOptions; ///< 动画类型

@property (nonatomic, copy) SACurrencyType cy; ///< 币种

#pragma mark - normal

/**
 正常字体属性UILabel中的数字在指定时间从 numberA -> numberB,

 @param numberA     开始的数字
 @param numberB     结束的数字
 @param duration    持续时间
 @param format      设置字体一般属性的Block
 */

- (void)sa_fromNumberString:(NSString *)numberA toNumberString:(NSString *)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format;

- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format;

/**
 1.正常字体属性UILabel中的数字在指定时间从 numberA -> numberB,
 2.有结束回调

 @param numberA    开始的数字
 @param numberB    结束的数字
 @param duration   持续时间
 @param format     设置一般字体的Block
 @param completion 完成的Block
 */

- (void)sa_fromNumberString:(NSString *)numberA toNumberString:(NSString *)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format completion:(nullable SACompletionBlock)completion;

- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format completion:(nullable SACompletionBlock)completion;

/**
 1.正常字体属性UILabel中的数字在指定时间从 numberA -> numberB,
 2.可设置动画类型,
 3.可设置币种
 4.有结束回调

 @param numberA             开始的数字
 @param numberB             结束的数字
 @param duration            持续时间
 @param cy                          币种
 @param animationOptions    动画类型
 @param format              设置字体一般属性的block
 @param completion          完成的block
 */

- (void)sa_fromNumberString:(NSString *)numberA
             toNumberString:(NSString *)numberB
                   duration:(CFTimeInterval)duration
                         cy:(SACurrencyType)cy
           animationOptions:(SACounterAnimationOptions)animationOptions
                     format:(SAFormatBlock)format
                 completion:(nullable SACompletionBlock)completion;

- (void)sa_fromNumber:(CGFloat)numberA
             toNumber:(CGFloat)numberB
             duration:(CFTimeInterval)duration
                   cy:(SACurrencyType)cy
     animationOptions:(SACounterAnimationOptions)animationOptions
               format:(SAFormatBlock)format
           completion:(nullable SACompletionBlock)completion;

#pragma mark - attributed

/**
 富文本字体属性UILabel中的数字在指定时间从 numberA -> numberB,

 @param numberA               开始的数字
 @param numberB               结束的数字
 @param duration              持续时间
 @param attributedFormat 设置富文本字体属性的Block
 */
- (void)sa_fromNumberString:(NSString *)numberA toNumberString:(NSString *)numberB duration:(CFTimeInterval)duration attributedFormat:(SAAttributedFormatBlock)attributedFormat;

- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration attributedFormat:(SAAttributedFormatBlock)attributedFormat;

/**
 1.富文本字体属性UILabel中的数字在指定时间从 numberA -> numberB,
 2.有结束回调

 @param numberA          开始的数字
 @param numberB          结束的数字
 @param duration         持续时间
 @param attributedFormat 设置富文本字体属性的Block
 @param completion       完成的Block
 */

- (void)sa_fromNumberString:(NSString *)numberA
             toNumberString:(NSString *)numberB
                   duration:(CFTimeInterval)duration
           attributedFormat:(SAAttributedFormatBlock)attributedFormat
                 completion:(nullable SACompletionBlock)completion;

- (void)sa_fromNumber:(CGFloat)numberA
             toNumber:(CGFloat)numberB
             duration:(CFTimeInterval)duration
     attributedFormat:(SAAttributedFormatBlock)attributedFormat
           completion:(nullable SACompletionBlock)completion;

/**
 1.富文本字体属性UILabel中的数字在指定时间从 numberA -> numberB,
 2.可设置动画类型,
 3.可设置币种
 4.有结束回调

 @param numberA            开始的数字
 @param numberB            结束的数字
 @param duration           持续时间
 @param cy                          币种
 @param animationOptions   动画类型
 @param attributedFormat   设置富文本字体属性的Block
 @param completion         完成的Block
 */

- (void)sa_fromNumberString:(NSString *)numberA
             toNumberString:(NSString *)numberB
                   duration:(CFTimeInterval)duration
                         cy:(SACurrencyType)cy
           animationOptions:(SACounterAnimationOptions)animationOptions
           attributedFormat:(SAAttributedFormatBlock)attributedFormat
                 completion:(nullable SACompletionBlock)completion;

- (void)sa_fromNumber:(CGFloat)numberA
             toNumber:(CGFloat)numberB
             duration:(CFTimeInterval)duration
                   cy:(SACurrencyType)cy
     animationOptions:(SACounterAnimationOptions)animationOptions
     attributedFormat:(SAAttributedFormatBlock)attributedFormat
           completion:(nullable SACompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END

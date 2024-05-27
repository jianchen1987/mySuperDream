//
//  UILabel+SACounterAnimation.m
//  SuperApp
//
//  Created by Tia on 2022/5/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyTools.h"
#import "UILabel+SACounterAnimation.h"
#import <objc/runtime.h>

/** 函数指针*/
typedef CGFloat (*SACurrentBufferFunction)(CGFloat);


@interface SACounterEngine : NSObject
/** 定时器*/
@property (nonatomic, strong) CADisplayLink *timer;
/** 开始的数字*/
@property (nonatomic, assign) CGFloat starNumber;
/** 结束的数字*/
@property (nonatomic, assign) CGFloat endNumber;
/** 动画的总持续时间*/
@property (nonatomic, assign) CFTimeInterval durationTime;
/** 记录上一帧动画的时间*/
@property (nonatomic, assign) CFTimeInterval lastTime;
/** 记录动画已持续的时间*/
@property (nonatomic, assign) CFTimeInterval progressTime;
/** 获取当前数字的Block*/
@property (nonatomic, copy) SACurrentNumberBlock currentNumber;
/** 计数完成的Block*/
@property (nonatomic, copy) SACompletionBlock completion;
/** 动画函数*/
@property SACurrentBufferFunction currentBufferFunction;
/// 当前币种符号
@property (nonatomic, copy) NSString *currencySymbol;

/**
 类方法创建一个计数器的实例
 */
+ (instancetype)counterEngine;
/**
 在指定时间内数字从 numberA -> numberB

 @param starNumer           开始的数字
 @param endNumber           结束的数字
 @param duration            指定的时间
 @param cy                          币种
 @param animationOptions    动画类型
 @param currentNumber       当前数字的回调
 @param completion          已完成的回调
 */
- (void)fromNumber:(CGFloat)starNumer
            toNumber:(CGFloat)endNumber
            duration:(CFTimeInterval)duration
                  cy:(SACurrencyType)cy
    animationOptions:(SACounterAnimationOptions)animationOptions
       currentNumber:(SACurrentNumberBlock)currentNumber
          completion:(SACompletionBlock)completion;

@end


@implementation SACounterEngine

- (instancetype)init {
    if (self = [super init]) {
        _currentBufferFunction = SABufferFunctionEaseInOut;
    }
    return self;
}

+ (instancetype)counterEngine {
    return [[self alloc] init];
}

- (void)fromNumber:(CGFloat)starNumer
            toNumber:(CGFloat)endNumber
            duration:(CFTimeInterval)durationTime
                  cy:(SACurrencyType)cy
    animationOptions:(SACounterAnimationOptions)animationOptions
       currentNumber:(SACurrentNumberBlock)currentNumber
          completion:(SACompletionBlock)completion {
    // 开始前清空定时器
    [self cleanTimer];

    //获取货币符号
    //    _currencySymbol = [self getCurrencySymbolByCode:cy];
    _currencySymbol = [SAMoneyTools getCurrencySymbolByCode:cy];

    // 如果开始数字与结束数字相等
    if (starNumer == endNumber) {
        currentNumber ? currentNumber(endNumber, _currencySymbol) : nil;
        completion ? completion(endNumber, _currencySymbol) : nil;
        return;
    }

    // 初始化相关变量
    _starNumber = starNumer;
    _endNumber = endNumber;
    _durationTime = durationTime;

    // 设置缓冲动画类型
    [self setAnimationOptions:animationOptions];

    // 设置block回调函数
    currentNumber ? _currentNumber = currentNumber : nil;
    completion ? _completion = completion : nil;

    // 记录定时器运行前的时间
    _lastTime = CACurrentMediaTime();

    // 实例化定时器
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeNumber)];
    _timer.preferredFramesPerSecond = 30; //每秒30FPS
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)changeNumber {
    // 1.记录当前动画开始的时间
    CFTimeInterval thisTime = CACurrentMediaTime();
    // 2.计算动画已持续的时间量
    _progressTime = _progressTime + (thisTime - _lastTime);
    // 3.准备下一次的计算
    _lastTime = thisTime;
    if (_progressTime >= _durationTime) {
        [self cleanTimer];
        _currentNumber ? _currentNumber(_endNumber, _currencySymbol) : nil;
        _completion ? _completion(_endNumber, @"a") : nil;
        return;
    }
    _currentNumber ? _currentNumber([self computeNumber], _currencySymbol) : nil;
}

- (void)setAnimationOptions:(SACounterAnimationOptions)animationOptions {
    switch (animationOptions) {
        case SACounterAnimationOptionCurveEaseInOut:
            _currentBufferFunction = SABufferFunctionEaseInOut;
            break;
        case SACounterAnimationOptionCurveEaseIn:
            _currentBufferFunction = SABufferFunctionEaseIn;
            break;
        case SACounterAnimationOptionCurveEaseOut:
            _currentBufferFunction = SABufferFunctionEaseOut;
            break;
        case SACounterAnimationOptionCurveLinear:
            _currentBufferFunction = SABufferFunctionLinear;
            break;
        default:
            break;
    }
}

/**
 计算数字
 */
- (CGFloat)computeNumber {
    CGFloat percent = _progressTime / _durationTime;
    return _starNumber + (_currentBufferFunction(percent) * (_endNumber - _starNumber));
}

/**
 清除定时器
 */
- (void)cleanTimer {
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
    _progressTime = 0;
}

#pragma mark - 缓冲动画函数

CGFloat SABufferFunctionEaseOut(CGFloat p) {
    return (p == 1.0) ? p : 1 - pow(2, -10 * p);
}

CGFloat SABufferFunctionEaseIn(CGFloat p) {
    return (p == 0.0) ? p : pow(2, 10 * (p - 1));
}

CGFloat SABufferFunctionEaseInOut(CGFloat p) {
    if (p == 0.0 || p == 1.0)
        return p;

    if (p < 0.5) {
        return 0.5 * pow(2, (20 * p) - 10);
    } else {
        return -0.5 * pow(2, (-20 * p) + 10) + 1;
    }
}

CGFloat SABufferFunctionLinear(CGFloat p) {
    return p;
}

@end


@implementation UILabel (SACounterAnimation)

#pragma mark - normal font
- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format {
    [self sa_fromNumber:numberA toNumber:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut format:format completion:nil];
}

- (void)sa_fromNumberString:(NSString *)numberA toNumberString:(NSString *)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format {
    [self sa_fromNumberString:numberA toNumberString:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut format:format completion:nil];
}

- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format completion:(SACompletionBlock)completion {
    [self sa_fromNumber:numberA toNumber:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut format:format completion:completion];
}

- (void)sa_fromNumberString:(NSString *)numberA toNumberString:(NSString *)numberB duration:(CFTimeInterval)duration format:(SAFormatBlock)format completion:(SACompletionBlock)completion {
    [self sa_fromNumberString:numberA toNumberString:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut format:format completion:completion];
}

- (void)sa_fromNumberString:(NSString *)numberA
             toNumberString:(NSString *)numberB
                   duration:(CFTimeInterval)duration
                         cy:(SACurrencyType)cy
           animationOptions:(SACounterAnimationOptions)animationOptions
                     format:(SAFormatBlock)format
                 completion:(SACompletionBlock)completion {
    CGFloat a = numberA.doubleValue;
    CGFloat b = numberB.doubleValue;
    [self sa_fromNumber:a toNumber:b duration:duration cy:cy animationOptions:animationOptions format:format completion:completion];
}

- (void)sa_fromNumber:(CGFloat)numberA
             toNumber:(CGFloat)numberB
             duration:(CFTimeInterval)duration
                   cy:(SACurrencyType)cy
     animationOptions:(SACounterAnimationOptions)animationOptions
               format:(SAFormatBlock)format
           completion:(SACompletionBlock)completion {
    if (self.animationOptions)
        animationOptions = self.animationOptions;
    if (self.cy)
        cy = self.cy;

    [[SACounterEngine counterEngine] fromNumber:numberA toNumber:numberB duration:duration cy:cy animationOptions:animationOptions currentNumber:^(CGFloat currentNumber, NSString *symbol) {
        format ? self.text = format(currentNumber, symbol) : nil;
    } completion:completion];
}

#pragma mark - attributed font
- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration attributedFormat:(SAAttributedFormatBlock)attributedFormat {
    [self sa_fromNumber:numberA toNumber:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut attributedFormat:attributedFormat completion:nil];
}

- (void)sa_fromNumberString:(NSString *)numberA toNumberString:(NSString *)numberB duration:(CFTimeInterval)duration attributedFormat:(SAAttributedFormatBlock)attributedFormat {
    [self sa_fromNumberString:numberA toNumberString:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut attributedFormat:attributedFormat
                   completion:nil];
}

- (void)sa_fromNumber:(CGFloat)numberA toNumber:(CGFloat)numberB duration:(CFTimeInterval)duration attributedFormat:(SAAttributedFormatBlock)attributedFormat completion:(SACompletionBlock)completion {
    [self sa_fromNumber:numberA toNumber:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut attributedFormat:attributedFormat
              completion:completion];
}

- (void)sa_fromNumberString:(NSString *)numberA
             toNumberString:(NSString *)numberB
                   duration:(CFTimeInterval)duration
           attributedFormat:(SAAttributedFormatBlock)attributedFormat
                 completion:(SACompletionBlock)completion {
    [self sa_fromNumberString:numberA toNumberString:numberB duration:duration cy:SACurrencyTypeUSD animationOptions:SACounterAnimationOptionCurveEaseInOut attributedFormat:attributedFormat
                   completion:completion];
}

- (void)sa_fromNumberString:(NSString *)numberA
             toNumberString:(NSString *)numberB
                   duration:(CFTimeInterval)duration
                         cy:(SACurrencyType)cy
           animationOptions:(SACounterAnimationOptions)animationOptions
           attributedFormat:(SAAttributedFormatBlock)attributedFormat
                 completion:(SACompletionBlock)completion {
    CGFloat a = numberA.doubleValue;
    CGFloat b = numberB.doubleValue;
    [self sa_fromNumber:a toNumber:b duration:duration cy:cy animationOptions:animationOptions attributedFormat:attributedFormat completion:completion];
}

- (void)sa_fromNumber:(CGFloat)numberA
             toNumber:(CGFloat)numberB
             duration:(CFTimeInterval)duration
                   cy:(SACurrencyType)cy
     animationOptions:(SACounterAnimationOptions)animationOptions
     attributedFormat:(SAAttributedFormatBlock)attributedFormat
           completion:(SACompletionBlock)completion {
    if (self.animationOptions)
        animationOptions = self.animationOptions;
    if (self.cy)
        cy = self.cy;
    [[SACounterEngine counterEngine] fromNumber:numberA toNumber:numberB duration:duration cy:cy animationOptions:animationOptions currentNumber:^(CGFloat currentNumber, NSString *symbol) {
        attributedFormat ? self.attributedText = attributedFormat(currentNumber, symbol) : nil;
    } completion:completion];
}

#pragma mark - setter/getter

- (void)setAnimationOptions:(SACounterAnimationOptions)animationOptions {
    objc_setAssociatedObject(self, @selector(animationOptions), @(animationOptions), OBJC_ASSOCIATION_ASSIGN);
}

- (SACounterAnimationOptions)animationOptions {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setCy:(SACurrencyType)cy {
    objc_setAssociatedObject(self, @selector(cy), cy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SACurrencyType)cy {
    return objc_getAssociatedObject(self, _cmd);
}

@end

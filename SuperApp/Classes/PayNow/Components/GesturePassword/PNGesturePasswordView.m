//
//  PNGesturePasswordView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGesturePasswordView.h"
#import "PNGesturePasswordConfig.h"
#import "PNPointButtonView.h"

typedef NS_ENUM(NSInteger, PNGesturePasswordButtonState) {
    PNGesturePasswordButtonStateNormal = 0,
    PNGesturePasswordButtonStateSelected,
    PNGesturePasswordButtonStateIncorrect,
};


@interface PNGesturePasswordView ()
/// 结果回调
@property (nonatomic, copy) SuccessBlock callBack;
/// 存储已经选择的按钮
@property (nonatomic, strong) NSMutableArray *selectItemArray;
/// 当前处于哪个按钮范围内
@property (nonatomic, assign) CGPoint currentPoint;
/// 当前控件器所处状态(设置、重新设置、登录)
@property (nonatomic, assign) PNGesturePasswordViewType viewType;
/// 输入的次数
@property (nonatomic, assign) NSInteger inputNum;
/// 重置密码时验证旧密码 输入的次数
@property (nonatomic, assign) NSInteger resetInputNum;
/// 表示设置密码时 第一次输入的手势密码
@property (nonatomic, strong) NSString *firstPassword;
@end


@implementation PNGesturePasswordView

- (instancetype)initWithFrame:(CGRect)frame viewType:(PNGesturePasswordViewType)viewType {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = viewType;
        self.selectItemArray = [[NSMutableArray alloc] init];
        [self setPropertiesByState:PNGesturePasswordButtonStateNormal];


        NSInteger size = [PNGesturePasswordConfig sharedInstance].circleRadius * 2;

        /// 列数
        NSInteger column = 3;
        /// 间距
        NSInteger margin = (self.bounds.size.width - column * size) / (column + 1);
        float ins = 50;
        for (int i = 0; i < 9; i++) {
            NSInteger row = i / column;
            NSInteger col = i % column;
            PNPointButtonView *gesturePasswordButton = [[PNPointButtonView alloc] initWithFrame:CGRectMake(ins + col * size + col * margin, row * size + row * margin, size, size)];
            [gesturePasswordButton setTag:i + 1];
            [self addSubview:gesturePasswordButton];
        }
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if ([self.selectItemArray count] == 0) {
        return;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:[PNGesturePasswordConfig sharedInstance].lineWidth];
    [self.lineColor set];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    for (NSInteger i = 0; i < self.selectItemArray.count; i++) {
        PNPointButtonView *btn = self.selectItemArray[i];
        if (i == 0) {
            [path moveToPoint:[btn center]];
        } else {
            [path addLineToPoint:[btn center]];
        }
        [btn setNeedsDisplay];
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

#pragma mark touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = point;
    for (PNPointButtonView *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            [btn setSelected:YES];
            if (![self.selectItemArray containsObject:btn]) {
                [self.selectItemArray addObject:btn];
                [self setPropertiesByState:PNGesturePasswordButtonStateSelected];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = point;
    for (PNPointButtonView *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            [btn setSelected:YES];
            if (![self.selectItemArray containsObject:btn]) {
                [self.selectItemArray addObject:btn];
                [self setPropertiesByState:PNGesturePasswordButtonStateSelected];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (self.selectItemArray.count < 5) {
        self.callBack(PNGesturePasswordResult_LessThan, [self getInpuPassword]);
        [self setPropertiesByState:PNGesturePasswordButtonStateNormal];
    } else if (self.viewType == PNGesturePasswordViewTypeSet) {
        [self handle_setPassword];
    } else if (self.viewType == PNGesturePasswordViewTypeReset) {
        [self handle_resetPassword];
    } else if (self.viewType == PNGesturePasswordViewTypeLogin) {
        [self handle_login];
    }

    PNPointButtonView *btn = [self.selectItemArray lastObject];
    [self setCurrentPoint:btn.center];
    [self setNeedsDisplay];
}

#pragma mark Logic
/// 校验密码
- (void)handle_login {
    NSString *password = [self getPassword];
    NSString *inputPassword = [self getInpuPassword];
    if ([inputPassword isEqualToString:password]) {
        self.callBack(PNGesturePasswordResult_TwoSameTime, password);
        [self setPropertiesByState:PNGesturePasswordButtonStateNormal];
    } else {
        self.callBack(PNGesturePasswordResult_TwoDifferentTimes, password);
        [self setPropertiesByState:PNGesturePasswordButtonStateIncorrect];
    }
}

/// 设置密码
- (void)handle_setPassword {
    if (self.inputNum == 0) {
        self.firstPassword = [self getInpuPassword];
        self.callBack(PNGesturePasswordResult_SetFirst, self.firstPassword);
        self.inputNum += 1;
        [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:PNGesturePasswordButtonStateNormal]] afterDelay:0.3f];
    } else {
        NSString *secondPassword = [self getInpuPassword];

        if ([self.firstPassword isEqualToString:secondPassword]) {
            [self savePassWord:secondPassword];
            self.callBack(PNGesturePasswordResult_SetFirstSuccess, secondPassword);
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:PNGesturePasswordButtonStateNormal]] afterDelay:0.3f];
        } else {
            self.callBack(PNGesturePasswordResult_SetFirstFail, secondPassword);
            [self setPropertiesByState:PNGesturePasswordButtonStateIncorrect];
            self.inputNum -= 1;
        }
    }
}

/// 重置密码
- (void)handle_resetPassword {
    NSString *password = [self getPassword];
    NSString *inputPassword = [self getInpuPassword];
    if (self.resetInputNum == 0) {
        if ([inputPassword isEqualToString:password]) {
            self.callBack(PNGesturePasswordResult_PassVerificationOldPassword, password);
            self.resetInputNum += 1;
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:PNGesturePasswordButtonStateNormal]] afterDelay:0.3f];
        } else {
            self.callBack(PNGesturePasswordResult_FailVerificationOldPassword, password);
            [self setPropertiesByState:PNGesturePasswordButtonStateIncorrect];
        }
    } else if (self.resetInputNum == 1) {
        [self handle_setPassword];
    }
}

/// 设置按钮的样式
- (void)setPropertiesByState:(PNGesturePasswordButtonState)buttonState {
    PNGesturePasswordConfig *config = [PNGesturePasswordConfig sharedInstance];
    switch (buttonState) {
        case PNGesturePasswordButtonStateNormal:
            [self setUserInteractionEnabled:YES];
            [self resetButtons];
            self.lineColor = config.lineColorNormal;
            self.fillColor = config.fillColorNormal;
            self.strokeColor = config.strokeColorNormal;
            self.centerPointColor = config.centerPointColorNormal;
            break;
        case PNGesturePasswordButtonStateSelected:
            self.lineColor = config.lineColorSelected;
            self.fillColor = config.fillColorSelected;
            self.strokeColor = config.strokeColorSelected;
            self.centerPointColor = config.centerPointColorSelected;
            break;
        case PNGesturePasswordButtonStateIncorrect:
            [self setUserInteractionEnabled:NO];
            self.lineColor = config.lineColorIncorrect;
            self.fillColor = config.fillColorIncorrect;
            self.strokeColor = config.strokeColorIncorrect;
            self.centerPointColor = config.centerPointColorIncorrect;
            [self performSelector:@selector(lockState:) withObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:PNGesturePasswordButtonStateNormal]] afterDelay:0.5f];
            break;
        default:
            break;
    }
}

- (void)lockState:(NSArray *)states {
    NSNumber *stateNumber = [states objectAtIndex:0];
    [self setPropertiesByState:[stateNumber integerValue]];
}

- (void)resetButtons {
    for (NSInteger i = 0; i < [self.selectItemArray count]; i++) {
        PNPointButtonView *button = self.selectItemArray[i];
        [button setSelected:NO];
    }

    [self.selectItemArray removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark PasswordProcessing
- (void)savePassWord:(NSString *)password {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:password forKey:@"123"];
    [userdefault synchronize];
}

- (NSString *)getPassword {
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"123"];
    HDLog(@"原密码是：%@", pwd);
    return pwd;
}

- (NSString *)getInpuPassword {
    NSString *inputPassword = @"";
    for (PNPointButtonView *btn in self.selectItemArray) {
        inputPassword = [inputPassword stringByAppendingFormat:@"%@", @(btn.tag)];
    }
    return inputPassword;
}

#pragma mark
- (void)resultCallback:(SuccessBlock)block {
    self.callBack = block;
}
@end

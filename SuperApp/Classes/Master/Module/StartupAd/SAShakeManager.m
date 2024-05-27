//
//  SAShareManager.m
//  SuperApp
//
//  Created by Tia on 2023/7/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAShakeManager.h"
#import <CoreMotion/CMMotionManager.h>
#import <HDKitCore/HDKitCore.h>


@interface SAShakeManager ()

@property (nonatomic, strong) CMMotionManager *motionManager;
// 记录上次发生摇一摇时间，防止频繁响应
@property (nonatomic, strong) NSDate *lastShakeDate;

@end


@implementation SAShakeManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // 为了防止频繁响应摇一摇，间隔一段时间再进行响应摇一摇
        self.lastShakeDate = [NSDate distantPast];
    }
    return self;
}

+ (instancetype)shaked {
    static SAShakeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SAShakeManager alloc] init];
    });
    return instance;
}

- (void)initMotionManager {
    if (!self.motionManager) {
        self.motionManager = [[CMMotionManager alloc] init];
        if (self.motionManager.accelerometerAvailable) {
            self.motionManager.accelerometerUpdateInterval = 0.1;
        }
    }
}

- (BOOL)startMonitorShake {
    [self initMotionManager];
    if (self.motionManager && self.motionManager.accelerometerAvailable) {
        HDLog(@"开始摇一摇监听");
        // 正在监听中
        if (!self.motionManager.isAccelerometerActive) {
            [self.motionManager startAccelerometerUpdates];
            [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *_Nullable accelerometerData, NSError *_Nullable error) {
                if (accelerometerData) {
                    CMAcceleration acceleration = accelerometerData.acceleration;
                    // 综合x、y两个方向的加速度，当综合加速度大于2.5时，就响应摇一摇
                    double accelerameter = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2));
                    if (accelerameter > 2.5) {
                        // 响应间隔时间设定为：1秒
                        NSDate *curDate = [NSDate date];
                        if ([curDate timeIntervalSinceDate:self.lastShakeDate] < 1) {
                            self.lastShakeDate = curDate;
                            return;
                        }
                        self.lastShakeDate = curDate;
                        [[NSNotificationCenter defaultCenter] postNotificationName:SHAKE_NOTIFY object:nil];
                    }
                }
            }];
        }
        return YES;
    }
    return NO;
}

- (void)stopMonitorShake {
    if (self.motionManager) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager = nil;
        HDLog(@"关闭摇一摇监听");
    }
}

@end

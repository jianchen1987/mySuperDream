//
//  SAMessageButton.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMessageButton.h"
#import "SACacheManager.h"
#import "SAMessageManager.h"
#import "SANotificationConst.h"
#import "SAUser.h"
#import <HDKitCore/HDCommonDefines.h>


@interface SAMessageButton () <SAMessageManagerDelegate>
@property (nonatomic, strong) CALayer *dotLayer;

- (NSString *)cacheKey;
@end


@implementation SAMessageButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType clientType:(SAClientType)clientType {
    SAMessageButton *button = [super buttonWithType:buttonType];
    button.clientType = clientType;
    [button initializeDotLayer];
    return button;
}

#pragma mark - life cycle
- (void)initializeDotLayer {
    self.dotPosition = CGPointMake(3, 3);
    [self.layer addSublayer:self.dotLayer];

    [SAMessageManager.share addListener:self];

    @HDWeakify(self);
    [SAMessageManager.share getUnreadMessageCount:^(NSUInteger count, NSDictionary<SAAppInnerMessageType, NSNumber *> *_Nonnull details) {
        @HDStrongify(self);
        self.dotLayer.hidden = !SAUser.hasSignedIn || count <= 0;
    }];

    // 监听未读消息数量通知
    //    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getUserUnreadStationLetterSuccess:) name:kNotificationNameUnreadMsgCountChanged object:nil];
}

- (void)dealloc {
    //    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUnreadMsgCountChanged object:nil];
    [SAMessageManager.share removeListener:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.dotLayer.bounds = CGRectMake(0, 0, 8, 8);
    self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.imageView.frame) - self.dotPosition.x, CGRectGetMinY(self.imageView.frame) + self.dotPosition.y);
    self.dotLayer.cornerRadius = CGRectGetHeight(self.dotLayer.bounds) * 0.5;
    self.dotLayer.borderColor = UIColor.whiteColor.CGColor;
    self.dotLayer.borderWidth = PixelOne;

    [CATransaction commit];
}

#pragma mark - Notification
//- (void)getUserUnreadStationLetterSuccess:(NSNotification *)notification {
//    // 取出数量
//    NSNumber *count = notification.userInfo[@"count"];
//    // 客户端类型
//    SAClientType clientType = notification.userInfo[@"clientType"];
//
//    if ([clientType isEqualToString:self.clientType]) {
//        [self showMessageCount:count.integerValue];
//    }
//}

#pragma mark - SAMessageManagerDelegate
- (void)unreadMessageCountChanged:(NSUInteger)count details:(NSDictionary<SAAppInnerMessageType, NSNumber *> *)details {
    [self showMessageCount:count];
}

#pragma mark - public methods
- (void)showMessageCount:(NSUInteger)count {
    self.dotLayer.hidden = count <= 0;

    if (count > 0) {
        [SACacheManager.shared setObject:@(count) forKey:self.cacheKey];
    } else {
        [SACacheManager.shared removeObjectForKey:self.cacheKey];
    }
}

- (void)clearMessageCount {
    self.dotLayer.hidden = true;
    [SACacheManager.shared removeObjectForKey:self.cacheKey];
}

- (void)setDotColor:(UIColor *)dotColor {
    if (dotColor) {
        self.dotLayer.backgroundColor = dotColor.CGColor;
    }
}

#pragma mark - private methods
- (NSString *)cacheKey {
    return [NSString stringWithFormat:@"kCurrentUserStationLetterCountKey_%@", self.clientType];
}

#pragma mark - lazy load
- (CALayer *)dotLayer {
    if (!_dotLayer) {
        _dotLayer = CALayer.new;
        _dotLayer.backgroundColor = HDAppTheme.color.C2.CGColor;
        _dotLayer.hidden = YES;
    }
    return _dotLayer;
}

- (void)setDotBackgroundColor:(UIColor *)dotBackgroundColor {
    _dotBackgroundColor = dotBackgroundColor;
    self.dotLayer.backgroundColor = dotBackgroundColor.CGColor;
}

@end

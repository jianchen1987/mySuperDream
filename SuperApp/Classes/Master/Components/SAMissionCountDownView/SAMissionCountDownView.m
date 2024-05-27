//
//  SAMissionCountDownView.m
//  SuperApp
//
//  Created by seeu on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMissionCountDownView.h"
#import "SAApolloManager.h"


@interface SAMissionCountDownView ()
/// 按钮
@property (nonatomic, strong) UIImageView *floatView;

///< 倒计时文本
@property (nonatomic, strong) UILabel *countDownLabel;
///< 完成按钮
@property (nonatomic, strong) UIImageView *completeBtnView;
///< 完成按钮文字
@property (nonatomic, strong) UILabel *completeBtnLabel;
/// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
/// 是否正在展示
@property (atomic, assign) BOOL isShowing;

///< 类型
@property (nonatomic, copy) NSString *browseType;
///< 任务id
@property (nonatomic, copy) NSString *taskNo;
///< 倒计时秒数
@property (nonatomic, assign) NSInteger seconds;
///< 浏览秒数
@property (nonatomic, assign) NSInteger browseSeconds;
///< 定时器
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation SAMissionCountDownView

- (instancetype)initWithSeconds:(NSInteger)seconds browseType:(NSString *)browseType taskNo:(NSString *)taskNo {
    CGRect frame = (CGRect){kScreenWidth - kRealWidth(58) - kRealWidth(8), kNavigationBarH + kRealWidth(8), CGSizeMake(kRealWidth(58), kRealWidth(58))};
    self = [super initWithFrame:frame];
    if (self) {
        self.seconds = seconds;
        self.browseType = browseType;
        self.taskNo = taskNo;
        self.browseSeconds = 0;
    }

    return self;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

    HDLog(@"倒计时销毁");
}

- (void)hd_setupViews {
    [self hd_removeAllSubviews];

    self.backgroundColor = [UIColor clearColor];

    self.floatView = [[UIImageView alloc] initWithFrame:CGRectMake(kRealWidth(58) - kRealWidth(52), 0, kRealWidth(52), kRealWidth(58))];
    self.floatView.image = [UIImage imageNamed:@"mission_countDown_bg"];
    [self addSubview:self.floatView];
    self.floatView.userInteractionEnabled = YES;

    self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kRealWidth(22), kRealWidth(44), kRealWidth(21))];
    self.countDownLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.countDownLabel.textColor = [UIColor hd_colorWithHexString:@"#EE6006"];
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    [self.floatView addSubview:self.countDownLabel];


    self.completeBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(kRealWidth(58) - kRealWidth(59), kRealWidth(58) - kRealWidth(22) + kRealWidth(7), kRealWidth(59), kRealWidth(22))];
    self.completeBtnView.image = [UIImage imageNamed:@"misson_btn_bg"];
    self.completeBtnView.userInteractionEnabled = YES;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnClose:)];
    [self.completeBtnView addGestureRecognizer:closeTap];
    self.completeBtnView.hidden = YES;
    [self addSubview:self.completeBtnView];

    self.completeBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kRealWidth(59), kRealWidth(22))];
    self.completeBtnLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    self.completeBtnLabel.textColor = [UIColor hd_colorWithHexString:@"#EE6006"];
    self.completeBtnLabel.textAlignment = NSTextAlignmentCenter;
    self.completeBtnLabel.text = SALocalizedStringFromTable(@"btn_complete", @"任务完成", @"Buttons");
    [self.completeBtnView addSubview:self.completeBtnLabel];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer = panGestureRecognizer;
    [self addGestureRecognizer:panGestureRecognizer];

    self.isShowing = YES; //默认进来是显示的
}

- (void)countDownChanged:(NSTimer *)timer {
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
        HDLog(@"当前app不活跃，跳过");
        return;
    }

    if (self.seconds - self.browseSeconds >= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countDownLabel.text = [NSString stringWithFormat:@"%zds", self.seconds - self.browseSeconds > 0 ? self.seconds - self.browseSeconds : 0];
            self.browseSeconds++;
        });

    } else {
        [self.timer invalidate];
        [self.completeBtnView setHidden:NO];
        [self missionCompletion];
        HDLog(@"时间到，关闭定时器");
    }
}

- (void)missionCompletion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 3;
    request.requestURI = @"/app/channel/task/deliveryBrowse";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    params[@"browseType"] = self.browseType;
    params[@"browseTime"] = @(self.seconds);
    params[@"taskNo"] = self.taskNo;
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"请求成功");
    } failure:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"请求失败");
    }];
}

- (void)start {
    if (self.seconds - self.browseSeconds <= 0) {
        return;
    }

    // 开始倒计时
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

    self.timer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownChanged:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}
- (void)pause {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)clickedOnClose:(UITapGestureRecognizer *)tap {
    //    [self removeFromSuperview];
    //    [LKDataRecord.shared traceClickEvent:@"click_floatWindowPlugin_close" parameters:nil SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@""]];

    NSString *urlStr = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyMissionCompleteJumpLink];
    HDLog(@"跳转地址:%@", urlStr);
    if (HDIsStringNotEmpty(urlStr)) {
        [SAWindowManager openUrl:urlStr withParameters:nil];
    } else {
        // TODO: 上线记得改掉
#ifdef DEBUG
        [SAWindowManager openUrl:@"https://h5-uat.lifekh.com/mobile-h5/vip/task-center" withParameters:nil];
#else
        [SAWindowManager openUrl:@"https://h5.lifekh.com/mobile-h5/vip/task-center" withParameters:nil];
#endif
    }

    [self removeFromSuperview];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    // 获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    // 清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    // 重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.center.x + offsetPoint.x;
    CGFloat newY = panView.center.y + offsetPoint.y;

    const CGFloat margin = kRealWidth(10);
    if (newX < kRealWidth(58) / 2 + margin) {
        newX = kRealWidth(58) / 2 + margin;
    }
    if (newX > kScreenWidth - kRealWidth(58) / 2) {
        newX = kScreenWidth - kRealWidth(58) / 2;
    }
    if (newY < kRealWidth(58) / 2 + kStatusBarH + margin) {
        newY = kRealWidth(58) / 2 + kStatusBarH + margin;
    }
    if (newY > kScreenHeight - kRealWidth(58) / 2 - kTabBarH) {
        newY = kScreenHeight - kRealWidth(58) / 2 - kTabBarH;
    }
    panView.center = CGPointMake(newX, newY);

    if (sender.state == UIGestureRecognizerStateEnded) {
        [self expand];
    }
}

#pragma mark - Data


#pragma mark - public methods
// 显示
- (void)expand {
    if (self.isShowing) {
        return;
    }
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - kRealWidth(58) - 10;
        } else {
            frame.origin.x = 10;
        }
        self.frame = frame;
        self.floatView.frame = self.bounds;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = YES;
    }];
}
// 隐藏
- (void)shrink {
    if (!self.isShowing) {
        return;
    }
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - 0.5 * kRealWidth(58);
        } else {
            frame.origin.x = -0.5 * kRealWidth(58);
        }
        self.frame = frame;
        self.floatView.frame = self.bounds;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = NO;
    }];
}

@end

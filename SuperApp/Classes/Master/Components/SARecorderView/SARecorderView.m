//
//  SARecoderView.m
//  SuperApp
//
//  Created by Tia on 2022/8/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARecorderView.h"
#import "SAAppTheme.h"
#import "SALotAnimationView.h"
#import "SAMultiLanguageManager.h"
#import "SARecorderTools.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>

static NSInteger const SARecorderMaxRecordTime = 60; //最大录音时长
static CGFloat const SARecorderLevelWidth = 2.0;     //分贝宽度
static CGFloat const SARecorderLevelMargin = 3.0;    //分贝间隔

typedef NS_ENUM(NSInteger, SARecorderState) {
    SARecorderStateDefault = 0, // 准备录音
    SARecorderStateRecording,   // 录音中
    SARecorderStateSend,        // 发送
    SARecorderStateCancel,      // 取消
};


@interface SARecorderView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// 子标题
@property (nonatomic, strong) UILabel *subTitleLB;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBTN;
/// 录音时长
@property (nonatomic, strong) UILabel *timeLB;
/// 分贝视图
@property (nonatomic, strong) UIView *levelView;
///录音功能容器
@property (nonatomic, strong) UIView *funcView;
/// 提示文言
@property (nonatomic, strong) UILabel *tipsLB;
/// 提示动画
@property (nonatomic, strong) SALotAnimationView *tipsAnimationView;
/// 录音动画视图
@property (nonatomic, strong) SALotAnimationView *recoderAnimationView;
/// 展示的假录音按钮
@property (nonatomic, strong) HDUIButton *recoderBtn;
/// 真正响应事件按钮
@property (nonatomic, strong) UIButton *realRecoderBtn;
/// 手势
@property (nonatomic, weak) UIPanGestureRecognizer *pan;
/// 录音状态
@property (nonatomic) SARecorderState recordState;
/// 录音路径
@property (nonatomic, copy) NSString *fileName;
/// 录音时长 计时器
@property (nonatomic, strong) NSTimer *audioTimer;
/// 录音时长
@property (nonatomic, assign) NSInteger recordDuration;

/// 振幅计时器
@property (nonatomic, strong) CADisplayLink *levelTimer;
/// 当前振幅数组
@property (nonatomic, strong) NSMutableArray *currentLevels;
/// 振幅layer
@property (nonatomic, weak) CAShapeLayer *levelLayer;
/// 画振幅的path
@property (nonatomic, strong) UIBezierPath *levelPath;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 子标题
@property (nonatomic, copy) NSString *subTitle;
/// 录制最大秒数
@property (nonatomic) NSInteger second;

@property (nonatomic, copy) void (^completion)(BOOL, NSString *_Nullable, NSInteger);

@end


@implementation SARecorderView

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle limitMaxRecordSecond:(NSInteger)second completion:(nullable void (^)(BOOL, NSString *_Nullable, NSInteger))completion {
    if (self = [super init]) {
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.title = title;
        self.subTitle = subTitle;
        self.second = second;
        if (second <= 0 || second > 60) {
            self.second = SARecorderMaxRecordTime;
        }
        self.completion = completion;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.subTitleLB];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.timeLB];
    [self.containerView addSubview:self.levelView];
    [self.containerView addSubview:self.funcView];
    [self.funcView addSubview:self.tipsLB];
    [self.funcView addSubview:self.tipsAnimationView];
    [self.funcView addSubview:self.recoderBtn];
    [self.funcView addSubview:self.recoderAnimationView];
    [self.funcView addSubview:self.realRecoderBtn];

    self.recordState = SARecorderStateDefault;
    self.recordDuration = 0;
}

- (void)layoutContainerViewSubViews {
    CGFloat margin = kRealWidth(12);
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(16));
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(self.closeBTN.mas_left).offset(-margin);
    }];

    [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(4));
        make.left.equalTo(self.titleLB);
        make.right.mas_equalTo(self.closeBTN.mas_left).offset(-margin);
    }];

    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB);
        make.right.mas_equalTo(-margin);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLB.mas_bottom).offset(kRealWidth(16));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(74));
    }];

    [self.levelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(112));
    }];

    [self.funcView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.levelView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(260));
        make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
    }];

    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(32));
        make.centerX.equalTo(self.funcView);
    }];

    [self.tipsAnimationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(26));
        make.centerX.equalTo(self.funcView);
    }];

    [self.recoderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(96), kRealWidth(96)));
        make.top.mas_equalTo(kRealWidth(108));
        make.centerX.equalTo(self.funcView);
    }];
    [self.recoderAnimationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recoderBtn);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(144), kRealWidth(144)));
    }];

    [self.realRecoderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recoderBtn);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(172), kRealWidth(172)));
    }];
}

#pragma mark - event response
- (void)starRecorde:(UIButton *)btn {
    HDLog(@"开始录音");
    if (self.recordState != SARecorderStateDefault) {
        self.recordState = SARecorderStateDefault;
    }
    self.fileName = [NSString stringWithFormat:@"SAVoice%lld", (long long)[NSDate timeIntervalSinceReferenceDate]];
    @HDWeakify(self);
    [[SARecorderTools shareManager] startRecordingWithFileName:self.fileName completion:^(NSError *error) {
        @HDStrongify(self);
        if (error) {
            if (error.code == 201) { //未授权
                [NAT showToastWithTitle:SALocalizedString(@"recorder_cannot_record", @"无法录音")
                                content:SALocalizedString(@"recorder_permission_tip", @"请在iPhone的“设置-隐私-麦克风”选项中，允许访问你的手机麦克风。")
                                   type:HDTopToastTypeError];
            } else {
                HDLog(@"其他问题 %@", error);
            }
        } else { //正常授权
            self.recordState = SARecorderStateRecording;
            [self startAudioTimer];
            [self startMeterTimer];
        }
    }];
}

- (void)sendRecorde:(UIButton *)btn {
    HDLog(@"结束录音");
    @HDWeakify(self);
    if (self.recordState == SARecorderStateRecording) { //正常录音
        HDLog(@"发送录音到云端");
        self.recordState = SARecorderStateSend;
        [[SARecorderTools shareManager] stopRecordingWithCompletion:^(NSString *recordPath, int duation) {
            @HDStrongify(self);
            if ([recordPath isEqualToString:kSAShortRecord]) {
                HDLog(@"录音时间太短");
                self.recordState = SARecorderStateDefault;
                [[SARecorderTools shareManager] removeCurrentRecordFile:self.fileName];
            } else {
                //                HDLog(@"发送录音消息,路径 == %@", recordPath);
                if (self.completion) {
                    self.completion(YES, recordPath, self.recordDuration);
                }
                [self dismiss];
            }
        }];

    } else { //取消状态
        HDLog(@"取消录音，恢复初始状态");
        self.recordState = SARecorderStateDefault;
        [[SARecorderTools shareManager] stopRecordingWithCompletion:nil];
        [[SARecorderTools shareManager] removeCurrentRecordFile:self.fileName];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (!self.realRecoderBtn.isSelected)
        return;

    CGPoint point = [pan locationInView:pan.view.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        if (CGRectContainsPoint(self.recoderAnimationView.frame, point)) { //在动画view里面
            self.recordState = SARecorderStateRecording;
        } else { //
            self.recordState = SARecorderStateCancel;
        }
    } else { // 松开手指 或者 手势cancel
        [self sendRecorde:self.realRecoderBtn];
    }
}

#pragma mark - audioTimer
- (void)startAudioTimer {
    [self stopAudioTimer];
    self.recordDuration = 0;
    [self updateTimeLabel];
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addSeconed) userInfo:nil repeats:YES];
}

// 停止定时器
- (void)stopAudioTimer {
    if (self.audioTimer) {
        [self.audioTimer invalidate];
        self.audioTimer = nil;
    }
}

- (void)addSeconed {
    self.recordDuration++;
    [self updateTimeLabel];
    if (_recordDuration >= self.second) {
        [self sendRecorde:self.realRecoderBtn]; //大于60秒中断录音
        return;
    }
}

//更新录音时间
- (void)updateTimeLabel {
    NSString *text = [self getTimeLabelTextWithDuration:_recordDuration];
    self.timeLB.text = text;
}

//转换时间格式
- (NSString *)getTimeLabelTextWithDuration:(NSInteger)duration {
    NSString *text;
    if (duration < 60) {
        text = [NSString stringWithFormat:@"00:%02zd", duration];
    } else {
        NSInteger minutes = duration / 60;
        NSInteger seconed = duration % 60;
        text = [NSString stringWithFormat:@"%zd:%02zd", minutes, seconed];
    }
    return text;
}

#pragma mark - meterTimer
- (void)startMeterTimer {
    [self stopMeterTimer];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    self.levelTimer.preferredFramesPerSecond = 10;
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

// 停止定时器
- (void)stopMeterTimer {
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
}

//更新分贝数值
- (void)updateMeter {
    AVAudioRecorder *recorder = [[SARecorderTools shareManager] recorder];
    [recorder updateMeters];
    CGFloat aveChannel = pow(10, (0.02 * [recorder averagePowerForChannel:0]));
    if (aveChannel <= 0.1f)
        aveChannel = 0.1f;
    if (aveChannel >= 0.85f)
        aveChannel = 0.85f;
    [self updateLevelLayer:aveChannel];
}

//更新layer动效
- (void)updateLevelLayer:(CGFloat)level {
    [self.currentLevels insertObject:@(level) atIndex:0];
    [self.currentLevels removeLastObject];
    self.levelPath = [UIBezierPath bezierPath];

    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i = 0; i < self.currentLevels.count; i++) {
        CGFloat x = i * (SARecorderLevelWidth + SARecorderLevelMargin) + kRealWidth(10);
        CGFloat pathH = [self.currentLevels[i] floatValue] * height;
        CGFloat startY = height / 2.0 - pathH / 2.0;
        CGFloat endY = height / 2.0 + pathH / 2.0;
        [_levelPath moveToPoint:CGPointMake(x, startY)];
        [_levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    self.levelLayer.path = _levelPath.CGPath;
}

#pragma mark - setter
- (void)setRecordState:(SARecorderState)recordState {
    if (_recordState == recordState && _recordState != SARecorderStateDefault)
        return;

    _recordState = recordState;

    switch (recordState) {
        case SARecorderStateDefault:
            HDLog(@"录音初始化");
            //真录音按钮
            self.realRecoderBtn.selected = NO;
            self.realRecoderBtn.layer.borderWidth = 0;
            //默认录音按钮
            self.recoderBtn.hidden = NO;
            //录音按钮动画
            self.recoderAnimationView.hidden = YES;
            [self.recoderAnimationView stop];

            //提示文本
            self.tipsLB.hidden = YES;
            //垃圾桶动画
            self.tipsAnimationView.hidden = YES;
            [self.tipsAnimationView stop];

            //录音时间
            self.recordDuration = 0;
            [self updateTimeLabel];
            //录音分贝动画
            self.currentLevels = nil;
            [self updateLevelLayer:0.1f];
            //注销计时器
            [self stopAudioTimer];
            [self stopMeterTimer];
            break;

        case SARecorderStateRecording:
            HDLog(@"录音中");
            //真录音按钮
            self.realRecoderBtn.selected = YES;
            self.realRecoderBtn.layer.borderWidth = 0;
            //默认录音按钮
            self.recoderBtn.hidden = YES;
            //录音按钮动画
            self.recoderAnimationView.hidden = NO;
            [self.recoderAnimationView play];

            //提示文本
            self.tipsLB.hidden = NO;
            //垃圾桶动画
            self.tipsAnimationView.hidden = YES;
            [self.tipsAnimationView stop];
            break;

        case SARecorderStateCancel:
            HDLog(@"取消");
            //真录音按钮
            self.realRecoderBtn.selected = YES;
            self.realRecoderBtn.layer.borderWidth = 1;

            //默认录音按钮
            self.recoderBtn.hidden = YES;
            //录音按钮动画
            self.recoderAnimationView.hidden = NO;
            [self.recoderAnimationView play];

            //提示文本
            self.tipsLB.hidden = YES;
            //垃圾桶动画
            self.tipsAnimationView.hidden = NO;
            [self.tipsAnimationView play];
            break;

        case SARecorderStateSend:
            HDLog(@"发送");
            //真录音按钮
            self.realRecoderBtn.selected = NO;
            self.realRecoderBtn.layer.borderWidth = 0;
            //默认录音按钮
            self.recoderBtn.hidden = NO;
            //录音按钮动画
            self.recoderAnimationView.hidden = YES;
            [self.recoderAnimationView stop];

            //提示文本
            self.tipsLB.hidden = YES;
            //垃圾桶动画
            self.tipsAnimationView.hidden = YES;
            [self.tipsAnimationView stop];
            //注销计时器
            [self stopAudioTimer];
            [self stopMeterTimer];

            break;

        default:
            break;
    }
}

#pragma mark - lazy load
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = UILabel.new;
        _titleLB.font = HDAppTheme.font.sa_standard20H;
        _titleLB.textColor = HDAppTheme.color.sa_C333;
        _titleLB.text = self.title;
    }
    return _titleLB;
}

- (UILabel *)subTitleLB {
    if (!_subTitleLB) {
        _subTitleLB = UILabel.new;
        _subTitleLB.font = HDAppTheme.font.sa_standard14;
        _subTitleLB.textColor = HDAppTheme.color.sa_C999;
        _subTitleLB.text = self.subTitle;
    }
    return _subTitleLB;
}

- (UIButton *)closeBTN {
    if (!_closeBTN) {
        @HDWeakify(self);
        _closeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBTN setImage:[UIImage imageNamed:@"recoder_del_hei"] forState:UIControlStateNormal];
        [_closeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.completion) {
                self.completion(NO, nil, 0);
            }
            [self dismiss];
        }];
    }
    return _closeBTN;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = UILabel.new;
        _timeLB.text = @"00:00";
        _timeLB.font = [UIFont systemFontOfSize:28 weight:UIFontWeightMedium];
        _timeLB.textColor = HDAppTheme.color.sa_C333;
        _timeLB.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLB;
}

- (UIView *)levelView {
    if (!_levelView) {
        _levelView = UIView.new;
        @HDWeakify(self);
        _levelView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.levelLayer) {
                [self.levelLayer removeFromSuperlayer];
                self.levelLayer = nil;
            }
            self.levelLayer.frame = CGRectMake(kRealWidth(38), kRealWidth(20), view.frame.size.width - kRealWidth(38) * 2, kRealWidth(72));
            [view.layer addSublayer:self.levelLayer];
            self.currentLevels = nil;
            [self updateLevelLayer:0.1f];
        };
    }
    return _levelView;
}

- (CAShapeLayer *)levelLayer {
    if (!_levelLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor blackColor].CGColor;
        layer.lineWidth = SARecorderLevelWidth;
        _levelLayer = layer;
    }
    return _levelLayer;
}

- (NSMutableArray *)currentLevels {
    if (!_currentLevels) {
        //计算初始分贝显示个数
        NSInteger count = (self.frame.size.width - kRealWidth(38 + 10) * 2) / (SARecorderLevelWidth + SARecorderLevelMargin);
        NSMutableArray *levels = @[].mutableCopy;
        for (NSInteger i = 0; i <= count; i++) {
            [levels addObject:@0.1];
        }
        _currentLevels = levels;
    }
    return _currentLevels;
}

- (UIView *)funcView {
    if (!_funcView) {
        _funcView = UIView.new;
    }
    return _funcView;
}

- (UILabel *)tipsLB {
    if (!_tipsLB) {
        _tipsLB = UILabel.new;
        _tipsLB.textAlignment = NSTextAlignmentCenter;
        _tipsLB.font = HDAppTheme.font.sa_standard14;
        _tipsLB.textColor = HDAppTheme.color.sa_C333;
        _tipsLB.text = SALocalizedString(@"recorder_label_tip", @"松开保存，滑动取消");
    }
    return _tipsLB;
}

- (SALotAnimationView *)tipsAnimationView {
    if (!_tipsAnimationView) {
        _tipsAnimationView = SALotAnimationView.new;
        [_tipsAnimationView setAnimationNamed:@"trash_can"];
        _tipsAnimationView.loopAnimation = YES;
    }
    return _tipsAnimationView;
}

- (SALotAnimationView *)recoderAnimationView {
    if (!_recoderAnimationView) {
        _recoderAnimationView = SALotAnimationView.new;
        [_recoderAnimationView setAnimationNamed:@"recoder"];
        _recoderAnimationView.loopAnimation = YES;
        _recoderAnimationView.userInteractionEnabled = NO;
    }
    return _recoderAnimationView;
}

- (HDUIButton *)recoderBtn {
    if (!_recoderBtn) {
        _recoderBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_recoderBtn setImage:[UIImage imageNamed:@"recoder_icon"] forState:UIControlStateNormal];
        _recoderBtn.backgroundColor = HDAppTheme.color.sa_C1;
        [_recoderBtn setTitle:SALocalizedStringFromTable(@"press_to_voice", @"按住录音", @"Buttons") forState:UIControlStateNormal];
        [_recoderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _recoderBtn.imagePosition = HDUIButtonImagePositionTop;
        _recoderBtn.spacingBetweenImageAndTitle = 4;
        _recoderBtn.titleLabel.font = HDAppTheme.font.sa_standard12;
        _recoderBtn.userInteractionEnabled = NO;
        _recoderBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(48)];
        };
    }
    return _recoderBtn;
}

- (UIButton *)realRecoderBtn {
    if (!_realRecoderBtn) {
        _realRecoderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 手指按下
        [_realRecoderBtn addTarget:self action:@selector(starRecorde:) forControlEvents:UIControlEventTouchDown];
        // 松开手指
        [_realRecoderBtn addTarget:self action:@selector(sendRecorde:) forControlEvents:UIControlEventTouchUpInside];
        // 拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _pan = pan;
        [_realRecoderBtn addGestureRecognizer:pan];
        _realRecoderBtn.layer.borderColor = [HDAppTheme.color sa_C1].CGColor;
        _realRecoderBtn.layer.borderWidth = 0;
        _realRecoderBtn.layer.cornerRadius = kRealWidth(86);
    }
    return _realRecoderBtn;
}

@end

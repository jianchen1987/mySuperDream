//
//  HDAuxiliaryToolShowFPSViewController.m
//  SuperApp
//
//  Created by VanJay on 2019/11/25.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolShowFPSViewController.h"
#import <HDKitCore/HDKitCore.h>

static CGFloat const kShowFPSLabelWidth = 80.0;
static CGFloat const kShowFPSLabelHeight = 24.0;


@interface HDAuxiliaryToolShowFPSViewController ()
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) CADisplayLink *link;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimeInterval lastTime;
@end


@implementation HDAuxiliaryToolShowFPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
    CGRect frame = CGRectMake(0, kScreenHeight - kTabBarH - kShowFPSLabelHeight, kShowFPSLabelWidth, kShowFPSLabelHeight);
    UILabel *displayLabel = [[UILabel alloc] initWithFrame:frame];
    displayLabel.alpha = 0.5;
    displayLabel.layer.cornerRadius = 5;
    displayLabel.clipsToBounds = YES;
    displayLabel.textAlignment = NSTextAlignmentCenter;
    displayLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    displayLabel.userInteractionEnabled = true;
    [self.view addSubview:displayLabel];
    self.displayLabel = displayLabel;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [displayLabel addGestureRecognizer:pan];
    [self initCADisplayLink];
}

- (void)initCADisplayLink {
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tick:(CADisplayLink *)link {
    if (self.lastTime == 0) { // 对LastTime进行初始化
        self.lastTime = link.timestamp;
        return;
    }

    self.count += 1;                                       // 记录tick在1秒内执行的次数
    NSTimeInterval delta = link.timestamp - self.lastTime; // 计算本次刷新和上次更新FPS的时间间隔

    // 大于等于1秒时，来计算FPS
    if (delta >= 1) {
        self.lastTime = link.timestamp;
        float fps = self.count / delta; // 次数 除以 时间 = FPS （次/秒）
        self.count = 0;
        [self updateDisplayLabelText:fps];
    }
}

- (void)updateDisplayLabelText:(float)fps {
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    self.displayLabel.text = [NSString stringWithFormat:@"%d FPS", (int)round(fps)];
    self.displayLabel.textColor = color;
}

- (void)dealloc {
    [_link invalidate];
}

#pragma mark - event response
- (void)pan:(UIPanGestureRecognizer *)sender {
    // 1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    // 2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    // 3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.centerX + offsetPoint.x;
    CGFloat newY = panView.centerY + offsetPoint.y;
    if (newX < kShowFPSLabelWidth / 2) {
        newX = kShowFPSLabelWidth / 2;
    }
    if (newX > kScreenWidth - kShowFPSLabelWidth / 2) {
        newX = kScreenWidth - kShowFPSLabelWidth / 2;
    }
    if (newY < 0) {
        newY = 0;
    }
    if (newY > kScreenHeight - kShowFPSLabelHeight) {
        newY = kScreenHeight - kShowFPSLabelHeight;
    }
    panView.center = CGPointMake(newX, newY);
}

@end

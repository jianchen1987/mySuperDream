//
//  PNContactUSWindow.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNContactUSWindow.h"


@interface PNContactUSWindow ()
@property (nonatomic, strong) HDUIButton *entryBtn;
@property (nonatomic, assign) BOOL isShowing;
@end


@implementation PNContactUSWindow

+ (instancetype)sharedInstance {
    static PNContactUSWindow *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
    });
    return ins;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

static CGFloat _kEntryViewWidth = 0;
static CGFloat _kEntryViewHeight = 0;

- (instancetype)init {
    _kEntryViewWidth = self.entryBtn.size.width + kRealWidth(10);
    _kEntryViewHeight = kRealWidth(30);
    CGRect frame = (CGRect){0, 0, CGSizeMake(_kEntryViewWidth, _kEntryViewHeight)};
    frame.size = CGSizeMake(_kEntryViewWidth, _kEntryViewHeight);
    frame.origin.x = kScreenWidth - _kEntryViewWidth;
    frame.origin.y = kNavigationBarH + kRealWidth(20);

    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLanguageChanged object:nil];
}

- (void)commonInit {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];

    [self addSubview:self.entryBtn];

    self.entryBtn.frame = self.bounds;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)hd_languageDidChanged {
    [self.entryBtn setTitle:PNLocalizedString(@"pn_contact_us", @"联系我们") forState:0];
    _kEntryViewWidth = self.entryBtn.size.width + kRealWidth(10);
    CGRect newRect = self.frame;
    newRect.size.width = _kEntryViewWidth;
    self.frame = newRect;
    self.entryBtn.frame = self.bounds;
    [self expand];
}
#pragma mark
- (void)pan:(UIPanGestureRecognizer *)sender {
    // 获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    // 清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    // 重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.center.x + offsetPoint.x;
    CGFloat newY = panView.center.y + offsetPoint.y;

    const CGFloat margin = 0;
    if (newX < _kEntryViewWidth / 2 + margin) {
        newX = _kEntryViewWidth / 2 + margin;
    }

    if (newX > kScreenWidth - _kEntryViewWidth / 2) {
        newX = kScreenWidth - _kEntryViewWidth / 2;
    }

    if (newY < _kEntryViewHeight / 2 + margin) {
        newY = _kEntryViewHeight / 2 + margin;
    }

    if (newY > kScreenHeight - _kEntryViewHeight / 2) {
        newY = kScreenHeight - _kEntryViewHeight / 2;
    }
    panView.center = CGPointMake(newX, newY);

    if (sender.state == UIGestureRecognizerStateEnded) {
        [self expand];
    }
}

// 显示
- (void)expand {
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        //            if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
        frame.origin.x = kScreenWidth - _kEntryViewWidth;
        //            } else {
        //                frame.origin.x = 0;
        //            }
        self.frame = frame;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = YES;
    }];
}

// 隐藏
- (void)shrink {
    @HDWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @HDStrongify(self);
        CGRect frame = self.frame;
        if (CGRectGetMinX(self.frame) + 0.5 * CGRectGetWidth(self.frame) >= kScreenWidth * 0.5) {
            frame.origin.x = kScreenWidth - 0.5 * _kEntryViewWidth;
        } else {
            frame.origin.x = -0.5 * _kEntryViewWidth;
        }
        self.frame = frame;
    } completion:^(BOOL finished) {
        @HDStrongify(self);
        self.isShowing = NO;
    }];
}

- (void)show {
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

#pragma mark
- (HDUIButton *)entryBtn {
    if (!_entryBtn) {
        _entryBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _entryBtn.adjustsButtonWhenHighlighted = NO;
        _entryBtn.backgroundColor = [UIColor hd_colorWithHexString:@"E7F4FF"];
        [_entryBtn setTitleColor:[UIColor hd_colorWithHexString:@"0077FF"] forState:UIControlStateNormal];
        _entryBtn.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [_entryBtn setTitle:PNLocalizedString(@"pn_contact_us", @"联系我们") forState:0];
        [_entryBtn setImage:[UIImage imageNamed:@"pn_wallet_home_contactUS"] forState:UIControlStateNormal];
        [_entryBtn setImagePosition:HDUIButtonImagePositionLeft];
        _entryBtn.spacingBetweenImageAndTitle = kRealWidth(2);
        [_entryBtn sizeToFit];
        _entryBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:kRealWidth(14)];
        };
        [_entryBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            NSString *tgKey = [SAApolloManager getApolloConfigForKey:kApolloCoolcashTelegram];
            if (WJIsStringEmpty(tgKey)) {
                tgKey = @"wownow_cs_bot";
            }
            NSURL *tgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://t.me/%@", tgKey]];
            if (![UIApplication.sharedApplication canOpenURL:tgUrl]) {
                HDLog(@"未安装Tg");
                return;
            }
            [UIApplication.sharedApplication openURL:tgUrl options:@{} completionHandler:^(BOOL success){
            }];
        }];
    }
    return _entryBtn;
}

@end

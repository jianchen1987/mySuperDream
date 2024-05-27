//
//  HDAuxiliaryToolViewController.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolViewController.h"
#import "HDAuxiliaryToolHomeWindow.h"
#import "HDAuxiliaryToolMacro.h"
#import "HDAuxiliaryToolShowFPSWindow.h"
#import "HDAuxiliaryToolShowLogWindow.h"
#import "HDAuxiliaryToolSliderView.h"
#import "HDAuxiliaryToolSwitchView.h"
#import "Masonry.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>

#define defaults [NSUserDefaults standardUserDefaults]


@interface HDAuxiliaryToolViewController ()
@property (nonatomic, strong) HDAuxiliaryToolSwitchView *showLogView;       ///< 是否显示log
@property (nonatomic, strong) HDAuxiliaryToolSwitchView *canScrollLogView;  ///< 是否可滚动log
@property (nonatomic, strong) HDAuxiliaryToolSliderView *bgAlphaSliderView; ///< 透明度
@property (nonatomic, strong) HDAuxiliaryToolSwitchView *showFPSView;       ///< 是否显示FPS
@property (nonatomic, strong) HDAuxiliaryToolSwitchView *closeDNSView;      ///< 是否关闭DNS
@property (nonatomic, strong) HDAuxiliaryToolSwitchView *openAdsView;       ///< 是否开启
/// 清除日志
@property (nonatomic, strong) HDUIButton *clearLogBTN;
@end


@implementation HDAuxiliaryToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"开发者工具";
    self.view.backgroundColor = UIColor.whiteColor;

    [self setupUI];
}

- (void)setupUI {
    // 右上角关闭
    UIImage *image = [UIImage hd_imageWithShape:HDUIImageShapeNavClose size:CGSizeMake(24, 24) lineWidth:2 tintColor:UIColor.blackColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonClickedHandler) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self.view addSubview:self.showLogView];
    [self.view addSubview:self.canScrollLogView];
    [self.view addSubview:self.bgAlphaSliderView];
    [self.view addSubview:self.showFPSView];
    [self.view addSubview:self.closeDNSView];
    [self.view addSubview:self.openAdsView];
    [self.view addSubview:self.clearLogBTN];

    [self activeConstraints];
    [self bindEvent];
}

- (void)activeConstraints {
    [self.showLogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([UIApplication sharedApplication].statusBarFrame.size.height + 44);
        make.width.centerX.equalTo(self.view);
    }];

    [self.canScrollLogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showLogView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];

    [self.bgAlphaSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.canScrollLogView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];

    [self.showFPSView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgAlphaSliderView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];
    [self.closeDNSView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showFPSView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];

    [self.closeDNSView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showFPSView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];

    [self.openAdsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeDNSView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];


    [self.clearLogBTN sizeToFit];
    [self.clearLogBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openAdsView.mas_bottom);
        make.width.centerX.equalTo(self.view);
    }];
}

- (void)bindEvent {
    self.showLogView.switchValueChangedHandler = ^(BOOL isOn) {
        if (isOn) {
            [[HDAuxiliaryToolShowLogWindow shared] show];
        } else {
            [[HDAuxiliaryToolShowLogWindow shared] hide];
        }
        [defaults setBool:isOn forKey:kHDAuxiliaryToolShowLogKey];
        [defaults synchronize];
    };
    self.canScrollLogView.switchValueChangedHandler = ^(BOOL isOn) {
        [[HDAuxiliaryToolShowLogWindow shared].vc setLogCanScroll:isOn];
        [defaults setBool:isOn forKey:kHDAuxiliaryToolCanScrollLogViewKey];
        [defaults synchronize];
    };
    self.bgAlphaSliderView.sliderValueChangedHandler = ^(CGFloat value) {
        [[HDAuxiliaryToolShowLogWindow shared].vc setLogTextViewAlpha:value];

        // 节流
        [HDFunctionThrottle throttleWithInterval:0.2 handler:^{
            [defaults setFloat:value forKey:kHDAuxiliaryToolShowLogViewAlphaValueKey];
            [defaults synchronize];
        }];
    };
    self.showFPSView.switchValueChangedHandler = ^(BOOL isOn) {
        if (isOn) {
            [[HDAuxiliaryToolShowFPSWindow shared] show];
        } else {
            [[HDAuxiliaryToolShowFPSWindow shared] hide];
        }
        [defaults setBool:isOn forKey:kHDAuxiliaryToolShowFPSKey];
        [defaults synchronize];
    };

    self.closeDNSView.switchValueChangedHandler = ^(BOOL isOn) {
        [defaults setBool:YES forKey:kHDAuxiliaryToolHadCloseDNSKey]; //标记为设置过
        [defaults setBool:isOn forKey:kHDAuxiliaryToolCloseDNSKey];
        [defaults synchronize];
    };

    self.openAdsView.switchValueChangedHandler = ^(BOOL isOn) {
        [defaults setBool:isOn forKey:kHDAuxiliaryToolOpenAdsKey];
        [defaults synchronize];
    };
}

- (BOOL)isShowLogOn {
    return self.showLogView.isOn;
}

#pragma mark - event response
- (void)rightBarButtonClickedHandler {
    [[HDAuxiliaryToolHomeWindow shared] hide];
}

- (void)clickedClearLogBTNHandler {
    [HDAuxiliaryToolShowLogWindow.shared.vc clearLog];
}

#pragma mark - lazy load
- (HDAuxiliaryToolSwitchView *)showLogView {
    if (!_showLogView) {
        _showLogView = ({
            BOOL isOn = [[defaults valueForKey:kHDAuxiliaryToolShowLogKey] boolValue];
            HDAuxiliaryToolSwitchView *view = [[HDAuxiliaryToolSwitchView alloc] initWithTitle:@"显示日志窗口" isOn:isOn];
            view;
        });
    }
    return _showLogView;
}

- (HDAuxiliaryToolSwitchView *)canScrollLogView {
    if (!_canScrollLogView) {
        _canScrollLogView = ({
            BOOL isOn = [[defaults valueForKey:kHDAuxiliaryToolCanScrollLogViewKey] boolValue];
            HDAuxiliaryToolSwitchView *view = [[HDAuxiliaryToolSwitchView alloc] initWithTitle:@"禁用/开启日志手动滚动" isOn:isOn];
            view;
        });
    }
    return _canScrollLogView;
}

- (HDAuxiliaryToolSliderView *)bgAlphaSliderView {
    if (!_bgAlphaSliderView) {
        _bgAlphaSliderView = ({
            CGFloat value = [[defaults valueForKey:kHDAuxiliaryToolShowLogViewAlphaValueKey] floatValue];
            HDAuxiliaryToolSliderView *view = [[HDAuxiliaryToolSliderView alloc] initWithTitle:@"日志窗口透明度" value:value];
            view;
        });
    }
    return _bgAlphaSliderView;
}

- (HDAuxiliaryToolSwitchView *)showFPSView {
    if (!_showFPSView) {
        _showFPSView = ({
            BOOL isOn = [[defaults valueForKey:kHDAuxiliaryToolShowFPSKey] boolValue];
            HDAuxiliaryToolSwitchView *view = [[HDAuxiliaryToolSwitchView alloc] initWithTitle:@"显示 FPS(可拖动)" isOn:isOn];
            view;
        });
    }
    return _showFPSView;
}

- (HDAuxiliaryToolSwitchView *)closeDNSView {
    if (!_closeDNSView) {
        bool hadCloseDNS = [defaults boolForKey:kHDAuxiliaryToolHadCloseDNSKey];
        BOOL isOn = NO;
        if (!hadCloseDNS) { //从来没有设置过dns开关
            isOn = YES;
            [defaults setBool:YES forKey:kHDAuxiliaryToolHadCloseDNSKey]; //标记为设置过
            [defaults setBool:YES forKey:kHDAuxiliaryToolCloseDNSKey];    //默认为关闭dns
            [defaults synchronize];

        } else {
            isOn = [defaults boolForKey:kHDAuxiliaryToolCloseDNSKey];
        }
        HDAuxiliaryToolSwitchView *view = [[HDAuxiliaryToolSwitchView alloc] initWithTitle:@"关闭DNS(可抓包)" isOn:isOn];
        _closeDNSView = view;
    }
    return _closeDNSView;
}

- (HDAuxiliaryToolSwitchView *)openAdsView {
    if (!_openAdsView) {
        _openAdsView = ({
            BOOL isOn = [[defaults valueForKey:kHDAuxiliaryToolOpenAdsKey] boolValue];
            HDAuxiliaryToolSwitchView *view = [[HDAuxiliaryToolSwitchView alloc] initWithTitle:@"开启广告抓包" isOn:isOn];
            view;
        });
    }
    return _openAdsView;
}

- (HDUIButton *)clearLogBTN {
    if (!_clearLogBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:@"清除当前日志" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.titleEdgeInsets = UIEdgeInsetsMake(3, 8, 3, 8);
        [button addTarget:self action:@selector(clickedClearLogBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _clearLogBTN = button;
    }
    return _clearLogBTN;
}
@end

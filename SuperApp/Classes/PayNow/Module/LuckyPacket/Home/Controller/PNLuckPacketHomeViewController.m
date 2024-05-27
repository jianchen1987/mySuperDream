//
//  PNLuckPacketHomeViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLuckPacketHomeViewController.h"
#import "PNLuckyPacketRuleWindow.h"
#import "PNLuckyPacketView.h"
#import "PNLuckyPacketViewModel.h"


@interface PNLuckPacketHomeViewController ()
@property (nonatomic, strong) PNLuckyPacketView *contentView;
@property (nonatomic, strong) PNLuckyPacketViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *navBtn;

@end


@implementation PNLuckPacketHomeViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PNLuckyPacketRuleWindow.sharedInstance show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PNLuckyPacketRuleWindow.sharedInstance.hidden = NO;
    [self.viewModel getNewData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    PNLuckyPacketRuleWindow.sharedInstance.hidden = YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_red_packet_title", @"红包");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_getNewData {
    [self.viewModel getNewData];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNLuckyPacketView *)contentView {
    if (!_contentView) {
        _contentView = [[PNLuckyPacketView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNLuckyPacketViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNLuckyPacketViewModel.new);
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"pn_packet_history", @"红包记录") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        [button sizeToFit];

        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToLuckPacketRecordsVC:@{}];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

@end

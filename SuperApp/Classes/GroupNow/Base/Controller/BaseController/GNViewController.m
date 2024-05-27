//
//  GNViewController.m
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNViewController.h"


@implementation GNViewController

- (void)hd_setupNavigation {
    self.hd_backButtonImage = [UIImage imageNamed:@"gn_home_nav_back"];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    if ([self gn_firstGetNewData])
        [self gn_getNewData];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    if ([event.key isEqualToString:@"backAction"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        _nameLB = SALabel.new;
        _nameLB.textColor = HDAppTheme.color.gn_333Color;
        _nameLB.font = [HDAppTheme.font gn_boldForSize:18];
    }
    return _nameLB;
}

- (HDUIButton *)backBtn {
    if (!_backBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"gn_home_nav_back"] forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _backBtn = button;
    }
    return _backBtn;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)needClose {
    return NO;
}

- (void)gn_getNewData {
}

- (BOOL)gn_firstGetNewData {
    return YES;
}

@end

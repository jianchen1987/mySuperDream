//
//  SAHomeMenuGroundView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAHomeMenuGroundView.h"
#import "SAHomeMenuNavView.h"
#import <HDUIKit/HDSearchBar.h>
#import <Stinger/Stinger.h>


@interface SAHomeMenuGroundView ()
/// dao
@property (nonatomic, strong) SAHomeMenuNavView *navView;
@end


@implementation SAHomeMenuGroundView
- (void)hd_setupViews {
    [self addSubview:self.navView];
}

- (void)updateConstraints {
    [self.navView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(UIApplication.sharedApplication.statusBarFrame.size.height);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(kRealWidth(-10));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SAHomeMenuNavView *)navView {
    return _navView ?: ({ _navView = SAHomeMenuNavView.new; });
}
@end

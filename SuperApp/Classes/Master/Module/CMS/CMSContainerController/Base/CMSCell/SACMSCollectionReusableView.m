//
//  SACMSCollectionReusableView.m
//  SuperApp
//
//  Created by seeu on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSCollectionReusableView.h"
#import <Masonry/Masonry.h>


@implementation SACMSCollectionReusableView

- (void)updateConstraints {
    if (self.customeView) {
        [self.customeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    [super updateConstraints];
}

- (void)setCustomeView:(UIView *)customeView {
    if (_customeView && [_customeView isEqual:customeView]) {
        //        HDLog(@"同一视图，不需要重新添加");
        self.backgroundColor = customeView.backgroundColor;
        return;
    } else {
        if (_customeView) {
            [_customeView removeFromSuperview];
        }
        _customeView = customeView;
        self.backgroundColor = customeView.backgroundColor;
        [self addSubview:customeView];
    }

    [self setNeedsUpdateConstraints];
}

@end

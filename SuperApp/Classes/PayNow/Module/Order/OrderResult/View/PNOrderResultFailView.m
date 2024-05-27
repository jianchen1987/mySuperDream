//
//  PNOrderResultFailView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNOrderResultFailView.h"


@interface PNOrderResultFailView ()
@property (nonatomic, strong) SALabel *msgLabel;
@property (nonatomic, strong) SAOperationButton *button;
@end


@implementation PNOrderResultFailView

- (void)hd_setupViews {
    [self addSubview:self.button];
}

- (void)updateConstraints {
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (SAOperationButton *)button {
    if (!_button) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:PNLocalizedString(@"trans_again", @"重新转账") forState:0];

        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            [HDMediator.sharedInstance navigaveToPayNowTransListVC:@{}];
        }];

        _button = button;
    }
    return _button;
}
@end

//
//  PNBottomView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNBottomView.h"


@interface PNBottomView ()
@property (nonatomic, strong) PNOperationButton *btn;
@end


@implementation PNBottomView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self.btn setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0600].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;

    [self addSubview:self.btn];
}

- (void)updateConstraints {
    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-((kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight)));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)btnClick {
    !self.btnClickBlock ?: self.btnClickBlock();
}

- (void)setBtnEnable:(BOOL)enable {
    self.btn.enabled = enable;
}

#pragma mark
- (PNOperationButton *)btn {
    if (!_btn) {
        _btn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end

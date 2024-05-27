//
//  TNMapZoomOprateView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMapZoomOprateView.h"


@interface TNMapZoomOprateView ()
/// 放大 按钮
@property (strong, nonatomic) HDUIButton *enlargeBtn;
/// 缩小
@property (strong, nonatomic) HDUIButton *smallBtn;
@end


@implementation TNMapZoomOprateView
- (void)hd_setupViews {
    [self addSubview:self.enlargeBtn];
    [self addSubview:self.smallBtn];
}
- (void)updateConstraints {
    [self.smallBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
    }];
    [self.enlargeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.smallBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(50), kRealWidth(50)));
    }];
    [super updateConstraints];
}
/** @lazy enlargeBtn */
- (HDUIButton *)enlargeBtn {
    if (!_enlargeBtn) {
        _enlargeBtn = [[HDUIButton alloc] init];
        [_enlargeBtn setBackgroundImage:[UIImage imageNamed:@"tn_zoom_big"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_enlargeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.enlargeClickCallBack ?: self.enlargeClickCallBack();
        }];
    }
    return _enlargeBtn;
}
/** @lazy _smallBtn */
- (HDUIButton *)smallBtn {
    if (!_smallBtn) {
        _smallBtn = [[HDUIButton alloc] init];
        [_smallBtn setBackgroundImage:[UIImage imageNamed:@"tn_zoom_small"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_smallBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.smallClickCallBack ?: self.smallClickCallBack();
        }];
    }
    return _smallBtn;
}
@end

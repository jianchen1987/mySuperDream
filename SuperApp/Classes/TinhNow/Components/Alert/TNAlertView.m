//
//  TNAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNAlertView.h"
#import <HDKitCore/HDKitCore.h>


@interface TNAlertView ()
///  关闭按钮
@property (strong, nonatomic) HDUIButton *closeBtn;
@end


@implementation TNAlertView

- (void)setupContainerSubViews {
    [super setupContainerSubViews];
    [self.containerView addSubview:self.closeBtn];
}

- (void)layoutContainerViewSubViews {
    [super layoutContainerViewSubViews];

    self.closeBtn.frame = CGRectMake(CGRectGetWidth(self.containerView.frame) - self.closeBtn.size.width, 0, self.closeBtn.size.width, self.closeBtn.size.height);
}
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.closeBtnClickCallBack ?: self.closeBtnClickCallBack();
            [self dismiss];
        }];
        [button sizeToFit];
        _closeBtn = button;
    }
    return _closeBtn;
}
@end

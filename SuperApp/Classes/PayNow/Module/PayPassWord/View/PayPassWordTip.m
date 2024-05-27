//
//  PayPassWordTip.m
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayPassWordTip.h"


@implementation PayPassWordTip
+ (void)showPayPassWordTipViewToView:(UIView *)view
                         IconImgName:(NSString *)iconImgName
                              Detail:(NSString *)detail
                       CancelBtnText:(NSString *)cancelBtnText
                         SureBtnText:(NSString *)sureBtnText
                        SureCallBack:(sureBtnTapBlock)sureCallBack
                      CancelCallBack:(cancelBtnTapBlock)cancelCallBack {
    PayPassWordTipView *tipView = [[PayPassWordTipView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    tipView.iconImg.image = [UIImage imageNamed:iconImgName.length > 0 ? iconImgName : @"pay_warning"];
    tipView.detailLB.text = detail;
    [tipView.cancelBtn setTitle:cancelBtnText.length > 0 ? cancelBtnText : PNLocalizedString(@"Forgot_password", @"") forState:UIControlStateNormal];
    [tipView.sureBtn setTitle:sureBtnText.length > 0 ? sureBtnText : PNLocalizedString(@"Re-enter", @"") forState:UIControlStateNormal];
    [view addSubview:tipView];
    @HDWeakify(tipView);
    tipView.cancelBlock = ^{
        @HDStrongify(tipView);
        [tipView removeFromSuperview];
        !cancelCallBack ?: cancelCallBack();
    };
    tipView.sureBlock = ^{
        @HDStrongify(tipView);
        [tipView removeFromSuperview];
        !sureCallBack ?: sureCallBack();
    };
}
@end

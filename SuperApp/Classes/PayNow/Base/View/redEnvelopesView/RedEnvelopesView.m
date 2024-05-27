//
//  RedEnvelopesView.m
//  customer
//
//  Created by 谢泽锋 on 2019/3/4.
//  Copyright © 2019 chaos network technology. All rights reserved.
//
#import "RedEnvelopesView.h"
#import "HDAppTheme.h"
#import "HDCommonUtils.h"
#import "InternationalManager.h"
#import "PNMultiLanguageManager.h" //语言
#import "UIMacro.h"
#import <UIColor+HDKitCore.h> //颜色
#define View_W 320
#define View_H 370


@interface RedEnvelopesView ()
@property (weak, nonatomic) IBOutlet UILabel *money_LB;
@property (weak, nonatomic) IBOutlet UILabel *title_LB;

@end


@implementation RedEnvelopesView

- (void)showInVC:(UIViewController *)vc {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    self.backView = backView;
    self.frame = CGRectMake((kScreenWidth - 155) / 2, (kScreenHeight - 165) / 2, 155, 165);
    [vc.view addSubview:backView];
    [vc.view addSubview:self];
    self.frame = CGRectMake((kScreenWidth - View_W) / 2, (kScreenHeight - View_H) / 2, View_W, View_H);
    self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);

    UILabel *detail_LB = [self viewWithTag:200];
    detail_LB.text = HDLocalizedString(@"redpacket_desc", @"红包已放入余额", nil);
    UILabel *title_LB = [self viewWithTag:300];
    title_LB.textColor = [UIColor hd_colorWithHexString:@"#FD7127"];
    title_LB.text = HDLocalizedString(@"redpacket_title", @"获得红包", nil);
    // 表示view的原来尺寸
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        // 按照比例scalex=0.001,y=0.001进行缩小
        strongSelf.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

- (void)show {
    //    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self showInVC:rootVC];
}

- (void)show:(ClickSure)clickSure {
    [self show];
    self.clickSure = clickSure;
}

- (void)setAmountNumber:(NSString *)amountNumber {
    _amountNumber = amountNumber;
    UILabel *money_LB = [self viewWithTag:100];
    money_LB.textColor = [UIColor hd_colorWithHexString:@"#FD7127"];
    money_LB.text = _amountNumber;
    //    self.money_LB.text = [HDCommonUtils thousandSeparatorAmount:_amountNumber currencyCode:CURRENCE_TYPE_KHR];
}

- (IBAction)closeAction:(id)sender {
    self.layer.transform = CATransform3DMakeScale(1, 1, 1);

    // 表示view的原来尺寸
    [UIView animateWithDuration:0.5 animations:^{
        // 按照比例scalex=0.001,y=0.001进行缩小
        self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
        self.backView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
        self.hidden = YES;
    }];
    if (self.clickSure) {
        self.clickSure();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

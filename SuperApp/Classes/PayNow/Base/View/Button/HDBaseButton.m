//
//  HDBaseButton.m
//  customer
//
//  Created by 陈剑 on 2018/7/5.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBaseButton.h"
#import "HDAppTheme.h"
#import "HDKitCore/HDFrameLayout.h"
#import "UIColor+HDKitCore.h"
#import "UIView+HD_Extension.h"


@implementation HDBaseButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [HDAppTheme.font standard2Bold];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [HDAppTheme.font standard2Bold];
}

//- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//
//    NSDictionary *attribute = @{NSFontAttributeName:[HDAppTheme.font standard2Bold]};
//    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
//
//    CGRect titleRect = [self.currentTitle boundingRectWithSize:contentRect.size options:option attributes:attribute context:nil];
//
//    return CGRectMake((contentRect.size.width - titleRect.size.width)/2, (contentRect.size.height - titleRect.size.height)/2, titleRect.size.width, titleRect.size.height);
//
//}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    UIView *backGroundView = [[UIView alloc] initWithFrame:rect];
    backGroundView.layer.cornerRadius = rect.size.height / 2.0;
    backGroundView.layer.masksToBounds = YES;
    //    [backGroundView setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#ff9a44"] toColor:[UIColor hd_colorWithHexString:@"#ff6f4c"]];
    [backGroundView setBackgroundColor:[UIColor hd_colorWithHexString:@"#EFB795"]];
    UIGraphicsBeginImageContextWithOptions(backGroundView.bounds.size, NO, [UIScreen mainScreen].scale);
    [backGroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIView *backGroundCloseView = [[UIView alloc] initWithFrame:rect];
    backGroundCloseView.layer.cornerRadius = rect.size.height / 2.0;
    backGroundCloseView.layer.masksToBounds = YES;
    [backGroundCloseView setBackgroundColor:[HDAppTheme.color G4]];
    //    [backGroundCloseView setBackgroundColor:[UIColor hd_colorWithHexString:@"#cccccc"]];

    UIGraphicsBeginImageContextWithOptions(backGroundCloseView.bounds.size, NO, [UIScreen mainScreen].scale);
    [backGroundCloseView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundcloseimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIView *backGroundHightLightView = [[UIView alloc] initWithFrame:rect];
    backGroundHightLightView.layer.cornerRadius = rect.size.height / 2.0;
    backGroundHightLightView.layer.masksToBounds = YES;
    //    [backGroundHightLightView setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#ff9a44"] toColor:[UIColor hd_colorWithHexString:@"#ff6f4c"]];
    [backGroundHightLightView setBackgroundColor:[UIColor hd_colorWithHexString:@"#FD7127"]];
    backGroundHightLightView.alpha = 0.7;
    UIGraphicsBeginImageContextWithOptions(backGroundHightLightView.bounds.size, NO, [UIScreen mainScreen].scale);
    [backGroundHightLightView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundHightLightimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self setBackgroundImage:backgroundimage forState:UIControlStateNormal];
    [self setBackgroundImage:backgroundcloseimage forState:UIControlStateDisabled];
    [self setBackgroundImage:backgroundHightLightimage forState:UIControlStateHighlighted];

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end

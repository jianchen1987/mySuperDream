//
//  HDWebServiceLeftButtonView.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceRightButtonView.h"
#import "HDCommonButton.h"
#import "UIColor+HDKitCore.h"
#import "UIImage+HDKitCore.h"

@implementation HDWebServiceRightButtonView
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {

    self.webFeatureResponse = webFeatureResponse;
    NSDictionary *params = [self.parameter.param objectForKey:@"params"];
    if (params) {
        NSString *buttonImageBase64String = [params objectForKey:@"icon"];
        NSString *buttionTitle = [params objectForKey:@"label"];
        NSString *buttonTitleColor = [params objectForKey:@"color"];
        //    NSString *buttonBgColor = self.parameter.param[@"params"][@"backgroundColor"];
        UIImage *image = nil;
        UIColor *titleColor = [UIColor hd_colorWithHexString:@"#FD7127"];
        if (HDIsStringNotEmpty(buttonImageBase64String)) {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:buttonImageBase64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
            image = [UIImage imageWithData:data];
        }

        if (HDIsStringNotEmpty(buttonTitleColor)) {
            titleColor = [UIColor hd_colorWithHexString:buttonTitleColor];
        }

        HDCommonButton *rightButton = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        ;
        [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.titleLabel.font = [HDAppTheme.font standard3];
        rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (HDIsStringNotEmpty(buttionTitle)) {
            rightButton.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, image && buttionTitle > 0 ? 5 : 0);
        }
        [rightButton setTitleColor:titleColor forState:UIControlStateNormal];
        [rightButton setTitle:buttionTitle forState:UIControlStateNormal];
        [rightButton setImage:image forState:UIControlStateNormal];
        rightButton.imageViewSize = CGSizeMake(20, 20);
        rightButton.frame = CGRectMake(0, 0, rightButton.appropriateSize.width, 40);
        self.viewController.rightView = rightButton;
        //        [self.viewController setNavCustomRightView:rightButton];
        self.viewController.hd_navRightBarButtonItems = @[ [[UIBarButtonItem alloc] initWithCustomView:rightButton] ];
        // 需要一直存活 响应点击事件
        self.isCompleteResponseDestroyMonitor = NO;
    } else {
        webFeatureResponse(self, [self responseFailureWithReason:@"params error"]);
    }
}

- (void)rightButtonAction:(HDCommonButton *)button {
    if (HDIsStringNotEmpty(self.viewController.rightButtonfunctionName)) {
        self.webFeatureResponse(self, [NSString stringWithFormat:@"window.%@()", self.viewController.rightButtonfunctionName]);
    }
}

@end

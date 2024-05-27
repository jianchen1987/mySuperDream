//
//  HDWebServiceLeftButtonView.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceLeftButtonView.h"
#import "HDCommonButton.h"
#import "UIColor+HDKitCore.h"

@implementation HDWebServiceLeftButtonView
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

        HDCommonButton *leftButton = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.titleLabel.font = [HDAppTheme.font standard3];
        leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (HDIsStringNotEmpty(buttionTitle)) {
            leftButton.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, image && buttionTitle > 0 ? 5 : 0);
        }
        [leftButton setTitleColor:titleColor forState:UIControlStateNormal];
        [leftButton setTitle:buttionTitle forState:UIControlStateNormal];
        [leftButton setImage:image forState:UIControlStateNormal];
        leftButton.imageViewSize = CGSizeMake(20, 20);
        leftButton.frame = CGRectMake(0, 0, leftButton.appropriateSize.width, 40);
        //        [self.viewController setNavCustomLeftView:leftButton];
        self.viewController.hd_navLeftBarButtonItems = @[ [[UIBarButtonItem alloc] initWithCustomView:leftButton] ];
        // 需要一直存活 响应点击事件
        self.isCompleteResponseDestroyMonitor = NO;
    } else {
        webFeatureResponse(self, [self responseFailureWithReason:@"params error"]);
    }
}

- (void)leftButtonAction:(HDCommonButton *)button {
    if (HDIsStringNotEmpty(self.viewController.backfunctionName)) {
        self.webFeatureResponse(self, [NSString stringWithFormat:@"window.%@()", self.viewController.backfunctionName]);
    } else {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}

@end

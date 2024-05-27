//
//  PNUploadImageViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadImageViewModel.h"
#import "HDAppTheme+PayNow.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation PNUploadImageViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.uploadImageViewLineWidth = PixelOne;
        self.subTitleFont = HDAppTheme.PayNowFont.standard15;
        self.subTitleColor = HDAppTheme.PayNowColor.c343B4D;
        self.subTitleAlignment = NSTextAlignmentLeft;
        self.subTitleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(-15));
    }
    return self;
}
@end

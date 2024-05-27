//
//  TNTakePhotoConfig.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTakePhotoConfig.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>


@implementation TNTakePhotoConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineSpace = 5;
        self.lineCount = 6;
        self.maxPhotoNum = 6;
        self.titleAndImagesSpace = 10;
        self.themeColor = HDAppTheme.TinhNowColor.C1;
        self.desFont = HDAppTheme.TinhNowFont.standard14;
        self.desColor = HDAppTheme.TinhNowColor.G1;
        self.contentInset = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
    }
    return self;
}
@end

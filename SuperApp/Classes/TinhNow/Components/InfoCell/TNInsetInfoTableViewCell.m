//
//  TNInsetInfoTableViewCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNInsetInfoTableViewCell.h"


@implementation TNInsetInfoTableViewCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}

@end

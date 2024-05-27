//
//  UIButton+sizeToFit.m
//  ViPay
//
//  Created by seeu on 2019/6/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UIButton+sizeToFit.h"


@implementation UIButton (sizeToFit)

- (CGSize)fitSizeForCurrentTitleWithSize:(CGSize)size {
    NSString *title = [self currentTitle];
    NSMutableParagraphStyle *paragraphStype = [[NSMutableParagraphStyle alloc] init];
    paragraphStype.lineSpacing = 5;
    paragraphStype.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font, NSParagraphStyleAttributeName: paragraphStype};
    return [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
}

@end

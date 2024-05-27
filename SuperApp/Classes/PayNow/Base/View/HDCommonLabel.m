//
//  HDCommonLabel.m
//  customer
//
//  Created by VanJay on 2019/4/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonLabel.h"


@implementation HDCommonLabel
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];

    rect.origin.x -= insets.left;
    rect.origin.y -= insets.top;
    rect.size.width += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);

    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}
@end

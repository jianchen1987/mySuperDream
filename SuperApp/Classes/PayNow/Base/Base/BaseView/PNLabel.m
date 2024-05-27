//
//  PNLabel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLabel.h"


@implementation PNLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (self.verticalAlignment) {
        CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
        switch (self.verticalAlignment) {
            case PNVerticalAlignmentTop:
                textRect.origin.y = bounds.origin.y;
                break;
            case PNVerticalAlignmentBottom:
                textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
                break;
            case PNVerticalAlignmentMiddle:
                // Fall through.
            default:
                textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
        }
        return textRect;
    }
    UIEdgeInsets insets = self.hd_edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];

    rect.origin.x -= insets.left;
    rect.origin.y -= insets.top;
    rect.size.width += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    if (self.verticalAlignment) {
        CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:actualRect];
    } else {
        [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.hd_edgeInsets)];
    }
}

- (void)setVerticalAlignment:(PNVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

@end

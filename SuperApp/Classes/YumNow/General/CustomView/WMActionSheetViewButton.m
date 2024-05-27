//
//  WMActionSheetViewButton.m
//  SuperApp
//
//  Created by wmz on 2022/3/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMActionSheetViewButton.h"
#import "WMZPageNaviBtn.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation WMActionSheetViewButton

+ (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(HDActionSheetViewButtonType)type handler:(HDActionSheetViewButtonHandler)handler {
    WMActionSheetViewButton *btn = [[WMActionSheetViewButton alloc] initWithTitle:title type:type handler:handler];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGFloat labWidth = self.titleLabel.bounds.size.width;
    CGFloat labHeight = self.titleLabel.bounds.size.height;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    labWidth = MAX(labWidth, frameSize.width);
    labHeight = MIN(labHeight, frameSize.height);
    CGFloat kMargin = kRealWidth(8);
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -kMargin, 0, kMargin)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, kMargin, 0, -kMargin)];
    self.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(20), 0, 0);
}

@end

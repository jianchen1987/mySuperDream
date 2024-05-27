//
//  TNTagButton.m
//  SuperApp
//
//  Created by 张杰 on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductTagButton.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>


@interface TNProductTagButton ()
///
@property (strong, nonatomic) CAShapeLayer *shadowLayer;
@end


@implementation TNProductTagButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:HDAppTheme.TinhNowColor.c5d667f forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        @HDWeakify(self);
        self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            if (self.shadowLayer) {
                [self.shadowLayer removeFromSuperlayer];
                self.shadowLayer = nil;
            }
            self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:20 borderWidth:1 borderColor:self.isSelected ? HDAppTheme.TinhNowColor.C1 : HDAppTheme.TinhNowColor.c5d667f];
        };
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = HDAppTheme.TinhNowColor.C1;
        self.shadowLayer.strokeColor = HDAppTheme.TinhNowColor.C1.CGColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.shadowLayer.strokeColor = HDAppTheme.TinhNowColor.c5d667f.CGColor;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (self.tagSize.width != 0 && self.tagSize.height != 0) {
        return self.tagSize;
    } else {
        return [super sizeThatFits:size];
    }
}
@end

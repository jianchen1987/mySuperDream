//
//  WMPropertyTagButton.m
//  SuperApp
//
//  Created by Chaos on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMPropertyTagButton.h"
#import "SAView.h"


@implementation WMPropertyTagButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (self.isSelected) {
        self.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:191 / 255.0 blue:1 / 255.0 alpha:0.1];
        self.layer.borderColor = [UIColor colorWithRed:254 / 255.0 green:191 / 255.0 blue:1 / 255.0 alpha:1.0].CGColor;
    } else {
        self.backgroundColor = UIColor.clearColor;
        self.layer.borderColor = HDAppTheme.color.G4.CGColor;
    }
}

@end

//
//  PNKeyBoard.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNKeyBoard.h"


@implementation PNKeyBoard

- (instancetype)initKeyboardWithType:(HDKeyBoardType)type theme:(HDKeyBoardTheme *_Nullable)theme isRandom:(BOOL)isRandom {
    self = [super init];
    if (self) {
        self.keyBoard = [HDKeyBoard keyboardWithType:type theme:theme isRandom:isRandom];
        [self addSubview:self.keyBoard];
        self.frame = self.keyBoard.bounds;
    }
    return self;
}

@end

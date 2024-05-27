//
//  TNScrollerView.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNScrollerView.h"


@implementation TNScrollerView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.needRecognizeSimultaneously = YES;
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.needRecognizeSimultaneously;
}

@end

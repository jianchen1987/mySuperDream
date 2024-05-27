//
//  TNGestureTableView.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGestureTableView.h"


@interface TNGestureTableView () <UIGestureRecognizerDelegate>
@end


@implementation TNGestureTableView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

@end

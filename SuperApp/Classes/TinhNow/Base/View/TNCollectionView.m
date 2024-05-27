//
//  TNCollectionView.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionView.h"


@implementation TNCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.needRecognizeSimultaneously;
}

@end

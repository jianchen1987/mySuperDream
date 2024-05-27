//
//  WMHomeCollectionView.m
//  SuperApp
//
//  Created by wmz on 2022/3/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeCollectionView.h"


@implementation WMHomeCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}


@end

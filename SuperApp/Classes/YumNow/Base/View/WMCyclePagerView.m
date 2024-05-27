//
//  WMCyclePagerView.m
//  SuperApp
//
//  Created by wmz on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCyclePagerView.h"


@implementation WMCyclePagerView
///重写偏移一定距离
- (CGFloat)caculateOffsetXAtIndexSection:(HDIndexSection)indexSection {
    NSInteger numberOfItems = [[self valueForKey:@"numberOfItems"] integerValue];
    if (numberOfItems == 0) {
        return 0;
    }
    UICollectionView *collectionView = [self valueForKey:@"collectionView"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    UIEdgeInsets edge = self.isInfiniteLoop ? self.layout.sectionInset : self.layout.onlyOneSectionInset;
    CGFloat leftEdge = edge.left;
    CGFloat rightEdge = edge.right;
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat itemWidth = layout.itemSize.width + layout.minimumInteritemSpacing;
    CGFloat offsetX = 0;
    if (!self.isInfiniteLoop && !self.layout.itemHorizontalCenter && indexSection.index == numberOfItems - 1) {
        offsetX = leftEdge + itemWidth * (indexSection.index + indexSection.section * numberOfItems) - (width - itemWidth) - layout.minimumInteritemSpacing + rightEdge;
    } else {
        offsetX = leftEdge + itemWidth * (indexSection.index + indexSection.section * numberOfItems) - layout.minimumInteritemSpacing / 2 - (width - itemWidth) / 2;
    }
    return MAX(offsetX + self.distance, 0);
}

///防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end

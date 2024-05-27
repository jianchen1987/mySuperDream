//
//  UICollectionViewWaterfallLayout.m
//  SuperApp
//
//  Created by VanJay on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UICollectionViewWaterfallLayout.h"
#import <HDKitCore/HDKitCore.h>


@implementation UICollectionViewWaterfallLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *originalAttributes = [super layoutAttributesForElementsInRect:rect];

    if (!HDIsArrayEmpty(originalAttributes)) {
        // 只处理 cell 类型
        NSArray<UICollectionViewLayoutAttributes *> *attributes = [originalAttributes hd_filterWithBlock:^BOOL(UICollectionViewLayoutAttributes *_Nonnull item) {
            return item.representedElementCategory == UICollectionElementCategoryCell;
        }];
        // 按 section 分组
        NSMutableDictionary<NSNumber *, NSMutableArray<UICollectionViewLayoutAttributes *> *> *sectionElements = [NSMutableDictionary dictionary];
        for (UICollectionViewLayoutAttributes *attr in attributes) {
            NSNumber *sectionIndex = [NSNumber numberWithInteger:attr.indexPath.section];
            NSMutableArray *attrsInSection = sectionElements[sectionIndex];
            if (!attrsInSection) {
                attrsInSection = [NSMutableArray array];
                sectionElements[sectionIndex] = attrsInSection;
            }
            [attrsInSection addObject:attr];
        }

        [sectionElements enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull section, NSArray<UICollectionViewLayoutAttributes *> *_Nonnull elements, BOOL *_Nonnull stop) {
            [self alignToTopSameSectionElements:elements];
        }];
        return originalAttributes;
    }
    return [super layoutAttributesForElementsInRect:rect];
}

- (void)alignToTopSameSectionElements:(NSArray<UICollectionViewLayoutAttributes *> *)elements {
    // 按列分组
    NSMutableDictionary<NSNumber *, NSMutableArray<UICollectionViewLayoutAttributes *> *> *columElements = [NSMutableDictionary dictionary];

    for (UICollectionViewLayoutAttributes *attr in elements) {
        NSNumber *midX = [NSNumber numberWithFloat:CGRectGetMidX(attr.frame)];
        NSMutableArray *attrsInColumn = columElements[midX];
        if (!attrsInColumn) {
            attrsInColumn = [NSMutableArray array];
            columElements[midX] = attrsInColumn;
        }
        [attrsInColumn addObject:attr];
    }

    [columElements enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull columIndex, NSMutableArray<UICollectionViewLayoutAttributes *> *_Nonnull object, BOOL *_Nonnull stop) {
        NSMutableArray<UICollectionViewLayoutAttributes *> *columElement = object;
        [columElement sortUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *_Nonnull obj1, UICollectionViewLayoutAttributes *_Nonnull obj2) {
            return obj1.indexPath.item < obj2.indexPath.item;
        }];

        __block CGFloat lastY = 0;
        [columElement enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_Nonnull element, NSUInteger index, BOOL *_Nonnull stop) {
            // 单组第一行
            BOOL isFirstRowItemInSection = index == 0;
            if (isFirstRowItemInSection) {
                UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:element.indexPath.section];
                lastY += sectionInset.top;
            } else {
                CGFloat minimumLineSpacing = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:element.indexPath.section];
                lastY += minimumLineSpacing;
            }
            CGRect frame = element.frame;
            frame.origin.y = lastY;
            lastY += frame.size.height;
            element.frame = frame;
        }];
    }];
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        id delegate = self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id delegate = self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}
@end

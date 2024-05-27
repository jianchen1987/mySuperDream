//
//  NSArray+SASudokuMasonry.m
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "NSArray+SASudokuMasonry.h"


@implementation NSArray (SASudokuMasonry)
#pragma mark - public methods
- (void)sa_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                   fixedItemHeight:(CGFloat)fixedItemHeight
                                       columnCount:(NSInteger)columnCount
                                        topSpacing:(CGFloat)topSpacing
                                     bottomSpacing:(CGFloat)bottomSpacing
                                       leadSpacing:(CGFloat)leadSpacing
                                       tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count > 1, @"需要布局的子控件不能少于两个");
        return;
    }
    if (columnCount < 1) {
        NSAssert(false, @"列数不能小于 1");
        return;
    }

    MAS_VIEW *tempSuperView = [self hd_commonSuperviewOfViews];

    NSInteger rowCount = self.count % columnCount == 0 ? self.count / columnCount : self.count / columnCount + 1;

    MAS_VIEW *prev;
    for (int i = 0; i < self.count; i++) {
        MAS_VIEW *v = self[i];

        // 当前行
        NSInteger currentRow = i / columnCount;
        // 当前列
        NSInteger currentColumn = i % columnCount;

        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            // 固定宽度
            make.width.equalTo(@(fixedItemWidth));
            make.height.equalTo(@(fixedItemHeight));

            // 第一行
            if (currentRow == 0) {
                make.top.equalTo(tempSuperView).offset(topSpacing);
            }
            // 最后一行
            if (currentRow == rowCount - 1) {
                make.bottom.equalTo(tempSuperView).offset(-bottomSpacing);
            }
            // 中间的若干行
            if (currentRow != 0 && currentRow != rowCount - 1) {
                CGFloat offset = (1 - (currentRow / ((CGFloat)rowCount - 1))) * (fixedItemHeight + topSpacing) - currentRow * bottomSpacing / (((CGFloat)rowCount - 1));
                make.bottom.equalTo(tempSuperView).multipliedBy(currentRow / ((CGFloat)rowCount - 1)).offset(offset);
            }

            // 第一列
            if (currentColumn == 0) {
                make.left.equalTo(tempSuperView).offset(leadSpacing);
            }
            // 最后一列
            if (currentColumn == columnCount - 1) {
                make.right.equalTo(tempSuperView).offset(-tailSpacing);
            }
            // 中间若干列
            if (currentColumn != 0 && currentColumn != columnCount - 1) {
                CGFloat offset = (1 - (currentColumn / ((CGFloat)columnCount - 1))) * (fixedItemWidth + leadSpacing) - currentColumn * tailSpacing / (((CGFloat)columnCount - 1));
                make.right.equalTo(tempSuperView).multipliedBy(currentColumn / ((CGFloat)columnCount - 1)).offset(offset);
            }
        }];
        prev = v;
    }
}

- (void)sa_distributeSudokuViewsWithFixedLineSpacing:(CGFloat)fixedLineSpacing
                               fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                         columnCount:(NSInteger)columnCount
                                          topSpacing:(CGFloat)topSpacing
                                       bottomSpacing:(CGFloat)bottomSpacing
                                         leadSpacing:(CGFloat)leadSpacing
                                         tailSpacing:(CGFloat)tailSpacing {
    [self sa_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:fixedLineSpacing fixedInteritemSpacing:fixedInteritemSpacing columnCount:columnCount heightToWidthScale:0
                                          topSpacing:topSpacing
                                       bottomSpacing:bottomSpacing
                                         leadSpacing:leadSpacing
                                         tailSpacing:tailSpacing];
}

- (void)sa_distributeSudokuViewsWithFixedLineSpacing:(CGFloat)fixedLineSpacing
                               fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                         columnCount:(NSInteger)columnCount
                                  heightToWidthScale:(float)heightToWidthScale
                                          topSpacing:(CGFloat)topSpacing
                                       bottomSpacing:(CGFloat)bottomSpacing
                                         leadSpacing:(CGFloat)leadSpacing
                                         tailSpacing:(CGFloat)tailSpacing {
    [self sa_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:fixedLineSpacing fixedInteritemSpacing:fixedInteritemSpacing columnCount:columnCount
                                  heightToWidthScale:heightToWidthScale
                                          topSpacing:topSpacing
                                       bottomSpacing:bottomSpacing
                                         leadSpacing:leadSpacing
                                         tailSpacing:tailSpacing];
}

- (NSArray *)sa_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                        fixedItemHeight:(CGFloat)fixedItemHeight
                                       fixedLineSpacing:(CGFloat)fixedLineSpacing
                                  fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                            columnCount:(NSInteger)columnCount
                                             topSpacing:(CGFloat)topSpacing
                                          bottomSpacing:(CGFloat)bottomSpacing
                                            leadSpacing:(CGFloat)leadSpacing
                                            tailSpacing:(CGFloat)tailSpacing {
    return [self sa_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:fixedLineSpacing fixedInteritemSpacing:fixedInteritemSpacing columnCount:columnCount
                                         heightToWidthScale:0
                                                 topSpacing:topSpacing
                                              bottomSpacing:bottomSpacing
                                                leadSpacing:leadSpacing
                                                tailSpacing:tailSpacing];
}

- (NSArray *)sa_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                        fixedItemHeight:(CGFloat)fixedItemHeight
                                       fixedLineSpacing:(CGFloat)fixedLineSpacing
                                  fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                            columnCount:(NSInteger)columnCount
                                     heightToWidthScale:(float)heightToWidthScale
                                             topSpacing:(CGFloat)topSpacing
                                          bottomSpacing:(CGFloat)bottomSpacing
                                            leadSpacing:(CGFloat)leadSpacing
                                            tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 1) {
        return self.copy;
    }
    if (columnCount < 1) {
        NSAssert(false, @"列数不能小于 1");
        return self.copy;
    }

    MAS_VIEW *tempSuperView = [self hd_commonSuperviewOfViews];

    NSArray<MAS_VIEW *> *tempViews = self.copy;
    if (columnCount > self.count) {
        for (int i = 0; i < columnCount - self.count; i++) {
            MAS_VIEW *tempView = [[MAS_VIEW alloc] init];
            [tempSuperView addSubview:tempView];
            tempViews = [tempViews arrayByAddingObject:tempView];
        }
    }

    NSInteger rowCount = tempViews.count % columnCount == 0 ? tempViews.count / columnCount : tempViews.count / columnCount + 1;

    MAS_VIEW *prev;
    for (int i = 0; i < tempViews.count; i++) {
        MAS_VIEW *v = tempViews[i];
        NSInteger currentRow = i / columnCount;
        NSInteger currentColumn = i % columnCount;

        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prev) {
                // 固定宽度
                make.width.equalTo(prev);
                make.height.equalTo(prev);
            } else {
                // 如果写的item高宽分别是0，则表示自适应
                if (fixedItemWidth > 0) {
                    make.width.equalTo(@(fixedItemWidth));
                }
                // 比例优先级更高
                if (heightToWidthScale > 0) {
                    make.height.equalTo(v.mas_width).multipliedBy(heightToWidthScale);
                } else if (fixedItemHeight > 0) {
                    make.height.equalTo(@(fixedItemHeight));
                }
            }

            // 第一行
            if (currentRow == 0) {
                make.top.equalTo(tempSuperView).offset(topSpacing);
            }
            // 最后一行
            if (currentRow == rowCount - 1) {
                // 如果只有一行
                if (currentRow != 0 && i - columnCount >= 0) {
                    make.top.equalTo(tempViews[i - columnCount].mas_bottom).offset(fixedLineSpacing);
                }
                make.bottom.equalTo(tempSuperView).offset(-bottomSpacing);
            }
            // 中间的若干行
            if (currentRow != 0 && currentRow != rowCount - 1) {
                make.top.equalTo(tempViews[i - columnCount].mas_bottom).offset(fixedLineSpacing);
            }

            // 第一列
            if (currentColumn == 0) {
                make.left.equalTo(tempSuperView).offset(leadSpacing);
            }
            // 最后一列
            if (currentColumn == columnCount - 1) {
                // 如果只有一列
                if (currentColumn != 0) {
                    make.left.equalTo(prev.mas_right).offset(fixedInteritemSpacing);
                }
                make.right.equalTo(tempSuperView).offset(-tailSpacing);
            }
            // 中间若干列
            if (currentColumn != 0 && currentColumn != columnCount - 1) {
                make.left.equalTo(prev.mas_right).offset(fixedInteritemSpacing);
            }
        }];
        prev = v;
    }
    return tempViews;
}

#pragma mark - private methods
- (MAS_VIEW *)hd_commonSuperviewOfViews {
    if (self.count == 1) {
        return ((MAS_VIEW *)self.firstObject).superview;
    }

    MAS_VIEW *commonSuperview = nil;
    MAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[MAS_VIEW class]]) {
            MAS_VIEW *view = (MAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view mas_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"请确保所有子控件已添加到 superView");
    return commonSuperview;
}
@end

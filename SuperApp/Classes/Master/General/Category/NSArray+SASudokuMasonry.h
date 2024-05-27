//
//  NSArray+SASudokuMasonry.h
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSArray <ObjectType>(SASudokuMasonry)

/**
 *  九宫格布局 固定 itemSize 可变 itemSpacing
 *
 *  @param fixedItemWidth  固定宽度
 *  @param fixedItemHeight 固定高度
 *  @param columnCount     列数
 *  @param topSpacing      顶间距
 *  @param bottomSpacing   底间距
 *  @param leadSpacing     左间距
 *  @param tailSpacing     右间距
 */
- (void)sa_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                   fixedItemHeight:(CGFloat)fixedItemHeight
                                       columnCount:(NSInteger)columnCount
                                        topSpacing:(CGFloat)topSpacing
                                     bottomSpacing:(CGFloat)bottomSpacing
                                       leadSpacing:(CGFloat)leadSpacing
                                       tailSpacing:(CGFloat)tailSpacing;

/**
 *  九宫格布局 可变 itemSize 固定 itemSpacing
 *
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param columnCount           列数
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 */
- (void)sa_distributeSudokuViewsWithFixedLineSpacing:(CGFloat)fixedLineSpacing
                               fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                         columnCount:(NSInteger)columnCount
                                          topSpacing:(CGFloat)topSpacing
                                       bottomSpacing:(CGFloat)bottomSpacing
                                         leadSpacing:(CGFloat)leadSpacing
                                         tailSpacing:(CGFloat)tailSpacing;

/**
 *  九宫格布局 可变 itemSize 固定 itemSpacing，高宽固定比例
 *
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param columnCount           列数
 *  @param heightToWidthScale    高宽比
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 */
- (void)sa_distributeSudokuViewsWithFixedLineSpacing:(CGFloat)fixedLineSpacing
                               fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                         columnCount:(NSInteger)columnCount
                                  heightToWidthScale:(float)heightToWidthScale
                                          topSpacing:(CGFloat)topSpacing
                                       bottomSpacing:(CGFloat)bottomSpacing
                                         leadSpacing:(CGFloat)leadSpacing
                                         tailSpacing:(CGFloat)tailSpacing;

/**
 *  九宫格布局 固定 itemSize 固定 itemSpacing
 *  可由九宫格的内容控制SuperView的大小
 *  如果columnCount大于[self count]，该方法将会用空白的View填充到superview中
 *
 *  Sudoku Layout, has fixed item size, and fix item space
 *  If warp count greater than self.count, It's fill empty view to superview
 *
 *  @param fixedItemWidth        固定宽度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
 *  @param fixedItemHeight       固定高度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param columnCount           列数
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 *
 *  @return 一般情况下会返回[self copy], 如果columnCount大于[self count]，则会返回一个被空白view填充过的数组，可以让你循环调用removeFromSuperview或者干一些其他的事情;
 *  @return Normal will return [self copy], If columnCount bigger than [self count] , It will return a empty views filled array, you could enumerate [subview removeFromSuperview] or do other things;
 */
- (NSArray *)sa_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                        fixedItemHeight:(CGFloat)fixedItemHeight
                                       fixedLineSpacing:(CGFloat)fixedLineSpacing
                                  fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                            columnCount:(NSInteger)columnCount
                                             topSpacing:(CGFloat)topSpacing
                                          bottomSpacing:(CGFloat)bottomSpacing
                                            leadSpacing:(CGFloat)leadSpacing
                                            tailSpacing:(CGFloat)tailSpacing;

/**
 *  九宫格布局 固定 itemSize 固定 itemSpacing，固定高宽比（优先级高于 fixedItemHeight）
 *  可由九宫格的内容控制SuperView的大小
 *  如果columnCount大于[self count]，该方法将会用空白的View填充到superview中
 *
 *  Sudoku Layout, has fixed item size, and fix item space
 *  If warp count greater than self.count, It's fill empty view to superview
 *
 *  @param fixedItemWidth        固定宽度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
 *  @param fixedItemHeight       固定高度，如果设置成0，则表示自适应，If set it to zero, indicates the adaptive.
 *  @param fixedLineSpacing      行间距
 *  @param fixedInteritemSpacing 列间距
 *  @param columnCount           列数
 *  @param heightToWidthScale    高宽比
 *  @param topSpacing            顶间距
 *  @param bottomSpacing         底间距
 *  @param leadSpacing           左间距
 *  @param tailSpacing           右间距
 *
 *  @return 一般情况下会返回[self copy], 如果columnCount大于[self count]，则会返回一个被空白view填充过的数组，可以让你循环调用removeFromSuperview或者干一些其他的事情;
 *  @return Normal will return [self copy], If columnCount bigger than [self count] , It will return a empty views filled array, you could enumerate [subview removeFromSuperview] or do other things;
 */
- (NSArray *)sa_distributeSudokuViewsWithFixedItemWidth:(CGFloat)fixedItemWidth
                                        fixedItemHeight:(CGFloat)fixedItemHeight
                                       fixedLineSpacing:(CGFloat)fixedLineSpacing
                                  fixedInteritemSpacing:(CGFloat)fixedInteritemSpacing
                                            columnCount:(NSInteger)columnCount
                                     heightToWidthScale:(float)heightToWidthScale
                                             topSpacing:(CGFloat)topSpacing
                                          bottomSpacing:(CGFloat)bottomSpacing
                                            leadSpacing:(CGFloat)leadSpacing
                                            tailSpacing:(CGFloat)tailSpacing;
@end

NS_ASSUME_NONNULL_END

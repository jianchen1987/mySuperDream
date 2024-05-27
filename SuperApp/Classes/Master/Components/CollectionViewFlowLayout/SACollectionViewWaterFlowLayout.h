//
//  SACollectionViewWaterFlowLayout.h
//  SuperApp
//
//  Created by VanJay on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAWaterFlowLayoutStyle) {
    SAWaterFlowVerticalEqualWidth = 0,    /** 竖向瀑布流 item等宽不等高 */
    SAWaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图 */
    SAWaterFlowVerticalEqualHeight = 2,   /** 竖向瀑布流 item等高不等宽 */
    SAWaterFlowHorizontalGrid = 3,        /** 水平栅格布局 */
};

@class SACollectionViewWaterFlowLayout;

@protocol SACollectionViewWaterFlowLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为SAWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 SAWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 SAWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 SAWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/** 头视图Size */
- (CGSize)waterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
- (CGSize)waterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

// 以下都有默认值
/** 列数 */
- (NSUInteger)columnCountInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout;
/** 行数 */
- (NSUInteger)rowCountInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout;

/** 列间距 */
- (CGFloat)columnMarginInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout;
/** 行间距 */
- (CGFloat)rowMarginInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout;
/** 边缘之间的间距 */
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(SACollectionViewWaterFlowLayout *)waterFlowLayout;

@end


@interface SACollectionViewWaterFlowLayout : UICollectionViewLayout

/** delegate */
@property (nonatomic, weak) id<SACollectionViewWaterFlowLayoutDelegate> delegate;
/** 瀑布流样式 */
@property (nonatomic, assign) SAWaterFlowLayoutStyle flowLayoutStyle;

/** 内容的高度 */
@property (nonatomic, assign, readonly) CGFloat maxColumnHeightInAllColumn;

@end

NS_ASSUME_NONNULL_END

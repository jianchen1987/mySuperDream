///
//  HDCollectionViewBaseFlowLayout.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionCellBaseEventModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDCollectionLayoutType) {
    HDCollectionLayoutTypeLabelHorizontal = 1,                           ///< 标签横向
    HDCollectionLayoutTypeLabelVertical = 2,                             ///< 标签纵向
    HDCollectionLayoutTypeLabel = HDCollectionLayoutTypeLabelHorizontal, ///< 标签横向
    HDCollectionLayoutTypeClosest = 3,                                   ///< 标签横向
    HDCollectionLayoutTypeColumn = HDCollectionLayoutTypeClosest, ///< 列布局，指定列数，按列数来等分一整行，itemSize的width可以任意写，在布局中会自动帮你计算。可用于瀑布流
    HDCollectionLayoutTypePercent = 4,                            ///< 百分比，需实现 percentOfRow 的代理，根据设定值来计算每个 itemSize 的宽度
    HDCollectionLayoutTypeFill = 5,     ///< 填充，将一堆大小不一的view见缝插针的填充到一个平面内，规则为先判断从左到右是否有间隙填充，再从上到下判断
    HDCollectionLayoutTypeAbsolute = 6, ///< 绝对定位布局，需实现rectOfItem的代理，指定每个item的frame
};

@class HDCollectionViewBaseFlowLayout;
@protocol HDCollectionViewBaseFlowLayoutDelegate <NSObject, UICollectionViewDelegateFlowLayout>
@optional
/** 指定是什么布局，如没有指定则为HDCollectionLayoutTypeFill(填充式布局) */
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section;

#pragma mark - 设置每个section的背景色
/** 设置每个section的背景色 */
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout backColorForSection:(NSInteger)section;

/** 设置每个section的背景图 */
- (UIImage *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout backImageForSection:(NSInteger)section;

/** 自定义每个section的背景view，需要继承UICollectionReusableView(如要调用方法传递参数需要继承HDCollectionBaseDecorationView)，返回类名 */
- (NSString *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout registerBackView:(NSInteger)section;

/** 向每个section自定义背景view传递自定义方法 eventName:方法名（注意带参数的方法名必须末尾加:）,parameter:参数 */
- (HDCollectionCellBaseEventModel *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout backgroundViewMethodForSection:(NSInteger)section;

//背景是否延伸覆盖到headerView，默认为NO
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout attachToTop:(NSInteger)section;

/** 背景是否延伸覆盖到footerView，默认为NO */
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout attachToBottom:(NSInteger)section;

#pragma mark - 提取出UICollectionViewLayoutAttributes的一些属性
/** 设置每个item的zIndex，不指定默认为0 */
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout zIndexOfItem:(NSIndexPath *)indexPath;
/** 设置每个item的CATransform3D，不指定默认为CATransform3DIdentity */
- (CATransform3D)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout transformOfItem:(NSIndexPath *)indexPath;
/** 设置每个item的alpha，不指定默认为1 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout alphaOfItem:(NSIndexPath *)indexPath;

#pragma mark - HDCollectionLayoutTypeClosest列布局需要的代理
/** 在HDCollectionLayoutTypeClosest列布局中指定一行有几列，不指定默认为1列 */
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section;

#pragma mark - HDCollectionLayoutTypePercent百分比布局需要的代理
/** 在HDCollectionLayoutTypePercent百分比布局中指定每个item占该行的几分之几，如3.0/4，注意为大于0小于等于1的数字。不指定默认为1 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout percentOfRow:(NSIndexPath *)indexPath;

#pragma mark - HDCollectionLayoutTypeAbsolute绝对定位布局需要的代理
/** 在HDCollectionLayoutTypeAbsolute绝对定位布局中指定每个item的frame，不指定默认为CGRectZero */
- (CGRect)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout rectOfItem:(NSIndexPath *)indexPath;

/** 拖动cell的相关代理 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout didMoveCell:(NSIndexPath *)atIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

/***
 此类是基类，不要调用。
 ***/
@interface HDCollectionViewBaseFlowLayout : UICollectionViewFlowLayout
/// 代理
@property (nonatomic, weak) id<HDCollectionViewBaseFlowLayoutDelegate> delegate;
/// 宽度是否向下取整，默认YES，用于填充布局，未来加入百分比布局
@property (nonatomic, assign) BOOL isFloor;
/// 是否允许拖动cell，默认是 NO
@property (nonatomic, assign) BOOL canDrag;
/// 头部是否悬浮，默认是NO
@property (nonatomic, assign) BOOL header_suspension;
/// 指定layout的类型，也可以在代理里设置
@property (nonatomic, assign) HDCollectionLayoutType layoutType;
/// 指定列数
@property (nonatomic, assign) NSInteger columnCount;
/// header 偏移量
@property (nonatomic, assign) CGFloat headerOffsetY;

/// 存放每个section的每一列的高度
@property (nonatomic, strong) NSMutableArray *collectionHeightsArray;
/// 存放每一个cell的属性
@property (nonatomic, strong) NSMutableArray *attributesArray;
/// 存放header属性, 外部不要干预
@property (nonatomic, strong, readonly) NSMutableArray *headerAttributesArray;

/// 是否需要重新计算所有布局
/// 内部控制，一般情况外部无需干预(内部会在外部调用reloadData,insertSections,insertItems,deleteItems...等方法调用时将此属性自动置为yYES)
@property (nonatomic, assign, readonly) BOOL isNeedReCalculateAllLayout;

/// 提供一个方法来设置isNeedReCalculateAllLayout (之所以提供是因为特殊情况下外部可能需要强制重新计算布局)
/// 比如需要强制刷新布局时，可以先调用此函数设置为YES, 一般情况外部无需干预
- (void)forceSetIsNeedReCalculateAllLayout:(BOOL)isNeedReCalculateAllLayout;

/// 注册所有的背景view(传入类名)
- (void)registerDecorationView:(NSArray<NSString *> *)classNames;

@end

NS_ASSUME_NONNULL_END

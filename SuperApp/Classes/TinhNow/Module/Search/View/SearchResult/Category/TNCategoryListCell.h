//
//  TNCategoryListCell.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "TNCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TNCategoryListCellDisplayType) {
    ///普通分类结果页样式
    TNCategoryListCellDisplayTypeNormal = 0,
    ///店铺样式
    TNCategoryListCellDisplayTypeStore = 1,
};


@interface TNCategoryListCellModel : NSObject
@property (nonatomic, strong) NSArray<TNCategoryModel *> *list;
/// 高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 文本高度  只要有一个商品超过两行  就是两行的高度
@property (nonatomic, assign) CGFloat labelHeight;
/// 是否需要滚动到已选中的地方
@property (nonatomic, assign) BOOL isNeedScrollerToSelected;
/// 滚动过去的位置
@property (nonatomic, assign) NSInteger scrollerToIndex;
/// 样式类型
@property (nonatomic, assign) TNCategoryListCellDisplayType displayType;
@end


@interface TNCategoryListCell : TNCollectionViewCell

@property (nonatomic, strong) TNCategoryListCellModel *model;
/// 点击选中回调
@property (nonatomic, copy) void (^categorySelectedCallBack)(TNCategoryModel *cModel);
/// 更多点击回调
@property (nonatomic, copy) void (^moreCategoryClickCallBack)(void);

@end

NS_ASSUME_NONNULL_END

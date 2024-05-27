//
//  SAKingKongAreaViewWrapperCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNKingKongAreaViewWrapperCellModel : NSObject
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface TNKingKongAreaViewWrapperCell : TNCollectionViewCell
@property (nonatomic, copy) void (^canNotOpenRouteHandler)(NSString *urlString); ///< 无法打开路由
@property (nonatomic, strong) TNKingKongAreaViewWrapperCellModel *model;         ///< 模型

/// 刷新
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END

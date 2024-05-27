//
//  TNHotSalesListCell.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
@class TNGoodsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNHotSalesListCellModel : NSObject
@property (nonatomic, strong) NSArray<TNGoodsModel *> *list;
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface TNHotSalesListCell : TNCollectionViewCell
@property (nonatomic, strong) TNHotSalesListCellModel *model;
@end

NS_ASSUME_NONNULL_END

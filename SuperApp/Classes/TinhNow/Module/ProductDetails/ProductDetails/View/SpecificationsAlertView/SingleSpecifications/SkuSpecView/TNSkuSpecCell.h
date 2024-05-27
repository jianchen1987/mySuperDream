//
//  TNSpecificationCollectionCell.h
//  SuperApp
//
//  Created by xixi on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSkuSpecCell : SACollectionViewCell

/// 显示名字
@property (nonatomic, strong) NSString *specNameStr;

/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

/// 是否有库存
@property (nonatomic, assign) BOOL hasStock;
@end

NS_ASSUME_NONNULL_END

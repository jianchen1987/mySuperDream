//
//  SAOrderListFilterCollectionViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListFilterCollectionViewCell : SACollectionViewCell
/// 显示名字
@property (nonatomic, strong) NSString *text;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END

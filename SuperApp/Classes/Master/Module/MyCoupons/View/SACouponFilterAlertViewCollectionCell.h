//
//  SACouponFilterAlertViewCollectionCell.h
//  SuperApp
//
//  Created by Tia on 2022/7/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

#define kSACouponFilterAlertViewCollectionCellFont [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]


@interface SACouponFilterAlertViewCollectionCell : SACollectionViewCell
/// 显示名字
@property (nonatomic, strong) NSString *text;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END

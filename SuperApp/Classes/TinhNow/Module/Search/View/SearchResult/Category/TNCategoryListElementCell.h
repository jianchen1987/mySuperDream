//
//  TNCategoryListElementCell.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "TNCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCategoryListElementCell : TNCollectionViewCell
/// 不显示选中效果
@property (nonatomic, assign) BOOL notShowSelectedStyle;
@property (nonatomic, strong) TNCategoryModel *model;
/// 点击回调
@property (nonatomic, copy) void (^itemClickCallBack)(TNCategoryModel *model);
@end

NS_ASSUME_NONNULL_END

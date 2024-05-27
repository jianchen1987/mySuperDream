//
//  TNCategoryChooseCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;


@interface TNCategoryChooseCell : SATableViewCell
/// 模型
@property (strong, nonatomic) TNCategoryModel *model;
/// cell点击
@property (nonatomic, copy) void (^tapClickCallBack)(TNCategoryModel *selectedModel);
@end

NS_ASSUME_NONNULL_END

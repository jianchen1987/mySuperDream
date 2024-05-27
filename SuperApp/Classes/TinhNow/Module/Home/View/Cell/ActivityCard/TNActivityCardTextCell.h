//
//  TNActivityTextItemCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNActivityCardModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNActivityCardTextCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNActivityCardModel *cardModel;
@end

NS_ASSUME_NONNULL_END

//
//  SASearchAddressResultTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressAutoCompleteItem.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchAddressResultTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SAAddressAutoCompleteItem *model;
@end

NS_ASSUME_NONNULL_END

//
//  TNExpressContactCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNExpressContactCellModel : NSObject
///
@property (strong, nonatomic) NSArray *telegrams;
///
@property (strong, nonatomic) NSArray *phones;
@end


@interface TNExpressContactCell : SATableViewCell
///
@property (strong, nonatomic) TNExpressContactCellModel *model;
@end

NS_ASSUME_NONNULL_END

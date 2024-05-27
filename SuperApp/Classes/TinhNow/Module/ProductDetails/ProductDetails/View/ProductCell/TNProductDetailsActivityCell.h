//
//  TNProductDetailsActivityCell.h
//  SuperApp
//
//  Created by xixi on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

#import "TNProductActivityModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailsActivityCellModel : NSObject

///
@property (nonatomic, strong) TNProductActivityModel *model;

@end


@interface TNProductDetailsActivityCell : SATableViewCell
///
@property (nonatomic, strong) TNProductActivityModel *model;
@end

NS_ASSUME_NONNULL_END

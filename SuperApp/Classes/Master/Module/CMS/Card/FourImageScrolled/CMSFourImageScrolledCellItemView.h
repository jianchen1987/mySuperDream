//
//  CMSFourImageScrolledCellItemView.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSFourImageScrolledItemConfig;


@interface CMSFourImageScrolledCellItemView : SAView

@property (nonatomic, strong) CMSFourImageScrolledItemConfig *model;
/// 点击回调
@property (nonatomic, copy) void (^clickedBlock)(CMSFourImageScrolledItemConfig *model);

@end

NS_ASSUME_NONNULL_END

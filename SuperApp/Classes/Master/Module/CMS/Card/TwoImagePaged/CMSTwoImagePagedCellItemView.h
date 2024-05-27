//
//  CMSTwoImagePagedCellItemView.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class CMSTwoImagePagedItemConfig;


@interface CMSTwoImagePagedCellItemView : SAView

@property (nonatomic, strong) CMSTwoImagePagedItemConfig *model;
/// 点击回调
@property (nonatomic, copy) void (^clickedBlock)(CMSTwoImagePagedItemConfig *model);

@end

NS_ASSUME_NONNULL_END

//
//  SAChooseAreaView.h
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressModel;


@interface SAChooseAddressZoneView : SAView

/// 选择的地区
@property (nonatomic, strong) SAAddressModel *_Nullable model;

@end

NS_ASSUME_NONNULL_END

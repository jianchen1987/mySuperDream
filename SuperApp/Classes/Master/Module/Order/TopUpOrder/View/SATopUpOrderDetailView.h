//
//  WMTopUpOrderDetailView.h
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class SATopUpOrderDetailViewModel;

NS_ASSUME_NONNULL_BEGIN


@interface SATopUpOrderDetailView : SAView

/// model
@property (nonatomic, strong) SATopUpOrderDetailViewModel *model;
/// 唤起收银台
@property (nonatomic, copy) void (^BlockOnToPay)(void);

@end

NS_ASSUME_NONNULL_END

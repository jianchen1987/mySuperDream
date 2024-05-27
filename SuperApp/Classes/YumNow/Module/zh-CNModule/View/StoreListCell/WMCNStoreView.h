//
//  WMCNStoreView.h
//  SuperApp
//
//  Created by Tia on 2023/12/5.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMCNStoreView : SAView
/// 数据
@property (nonatomic, strong) WMBaseStoreModel *model;

@end

NS_ASSUME_NONNULL_END

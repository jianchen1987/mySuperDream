//
//  WMStoreView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreModel.h"
//@class WMStoreModel;

NS_ASSUME_NONNULL_BEGIN

static CGFloat const kStoreImageH2W = 150.0 / 350.0;


@interface WMStoreView : SAView
/// 数据
@property (nonatomic, strong) WMBaseStoreModel *model;
@end

NS_ASSUME_NONNULL_END

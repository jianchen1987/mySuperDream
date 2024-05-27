//
//  WMNearbyStoreTagsMode.h
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNearbyStoreTagsModel : WMModel
/// name
@property (nonatomic, copy) NSString *key;
/// value
@property (nonatomic, copy) NSString *value;
/// 是否选中
@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END

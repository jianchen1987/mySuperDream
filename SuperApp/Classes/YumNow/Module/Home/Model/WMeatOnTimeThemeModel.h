//
//  WMeatOnTimeThemeModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMeatOnTimeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMeatOnTimeThemeModel : WMModel
/// id
@property (nonatomic, assign) NSInteger id;
/// name
@property (nonatomic, copy) NSString *title;
/// name
@property (nonatomic, copy) NSArray<WMeatOnTimeModel *> *rel;
@end

NS_ASSUME_NONNULL_END

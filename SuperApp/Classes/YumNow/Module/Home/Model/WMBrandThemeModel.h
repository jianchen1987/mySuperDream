//
//  WMBrandThemeModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMBrandThemeModel : WMModel
/// name
@property (nonatomic, copy) NSString *name;
/// images
@property (nonatomic, copy) NSString *images;
/// link
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END

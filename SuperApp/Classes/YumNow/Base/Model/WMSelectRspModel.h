//
//  WMSelectRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSelectRspModel : WMRspModel
/// select
@property (nonatomic, assign, getter=isSelect) BOOL select;

@property (nonatomic, copy) NSString *showName;

@end

NS_ASSUME_NONNULL_END

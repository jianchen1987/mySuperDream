//
//  WMFAQDetailRspModel.h
//  SuperApp
//
//  Created by wmz on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFAQDetailRspModel : WMModel
/// title
@property (nonatomic, copy) NSString *title;
///内容
@property (nonatomic, copy) NSString *content;
///评价
@property (nonatomic, assign) BOOL isSupport;

@end

NS_ASSUME_NONNULL_END

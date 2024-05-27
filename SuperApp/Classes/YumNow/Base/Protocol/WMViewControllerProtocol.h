//
//  WMViewControllerProtocol.h
//  SuperApp
//
//  Created by wmz on 2023/4/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMEnum.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WMViewControllerProtocol <NSObject>

@optional
///当前页面
- (WMSourceType)currentSourceType;

@end

NS_ASSUME_NONNULL_END

//
//  SAAppEnvMockDataModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAAppEnvMockDataModel : NSObject
/// 路径
@property (nonatomic, copy) NSString *requestURI;
/// 映射文件路径
@property (nonatomic, copy) NSString *jsonPath;
/// 是否开启
@property (nonatomic, assign) BOOL enabled;
@end

NS_ASSUME_NONNULL_END

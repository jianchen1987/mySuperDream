//
//  WMNormalAppModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNormalAppModel : WMModel

@property (nonatomic, copy) NSString *appImageName;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *remarkImageName;

+ (instancetype)normalAppModelWithTitle:(NSString *)title imageName:(NSString *)imageName;
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

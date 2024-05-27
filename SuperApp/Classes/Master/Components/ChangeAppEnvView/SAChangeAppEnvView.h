//
//  SAChangeAppEnvView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class SAAppEnvConfig;

@protocol HDCustomViewActionViewProtocol;

NS_ASSUME_NONNULL_BEGIN


@interface SAChangeAppEnvView : SAView <HDCustomViewActionViewProtocol>
/// 选择了 item 回调
@property (nonatomic, copy) void (^selectedItemHandler)(SAAppEnvConfig *config);

@end

NS_ASSUME_NONNULL_END

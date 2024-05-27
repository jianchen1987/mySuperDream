//
//  TNProductServiceModel.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/9/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNProductServiceModel : TNModel
///名称
@property (nonatomic, copy) NSString *name;
///内容
@property (nonatomic, copy) NSString *content;
@end

NS_ASSUME_NONNULL_END

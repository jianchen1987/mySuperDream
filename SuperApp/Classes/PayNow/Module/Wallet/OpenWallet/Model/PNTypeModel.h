//
//  TypeModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNTypeModel : PNModel
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@end

NS_ASSUME_NONNULL_END

//
//  SAContactPhoneModel.h
//  SuperApp
//
//  Created by Chaos on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SAContactPhoneName NS_TYPED_ENUM;
FOUNDATION_EXPORT SAContactPhoneName const SAContactPhoneNameCallCenter; // 客服电话
FOUNDATION_EXPORT SAContactPhoneName const SAContactPhoneNameTemp;       // 临时电话


@interface SAContactPhoneModel : SAModel

/// 类型
@property (nonatomic, copy) NSString *name;
/// 号码
@property (nonatomic, copy) NSString *num;
/// 图片
@property (nonatomic, copy) NSString *img;
/// 图片
@property (nonatomic, copy) NSString *picture;

@end

NS_ASSUME_NONNULL_END

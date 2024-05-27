//
//  SAContactModel.h
//  SuperApp
//
//  Created by seeu on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAContactModel : SACodingModel
@property (nonatomic, copy) NSString *areaCode; ///< 地区吗
@property (nonatomic, copy) NSString *phone;    ///< 电话
@property (nonatomic, copy) NSString *name;     ///< 名称
@property (nonatomic, copy) NSString *tag;      ///< 标签
@property (nonatomic, copy) NSString *address;  ///< 地址
@property (nonatomic, copy) NSString *email;    ///< 邮箱

@end

NS_ASSUME_NONNULL_END

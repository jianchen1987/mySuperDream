//
//  TNTelegramGroupModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNTelegramGroupModel : TNModel
/// 群名
@property (nonatomic, copy) NSString *title;
/// 介绍
@property (nonatomic, copy) NSString *instruction;
/// 跳转链接
@property (nonatomic, copy) NSString *link;
@end

NS_ASSUME_NONNULL_END

//
//  SAWOWTokenModel.h
//  SuperApp
//
//  Created by Chaos on 2021/3/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWOWTokenSenderModel : SAModel

/// 名称
@property (nonatomic, copy) NSString *name;
/// 头像
@property (nonatomic, copy) NSString *headImageUrl;

@end


@interface SAWOWTokenModel : SAModel

/// 类型
@property (nonatomic, assign) NSInteger type;
/// 发送者
@property (nonatomic, strong) SAWOWTokenSenderModel *sender;
/// 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 描述
@property (nonatomic, strong) SAInternationalizationModel *desc;
/// 背景图
@property (nonatomic, copy) NSString *backgroundImageUrl;
/// 路由地址
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END

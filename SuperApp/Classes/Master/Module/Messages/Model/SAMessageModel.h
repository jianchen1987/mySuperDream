//
//  SAMessageModel.h
//  SuperApp
//
//  Created by seeu on 2021/1/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMessageModel : SAModel
@property (nonatomic, strong) UIImage *headPlaceholderImage; ///< 头像图片
@property (nonatomic, copy, nullable) NSString *headImgUrl;  ///< 头像链接
@property (nonatomic, copy) NSString *title;                 ///< 标题
@property (nonatomic, copy) NSString *content;               ///< 内容
@property (nonatomic, assign) NSTimeInterval sendDate;       ///< 发送时间
@property (nonatomic, assign) NSUInteger bubble;             ///< 气泡数字
@property (nonatomic, strong) id associatedObject;           ///< 关联对象
@property (nonatomic, assign) BOOL isGroup;                  ///< 是否群聊
@end

NS_ASSUME_NONNULL_END

//
//  SAShareObject.h
//  SuperApp
//
//  Created by Chaos on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

// 分享模型基类，实际分享使用其子类
@interface SAShareObject : SAModel

/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;

/** 缩略图数据
 * @note 微信最终分享时使用（facebook使用thumbImage），外部传入则优先使用，否则会自动使用thumbImage转换
 */
@property (nonatomic, strong) NSData *thumbData;

@end

NS_ASSUME_NONNULL_END

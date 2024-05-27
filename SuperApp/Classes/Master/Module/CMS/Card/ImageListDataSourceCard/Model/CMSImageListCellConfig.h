//
//  CMSImageListCellConfig.h
//  SuperApp
//
//  Created by seeu on 2021/8/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSImageListCellConfig : SAModel

@property (nonatomic, copy) NSString *imageUrl;     ///< 图片地址
@property (nonatomic, copy) NSString *link;         ///< 跳转地址
@property (nonatomic, assign) CGFloat cornerRadius; ///< 圆角角度

@end

NS_ASSUME_NONNULL_END

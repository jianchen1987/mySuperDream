//
//  TNProductDetailPublicImg.h
//  SuperApp
//
//  Created by xixi_wen on 2021/11/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailPublicImg : TNModel

// 公共详情页 -- 图片URL
@property (nonatomic, strong) NSString *publicDetailImgUrl;
// 公共性情也 -- APP跳转URL
@property (nonatomic, strong) NSString *publicDetailAppLink;
// 公共性情也 -- H5跳转URL
@property (nonatomic, strong) NSString *publicDetailH5Link;
@end

NS_ASSUME_NONNULL_END

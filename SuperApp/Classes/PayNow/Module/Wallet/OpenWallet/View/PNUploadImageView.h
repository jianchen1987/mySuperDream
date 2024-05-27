//
//  PNUploadImageView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PNUploadImageType_Avatar = 0,
    PNUploadImageType_Legal = 1,
} PNUploadImageType;

typedef void (^ButtonEnableBlock)(BOOL enabled);


@interface PNUploadImageView : PNView
/// 类型 根据类型显示不同的 样式文案
@property (nonatomic, assign) PNUploadImageType viewType;

/// 图片的url
@property (nonatomic, strong) NSString *leftImageURLStr;

@property (nonatomic, copy) ButtonEnableBlock buttonEnableBlock;
@end

NS_ASSUME_NONNULL_END

//
//  PNUploadImageItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ButtonEnableBlock)(NSString *url);


@interface PNUploadImageItemView : PNView
@property (nonatomic, strong) NSString *tipsStr;

@property (nonatomic, strong) NSString *urlStr;

/// 是否可以使用 使用默认照片 弹窗选项
@property (nonatomic, assign) BOOL isCanSelectDefaultPhoto;

@property (nonatomic, copy) ButtonEnableBlock buttonEnableBlock;

@end

NS_ASSUME_NONNULL_END

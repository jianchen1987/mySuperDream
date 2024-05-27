//
//  TNCameraView.h
//  SuperApp
//
//  Created by 张杰 on 2022/1/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCameraView : TNView
/// 选择图片回调
@property (nonatomic, copy) void (^takePhotoCallBack)(UIImage *image);
- (void)startRunning;
- (void)stopRunning;
@end

NS_ASSUME_NONNULL_END

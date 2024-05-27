//
//  PNUploadIDImageView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshLeftResultBlock)(NSString *leftURL);
typedef void (^RefreshRightResultBlock)(NSString *rightURL);


@interface PNUploadIDImageView : PNView

@property (nonatomic, copy) NSString *leftURL;
@property (nonatomic, copy) NSString *rightURL;

@property (nonatomic, copy) NSString *leftTitleStr;
@property (nonatomic, copy) NSString *rightTitleStr;

/// 是否显示右边view
@property (nonatomic, assign) BOOL isHiddeRightView;

/// 是否可以使用 使用默认照片 弹窗选项 这里只针对rightView
@property (nonatomic, assign) BOOL isCanSelectDefaultPhoto;

@property (nonatomic, copy) RefreshLeftResultBlock refreshLeftResultBlock;
@property (nonatomic, copy) RefreshRightResultBlock refreshRightResultBlock;

@end

NS_ASSUME_NONNULL_END

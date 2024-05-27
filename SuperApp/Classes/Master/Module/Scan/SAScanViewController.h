//
//  SAScanViewController.h
//  SuperApp
//
//  Created by Tia on 2023/4/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"
#import "HDScanCodeDefines.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAScanViewController : SAViewController

/// 扫描出结果后的回调 ，注意循环引用的问题
@property (nonatomic, copy) HDScanCodeResultBlock _Nullable resultBlock;


/// 点击我的二维码的回调
@property (nonatomic, copy) HDScanCodeClickedMyQRCodeBlock clickedMyQRCodeBlock;

/// 用户点击了返回即取消的回调
@property (nonatomic, copy) void (^userCancelBlock)(void);
@property (nonatomic, copy) NSString *customerTitle; ///< 自定义标题

@end

NS_ASSUME_NONNULL_END

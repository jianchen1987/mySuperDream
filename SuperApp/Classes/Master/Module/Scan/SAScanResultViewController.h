//
//  SAScanResultViewController.h
//  SuperApp
//
//  Created by Tia on 2023/4/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SAScanResultControllerDelegate <NSObject>

/// 重拍
- (void)SAScanResultControllerClickRemake;
/// 完成
- (void)SAScanResultControllerClickDetermineWithDic:(NSDictionary *)dic;

@end


@interface SAScanResultViewController : SAViewController

@property (nonatomic, weak) id<SAScanResultControllerDelegate> delegate;

@property (nonatomic, assign) CGRect scanRetangleRect;
/// 扫描类型，1为身份证，2为护照
@property (nonatomic, assign) NSInteger type;

/// 显示裁切后的图片
/// @param image 裁切后的图片
- (void)setImage:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END

//
//  WMCategoryChildViewControllerConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HDCategoryListContentViewDelegate;


@interface WMCategoryChildViewControllerConfig : WMModel
/// 标题
@property (nonatomic, copy) NSString *title;
/// 控制器
@property (nonatomic, strong) UIViewController<HDCategoryListContentViewDelegate> *vc;

+ (instancetype)configWithTitle:(NSString *)title vc:(UIViewController<HDCategoryListContentViewDelegate> *)vc;
@end

NS_ASSUME_NONNULL_END

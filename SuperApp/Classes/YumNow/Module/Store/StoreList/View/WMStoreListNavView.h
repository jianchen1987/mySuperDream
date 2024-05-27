//
//  WMStoreListNavView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMessageButton.h"
#import "SAView.h"
#import "GNEvent.h"
#import "WMStoreListViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreListNavView : SAView
/// 点击返回按钮时的额外操作(返回操作内部处理)
@property (nonatomic, copy) void (^clickBackOperatingBlock)(void);
/// 分类信息
@property (nonatomic, copy) NSString *cateName;
/// 返回按钮
@property (nonatomic, strong) HDUIButton *backBTN;
/// 信息按钮
@property (nonatomic, strong) SAMessageButton *messageBTN;
///< viewmodel
@property (nonatomic, strong) WMStoreListViewModel *viewModel;

- (void)updateNavUIWithTipViewHidden:(BOOL)tipViewHidden;

@end

NS_ASSUME_NONNULL_END

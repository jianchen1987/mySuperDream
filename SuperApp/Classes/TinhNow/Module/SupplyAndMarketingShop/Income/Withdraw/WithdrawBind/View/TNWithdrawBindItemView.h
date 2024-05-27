//
//  TNWithdrawBindItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

typedef enum : NSUInteger {
    TNWithdrawBindItemViewType_Alert,       //弹窗
    TNWithdrawBindItemViewType_Input,       //输入框
    TNWithdrawBindItemViewType_DoubleInput, //双输入框
} TNWithdrawBindItemViewType;

NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawBindItemConfig : NSObject
@property (nonatomic, assign) TNWithdrawBindItemViewType type;

@property (nonatomic, copy) NSString *title;
/// textFiled 显示text
@property (nonatomic, copy) NSString *_Nullable text;
/// textFiled 显示placeholder
@property (nonatomic, copy) NSString *placeholder;

///右边textFiled 显示text 可能有  可能没有
@property (nonatomic, strong) NSString *_Nullable rightText;
///右边textFiled 显示placeholder
@property (nonatomic, strong) NSString *_Nullable rightPlaceholder;
+ (instancetype)configWithType:(TNWithdrawBindItemViewType)type
                          text:(NSString *_Nullable)text
                         title:(NSString *)title
                   placeholder:(NSString *)placeholder
                     rightText:(NSString *_Nullable)rightText
              rightPlaceholder:(NSString *_Nullable)rightPlaceholder;
@end


@interface TNWithdrawBindItemView : TNView

@property (nonatomic, copy) NSString *text;      ///< 外部填充正文
@property (nonatomic, copy) NSString *rightText; ///< 外部填充正文  只有双输入框 姓名才需要

+ (instancetype)itemViewWithConfig:(TNWithdrawBindItemConfig *)config;

@property (nonatomic, copy) void (^itemClickCallBack)(void); ///< 点击回调

@property (nonatomic, copy) void (^itemTextDidChangeCallBack)(NSString *text); ///< 输入改变回调回调

@property (nonatomic, copy) void (^itemRightTextDidChangeCallBack)(NSString *text); ///< 右边输入框输入改变回调回调
@end

NS_ASSUME_NONNULL_END

//
//  PNInterTransferAmountCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TextFieldDidEndEditingBlock)(void);
typedef void (^RightBtnClickActionBlock)(NSString *tag);


@interface PNInterTransferAmountCellModel : PNModel
/// 文案
@property (nonatomic, copy) NSString *keyText;
/// 说明文案
@property (nonatomic, copy) NSString *descriptionText;
/// 是否可以编辑  简约写  可以编辑  是美元样式   不可以编辑是人民币样式
@property (nonatomic, assign) BOOL canEdit;
/// 值
@property (nonatomic, copy) NSString *valueText;
/// 值 颜色
@property (nonatomic, strong) UIColor *valueColor;
/// 是否立即响应 键盘
@property (nonatomic, assign) BOOL isBecomeFirstResponder;
/// 变化回调
@property (nonatomic, copy) void (^valueChangedCallBack)(NSString *text);
/// 特殊标志[用于业务]
@property (nonatomic, copy) NSString *tag;
/// 结束输入时的回调
@property (nonatomic, copy) TextFieldDidEndEditingBlock endEditingBlock;
/// 右边显示的图片[TextFiled]
@property (nonatomic, strong) UIImage *textFieldRightIconImage;
/// 右边按钮 title
@property (nonatomic, copy) NSString *rightBtnTitle;
/// 右边按钮 title color
@property (nonatomic, strong) UIColor *rightBtnTitleColor;
/// 右边按钮 title font
@property (nonatomic, strong) UIFont *rightBtnTitleFont;
/// 右边按钮 image
@property (nonatomic, strong) UIImage *rightBtnImage;
/// 右边按钮点击回调
@property (nonatomic, copy) RightBtnClickActionBlock rightBtnClickBlock;

@end


@interface PNInterTransferAmountCell : PNTableViewCell

///
@property (strong, nonatomic) PNInterTransferAmountCellModel *model;
//键盘响应
- (void)becomeFirstResponder;
@end

NS_ASSUME_NONNULL_END

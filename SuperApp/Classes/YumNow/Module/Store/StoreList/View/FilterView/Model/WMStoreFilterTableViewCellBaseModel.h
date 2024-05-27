//
//  WMStoreFilterTableViewCellBaseModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreFilterTableViewCellBaseModel : WMModel
@property (nonatomic, copy) NSString *superTitle;                        ///< 父标题
@property (nonatomic, copy) NSString *title;                             ///< 标题
@property (nonatomic, copy) NSAttributedString *attributedTitle;         ///< 富文本
@property (nonatomic, copy) NSAttributedString *selectedAttributedTitle; ///< 富文本
@property (nonatomic, strong) id associatedParamsModel;                  ///< 关联的参数对象
@property (nonatomic, assign, getter=isSelected) BOOL selected;          ///< 是否选中
/// 是否要顶部部线条
@property (nonatomic, assign) BOOL needTopLine;
/// 是否要底部线条
@property (nonatomic, assign) BOOL needBottomLine;
/// 是否一级菜单
@property (nonatomic, assign) BOOL isMain;
/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 标题选中颜色
@property (nonatomic, strong) UIColor *titleSelectColor;
/// 标题font
@property (nonatomic, strong) UIFont *titleFont;
/// select Font
@property (nonatomic, strong) UIFont *titleSelectFont;
/// 能否选中
@property (nonatomic, assign, getter=isCanSelect) BOOL canSelect;
/// 能选中的时候 普通状态的图标是否显示
@property (nonatomic, assign) BOOL unShowNormal;
+ (instancetype)modelWithTitle:(NSString *)title associatedParamsModel:(id __nullable)associatedParamsModel;
+ (instancetype)modelWithAttributedTitle:(NSAttributedString *)title associatedParamsModel:(id __nullable)associatedParamsModel;
+ (instancetype)modelWithAttributedTitle:(NSAttributedString *)title selectedAttributedTitle:(NSAttributedString *__nullable)selectTitle associatedParamsModel:(id __nullable)associatedParamsModel;

- (instancetype)initWithTitle:(NSString *)title associatedParamsModel:(id __nullable)associatedParamsModel;
- (instancetype)initWithAttributedTitle:(NSAttributedString *)title selectedAttributedTitle:(NSAttributedString *__nullable)selectTitle associatedParamsModel:(id __nullable)associatedParamsModel;

@end

NS_ASSUME_NONNULL_END

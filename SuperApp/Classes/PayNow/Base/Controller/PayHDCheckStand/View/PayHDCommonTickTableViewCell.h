//
//  PayHDCommonTickTableViewCell.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCommonTickTableViewCellModel : NSObject
@property (nonatomic, copy) NSString *imageName;      ///< 图片
@property (nonatomic, copy) NSString *title;          ///< 标题
@property (nonatomic, strong) UIFont *titleFont;      ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;    ///< 标题颜色
@property (nonatomic, copy) NSString *subTitle;       ///< 子标题
@property (nonatomic, strong) UIFont *subTitleFont;   ///< 子标题字体
@property (nonatomic, strong) UIColor *subTitleColor; ///< 子标题颜色
@property (nonatomic, assign) CGFloat VMargin;        ///< 垂直外边距
@property (nonatomic, assign) CGFloat labelMargin;    ///<  标题之间距离
@property (nonatomic, assign) BOOL disabled;          ///< 是否可用
@property (nonatomic, assign) BOOL selected;          ///< 是否选中
@property (nonatomic, strong) UIColor *disabledColor; ///< 灰显颜色
@property (nonatomic, assign) BOOL hideBottomLine;    ///< 隐藏底部线条
@end


@interface PayHDCommonTickTableViewCell : UITableViewCell
@property (nonatomic, strong) PayHDCommonTickTableViewCellModel *model; ///< 模型
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END

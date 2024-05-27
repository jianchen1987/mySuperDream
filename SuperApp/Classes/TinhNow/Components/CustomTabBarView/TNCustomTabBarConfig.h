//
//  TNCustomTabBarConfig.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNCustomTabBarItem : NSObject
@property (nonatomic, copy) NSString *title;                     ///< 名称
@property (nonatomic, copy) NSString *unSelectImageName;         ///< 未选中图片
@property (nonatomic, copy) NSString *_Nullable selectImageName; ///< 选中图片
@property (nonatomic, strong) UIColor *unSelectColor;            ///<未选中颜色
@property (nonatomic, strong) UIColor *_Nullable selectColor;    ///<选中颜色
@property (nonatomic, strong) UIFont *font;                      ///<文字字体
@property (nonatomic, assign) NSInteger index;                   ///< 位置

+ (instancetype)itemWithTitle:(NSString *)title
            unSelectImageName:(NSString *)unSelectImageName
              selectImageName:(NSString *_Nullable)selectImageName
                unSelectColor:(UIColor *)unSelectColor
                  selectColor:(UIColor *_Nullable)selectColor
                         font:(UIFont *)font;
@end


@interface TNCustomTabBarConfig : NSObject
@property (strong, nonatomic) NSArray<TNCustomTabBarItem *> *tabBarItems; ///< 数据源
@end

NS_ASSUME_NONNULL_END

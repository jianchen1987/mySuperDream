//
//  TNCustomerServiceView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"


@interface TNCustomerServiceItemModel : NSObject
/// 文本
@property (nonatomic, strong) NSString *title;
/// 按钮的title
@property (nonatomic, strong) NSString *btnTitle;
/// 按钮的图片
@property (nonatomic, strong) NSString *btnImage;
///
@property (nonatomic, strong) NSString *key;
///
@property (nonatomic, strong) NSArray<UIColor *> *backgroundColors;
///
@property (nonatomic, strong) UIColor *themeColor;
@end


@interface TNCustomerServiceModel : NSObject
///
@property (nonatomic, strong) NSString *title;
///
@property (nonatomic, strong) NSArray<TNCustomerServiceItemModel *> *listArray;
@end


@interface TNCustomerServiceView : TNView <HDCustomViewActionViewProtocol>
/// 数据源
@property (strong, nonatomic) NSArray<TNCustomerServiceModel *> *dataSource;
/// 返回默认的电商平台电话
- (NSArray<TNCustomerServiceModel *> *)getTinhnowDefaultPlatform;

@end

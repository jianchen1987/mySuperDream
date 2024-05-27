//
//  PNGrideItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGrideItemModel : PNModel
/// 值
@property (nonatomic, copy) NSString *value;
/// 值的字体
@property (nonatomic, strong) UIFont *valueFont;
/// 值的颜色
@property (nonatomic, strong) UIColor *valueColor;
/// 单元格背景色
@property (nonatomic, strong) UIColor *cellBackgroudColor;
@end


@interface PNGrideModel : PNModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger gridColumn; //必传，不然出问题
@property (nonatomic, strong) NSArray<PNGrideItemModel *> *listArray;
@end

NS_ASSUME_NONNULL_END

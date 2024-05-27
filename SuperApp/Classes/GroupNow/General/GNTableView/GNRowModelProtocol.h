//
//  GNRowModelProtocol.h
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNEvent.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol GNRowModelProtocol <NSObject>
/// selectionStyle
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
/// accessoryType
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
/// 数据源
@property (nonatomic, copy) NSArray *dataSource;
/// 背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 选中
@property (nonatomic, assign, getter=isSelected) BOOL select;
/// 对应的tableviewCell的类
@property (nonatomic, strong) Class cellClass;
/// cell行高
@property (nonatomic, assign) CGFloat cellHeight;
/// 预估行高
@property (nonatomic, assign) CGFloat estimatedHeight;
/// 是否是xib
@property (nonatomic, assign) BOOL xib;
/// indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;
/// hidden
@property (nonatomic, assign) BOOL hidden;
/// 不缓存高度
@property (nonatomic, assign, getter=isNotCacheheight) BOOL notCacheHeight;
///业务数据 该属性不为空的时候 setGNModel 为此数据
@property (nonatomic, strong) id businessData;

@end

NS_ASSUME_NONNULL_END

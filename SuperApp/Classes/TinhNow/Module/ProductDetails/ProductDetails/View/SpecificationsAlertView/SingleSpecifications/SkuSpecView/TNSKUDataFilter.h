//
//  TNSKUDataFilter.h
//  SuperApp
//
//  Created by xixi on 2021/3/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class TNSKUDataFilter;
@class TNSKUProperty;

@protocol TNSKUDataFilterDataSource <NSObject>

@required

//属性种类个数
- (NSInteger)numberOfSectionsForPropertiesInFilter:(TNSKUDataFilter *)filter;

/*
 * 每个种类所有的的属性值
 * 这里不关心具体的值，可以是属性ID, 属性名，字典、model
 */
- (NSArray *)filter:(TNSKUDataFilter *)filter propertiesInSection:(NSInteger)section;

//满足条件 的 个数
- (NSInteger)numberOfConditionsInFilter:(TNSKUDataFilter *)filter;

/*
 * 对应的条件式
 * 这里条件式的属性值，需要和propertiesInSection里面的数据类型保持一致
 */
- (NSArray *)filter:(TNSKUDataFilter *)filter conditionForRow:(NSInteger)row;

//条件式 对应的 结果数据（库存、价格等）
- (id)filter:(TNSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row;

@end


@interface TNSKUDataFilter : NSObject

@property (nonatomic, assign) id<TNSKUDataFilterDataSource> dataSource;

//当前 选中的属性indexPath
@property (nonatomic, strong, readonly) NSSet<NSIndexPath *> *selectedIndexPaths;
//当前 可选的属性indexPath
@property (nonatomic, strong, readonly) NSSet<NSIndexPath *> *availableIndexPathsSet;
//当前 结果
@property (nonatomic, strong, readonly) id currentResult;
//当前 可用结果，一般用于 价格区间动态变化
@property (nonatomic, strong, readonly) NSSet *currentAvailableResutls;

//是否需要默认选中第一组SKU
@property (nonatomic, assign) BOOL needDefaultValue;

// init
- (instancetype)initWithDataSource:(id<TNSKUDataFilterDataSource>)dataSource;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;


//选中 属性的时候 调用
- (void)didSelectedPropertyWithIndexPath:(NSIndexPath *)indexPath;

//重新加载数据
- (void)reloadData;


@end


@interface TNSKUCondition : NSObject

@property (nonatomic, strong) NSArray<TNSKUProperty *> *properties;

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *conditionIndexs;
@property (nonatomic, strong, readonly) NSSet<NSIndexPath *> *conditionIndexPaths;

@property (nonatomic, strong) id result;

@end


@interface TNSKUProperty : NSObject

@property (nonatomic, copy, readonly) NSIndexPath *indexPath;
@property (nonatomic, copy, readonly) id value;

- (instancetype)initWithValue:(id)value indexPath:(NSIndexPath *)indexPath;

@end

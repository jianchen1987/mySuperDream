//
//  GNTableViewProtocol.h
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNRowModelProtocol.h"
#import <Foundation/Foundation.h>

@class GNSectionModel, GNTableView;
NS_ASSUME_NONNULL_BEGIN

@protocol GNTableViewProtocol <NSObject>

@optional

/*!
 * @brief 单个section
 * @param tableView MZTableView
 */
- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView;

/*!
 * @brief 多个section
 * @param tableView MZTableView
 */
- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView;

/*!
 * @brief 设置cellclass的方法
 * @param tableView MZTableView
 */
- (Class)classOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

/*!
 * @brief cellclass是否是xib
 * @param tableView MZTableView
 */
- (BOOL)xibOfGNTableView:(GNTableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

/*!
 * @brief tableView点击cell
 * @param tableView MZTableView
 * @param indexPath NSIndexPath
 * @param rowData 对应数据
 */
- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData;

/*!
 * @brief tableViewCell自定义操作
 * @param tableView MZTableView
 * @param indexPath NSIndexPath
 * @param rowData 对应数据
 */
- (void)GNTableView:(GNTableView *)tableView cellRowAtIndexPath:(NSIndexPath *)indexPath cell:(SATableViewCell *)cell data:(id<GNRowModelProtocol>)rowData;

/*!
 * @brief 滚动
 * @param tableView MZTableView
 */
- (void)gnScrollViewDidScroll:(UIScrollView *)tableView;

/*!
 * @brief 编辑事件
 * @param tableView MZTableView
 * @param indexPath NSIndexPath
 * @param rowData 对应数据
 */
- (void)GNTableView:(GNTableView *)tableView editRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData;

/*!
 * @brief 设置tableViewHead
 * @param tableView MZTableView
 */
- (UIView *)GNTableView:(GNTableView *)tableView viewForHeaderInSection:(NSInteger)section;

/*!
 * @brief 设置tableViewFoot
 * @param tableView MZTableView
 */
- (UIView *)GNTableView:(GNTableView *)tableView viewForFooterInSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END

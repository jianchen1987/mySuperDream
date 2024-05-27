//
//  TNView.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDAppTheme+TinhNow.h"
#import "SAAppEnvConfig.h"
#import "SAAppEnvManager.h"
#import "SAView.h"
#import "TNEventTracking.h"
#import "TNGlobalData.h"
#import "TNHostUrlConst.h"
#import "TNMultiLanguageManager.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNView : SAView
/// 显示自定义占位图
/// @param placeHolder 占位模型
/// @param needRefrenshBtn 是否需要显示刷新按钮
/// @param refrenshCallBack 刷新按钮事件回调
- (void)showPlaceHolder:(UIViewPlaceholderViewModel *)placeHolder NeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^__nullable)(void))refrenshCallBack;

/// 显示无数据占位图
/// @param needRefrenshBtn 是否需要显示刷新按钮
/// @param refrenshCallBack 刷新按钮事件回调
- (void)showNoDataPlaceHolderNeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^__nullable)(void))refrenshCallBack;

/// 显示错误占位图
/// @param needRefrenshBtn 是否需要显示刷新按钮
/// @param refrenshCallBack 刷新按钮事件回调
- (void)showErrorPlaceHolderNeedRefrenshBtn:(BOOL)needRefrenshBtn refrenshCallBack:(void (^__nullable)(void))refrenshCallBack;
/// 移除占位图
- (void)removePlaceHolder;

#pragma mark -设置tableView分组cell圆角
- (void)setCornerRadiusForSectionCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView needSetAlone:(BOOL)needSetAlone;
@end

NS_ASSUME_NONNULL_END

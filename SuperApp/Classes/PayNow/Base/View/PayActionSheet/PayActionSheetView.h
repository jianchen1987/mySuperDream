//
//  PayActionSheetView.h
//  SuperApp
//
//  Created by Quin on 2021/11/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAView.h"
#import "SATableView.h"
#import "PaySelectableTableViewCell.h"
@class PaySelectableTableViewCellModel;
NS_ASSUME_NONNULL_BEGIN


@interface PayActionSheetView : SAView <HDCustomViewActionViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) void (^selectedItemHandler)(PaySelectableTableViewCellModel *model);
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray<PaySelectableTableViewCellModel *> *dataSource;
@property (nonatomic, copy) NSString *DefaultStr; //默认选中
@end

NS_ASSUME_NONNULL_END

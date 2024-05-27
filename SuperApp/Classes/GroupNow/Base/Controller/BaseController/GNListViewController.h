//
//  GNListViewController.h
//  SuperApp
//
//  Created by wmz on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTableView.h"
#import "GNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNListViewController : GNViewController <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
///数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END

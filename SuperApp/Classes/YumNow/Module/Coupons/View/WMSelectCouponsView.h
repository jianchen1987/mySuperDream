//
//  WMSelectCouponsView.h
//  SuperApp
//
//  Created by wmz on 2022/7/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMTableView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSelectCouponsView : SAView
/// tableView
@property (nonatomic, strong) WMTableView *tableView;
/// dataSource
@property (nonatomic, strong) NSArray *dataSource;

@end

NS_ASSUME_NONNULL_END

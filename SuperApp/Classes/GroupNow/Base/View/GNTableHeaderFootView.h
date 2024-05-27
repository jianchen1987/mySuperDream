//
//  GNTableHeaderFootView.h
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNTableHeaderFootViewModel.h"
#import "GNTheme.h"
#import "HDTableHeaderFootView.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTableHeaderFootView : UITableViewHeaderFooterView

@property (nonatomic, strong) GNTableHeaderFootViewModel *model;
- (void)setupSubViews;
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END

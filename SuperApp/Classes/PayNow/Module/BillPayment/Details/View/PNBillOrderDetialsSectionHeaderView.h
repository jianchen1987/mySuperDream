//
//  PNBillOrderDetialsSectionHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNBillOrderDetialsSectionHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSString *sectionTitleStr;
@end

NS_ASSUME_NONNULL_END

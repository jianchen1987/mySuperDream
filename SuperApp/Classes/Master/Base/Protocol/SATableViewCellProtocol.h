//
//  SATableViewCellProtocol.h
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SATableViewCellProtocol <NSObject>
@optional
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *_Nullable)identifier;

- (void)hd_setupViews;
- (void)hd_bindViewModel;

/// 骨架占位 View 高度
+ (CGFloat)skeletonViewHeight;
@end

NS_ASSUME_NONNULL_END

//
//  HDBaseTableViewCell.h
//  customer
//
//  Created by 陈剑 on 2018/7/4.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDAppTheme.h"
#import "HDCommonDefines.h"
#import "HDSkeleton.h"
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>


@interface HDBaseTableViewCellModel : NSObject

@end


@interface HDBaseTableViewCell : UITableViewCell <HDSkeletonLayerLayoutProtocol>

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)skeletonViewHeight; ///< 骨架占位 View 高度
@end

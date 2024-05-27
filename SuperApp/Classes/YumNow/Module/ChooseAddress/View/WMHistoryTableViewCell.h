//
//  WMHistoryTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/4/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNEvent.h"
#import "SAImageTitleTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHistoryTableViewCellModel : NSObject
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 标记
@property (nonatomic, assign) NSUInteger tag;
/// 右边
@property (nonatomic, copy) NSString *detail;
@end


@interface WMHistoryTableViewCell : SAImageTitleTableViewCell
/// 模型
@property (nonatomic, strong) WMHistoryTableViewCellModel *historyModel;
@end

NS_ASSUME_NONNULL_END

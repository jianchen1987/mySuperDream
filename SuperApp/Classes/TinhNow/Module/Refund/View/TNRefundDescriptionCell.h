//
//  TNRefundDescriptionCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

@class TNApplyRefundModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundDescriptionCellModel : NSObject

@end


@interface TNRefundDescriptionCell : SATableViewCell
///
@property (nonatomic, strong) TNApplyRefundModel *model;

/// 完成输入之后的回调
@property (nonatomic, copy) void (^endInputHander)(NSString *reasonStr);
/// 刷新选择图片控件高度
@property (nonatomic, copy) void (^reloadHander)(void);

/// 选择完图片之后回调
@property (nonatomic, copy) void (^selectImageHander)(NSArray *imageArray);

@end

NS_ASSUME_NONNULL_END

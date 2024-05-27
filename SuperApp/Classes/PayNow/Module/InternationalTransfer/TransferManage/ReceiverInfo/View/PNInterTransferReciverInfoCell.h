//
//  PNInterTransferReciverInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferReciverModel.h"
#import "PNTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferReciverInfoCell : PNTableViewCell
///
@property (nonatomic, assign) BOOL hiddenEditBtn;
///
@property (strong, nonatomic) PNInterTransferReciverModel *model;
/// 点击编辑按钮回调
@property (nonatomic, copy) void (^editClickCallBack)(void);

/// 设置右边图片  设置后  就不能点击了
- (void)setRightImage:(UIImage *)rightImage;

- (void)setHiddenLeftImage:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END

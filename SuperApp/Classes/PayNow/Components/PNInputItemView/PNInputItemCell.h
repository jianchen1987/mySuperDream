//
//  PNInputItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInputItemView.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^InputChangeBlock)(NSString *text);


@interface PNInputItemCell : PNTableViewCell

@property (nonatomic, strong) PNInputItemModel *model;

@property (nonatomic, copy) InputChangeBlock inputChangeBlock;

@end

NS_ASSUME_NONNULL_END

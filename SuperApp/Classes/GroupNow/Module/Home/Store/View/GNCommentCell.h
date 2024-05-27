//
//  GNCommentCell.h
//  SuperApp
//
//  Created by wmz on 2021/9/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommentModel.h"
#import "GNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNCommentCell : GNTableViewCell
@property (nonatomic, strong) GNCommentModel *model;
@end

NS_ASSUME_NONNULL_END

//
//  GNImageTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTableViewCell.h"
#import "GNTagViewCell.h"
#import "YBImageBrowser.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNImageHandle : HDImageBrowserToolViewHandler

@end


@interface GNImageTableViewCell : GNTableViewCell

@property (nonatomic, strong) GNTagViewCellModel *model;

@end

NS_ASSUME_NONNULL_END

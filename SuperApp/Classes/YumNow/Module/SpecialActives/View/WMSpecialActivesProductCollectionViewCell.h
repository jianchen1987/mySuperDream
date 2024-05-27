//
//  WMSpecialActivesProductCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class WMSpecialActivesProductModel;


@interface WMSpecialActivesProductCollectionViewCell : SACollectionViewCell
/// model
@property (nonatomic, strong) WMSpecialActivesProductModel *model;
@end

NS_ASSUME_NONNULL_END

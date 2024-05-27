//
//  WMNewSpecialActivesProductCollectionViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/8/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "WMSpecialActivesProductModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewSpecialActivesProductCollectionViewCell : SACollectionViewCell
/// model
@property (nonatomic, strong) WMSpecialActivesProductModel *model;

@end

NS_ASSUME_NONNULL_END

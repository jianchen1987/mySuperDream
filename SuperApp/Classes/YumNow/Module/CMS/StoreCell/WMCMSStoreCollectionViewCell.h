//
//  WMCMSStoreCNCollectionViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/12/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "WMStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMCMSStoreCollectionViewCell : SACollectionViewCell

@property (nonatomic, strong) WMNewStoreModel *storeModel;

@end

NS_ASSUME_NONNULL_END

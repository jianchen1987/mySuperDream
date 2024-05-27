//
//  TNSearchHistoryEmptyCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSearchHistoryEmptyModel : TNModel

@end


@interface TNSearchHistoryEmptyCollectionViewCell : TNCollectionViewCell
/// model
@property (nonatomic, strong) TNSearchHistoryEmptyModel *model;
@end

NS_ASSUME_NONNULL_END

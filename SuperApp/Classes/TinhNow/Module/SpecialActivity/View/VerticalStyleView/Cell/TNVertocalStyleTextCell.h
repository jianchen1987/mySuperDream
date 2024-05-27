//
//  TNVertocalStyleTextCellCollectionViewCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNVertocalStyleTextCellModel : NSObject
///
@property (nonatomic, copy) NSString *title;
@end


@interface TNVertocalStyleTextCell : TNCollectionViewCell
///
@property (strong, nonatomic) TNVertocalStyleTextCellModel *model;
@end

NS_ASSUME_NONNULL_END

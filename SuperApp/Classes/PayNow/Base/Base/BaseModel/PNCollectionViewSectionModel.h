//
//  PNCollectionViewSectionModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCollectionViewSectionModel : SACollectionViewSectionModel

//关联对象
@property (nonatomic, strong) id associatedObject;
@end

NS_ASSUME_NONNULL_END

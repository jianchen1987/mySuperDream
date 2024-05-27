//
//  TNActivityCardWrapperCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNActivityCardRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNActivityCardWrapperCell : TNCollectionViewCell
/// 模型数据
@property (strong, nonatomic) TNActivityCardRspModel *cellModel;
@end

NS_ASSUME_NONNULL_END

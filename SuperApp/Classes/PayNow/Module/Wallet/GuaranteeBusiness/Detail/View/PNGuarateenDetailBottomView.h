//
//  PNGuarateenDetailBottomView.h
//  SuperApp
//
//  Created by xixi on 2023/1/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenDetailModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BtnClickBlock)(PNGuarateenNextActionModel *model);


@interface PNGuarateenDetailBottomView : PNView

@property (nonatomic, strong) NSMutableArray<PNGuarateenNextActionModel *> *dataSource;

@property (nonatomic, copy) BtnClickBlock btnClickBlock;
@end

NS_ASSUME_NONNULL_END

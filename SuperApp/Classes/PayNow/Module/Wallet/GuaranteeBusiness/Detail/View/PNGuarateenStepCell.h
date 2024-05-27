//
//  PNGuarateenStepCell.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"
#import "PNGuarateenDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenStepCell : PNCollectionViewCell
//- (void)refreshCell:(PNGuarateenFlowModel *)model index:(NSInteger)index flowstep:(NSInteger)step;
- (void)refreshCell:(NSArray *)arr index:(NSInteger)index flowstep:(NSInteger)step;
@end

NS_ASSUME_NONNULL_END

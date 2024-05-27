//
//  PNMSFilterStoreCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNMSBillFilterModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickBtnBlock)(void);


@interface PNMSFilterStoreCell : PNCollectionViewCell
@property (nonatomic, strong) NSString *valueTitle;

@property (nonatomic, copy) ClickBtnBlock clickBtnBlock;
@end

NS_ASSUME_NONNULL_END

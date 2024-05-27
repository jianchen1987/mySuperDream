//
//  PNApartmentComfirmSingleView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"
#import "PNApartmentListRspModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^PayNowBlock)(NSArray<PNApartmentListItemModel *> *array);


@interface PNApartmentComfirmSingleView : PNView
@property (nonatomic, strong) PNApartmentListItemModel *model;

@property (nonatomic, copy) PayNowBlock payNowBlock;
@end

NS_ASSUME_NONNULL_END

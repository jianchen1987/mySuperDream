//
//  PayHDBillListRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/12.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "PNBillListModel.h"
#import "HDCommonPagingRspModel.h"


@interface PNBillListRspModel : HDCommonPagingRspModel

@property (nonatomic, strong) NSMutableArray<PNBillListModel *> *list;

@end

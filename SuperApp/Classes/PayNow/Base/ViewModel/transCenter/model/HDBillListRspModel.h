//
//  HDBillListRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/12.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBillListModel.h"
#import "HDCommonPagingRspModel.h"


@interface HDBillListRspModel : HDCommonPagingRspModel

@property (nonatomic, strong) NSMutableArray<HDBillListModel *> *list;

@end

//
//  HDContactsModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/7.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "SAModel.h"


@interface HDContactsModel : SAModel
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *realNameEnd;
@property (nonatomic, copy) NSString *realNameFirst;
@property (nonatomic, copy) NSString *headUrl;
- (instancetype)initWithJson:(NSDictionary *)json;
@end

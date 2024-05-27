//
//  HDJsonRspModel.h
//  National Wallet
//
//  Created by 陈剑 on 2018/4/27.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "PNEnum.h"
#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface HDJsonRspModel : NSObject

//@property (nonatomic, copy) NSString *rspCode;
////@property (nonatomic, copy) NSDictionary *data;  ///< 数据
//@property (nonatomic, copy) NSString *rspMsg;
////@property (nonatomic, strong) NSNumber *rspType;
////@property (nonatomic, strong) NSNumber *v;
//@property (nonatomic, strong) NSNumber *rspDateTime;
//@property (nonatomic, strong) NSMutableDictionary *jsonData;
//@property (nonatomic, copy) NSDictionary *jsonBody;

@property (nonatomic, copy) NSString *rspInf;
@property (nonatomic, copy) NSString *rspCd;
@property (nonatomic, copy) id data;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger rspType;
@property (nonatomic, copy) NSString *v;
@property (nonatomic, copy) NSString *responseTm;

- (instancetype)initWithJson:(NSDictionary *)json;
- (BOOL)parse;
- (void)parseAllObject;
- (BOOL)isValid;
@end

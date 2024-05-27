//
//  TransListModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNTransListModel : PNModel

@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *realNameEnd;
@property (nonatomic, copy) NSString *realNameFirst;
@property (nonatomic, assign) PNTransferType bizEntity;
@property (nonatomic, copy) NSString *payInst;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;

@end

NS_ASSUME_NONNULL_END

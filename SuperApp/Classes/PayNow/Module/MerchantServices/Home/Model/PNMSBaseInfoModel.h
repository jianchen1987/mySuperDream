//
//  PNMSBaseInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/2.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBaseInfoModel : PNModel
@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, assign) PNMerchantStatus merStatus;
@property (nonatomic, assign) NSInteger merchantType;
@property (nonatomic, assign) NSInteger categoryItem;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *adress;
@property (nonatomic, copy) NSString *addressGlobal;
@property (nonatomic, copy) NSString *merPhone;
@property (nonatomic, copy) NSString *businessLicenseNumber;
@property (nonatomic, copy) NSString *personLastName;
@property (nonatomic, copy) NSString *personFristName;
@property (nonatomic, assign) NSInteger identificationType;
@property (nonatomic, copy) NSString *identificationNumber;
@property (nonatomic, copy) NSString *merchantLogoImage;
@property (nonatomic, copy) NSString *merchantBizType;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *merMobile;

@end

NS_ASSUME_NONNULL_END

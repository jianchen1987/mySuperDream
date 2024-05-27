//
//  PNUploadLegalDocView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadIDImageView.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickButtonBlock)(NSMutableDictionary *postDict);


@interface PNUploadLegalDocView : PNView

@property (nonatomic, strong) PNUploadIDImageView *uploadIDImageView;

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, copy) NSString *headUrl;
/// 名字
@property (nonatomic, copy) NSString *lastName;
/// 姓
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, assign) PNSexType sex;
@property (nonatomic, assign) NSInteger birthday;
@property (nonatomic, copy) NSString *country; // code

@property (nonatomic, assign) PNPapersType cardType;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, assign) NSInteger expirationTime;
@property (nonatomic, assign) NSInteger visaExpirationTime;
@property (nonatomic, copy) NSString *idCardFrontUrl;
@property (nonatomic, copy) NSString *idCardBackUrl;
@property (nonatomic, copy) NSString *cardHandUrl;

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;
@end

NS_ASSUME_NONNULL_END

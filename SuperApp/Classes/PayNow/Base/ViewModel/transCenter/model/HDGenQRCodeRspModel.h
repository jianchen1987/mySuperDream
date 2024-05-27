//
//  HDGenQRCodeRspModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/7.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"


@interface HDGenQRCodeRspModel : HDJsonRspModel

//@property (nonatomic, copy) NSString *contentQrCode;
//@property (nonatomic, copy) NSString *payeeHeadUrl;
//@property (nonatomic, copy) NSString *payeeName;

@property (nonatomic, copy) NSString *qrData;
@property (nonatomic, copy) NSString *md5;
@property (nonatomic, assign) BOOL isHideSaveBtn;
@end

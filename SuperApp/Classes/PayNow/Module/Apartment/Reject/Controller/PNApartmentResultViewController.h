//
//  PNApartmentResultViewController.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewController.h"

typedef NS_ENUM(NSInteger, PNApartmentPaymentResultType) {
    PNApartmentPaymentResultType_RejectSuccess = 0, ///< 拒绝成功
    PNApartmentPaymentResultType_UploadSuccess = 1, ///< 上传凭证成功
};


NS_ASSUME_NONNULL_BEGIN


@interface PNApartmentResultViewController : PNViewController

@end

NS_ASSUME_NONNULL_END

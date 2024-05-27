//
//  TNWithDrawDetailCertificateCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNWithDrawDetailCertificateCellModel : NSObject
@property (nonatomic, copy) NSString *voucher; ///< 凭证
@end


@interface TNWithDrawDetailCertificateCell : SATableViewCell
///
@property (strong, nonatomic) TNWithDrawDetailCertificateCellModel *model;
@end

NS_ASSUME_NONNULL_END

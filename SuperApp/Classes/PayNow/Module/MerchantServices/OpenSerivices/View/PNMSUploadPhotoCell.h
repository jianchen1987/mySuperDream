//
//  PNMSUploadPhotoCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSUploadPhotoModel : PNModel
@property (nonatomic, strong) NSString *leftURL;
@property (nonatomic, strong) NSString *rightURL;
@end


@interface PNMSUploadPhotoCell : PNTableViewCell
@property (nonatomic, strong) PNMSUploadPhotoModel *model;

@end

NS_ASSUME_NONNULL_END

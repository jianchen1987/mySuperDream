//
//  PNMSStorePhotoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStorePhotoItemModel : PNModel
@property (nonatomic, strong) NSString *url;
@end


@interface PNMSStorePhotoModel : PNModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSAttributedString *attrTitle; ///< 优先级高 于 title
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, strong) NSMutableArray<PNMSStorePhotoItemModel *> *imageArray;
@end

NS_ASSUME_NONNULL_END

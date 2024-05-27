//
//  TNTakePhotoItemCell.h
//  SuperApp
//
//  Created by xixi on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNTakePhotoItemCellModel : NSObject
/// add or normal("")
@property (nonatomic, strong) NSString *type;
///
@property (nonatomic, strong) UIImage *imageData;
@end


@interface TNTakePhotoItemCell : SACollectionViewCell
///
//@property (nonatomic, strong) TNTakePhotoItemCellModel *model;
///
@property (nonatomic, strong) NSString *imgURL;
@end

NS_ASSUME_NONNULL_END

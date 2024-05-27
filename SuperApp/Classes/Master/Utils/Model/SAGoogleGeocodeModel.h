//
//  SAGoogleGeocodeModel.h
//  SuperApp
//
//  Created by Chaos on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAGoogleGeocodeComponentsModel : SAModel

@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *longName;
@property (nonatomic, strong) NSArray<NSString *> *types;

@end


@interface SAGoogleGeocodeModel : SAModel

/// 格式化地址
@property (nonatomic, copy) NSString *formattedAddress;
@property (nonatomic, strong) NSArray<SAGoogleGeocodeComponentsModel *> *addressComponents;

@end

NS_ASSUME_NONNULL_END

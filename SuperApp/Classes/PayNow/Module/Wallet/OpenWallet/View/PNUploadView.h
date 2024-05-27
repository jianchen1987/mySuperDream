//
//  PNUploadView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PNUploadImageType_Avatar = 0,
    PNUploadImageType_Legal = 1,
} PNUploadImageType;

typedef void (^ButtonEnableBlock)(BOOL enabled, NSString *imageURL);


@interface PNUploadView : PNView
@property (nonatomic, strong) NSMutableArray *demoArray;

@property (nonatomic, copy) NSString *imageURLStr;
@property (nonatomic, assign) PNUploadImageType viewType;

@property (nonatomic, copy) ButtonEnableBlock buttonEnableBlock;

@end

NS_ASSUME_NONNULL_END

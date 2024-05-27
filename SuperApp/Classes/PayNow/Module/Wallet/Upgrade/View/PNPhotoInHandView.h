//
//  PNPhotoInHandView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshResultBlock)(NSString *url);


@interface PNPhotoInHandView : PNView

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) PNPapersType cardType;

@property (nonatomic, copy) RefreshResultBlock refreshResultBlock;
@end

NS_ASSUME_NONNULL_END

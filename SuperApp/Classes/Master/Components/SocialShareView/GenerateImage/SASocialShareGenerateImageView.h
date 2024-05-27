//
//  SASocialShareGenerateImageView.h
//  SuperApp
//
//  Created by Chaos on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SASocialShareBaseGenerateImageView.h"
#import "SAShareWebpageObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASocialShareGenerateImageView : SASocialShareBaseGenerateImageView

- (instancetype)initWithShareObject:(SAShareWebpageObject *)shareObject;

@end

NS_ASSUME_NONNULL_END

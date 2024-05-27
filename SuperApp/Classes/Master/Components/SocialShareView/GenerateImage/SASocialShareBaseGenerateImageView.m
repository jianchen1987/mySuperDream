//
//  SASocialShareBaseGenerateImageView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SASocialShareBaseGenerateImageView.h"


@implementation SASocialShareBaseGenerateImageView

- (UIImage *)generateImageWithChannel:(SAShareChannel)channel {
    UIImage *image = [self snapshotImageAfterScreenUpdates:true];
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *pngImage = [UIImage imageWithData:imageData];
    return pngImage;
}

@end

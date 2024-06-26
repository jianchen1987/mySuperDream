//
//  SJWatermarkViewDefines.h
//  Pods
//
//  Created by BlueDancer on 2020/6/13.
//

#ifndef SJWatermarkViewDefines_h
#define SJWatermarkViewDefines_h

#import "SJVideoPlayerPlaybackControllerDefines.h"
#import <UIKit/UIKit.h>

@protocol SJWatermarkView <NSObject>

- (void)layoutWatermarkInRect:(CGRect)rect videoPresentationSize:(CGSize)vSize videoGravity:(SJVideoGravity)videoGravity;

@end

#endif /* SJWatermarkViewDefines_h */

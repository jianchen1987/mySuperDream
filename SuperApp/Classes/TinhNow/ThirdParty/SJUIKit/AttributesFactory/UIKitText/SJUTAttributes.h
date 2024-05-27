//
//  SJUTAttributes.h
//  AttributesFactory
//
//  Created by 畅三江 on 2019/4/12.
//  Copyright © 2019 SanJiang. All rights reserved.
//

#import "SJUIKitAttributesDefines.h"
#import "SJUTRecorder.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SJUTAttributes : NSObject <SJUTAttributesProtocol>
@property (nonatomic, strong, readonly) SJUTRecorder *recorder;
@end
NS_ASSUME_NONNULL_END

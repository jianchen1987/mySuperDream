//
//  SAPhoneFormatValidator.h
//  SuperApp
//
//  Created by seeu on 2021/11/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAPhoneFormatModel : NSObject

@property (nonatomic, copy) NSString *prefix; ///< 前缀
@property (nonatomic, assign) NSUInteger max; ///< 最长
@property (nonatomic, assign) NSUInteger min; ///< 最短

@end


@interface SAPhoneFormatValidator : NSObject

+ (BOOL)isCambodia:(NSString *)phoneNo;
@end

NS_ASSUME_NONNULL_END

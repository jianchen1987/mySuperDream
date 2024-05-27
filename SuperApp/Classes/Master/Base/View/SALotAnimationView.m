//
//  SALotAnimationView.m
//  SuperApp
//
//  Created by Tia on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALotAnimationView.h"
#import "SACacheManager.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation SALotAnimationView

- (void)setAnimationFromURL:(NSString *)animationURL {
    if (HDIsStringEmpty(animationURL))
        return;
    NSData *animationData = [SACacheManager.shared objectForKey:animationURL type:SACacheTypeDocumentPublic];
    if (animationData && [animationData isKindOfClass:NSData.class]) {
        NSError *error;
        NSDictionary *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData options:0 error:&error];

        if (error || !animationJSON) {
            HDLog(@"获取缓存失败，重新下载json文件--%@", animationURL);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                NSData *animationData = [NSData dataWithContentsOfURL:[NSURL URLWithString:animationURL]];
                if (!animationData)
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SACacheManager.shared setObject:animationData forKey:animationURL type:SACacheTypeDocumentPublic];
                    NSError *error;
                    NSDictionary *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData options:0 error:&error];
                    if (error || !animationJSON)
                        return;
                    [self setAnimationFromJSON:animationJSON];
                });
            });
        } else {
            [self setAnimationFromJSON:animationJSON];
        }
    } else {
        HDLog(@"没有缓存或数据类型不对，即将重新下载json文件--%@", animationURL);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSData *animationData = [NSData dataWithContentsOfURL:[NSURL URLWithString:animationURL]];
            if (!animationData)
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SACacheManager.shared setObject:animationData forKey:animationURL type:SACacheTypeDocumentPublic];
                NSError *error;
                NSDictionary *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData options:0 error:&error];
                if (error || !animationJSON)
                    return;
                [self setAnimationFromJSON:animationJSON];
            });
        });
    }
}

@end

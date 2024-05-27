//
//  SATabBarItemConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBarItemConfig.h"
#import "SAAppTheme.h"
#import "SACacheManager.h"


@implementation SATabBarImageModel

- (void)setType:(NSString *)type {
    _type = type;
    if ([type isEqualToString:@"json"]) {
        NSString *animationURL = self.url;
        if (HDIsStringEmpty(animationURL))
            return;
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            NSData *animationData = [SACacheManager.shared objectForKey:animationURL type:SACacheTypeDocumentPublic];
            if (!animationData || ![animationData isKindOfClass:NSData.class]) {
                animationData = [NSData dataWithContentsOfURL:[NSURL URLWithString:animationURL]];
                if (!animationData)
                    return;
                //                HDLog(@"下载完json动画文件 = %@", self.url);
                [SACacheManager.shared setObject:animationData forKey:animationURL type:SACacheTypeDocumentPublic];
            } else {
                //                HDLog(@"json动画文件 = %@,已存在",self.url);
            }
        });
    }
}

@end


@implementation SATabBarItemConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = HDAppTheme.color.G2;
        self.selectedTitleColor = HDAppTheme.color.sa_C1;
        self.titleFont = HDAppTheme.font.standard4;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"name": @"appTabBarName",
        @"guideDesc": @"appTabBarGuide",
        @"imageUrl": @"iconDefault",
        @"selectedImageUrl": @"iconSelect",
        @"index": @"serial",
        @"identifier": @[@"identifier", @"id"],
        @"hideTextWhenSelected": @"iconTextState",
        @"loadPageName": @"iosPage"
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *paramsStr = [dic objectForKey:@"iosParam"];
    if (HDIsStringNotEmpty(paramsStr)) {
        NSData *jsonData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
            if ([dicTemp isKindOfClass:[NSDictionary class]]) {
                self.startupParams = dicTemp;
            }
        }
    }

    NSString *imageNormal = dic[@"imageNormal"];
    if ([imageNormal isKindOfClass:NSString.class]) {
        NSDictionary *messageNameDict = imageNormal.hd_dictionary;
        self.imageNormal = [SATabBarImageModel yy_modelWithJSON:messageNameDict];
    }

    NSString *imageSelected = dic[@"imageSelected"];
    if ([imageSelected isKindOfClass:NSString.class]) {
        NSDictionary *messageNameDict = imageSelected.hd_dictionary;
        self.imageSelected = [SATabBarImageModel yy_modelWithJSON:messageNameDict];
    }
    return YES;
}

- (void)setLocalName:(SAInternationalizationModel *)localName localImage:(NSString *)localImage selectedLocalImage:(NSString *)selectedLocalImage {
    self.localName = localName;
    self.localImage = localImage;
    self.selectedLocalImage = selectedLocalImage;
}

- (void)setTitleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor {
    self.titleColor = titleColor;
    self.selectedTitleColor = selectedTitleColor;
}
@end

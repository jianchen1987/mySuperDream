//
//  GNArticleModel.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleModel.h"


@implementation GNArticleModel
- (NSArray<NSString *> *)imagePathArr {
    if (!_imagePathArr) {
        if ([self.imagePath isKindOfClass:NSString.class] && self.imagePath.length) {
            if ([self.imagePath containsString:@","]) {
                _imagePathArr = [self.imagePath componentsSeparatedByString:@","];
            } else {
                _imagePathArr = @[self.imagePath];
            }
        }
        if (!_imagePathArr) {
            _imagePathArr = @[];
        }
    }
    return _imagePathArr;
}

- (CGFloat)showHigh {
    if (!_showHigh) {
        if (!HDIsArrayEmpty(self.imagePathArr)) {
            for (NSString *url in self.imagePathArr) {
                if ([url containsString:@"="]) {
                    NSArray *arr = [url componentsSeparatedByString:@"="];
                    if (arr.count > 1) {
                        NSString *lastObj = arr.lastObject;
                        if ([lastObj containsString:@"x"]) {
                            NSArray *whArr = [lastObj componentsSeparatedByString:@"x"];
                            if (whArr.count > 1) {
                                CGFloat w = [whArr.firstObject floatValue];
                                CGFloat h = [whArr.lastObject floatValue];
                                if (w > kScreenWidth) {
                                    h = kScreenWidth / w * h;
                                }
                                if (_showHigh < h) {
                                    _showHigh = h;
                                }
                            }
                        }
                    }
                }
            }
            _showHigh = MIN(kRealWidth(540), _showHigh);
        }
    }

    return _showHigh;
}

@end

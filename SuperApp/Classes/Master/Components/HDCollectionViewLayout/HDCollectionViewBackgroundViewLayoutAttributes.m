///
//  HDCollectionViewBackgroundViewLayoutAttributes.m
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionViewBackgroundViewLayoutAttributes.h"


@implementation HDCollectionViewBackgroundViewLayoutAttributes
@synthesize headerFrame = _headerFrame;
@synthesize footerFrame = _footerFrame;

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath orginalFrmae:(CGRect)orginalFrame {
    HDCollectionViewBackgroundViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    [layoutAttributes setValue:[NSValue valueWithCGRect:orginalFrame] forKey:@"orginalFrame"];
    layoutAttributes.frame = orginalFrame;
    return layoutAttributes;
}

- (CGRect)orginalFrame {
    if ([self.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return _headerFrame;
    } else if ([self.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        return _footerFrame;
    } else {
        return self.frame;
    }
}

- (void)callMethod:(HDCollectionCellBaseEventModel *)eventModel {
    NSAssert([eventModel isKindOfClass:[HDCollectionCellBaseEventModel class]], @"callMethod必须传入 HDCollectionCellBaseEventModel 类型参数");
    if (eventModel == nil) {
        return;
    }
    if (eventModel.eventName != nil) {
        self.eventName = eventModel.eventName;
    }
    if (eventModel.parameter) {
        self.parameter = eventModel.parameter;
    }
}

@end

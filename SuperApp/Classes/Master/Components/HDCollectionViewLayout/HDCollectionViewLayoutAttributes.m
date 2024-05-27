///
//  HDCollectionViewLayoutAttributes.m
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import "HDCollectionViewLayoutAttributes.h"
#import "HDCollectionReusableView.h"


@implementation HDCollectionViewLayoutAttributes
@synthesize orginalFrame = _orginalFrame;

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath orginalFrmae:(CGRect)orginalFrame {
    HDCollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    [layoutAttributes setValue:[NSValue valueWithCGRect:orginalFrame] forKey:@"orginalFrame"];
    layoutAttributes.frame = orginalFrame;
    return layoutAttributes;
}

- (CGRect)orginalFrame {
    if ([self.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return _orginalFrame;
    } else {
        return self.frame;
    }
}

@end

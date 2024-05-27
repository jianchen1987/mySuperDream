//
//  TNCollectionReusableView.m
//  SuperApp
//
//  Created by 张杰 on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCollectionReusableView.h"


@implementation TNCollectionReusableView
+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    return [self headerWithCollectionView:collectionView forIndexPath:indexPath identifier:nil];
}

+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath identifier:(NSString *_Nullable)identifier {
    if (!identifier) {
        identifier = NSStringFromClass(self);
    }
    // 创建 header
    TNCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];

    if (!header) {
        header = [[self alloc] init];
    }
    return header;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
}
@end

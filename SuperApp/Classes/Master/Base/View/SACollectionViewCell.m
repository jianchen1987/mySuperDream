//
//  SACollectionViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"


@implementation SACollectionViewCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    return [self cellWithCollectionView:collectionView forIndexPath:indexPath identifier:nil];
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier {
    if (HDIsStringEmpty(identifier)) {
        identifier = NSStringFromClass(self);
    }
    [collectionView registerClass:self.class forCellWithReuseIdentifier:identifier];
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)commonInit {
    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];

    [self hd_setupViews];
    [self hd_bindViewModel];

    [self hd_languageDidChanged];

    [self setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - SAViewProtocol
- (void)hd_bindViewModel {
}

- (void)hd_setupViews {
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}
@end

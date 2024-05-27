///
//  HDCollectionViewLayoutAttributes.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, copy) UIColor *color;
@property (nonatomic, copy) UIImage *image;

// 此属性只是header会单独设置，其他均直接返回其frame属性
@property (nonatomic, assign, readonly) CGRect orginalFrame;

@end

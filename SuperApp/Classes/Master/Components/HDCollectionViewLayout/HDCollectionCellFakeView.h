///
//  HDCollectionCellFakeView.h
//  SuperApp
//
//  Created by VanJay on 2020/8/24.
//  Copyright © 2020 VanJay. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDCollectionCellFakeView : UIView

@property (nonatomic, weak) UICollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *cellFakeImageView;
@property (nonatomic, strong) UIImageView *cellFakeHightedView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGRect cellFrame;

- (instancetype)initWithCell:(UICollectionViewCell *)cell;
- (void)changeBoundsIfNeeded:(CGRect)bounds;
- (void)pushFowardView;
- (void)pushBackView:(void (^)(void))completion;

@end

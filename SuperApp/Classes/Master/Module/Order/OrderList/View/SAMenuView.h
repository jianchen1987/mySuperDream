//
//  SAMenuView.h
//
//
//  Created by Tia on 2023/2/16.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SAMenuViewDelegate <NSObject>

- (void)hasSelectedSAMenuViewIndex:(NSInteger)index;

@end


@interface SAMenuView : UIView

@property (nonatomic, weak) id<SAMenuViewDelegate> delegate;

- (instancetype)init; //初始化
- (void)setTargetView:(UIView *)target InView:(UIView *)superview;
- (void)setTitleArray:(NSArray *)array;
- (void)show;
- (void)dismiss;
+ (void)dismissAllSAMenu; //收回所有JRMenu
@end

NS_ASSUME_NONNULL_END

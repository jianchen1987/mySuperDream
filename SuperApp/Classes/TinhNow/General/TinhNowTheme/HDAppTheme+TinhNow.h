//
//  HDAppTheme+TNAppTheme.h
//  SuperApp
//
//  Created by seeu on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface THAppThemeColor : NSObject
- (UIColor *)cD6DBE8;
- (UIColor *)cFF8F1A;
- (UIColor *)c5d667f;
- (UIColor *)c14B96D;
- (UIColor *)cFFFFFF;
- (UIColor *)cFA3A18;
- (UIColor *)c222222;
- (UIColor *)c343B4D;
- (UIColor *)cADB6C8;
- (UIColor *)cF5F7FA;
- (UIColor *)cFF2323;
- (UIColor *)cFF8824;
- (UIColor *)c585858;
- (UIColor *)c666666;
- (UIColor *)cFFF3E8;
- (UIColor *)lineColor;
- (UIColor *)c5E6681;
/** #ff8812 */
- (UIColor *)C1;
/** #ffc95f */
- (UIColor *)C2;
/** #F83E00 */
- (UIColor *)C3;

/** #343b4d */
- (UIColor *)G1;
/** #5d667f */
- (UIColor *)G2;
/** #adb6c8 */
- (UIColor *)G3;
/** #E4E5EA */
- (UIColor *)G4;
/** #f5f7fa */
- (UIColor *)G5;
/** #f8f8fa */
- (UIColor *)G6;
/** #EBEDF0 */
- (UIColor *)G7;
/** FF2323*/
- (UIColor *)R1;
/** #F52138*/
- (UIColor *)R2;
/** #FF9457*/
- (UIColor *)R3;
/** #FF0000*/
- (UIColor *)R4;
@end


@interface THAppThemeFont : NSObject
- (UIFont *)standard20;
- (UIFont *)standard20B;
- (UIFont *)standard17B;
- (UIFont *)standard17;
- (UIFont *)standard16;
- (UIFont *)standard15;
- (UIFont *)standard15B;
- (UIFont *)standard14;
- (UIFont *)standard13;
- (UIFont *)standard12;
- (UIFont *)standard12B;
- (UIFont *)standard18B;
- (UIFont *)standard11;
- (UIFont *)standard14M;
- (UIFont *)standard15M; //中号字体
- (UIFont *)standard17M; //中号字体
- (UIFont *)standard20M; //中号字体
- (UIFont *)standard12M;

- (UIFont *)fontSemibold:(CGFloat)fontSize;
- (UIFont *)fontRegular:(CGFloat)fontSize;
- (UIFont *)fontMedium:(CGFloat)fontSize;
- (UIFont *)fontLight:(CGFloat)fontSize;
@end


@interface HDAppTheme (TinhNow)

+ (THAppThemeColor *)TinhNowColor;
+ (THAppThemeFont *)TinhNowFont;

@end

NS_ASSUME_NONNULL_END

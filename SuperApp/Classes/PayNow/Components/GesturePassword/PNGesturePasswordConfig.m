//
//  PNGesturePasswordConfig.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGesturePasswordConfig.h"
#import "PNUtilMacro.h"
#import "HDCommonDefines.h"


@implementation PNGesturePasswordConfig

+ (instancetype)sharedInstance {
    static PNGesturePasswordConfig *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
        [ins initData];
    });
    return ins;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (void)initData {
    self.strokeWidth = 1.0f;       //圆弧的宽度
    self.circleRadius = 65 / 2;    //半径
    self.centerPointRadius = 10.f; //中心圆半径
    self.lineWidth = 2.f;          //连接线宽度

    self.strokeColorNormal = [UIColor whiteColor];    //圆弧的填充颜色（正常）
    self.fillColorNormal = [UIColor whiteColor];      //除中心圆点外 其他部分的填充色（正常）
    self.centerPointColorNormal = HexColor(0x666666); //中心圆点的颜色（正常）
    self.lineColorNormal = [UIColor whiteColor];      //线条填充颜色（正常）

    self.strokeColorSelected = HexColor(0xd7f7eb);      //圆弧的填充颜色（选择）
    self.fillColorSelected = HexColor(0xd7f7eb);        //除中心圆点外 其他部分的填充色（选择）
    self.centerPointColorSelected = HexColor(0x35d59b); //中心圆点的颜色（选择）
    self.lineColorSelected = HexColor(0x35d59b);        //线条填充颜色（选择）

    self.strokeColorIncorrect = HexColor(0xfdddd6);      //圆弧的填充颜色（错误）
    self.fillColorIncorrect = HexColor(0xfdddd6);        //除中心圆点外 其他部分的填充色（错误）
    self.centerPointColorIncorrect = HexColor(0xf75730); //中心圆点的颜色（错误）
    self.lineColorIncorrect = HexColor(0xf75730);        //线条填充颜色（错误）

    self.showCenterPoint = YES; //是否显示中心圆
    self.fillCenterPoint = YES; //是否填充中心圆
}

@end

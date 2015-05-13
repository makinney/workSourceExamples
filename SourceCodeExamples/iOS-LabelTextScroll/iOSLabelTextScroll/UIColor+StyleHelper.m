//
//  UIColor+DefaultStyle.m
//  XoomApp
//
//  Created by Luiz Rath on 9/25/12.
//  Copyright (c) 2012 Xoom.com. All rights reserved.
//

#import "UIColor+StyleHelper.h"

@implementation UIColor (StyleHelper)

+ (UIColor *)colorWithRGBValueRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

#pragma mark - Blue Colors

+ (UIColor *)tapBlue {
    return [self colorWithRGBValueRed:240 green:241 blue:246 alpha:1.0f];
}

+ (UIColor *)xoomLink {
    return [UIColor colorWithRGBValueRed:0 green:135 blue:213 alpha:1.0];
}

+ (UIColor *)xoomBlue {
    return [UIColor colorWithRGBValueRed:23 green:51 blue:143 alpha:1.0f];
}


#pragma mark - Green Colors

+ (UIColor *)xoomGreen {
    return [UIColor colorWithRGBValueRed:70 green:156 blue:35 alpha:1.0f];
}

+ (UIColor *)lightGreen {
    return [UIColor colorWithRGBValueRed:240 green:247 blue:237 alpha:1.0f];
}

#pragma mark - Gray Colors

+ (UIColor *)translucentBlackColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85f];
}

+ (UIColor *)charcoalColor {
    return [UIColor colorWithRGBValueRed:64 green:64 blue:64 alpha:1.0f];
}

+ (UIColor *)simpleLineFiftyPercentOpacityColor {
    return [UIColor colorWithRGBValueRed:223 green:221 blue:215 alpha:0.5f];
}

+ (UIColor *)simpleLine {
    return [UIColor colorWithRGBValueRed:223 green:221 blue:215 alpha:1.0f];
}

+ (UIColor *)placeHolderGray {
    return [UIColor colorWithRGBValueRed:200 green:200 blue:200 alpha:1.0f];
}


#pragma mark - Red Colors

+ (UIColor *)errorRed {
    return [UIColor colorWithRGBValueRed:153 green:46 blue:39 alpha:1];
}

+ (UIColor *)lightRed {
    return [UIColor colorWithRGBValueRed:250 green:245 blue:245 alpha:1.0f];
}


#pragma mark - Beige Color

+ (UIColor *)lightTanFooter {
    return [UIColor colorWithRGBValueRed:211 green:205 blue:188 alpha:1];
}

+ (UIColor *)lightTanBackground {
    return [UIColor colorWithRGBValueRed:246 green:246 blue:244 alpha:1.0f];
}

+ (UIColor *)tanBackground {
    return [UIColor colorWithRGBValueRed:230 green:227 blue:219 alpha:1.0f];
}

+ (UIColor *)toolbarStroke {
    return [UIColor colorWithRGBValueRed:157 green:150 blue:135 alpha:1];
}

@end

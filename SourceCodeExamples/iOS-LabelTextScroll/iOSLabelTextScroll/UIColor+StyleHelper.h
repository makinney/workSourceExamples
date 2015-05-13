//
//  UIColor+DefaultStyle.h
//  XoomApp
//
//  Created by Luiz Rath on 9/25/12.
//  Copyright (c) 2012 Xoom.com. All rights reserved.
//

@interface UIColor (StyleHelper)

#pragma mark - Blue Colors

/*!
 tapBlueColor
 @note Red 240, Green 241, Blue 246, Alpha 1.0f
 */
+ (UIColor *)tapBlue;

/*!
 xoomLinkColor
 @note Red 0, Green 135, Blue 213, Alpha 1.0f
 */
+ (UIColor *)xoomLink;

/*!
 xoomBlueColor
 @note Red 23, Green 51, Blue 143, Alpha 1.0f
 */
+ (UIColor *)xoomBlue;

#pragma mark -  Green Colors

/*!
 xoomGreenColor
 @note Red 70, Green 156, Blue 35, Alpha 1.0f
 */
+ (UIColor *)xoomGreen;

/*!
 lightGreenColor
 @note Red 240, Green 247, Blue 237, Alpha 1.0f
 */
+ (UIColor *)lightGreen;


#pragma mark - Gray Colors
// Use [UIColor grayColor] for gray (#808080 [UIColor 128, 128, 128])

/*!
 translucentBlackColor
 @note Red 0, Green 0, Blue 0, Alpha 0.85f
 */
+ (UIColor *)translucentBlackColor;

/*!
 charcoalColor
 @note Red 64, Green 64, Blue 64, Alpha 1.0f
 */
+ (UIColor *)charcoalColor;

/*!
 simpleLineColor
 @note Red 223, Green 221, Blue 215, Alpha 1.0f
 */
+ (UIColor *)simpleLine;

/*!
 simpleLineFiftyPercentOpacityColor
 @note Red 223, Green 221, Blue 215, Alpha 0.5f
 */
+ (UIColor *)simpleLineFiftyPercentOpacityColor;

/*!
 placeHolderGrayColor
 @note Red 200, Green 200, Blue 200, Alpha 1.0f
 */
+ (UIColor *)placeHolderGray;

#pragma mark - RedColors
/*!
 errorRedColor
 @note Red 153, Green 46, Blue 39, Alpha 1.0f
 */
+ (UIColor *)errorRed;

/*!
 lightRedColor
 @note Red 245, Green 245, Blue 245, Alpha 1.0f
 */
+ (UIColor *)lightRed;

#pragma mark - Beige Color
/*!
 lightTanBackgroundColor
 @note Red 246, Green 246, Blue 244, Alpha 1.0f
 */
+ (UIColor *)lightTanBackground;

/*!
 tanBackgroundColor
 @note Red 230, Green 227, Blue 219, Alpha 1.0f
 */
+ (UIColor *)tanBackground;

/*!
 lightTanFooter
 @note Red 211, Green 205, Blue 188, Alpha 1.0f
 */
+ (UIColor *)lightTanFooter;

/*!
 toolbarStroke
 @note Red 157, Green 150, Blue 135, Alpha 1.0f
 */

+ (UIColor *)toolbarStroke;

@end

//
//  UILabel+XmaScroll_Private.h
//  LabelTextScrollAnimation
//
//  Created by Mike Kinney on 4/24/14.
//  Copyright (c) 2014 Xoom Corporation. All rights reserved.
//



@interface UILabel (XmaScroll_Private)

- (void)setText:(NSString *)text
	  scrolling:(XmaScrollAnimationType) scrollAnimtionType
		options:(UIViewAnimationOptions)options
	   duration:(CGFloat)duration
		  delay:(CGFloat)delay;

- (BOOL)xmaClippingDisabled;
- (BOOL)xmaBackgroundsOn;
- (void)xmaSetOriginalTextColor:(UIColor *)color;
- (UIColor *)xmaOriginalTextColor;

@end

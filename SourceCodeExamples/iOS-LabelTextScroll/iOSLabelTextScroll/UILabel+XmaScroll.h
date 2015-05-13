//
//  UILabel+XmaScroll.h
//  XoomApp
//
//  Created by Mike Kinney on 3/24/14.
//  Copyright (c) 2014 Xoom.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XmaScrollAnimationType) {
    XmaScrollNone = 1,
    XmaScrollDown,
    XmaScrollUp,
	XmaScrollDownUp
};


@interface UILabel (XmaScroll)

- (void)setText:(NSString *)text
	  scrolling:(XmaScrollAnimationType) scrollAnimtionType;

- (void)setText:(NSString *)text
	  scrolling:(XmaScrollAnimationType) scrollAnimtionType
	   duration:(CGFloat)duration;

// would normally only use this for debugging
- (void)xmaDisableClipping:(BOOL)disabled;
- (void)xmaShowBackgrounds:(BOOL)show;


@end

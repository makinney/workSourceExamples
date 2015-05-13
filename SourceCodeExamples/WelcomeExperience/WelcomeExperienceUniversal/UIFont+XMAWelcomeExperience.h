//
//  UIFont+XMAWelcomeExperience.h
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/28/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (XMAWelcomeExperience)
+ (UIFont *)XMAPreferredFontWithTextStyle:(NSString *)aTextStyle scale:(CGFloat)aScale;

- (NSString *)XMATextStyle;
- (UIFont *)XMAFontWithScale:(CGFloat)fontScale;
@end

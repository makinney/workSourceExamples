//
//  UIFontDescriptor+XMAWelcomeExperience.h
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/28/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFontDescriptor (XMAWelcomeExperience)
+ (UIFontDescriptor *)XMAPreferredFontDescriptorWithTextStyle:(NSString *)aTextStyle scale:(CGFloat)aScale;

- (NSString *)XMATextStyle;
- (UIFontDescriptor *)XMAFontDescriptorWithScale:(CGFloat)aScale;
@end

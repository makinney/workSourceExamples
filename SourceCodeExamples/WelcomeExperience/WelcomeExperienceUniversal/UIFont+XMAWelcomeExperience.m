//
//  UIFont+XMAWelcomeExperience.m
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/28/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "UIFont+XMAWelcomeExperience.h"
#import "UIFontDescriptor+XMAWelcomeExperience.h"

@implementation UIFont (XMAWelcomeExperience)

+ (UIFont *)XMAPreferredFontWithTextStyle:(NSString *)aTextStyle scale:(CGFloat)aScale
{
    UIFontDescriptor *newFontDescriptor = [UIFontDescriptor XMAPreferredFontDescriptorWithTextStyle:aTextStyle scale:aScale];
	
    return [UIFont fontWithDescriptor:newFontDescriptor size:newFontDescriptor.pointSize];
}

- (NSString *)XMATextStyle
{
    return [self.fontDescriptor XMATextStyle];
}

- (UIFont *)XMAFontWithScale:(CGFloat)aScale
{
    return [self fontWithSize:lrint(self.pointSize * aScale)];
}

@end

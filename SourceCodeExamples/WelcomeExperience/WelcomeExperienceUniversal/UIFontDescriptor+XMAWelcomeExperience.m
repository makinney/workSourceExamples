//
//  UIFontDescriptor+XMAWelcomeExperience.m
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/28/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "UIFontDescriptor+XMAWelcomeExperience.h"

@implementation UIFontDescriptor (XMAWelcomeExperience)

+ (UIFontDescriptor *)XMAPreferredFontDescriptorWithTextStyle:(NSString *)aTextStyle scale:(CGFloat)aScale
{
    UIFontDescriptor *newBaseDescriptor = [self preferredFontDescriptorWithTextStyle:aTextStyle];
	
    return [newBaseDescriptor fontDescriptorWithSize:lrint([newBaseDescriptor pointSize] * aScale)];
}

- (NSString *)XMATextStyle
{
    return [self objectForKey:@"NSCTFontUIUsageAttribute"];
}

- (UIFontDescriptor *)XMAFontDescriptorWithScale:(CGFloat)aScale
{
    return [self fontDescriptorWithSize:lrint(self.pointSize * aScale)];
}

@end

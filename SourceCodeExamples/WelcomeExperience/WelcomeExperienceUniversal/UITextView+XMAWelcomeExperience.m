//
//  UITextView+XMAWelcomeExperience.m
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/29/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "UITextView+XMAWelcomeExperience.h"
#import "UIFont+XMAWelcomeExperience.h"

@implementation UITextView (XMAWelcomeExperience)
- (NSString *)XMATextStyle {
    return [self.font XMATextStyle];
}
@end

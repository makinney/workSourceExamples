//
//  UILabel+XmaScroll.m
//  XoomApp
//
//  Created by Mike Kinney on 3/24/14.
//  Copyright (c) 2014 Xoom.com. All rights reserved.
//

#import "UILabel+XmaScroll.h"
#import "UIColor+StyleHelper.h"
#import <objc/runtime.h>

#define SLIDE_ANIMATION_DURATION_DEFAULT .5
#define ANIMATION_DELAY_DEFAULT 0


@implementation UILabel (XmaScroll)
static char	XMA_DISABLE_CLIPPING_KEY;
static char	XMA_SHOW_BACKGROUNDS_KEY;
static char	XMA_ORIGINAL_TEXT_COLOR_KEY;


- (void)setText:(NSString *)text
	  scrolling:(XmaScrollAnimationType) scrollAnimtionType {
	
	[self setText:text
		scrolling:scrollAnimtionType
		  options:UIViewAnimationOptionCurveEaseInOut
		 duration:SLIDE_ANIMATION_DURATION_DEFAULT
			delay:ANIMATION_DELAY_DEFAULT];
}

- (void)setText:(NSString *)text
	  scrolling:(XmaScrollAnimationType) scrollAnimtionType
	   duration:(CGFloat)duration{
	
	[self setText:text
		scrolling:scrollAnimtionType
		  options:UIViewAnimationOptionCurveEaseInOut
		 duration:duration
			delay:ANIMATION_DELAY_DEFAULT];
}


- (void)setText:(NSString *)text
	  scrolling:(XmaScrollAnimationType) scrollAnimationType
		options:(UIViewAnimationOptions)options
	   duration:(CGFloat)duration
		  delay:(CGFloat)delay
{
	
	if(text.length == 0) {
        text = @" "; // guard against zero size frame
    }
    
	if(scrollAnimationType == XmaScrollNone) {
		
		self.text = text;
		
	} else {
		
        UILabel *scrollingInLabel;
        NSLayoutConstraint *scrollInConstraint;
        UILabel *scrollingOutLabel;
        NSLayoutConstraint *scrollOutConstraint;

		CGFloat scrollInInitialPlacement;
		CGFloat scrollInFinalPlacement;
		CGFloat	scrollOutInitialPlacement;
		CGFloat	scrollOutFinalPlacement;
			
		CGFloat aboveLabel;
		CGFloat overLabel;
		CGFloat belowLabel;
				
		aboveLabel = self.frame.size.height;
		overLabel = 0;
		belowLabel = -self.frame.size.height;
		
		scrollingOutLabel = [[UILabel alloc] init];
        [self propertyCopyForScrollAnimation:scrollingOutLabel];
		scrollingOutLabel.text = self.text; // scroll out existing
		[self addSubview:scrollingOutLabel];
        scrollOutConstraint = [self setAnimationConstraintsForView:scrollingOutLabel yPlacement:overLabel];
		[self addConstraint:scrollOutConstraint];
		
		scrollingInLabel = [[UILabel alloc] init];
        [self propertyCopyForScrollAnimation:scrollingInLabel];
		scrollingInLabel.text = text; //  scroll in new
		[self addSubview:scrollingInLabel];
	    scrollInConstraint = [self setAnimationConstraintsForView:scrollingInLabel yPlacement:overLabel];
		[self addConstraint:scrollInConstraint];

		self.text = scrollingInLabel.text; // so a read during animation will return correct text value

		if(self.textColor != [UIColor clearColor]){ // allow for reentrancy during animation
			[self xmaSetOriginalTextColor:self.textColor];
			self.textColor = [UIColor clearColor];
		}
		
#ifndef DEBUG
		self.clipsToBounds = YES;
		scrollingInLabel.backgroundColor = [UIColor clearColor];
		scrollingOutLabel.backgroundColor = [UIColor clearColor];
#else
		if([self xmaClippingDisabled]) {
			self.clipsToBounds = NO;
		} else {
			self.clipsToBounds = YES;
		}
		
		if([self xmaBackgroundsOn]) {
			scrollingInLabel.backgroundColor = [UIColor lightGrayColor];
			scrollingOutLabel.backgroundColor = [UIColor tanBackground];
			
		} else {
			scrollingInLabel.backgroundColor = [UIColor clearColor];
			scrollingOutLabel.backgroundColor = [UIColor clearColor];
		}
#endif
				
		switch (scrollAnimationType) {
			case XmaScrollDown:
			{
				scrollInInitialPlacement = aboveLabel;
				scrollInFinalPlacement = overLabel;
				scrollOutInitialPlacement = overLabel;
				scrollOutFinalPlacement = belowLabel;
				break;
			}
			case XmaScrollUp:
			{
				scrollInInitialPlacement = belowLabel;
				scrollInFinalPlacement = overLabel;
				scrollOutInitialPlacement = overLabel;
				scrollOutFinalPlacement = aboveLabel;
				break;
			}
			case XmaScrollDownUp:
			{
				scrollInInitialPlacement = belowLabel;
				scrollInFinalPlacement = overLabel;
				scrollOutInitialPlacement = overLabel;
				scrollOutFinalPlacement = belowLabel;
				break;
			}
			default:
				break;
		}
		
		scrollInConstraint.constant = scrollInInitialPlacement;
		scrollOutConstraint.constant = scrollOutInitialPlacement;
	
  		[self layoutIfNeeded];
  		
		[UIView animateWithDuration:duration
							  delay:delay
							options:options
						 animations:^{
                             scrollInConstraint.constant = scrollInFinalPlacement;
							 scrollOutConstraint.constant = scrollOutFinalPlacement;
							 [self layoutIfNeeded];
						 } completion:^(BOOL finished) {
                             self.textColor = self.xmaOriginalTextColor;
							 [scrollingInLabel removeFromSuperview];
							 [scrollingOutLabel removeFromSuperview];
						 }];
	}
}


- (void)propertyCopyForScrollAnimation:(UILabel*)label {
  	label.enabled = self.enabled;
	label.numberOfLines = self.numberOfLines;
	label.textAlignment = self.textAlignment;
	label.textColor = self.textColor;
    label.font = self.font;
	label.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
}


- (NSLayoutConstraint *)setAnimationConstraintsForView:(UIView *) view yPlacement:(CGFloat)yPlacement {
    
    NSLayoutConstraint *scrollConstraint;
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                  options:NSLayoutFormatAlignAllCenterX
                                                                  metrics:nil
                                                                    views:NSDictionaryOfVariableBindings(view)]];
	
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(==view)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:NSDictionaryOfVariableBindings(self,view)]];
	
    scrollConstraint = [NSLayoutConstraint constraintWithItem:self
													attribute:NSLayoutAttributeTop
													relatedBy:NSLayoutRelationEqual
													   toItem:view
													attribute:NSLayoutAttributeTop
												   multiplier:1
													 constant:yPlacement];
    return scrollConstraint;
}


#pragma mark associates for category variables

- (void)xmaSetOriginalTextColor:(UIColor *)color {
	objc_setAssociatedObject(self, &XMA_ORIGINAL_TEXT_COLOR_KEY, color, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)xmaOriginalTextColor {
	UIColor * color = (UIColor *)objc_getAssociatedObject(self, &XMA_ORIGINAL_TEXT_COLOR_KEY);
	return color;
}

- (void)xmaDisableClipping:(BOOL)disable {
	objc_setAssociatedObject(self, &XMA_DISABLE_CLIPPING_KEY, [NSNumber numberWithBool:disable], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)xmaClippingDisabled {
	NSNumber *item = (NSNumber *)objc_getAssociatedObject(self, &XMA_DISABLE_CLIPPING_KEY);
	return [item boolValue];
}

- (void)xmaShowBackgrounds:(BOOL)show {
	objc_setAssociatedObject(self, &XMA_SHOW_BACKGROUNDS_KEY, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)xmaBackgroundsOn {
	NSNumber *item = (NSNumber *)objc_getAssociatedObject(self, &XMA_SHOW_BACKGROUNDS_KEY);
	return [item boolValue];
}




@end

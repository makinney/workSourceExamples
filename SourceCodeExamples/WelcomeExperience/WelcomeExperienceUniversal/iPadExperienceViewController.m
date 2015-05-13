//
//  iPadExperienceViewController.m
//  WelcomeExperienceUniversal
//
//  Created by Michael Kinney on 11/13/13.
//  Copyright (c) 2013 MikeKinney. All rights reserved.
//

#import "iPadExperienceViewController_Private.h"


@implementation iPadExperienceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.animationCanvasView.frame = CGRectMake(self.animationCanvasView.frame.origin.x, self.animationCanvasView.frame.origin.y, 960, 570);
	
	self.originalPhoneScreenCenter = self.phoneView.center;
	[self.view bringSubviewToFront:self.phoneView];
	[self phoneViewVisible:self.phoneSwitch.on];
	
}


- (void)phoneViewVisible:(BOOL)visible {
	float alphaOn = 1.0;
	if(visible) {
		self.phoneView.alpha = alphaOn;
	} else {
		self.phoneView.alpha = 0.0;
	}
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
	float value = sender.value;
	if(value > 640) {
		value = 640;
	}
	
	CGPoint offset = CGPointMake(value,0);
	
	self.animationCanvasView.scrollLocation = offset;
	
	CGPoint phoneCenter = CGPointMake(self.originalPhoneScreenCenter.x + value, self.originalPhoneScreenCenter.y);
	
	self.phoneView.center = phoneCenter;
	
}
- (IBAction)phoneSwitchStateChanged:(UISwitch *)sender {
	[self phoneViewVisible:sender.on];
}
@end

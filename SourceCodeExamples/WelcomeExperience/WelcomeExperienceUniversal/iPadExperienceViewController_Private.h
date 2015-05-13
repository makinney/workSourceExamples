//
//  iPadExperienceViewController_Private.h
//  WelcomeExperienceUniversal
//
//  Created by Michael Kinney on 11/13/13.
//  Copyright (c) 2013 MikeKinney. All rights reserved.
//

#import "iPadExperienceViewController.h"
#import "AnimationCanvasView.h"
@interface iPadExperienceViewController ()

@property (weak, nonatomic) IBOutlet AnimationCanvasView *animationCanvasView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
- (IBAction)phoneSwitchStateChanged:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *phoneSwitch;

@property (assign, nonatomic) CGPoint originalPhoneScreenCenter;

@end

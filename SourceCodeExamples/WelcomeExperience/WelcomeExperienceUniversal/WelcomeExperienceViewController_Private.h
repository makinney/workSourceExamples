//
//  WelcomeExperienceViewController_Private.h
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/11/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "WelcomeExperienceViewController.h"
#import "AnimationCanvasView.h"


@interface WelcomeExperienceViewController ()

- (IBAction)pageControlValueChanged:(UIPageControl *)sender;
@property (weak, nonatomic) IBOutlet AnimationCanvasView *animationCanvasView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) BOOL pageControlBeingUsed;

@end

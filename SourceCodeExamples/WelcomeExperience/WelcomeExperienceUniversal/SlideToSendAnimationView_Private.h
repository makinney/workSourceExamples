//
//  SlideToSendAnimationView_Private.h
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/24/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "SlideToSendAnimationView.h"
#import "FlagsModel.h"
#import "WalkPath.h"

@interface SlideToSendAnimationView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *barImage;
@property (weak, nonatomic) IBOutlet UIImageView *blueBorder;
@property (weak, nonatomic) IBOutlet UIImageView *buttonImage;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageViewA;
@property (weak, nonatomic) IBOutlet UIView *flagsView;
@property (weak, nonatomic) IBOutlet UIImageView *topBorder;

@property (nonatomic, strong) WalkPath * buttonWalkPath;
@property (nonatomic, strong) NSEnumerator *barEnumerator;
@property (nonatomic, strong) NSArray *barFileNames;
@property (nonatomic, strong) NSEnumerator *flagFileNameEnumerator;
@property (nonatomic, strong) FlagsModel *flagsModel;
@property (nonatomic, assign) float originalButtonToFlagXdistance;

@end

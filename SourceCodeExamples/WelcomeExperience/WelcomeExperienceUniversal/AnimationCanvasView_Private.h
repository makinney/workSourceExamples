//
//  AnimationCanvasView_Private.h
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/11/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "AnimationCanvasView.h"
#import "UIFont+XMAWelcomeExperience.h"
#import "UILabel+XMAWelcomeExperience.h"
#import "UITextView+XMAWelcomeExperience.h"
#import "MoveCalculator.h"
#import "SlideToSendAnimationView.h"
#import "WalkPath.h"

@interface AnimationCanvasView () <SlideToSendAnimationViewProtocol>

@property (nonatomic, assign) CGFloat animationCanvasHeight;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UIImageView *birthdayImage;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (weak, nonatomic) IBOutlet UIView *getStatusMoneyXferView;
@property (weak, nonatomic) IBOutlet UILabel *getStatusUpdatesLabel;
@property (weak, nonatomic) IBOutlet UITextView *happyBirthdayTextView;
@property (weak, nonatomic) IBOutlet UIView *happyBirthdayView;
@property (weak, nonatomic) IBOutlet UILabel *justSlideToSendLabel;
@property (weak, nonatomic) IBOutlet UITextView *justSlideToSendTextView;
@property (weak, nonatomic) IBOutlet UIView *justSlideView;
@property (weak, nonatomic) IBOutlet UITextView *moneyXferedTextView;
@property (weak, nonatomic) IBOutlet UITextView *neverReciteTextView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (weak, nonatomic) IBOutlet UILabel *scrollReadout;
@property (weak, nonatomic) IBOutlet UIView *shareDetailsNeverReciteView;
@property (weak, nonatomic) IBOutlet UILabel *shareTheDetailsLabel;
@property (nonatomic, strong) WalkPath * sideToSendAnimationViewWalkPath;
@property (weak, nonatomic) IBOutlet SlideToSendAnimationView *slideToSendAnimationView;
@property (weak, nonatomic) IBOutlet UIImageView *statusViewBubble;
@property (weak, nonatomic) IBOutlet UIImageView *thankyouImage;
@property (weak, nonatomic) IBOutlet UITextView *thankYouTextView;
@property (weak, nonatomic) IBOutlet UIView *thankYouView;
@property (weak, nonatomic) IBOutlet UIImageView *trackStatusImage;
@property (nonatomic, strong) NSMutableArray * walkPaths;

@end


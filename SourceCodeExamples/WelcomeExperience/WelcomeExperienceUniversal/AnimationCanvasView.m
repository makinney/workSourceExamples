//
//  AnimationCanvasView.m
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/11/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "AnimationCanvasView_Private.h"


#define ANIMATION_CANVAS_NIB @"AnimationCanvasView"
#define SCREEN_WIDTH 320
#define SCROLL_X_HALF_SCREEN  SCREEN_WIDTH / 2
#define SCROLL_X_ONE_SCREEN  SCREEN_WIDTH
#define DYNAMIC_TYPE_FONT_SCALE 1.7
#define DYNAMIC_TYPE_FONT_SCALE_NEVER_RECITE 0.8
#define DYNAMIC_TYPE_FONT_SCALE_MONEY_XFERED 0.8
#define DYNAMIC_TYPE_FONT_SCALE_COMPLETE_AVAILABLE 1.5
#define DYNAMIC_TYPE_FONT_SCALE_HAPPY_BIRTHDAY 0.7
#define DYNAMIC_TYPE_FONT_SCALE_THANK_YOU 0.65

@implementation AnimationCanvasView 


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *nibList = [[NSBundle mainBundle] loadNibNamed:ANIMATION_CANVAS_NIB owner:self options:nil];
        UIView *nibView = [nibList objectAtIndex:0];
		self.frame = nibView.frame;
        [self addSubview:nibView];
		self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
        self.slideToSendAnimationView.center = (CGPointMake(self.slideToSendAnimationView.center.x, self.slideToSendAnimationView.center.y + 305)); // FIXME hack - remove when auto layout installed
		self.slideToSendAnimationView.delegate = self;
        self.scrollReadout.text = [NSString stringWithFormat:@"x = %f",0.0];
		self.scrollReadout.alpha = 0.5;
		[self bringSubviewToFront:self.scrollReadout];
        self.neverReciteTextView.text = @"You never have to recite transaction details over the phone, just share it";
        self.moneyXferedTextView.text = @"Xoom notifies you when money is transfered, and available for pickup";
        self.thankYouTextView.text = @"Thank you so much!";
        self.happyBirthdayTextView.text = @"Happy Birthday Mom! Here are the details for the transfer I just sent";
        self.justSlideToSendTextView.text = @"Xoom makes it insanely simple to send money to family and friends in over 30 countries";
		[self updateFonts];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dynamicTypeContentSizeChanged)
													 name:@"UIContentSizeCategoryDidChangeNotification"
												   object:nil];
		[self loadWalkPaths];
		[self createSlideToSendAnimationViewWalkPath];
		
      }
    return self;
}

- (void)dynamicTypeContentSizeChanged {
	[self updateFonts];
}

- (void)updateFonts {
	UIFont *updatedFont;
	NSString *textStyle;
	
	textStyle = [self.justSlideToSendLabel XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE];
	self.justSlideToSendLabel.font = updatedFont;
    
    textStyle = [self.justSlideToSendTextView XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_NEVER_RECITE];
	self.justSlideToSendTextView.font = updatedFont;
	
	textStyle = [self.shareTheDetailsLabel XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE];
	self.shareTheDetailsLabel.font = updatedFont;
    
    textStyle = [self.neverReciteTextView XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_NEVER_RECITE];
	self.neverReciteTextView.font = updatedFont;
    
    textStyle = [self.getStatusUpdatesLabel XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE];
	self.getStatusUpdatesLabel.font = updatedFont;
    
    textStyle = [self.thankYouTextView XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_THANK_YOU];
	self.thankYouTextView.font = updatedFont;
    
	textStyle = [self.happyBirthdayTextView XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_HAPPY_BIRTHDAY];
	self.happyBirthdayTextView.font = updatedFont;
    
    textStyle = [self.moneyXferedTextView XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_MONEY_XFERED];
	self.moneyXferedTextView.font = updatedFont;
    
    textStyle = [self.completedLabel XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_COMPLETE_AVAILABLE];
	self.completedLabel.font = updatedFont;
    
    textStyle = [self.availableLabel XMATextStyle];
	updatedFont = [UIFont XMAPreferredFontWithTextStyle:textStyle scale:DYNAMIC_TYPE_FONT_SCALE_COMPLETE_AVAILABLE];
	self.availableLabel.font = updatedFont;
	
}


- (void)setScrollLocation:(CGPoint)scrollLocation {
    _scrollLocation = scrollLocation;
	for(WalkPath *walkPath in self.walkPaths){
		[walkPath move:scrollLocation];
	}
    [self.sideToSendAnimationViewWalkPath move:scrollLocation];
    [self.slideToSendAnimationView  moveButton:scrollLocation.x];
	
	self.scrollReadout.text = [NSString stringWithFormat:@"x = %f",scrollLocation.x];
}


- (void) createSlideToSendAnimationViewWalkPath {
    CGPoint pathStartPoint = CGPointMake(self.slideToSendAnimationView.center.x, self.slideToSendAnimationView.center.y);
    CGPoint scrollStartPoint = CGPointMake(0, 0); // at present scroll position
    CGPoint pathEndPoint = CGPointMake(pathStartPoint.x - 25, pathStartPoint.y); // FIXME :hack move to left enough for flags to center under label
	self.sideToSendAnimationViewWalkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
                                                               scrollStartPoint:scrollStartPoint
                                                                       pathUser:self.slideToSendAnimationView];
	[self.sideToSendAnimationViewWalkPath holdPositionOverScrollLength:60];
	[self.sideToSendAnimationViewWalkPath movePathToPostion:pathEndPoint overScrollLength:75];
}

// screen 1
//
- (WalkPath *) createScrollReadoutWalkPath {
    WalkPath * walkPath;
	walkPath = [[WalkPath alloc] initPathStartPoint:self.scrollReadout.center
								   scrollStartPoint:CGPointMake(0, 0)
										   pathUser:self.scrollReadout];
	[walkPath holdPositionOverScrollLength:SCROLL_X_ONE_SCREEN * 2];
    return walkPath;
}

- (WalkPath *) createJustSlideViewWalkPath {
    WalkPath * walkPath;
	walkPath = [[WalkPath alloc] initPathStartPoint:self.justSlideView.center
								   scrollStartPoint:CGPointMake(0, 0)
										   pathUser:self.justSlideView];
	[walkPath holdPositionOverScrollLength:125];
	CGPoint pathEndPoint = CGPointMake(self.justSlideView.center.x, self.justSlideView.center.y);
	[walkPath movePathToPostion:pathEndPoint overScrollLength:50];
    return walkPath;
}


// screen 2
//
- (WalkPath *) createShareDetailsNeverReciteWalkPath {
    WalkPath * walkPath;
    CGPoint pathStartPoint = CGPointMake((SCREEN_WIDTH + self.shareDetailsNeverReciteView.frame.size.width) , self.screenHeight - 100); //
    CGPoint scrollStartPoint = CGPointMake(0, 0);
    walkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
                                   scrollStartPoint:scrollStartPoint
                                           pathUser:self.shareDetailsNeverReciteView];
	
	
    CGFloat scrollRange = SCROLL_X_ONE_SCREEN - scrollStartPoint.x;
    CGPoint pathEndPoint = CGPointMake(self.shareDetailsNeverReciteView.center.x, self.shareDetailsNeverReciteView.center.y);
    [walkPath movePathToPostion:pathEndPoint overScrollLength:scrollRange];
    [walkPath holdPositionOverScrollLength:5];
    [walkPath movePathVerticalTo:- self.shareDetailsNeverReciteView.frame.size.height
                overScrollLength:100];
    return walkPath;
}


- (WalkPath *) createBirthdayImageWalkPath {
	WalkPath * walkPath;
	CGPoint scrollStartPoint = CGPointMake(125, 0);
	walkPath = [[WalkPath alloc] initMoveVerticalToOrigin:self.happyBirthdayView
										 scrollStartPoint:scrollStartPoint];
	[walkPath holdPositionOverScrollLength:10];
	[walkPath movePathVerticalTo:- self.happyBirthdayView.frame.size.height
				overScrollLength:140];
    return walkPath;
}


- (WalkPath *) createStatusBubbleWalkPath {
	WalkPath * walkPath;
	CGPoint scrollStartPoint = CGPointMake(200, 0);
	walkPath = [[WalkPath alloc] initMoveVerticalToOrigin:self.statusViewBubble
                                         scrollStartPoint:scrollStartPoint];
	[walkPath holdPositionOverScrollLength:15];
	[walkPath movePathVerticalTo:- self.statusViewBubble.frame.size.height
					overScrollLength:200];
    return walkPath;
}

- (WalkPath *) createThankYouImageWalkPath {
	WalkPath * walkPath;
	CGPoint scrollStartPoint = CGPointMake(275, 0);
	walkPath = [[WalkPath alloc] initMoveVerticalToOrigin:self.thankYouView
										 scrollStartPoint:scrollStartPoint];
	[walkPath holdPositionOverScrollLength:35];
	[walkPath movePathVerticalTo:- self.thankYouView.frame.size.height
				overScrollLength:200];
    return walkPath;
}


// screen 3
//
- (WalkPath *) createStatusUpdatesMoneyXferedWalkPath {
    WalkPath* walkPath;
	CGPoint pathStartPoint = CGPointMake((SCROLL_X_ONE_SCREEN * 2) + self.getStatusMoneyXferView.frame.size.width , self.getStatusMoneyXferView.center.y);
    CGPoint scrollStartPoint = CGPointMake(470, 0);
	walkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
								   scrollStartPoint:scrollStartPoint
										   pathUser:self.getStatusMoneyXferView];
	[walkPath movePathToPostion:self.getStatusMoneyXferView.center
			   overScrollLength:25];
    return walkPath;
}

- (WalkPath *) createGlobeWalkPath {
	WalkPath* walkPath;
    CGPoint pathStartPoint = CGPointMake(400 , self.screenHeight + self.trackStatusImage.frame.size.height); //
    CGPoint scrollStartPoint = CGPointMake(450, 0);
	walkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
								   scrollStartPoint:scrollStartPoint
										   pathUser:self.trackStatusImage];
	
	[walkPath movePathVerticalTo:self.trackStatusImage.center.y
			   overScrollLength:1];
	[walkPath movePathToPostion:self.trackStatusImage.center
			   overScrollLength:190];
    return walkPath;
}

- (WalkPath *) createCompletedLabelWalkPath {
    WalkPath* walkPath;
	CGPoint pathStartPoint = CGPointMake((SCROLL_X_ONE_SCREEN * 2) + self.completedLabel.frame.size.width , self.completedLabel.center.y);
    CGPoint scrollStartPoint = CGPointMake(320, 0);
	walkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
								   scrollStartPoint:scrollStartPoint
										   pathUser:self.completedLabel];
    CGFloat holdFor = 120;
    [walkPath holdPositionOverScrollLength:holdFor];
    [walkPath movePathToPostion:self.completedLabel.center
			   overScrollLength:(SCROLL_X_ONE_SCREEN * 2) - scrollStartPoint.x - holdFor - 50]; // magic number makes this label get to end before scrolling is over
    return walkPath;
}

- (WalkPath *) createAvailableForPickupLabelWalkPath {
    WalkPath* walkPath;
	CGPoint pathStartPoint = CGPointMake((SCROLL_X_ONE_SCREEN * 2) + self.availableLabel.frame.size.width , self.availableLabel.center.y);
    CGPoint scrollStartPoint = CGPointMake(320, 0);
	walkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
								   scrollStartPoint:scrollStartPoint
										   pathUser:self.availableLabel];
    CGFloat holdFor = 140;
    [walkPath holdPositionOverScrollLength:holdFor];
    [walkPath movePathToPostion:self.availableLabel.center
			   overScrollLength:(SCROLL_X_ONE_SCREEN * 2) - scrollStartPoint.x - holdFor]; // must subtract holdFor so scrollLenght is short enough to complete before scroll stops
    return walkPath;
}

- (void)loadWalkPaths {
    if(self.walkPaths.count == 0){
        [self.walkPaths addObject:self.createJustSlideViewWalkPath];
        [self.walkPaths addObject:self.createShareDetailsNeverReciteWalkPath];
        [self.walkPaths addObject:self.createStatusBubbleWalkPath];
		[self.walkPaths addObject:self.createBirthdayImageWalkPath];
		[self.walkPaths addObject:self.createThankYouImageWalkPath];
        [self.walkPaths addObject:self.createStatusUpdatesMoneyXferedWalkPath];
        [self.walkPaths addObject:self.createGlobeWalkPath];
        [self.walkPaths addObject:self.createCompletedLabelWalkPath];
        [self.walkPaths addObject:self.createAvailableForPickupLabelWalkPath];
        [self.walkPaths addObject:self.createScrollReadoutWalkPath];
     }
}

- (NSMutableArray *) walkPaths {
	if(!_walkPaths) {
		_walkPaths = [[NSMutableArray alloc] init];
	}
	return _walkPaths;
}
	
- (void) slideToSendDidComplete:(id)sender {
    // reserved for future use...
}

@end

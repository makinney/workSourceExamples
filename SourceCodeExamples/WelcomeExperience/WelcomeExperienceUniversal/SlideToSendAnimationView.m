//
//  SlideToSendAnimationView.m
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/24/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "SlideToSendAnimationView_Private.h"

#define SLIDE_TO_SEND_VIEW_NIB @"SlideToSendAnimationView"

@implementation SlideToSendAnimationView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *nibList = [[NSBundle mainBundle] loadNibNamed:SLIDE_TO_SEND_VIEW_NIB owner:self options:nil];
        UIView *nibView = [nibList objectAtIndex:0];
        self.frame = nibView.frame;
        nibView.backgroundColor = [UIColor whiteColor];
        [self addSubview:nibView];
        [self sendSubviewToBack:self.barImage]; // so bar is not in front of button or flags
        
        UIPanGestureRecognizer * buttonGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        buttonGestureRecognizer.delegate = self;
        [buttonGestureRecognizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:buttonGestureRecognizer];
 		self.barFileNames = @[@"BarOne.png",
                              @"BarTwo.png",
                              @"BarThree.png",
                              @"BarFour.png",];
		self.barEnumerator = self.barFileNames.objectEnumerator;
        self.buttonWalkPath = [self createButtonWalkPath];
        [self setupFlagSystem];
        [self animateFlagToFlag];
		[self animateBarToBar];
    }
    return self;
}


- (void) moveButton:(CGFloat)scrollXlocation {
    CGPoint scrollPosition = CGPointMake(scrollXlocation, self.buttonImage.center.y);
    if(self.buttonWalkPath) {
        [self.buttonWalkPath move:scrollPosition];
        [self adjustBarWidth];
//        [self adjustFlagRingAlpha];
        [self signalOnScrollComplete];
    }
}


- (void)animateBarToBar {
	self.barImage.alpha = 1.0;
	[UIView animateWithDuration:.1
						  delay:.15
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 self.barImage.alpha = 0.999;
					 } completion:^(BOOL finished) {
						 self.barImage.image = [self nextBarImage];
						 [self animateBarToBar];
					 }];
}

- (UIImage *)nextBarImage {
	UIImage * barImage;
	NSString *barFileName;
	id item;
	item = [self.barEnumerator nextObject];
	if(item) {
		barFileName = (NSString *)item;
		barImage = [UIImage imageNamed:barFileName];
	} else {
		self.barEnumerator = self.barFileNames.objectEnumerator;
		item = [self.barEnumerator nextObject];
		barFileName = (NSString *)item;
		barImage = [UIImage imageNamed:barFileName];
	}
	return barImage;
}


- (void)animateFlagToFlag {
	NSArray * subViews = self.flagsView.subviews;
	UIImageView *frontFlagView = (UIImageView *)subViews[1];
	
	frontFlagView.alpha = 1;
	[UIView animateWithDuration:.25 // fade duration seconds
						  delay:.25 // flag hold time
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 frontFlagView.alpha = 0;
					 } completion:^(BOOL finished) {
						 [self swapInNextFlag];
						 [self animateFlagToFlag];
					 }];
}

- (void)swapInNextFlag {
	// bring the flag that is in back now to front
	[self.flagsView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	NSArray * subViews = self.flagsView.subviews;
	UIImageView *backFlagView = (UIImageView *)subViews[0];
	backFlagView.image = [self nextFlagImage];
	backFlagView.alpha = 1.0; // FIXME: hack
}


- (UIImage *)nextFlagImage {
	UIImage * flagImage;
	id flagItem;
	flagItem = [self.flagFileNameEnumerator nextObject];
	if(flagItem) {
		NSString *flagName = (NSString *)flagItem;
		flagImage = [UIImage imageNamed:flagName];
	} else {
		self.flagFileNameEnumerator = self.flagFileNames.objectEnumerator;
		flagItem = [self.flagFileNameEnumerator nextObject];
		NSString *flagName = (NSString *)flagItem;
		flagImage = [UIImage imageNamed:flagName];
	}
	return flagImage;
}


- (void)setupFlagSystem {
	self.flagFileNameEnumerator = self.flagFileNames.objectEnumerator;
	[self.flagsView bringSubviewToFront:self.topBorder];
	[self.flagsView insertSubview:self.blueBorder belowSubview:self.topBorder];
	NSArray * subViews = self.flagsView.subviews;
	UIImageView * frontFlagView = (UIImageView *)subViews[1];
	frontFlagView.image = [self nextFlagImage];
	UIImageView *backFlagView = (UIImageView *)subViews[0];
	backFlagView.image = [self nextFlagImage];
}


- (WalkPath *) createButtonWalkPath {
    WalkPath * walkPath;
    CGFloat scrollRange = self.flagsView.center.x - self.buttonImage.center.x;
    scrollRange = scrollRange / 4; // higher number, faster the scroll
    CGFloat scrollStart = 5;
    CGPoint pathStartPoint = self.buttonImage.center;
    CGPoint scrollStartPoint = CGPointMake(scrollStart, self.buttonImage.center.y);
    CGPoint pathEndPoint = self.flagsView.center;
    self.originalButtonToFlagXdistance = pathEndPoint.x - pathStartPoint.x;
	walkPath = [[WalkPath alloc] initPathStartPoint:pathStartPoint
								   scrollStartPoint:scrollStartPoint
										   pathUser:self.buttonImage];
	
	[walkPath movePathToPostion:pathEndPoint overScrollLength:scrollRange];
	return walkPath;
}


- (void) signalOnScrollComplete {
    if(self.buttonImage.center.x == self.flagsView.center.x){
        if(self.delegate){
            [self.delegate slideToSendDidComplete:self];
        }
    }
}


- (void) adjustBarWidth {
    CGFloat barWidth = self.flagsView.center.x - self.buttonImage.center.x; //
    // keep left side of bar attached to buttonImage, also adjust center.y else bar will move down on first scroll
    CGRect frame = CGRectMake(self.buttonImage.center.x, self.buttonImage.center.y - (self.barImage.frame.size.height / 2 ), barWidth, self.barImage.frame.size.height);
    self.barImage.frame = frame;
}

- (void) adjustFlagRingAlpha {
    CGFloat alpha = (self.flagsView.center.x - self.buttonImage.center.x) / self.originalButtonToFlagXdistance;
    self.topBorder.alpha = alpha;
}


- (FlagsModel *) flagsModel {
	if(!_flagsModel){
		_flagsModel = [[FlagsModel alloc] init];
	}
	return _flagsModel;
}


- (NSArray *)flagFileNames {
	return self.flagsModel.flagFileNames;
}

-(void)handlePanGesture:(UIPanGestureRecognizer *) gestureRecognizer {
    // NOTE: MK reserved for future use
}



@end

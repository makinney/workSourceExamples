//
//  WelcomeAnimator.m
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/14/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "MoveCalculator_Private.h"

@implementation MoveCalculator

- (id)initWithPathStartPoint:(CGPoint)pathStartPoint
    scrollStartPoint:(CGPoint)scrollStartPoint
		pathEndPoint:(CGPoint)pathEndPoint
	  scrollEndPoint:(CGPoint)scrollEndPoint {
    self = [super init];
    if(self) {
       
        self.pathStartPoint = pathStartPoint;
		self.currentPathPosition = self.pathStartPoint;
		self.scrollStartPoint = scrollStartPoint;
        self.pathEndPoint = pathEndPoint;
		self.scrollEndPoint = scrollEndPoint;
        
		self.xSlope = (self.pathEndPoint.x - self.pathStartPoint.x) / (self.scrollEndPoint.x - self.scrollStartPoint.x);
        self.ySlope = (self.pathEndPoint.y - self.pathStartPoint.y) / (self.scrollEndPoint.x - self.scrollStartPoint.x);
			
    }
    return self;
}

- (CGPoint) calculatePathPositionFor:(CGPoint)scrollPosition {
	CGFloat xCalculated;
	CGFloat yCalculated;
	CGFloat scrollNormalized = scrollPosition.x - self.scrollStartPoint.x;
	
    xCalculated = self.pathStartPoint.x + (self.xSlope * scrollNormalized);
    if(self.pathStartPoint.x <= self.pathEndPoint.x){
        if(xCalculated < self.pathStartPoint.x ) {
            xCalculated = self.pathStartPoint.x;
        } else if (xCalculated > self.pathEndPoint.x){
            xCalculated = self.pathEndPoint.x;
        }
    } else {
        if(xCalculated > self.pathStartPoint.x ) {
            xCalculated = self.pathStartPoint.x;
        } else if (xCalculated < self.pathEndPoint.x){
            xCalculated = self.pathEndPoint.x;
        }
    }
	
	yCalculated = self.pathStartPoint.y + (self.ySlope * scrollNormalized);
	if(yCalculated > self.pathStartPoint.y ) {
		yCalculated = self.pathStartPoint.y;
	} else if (yCalculated < self.pathEndPoint.y ){
		yCalculated = self.pathEndPoint.y ;
	}
	
	self.currentPathPosition = CGPointMake(xCalculated, yCalculated);
	return self.currentPathPosition;
}

- (BOOL) inRangeScrollPosition:(CGPoint)scrollPosition {
	BOOL inRange = YES;
	if(scrollPosition.x < self.scrollStartPoint.x ||
	   scrollPosition.x > self.scrollEndPoint.x ) {
		inRange = NO;
	}
    return inRange;
}


@end

//
//  WalkPath.m
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/26/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.


#import "WalkPath_Private.h"

#define ONE_SCREEN_WIDTH 320
#define TWO_SCREEN_WIDTHS 640
#define THREE_SCREEN_WIDTHS 960

@implementation WalkPath


- (id)initMoveVerticalToOrigin:(UIView *)pathUser
			  scrollStartPoint:(CGPoint)scrollStartPoint {
	self = [super init];
	if(self) {
		self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
		self.pathUser = pathUser;
		self.isFirstMove = YES;
		self.moveCalculators = [[NSMutableArray alloc] init];
		self.scrollStartPoint = scrollStartPoint;
		
		CGFloat normalizedXdistanceFromLeftSide;
		if(self.pathUser.center.x <= ONE_SCREEN_WIDTH) { //
			normalizedXdistanceFromLeftSide = self.pathUser.center.x;
		} else if (self.pathUser.center.x <= TWO_SCREEN_WIDTHS) {
			normalizedXdistanceFromLeftSide = self.pathUser.center.x - ONE_SCREEN_WIDTH; // example for center.x == 520, the distance from left is 200
		} else {
			normalizedXdistanceFromLeftSide = self.pathUser.center.x - TWO_SCREEN_WIDTHS;
		}
		
		CGFloat partStartXposition = self.scrollStartPoint.x + normalizedXdistanceFromLeftSide;
		self.pathStartPoint = CGPointMake(partStartXposition, self.screenHeight + self.pathUser.frame.size.height / 2);
		CGPoint pathEndPoint = self.pathUser.center;
		CGFloat scrollXend = self.scrollStartPoint.x + (pathEndPoint.x - self.pathStartPoint.x);
		if(scrollXend > THREE_SCREEN_WIDTHS) {
			scrollXend = THREE_SCREEN_WIDTHS;
		}
		CGPoint scrollEndPoint = CGPointMake(scrollXend, self.scrollStartPoint.y);
		
		MoveCalculator * moveCalculator = [[MoveCalculator alloc] initWithPathStartPoint:self.pathStartPoint
																		scrollStartPoint:self.scrollStartPoint
																			pathEndPoint:pathEndPoint
																		  scrollEndPoint:scrollEndPoint];
		[self.moveCalculators addObject:moveCalculator];
		
		self.lastPathPoint = pathEndPoint;
		self.lastScrollPoint = scrollEndPoint;
	}
	return self;
}


- (id)initPathStartPoint:(CGPoint)pathStartPoint
		scrollStartPoint:(CGPoint)scrollStartPoint
				pathUser:(UIView *) pathUser {
	self = [super init];
	if(self) {
		self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
		self.pathStartPoint = pathStartPoint;
		self.lastPathPoint = self.pathStartPoint;
		self.scrollStartPoint = scrollStartPoint;
		self.lastScrollPoint = self.scrollStartPoint;
		self.pathUser = pathUser;
		self.isFirstMove = YES;
		self.moveCalculators = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void)holdPositionOverScrollLength:(CGFloat)scrollLength {
	
	CGPoint pathPoint = CGPointMake(self.lastPathPoint.x + scrollLength, self.lastPathPoint.y);
	CGPoint scrollPoint = CGPointMake(self.lastScrollPoint.x + scrollLength, self.lastScrollPoint.y);
	
  	MoveCalculator * moveCalculator = [[MoveCalculator alloc] initWithPathStartPoint:self.lastPathPoint
																	scrollStartPoint:self.lastScrollPoint
																		pathEndPoint:pathPoint
																	  scrollEndPoint:scrollPoint];
	[self.moveCalculators addObject:moveCalculator];
    
    self.lastPathPoint = pathPoint;
	self.lastScrollPoint = scrollPoint;
}


- (void)movePathToPostion:(CGPoint)pathPoint
		 overScrollLength:(CGFloat)scrollLength  {
	
	CGPoint scrollPoint = CGPointMake(self.lastScrollPoint.x + scrollLength, self.lastScrollPoint.y);
	
  	MoveCalculator * moveCalculator = [[MoveCalculator alloc] initWithPathStartPoint:self.lastPathPoint
																	scrollStartPoint:self.lastScrollPoint
																		pathEndPoint:pathPoint
																	  scrollEndPoint:scrollPoint];
	[self.moveCalculators addObject:moveCalculator];
    
    self.lastPathPoint = pathPoint;
	self.lastScrollPoint = scrollPoint;
}


- (void)movePathVerticalTo:(CGFloat)yLocation
		  overScrollLength:(CGFloat)scrollLength {
	
	CGPoint pathPoint = CGPointMake(self.lastPathPoint.x + scrollLength, yLocation);
	CGPoint scrollPoint = CGPointMake(self.lastScrollPoint.x + scrollLength, self.lastScrollPoint.y);
	
  	MoveCalculator * moveCalculator = [[MoveCalculator alloc] initWithPathStartPoint:self.lastPathPoint
																	scrollStartPoint:self.lastScrollPoint
																		pathEndPoint:pathPoint
																	  scrollEndPoint:scrollPoint];
	[self.moveCalculators addObject:moveCalculator];
    
    self.lastPathPoint = pathPoint;
	self.lastScrollPoint = scrollPoint;
}


- (void)move:(CGPoint)scrollPosition {
	MoveCalculator * moveCalculator;
	if(self.isFirstMove){
		self.pathUser.center = self.pathStartPoint;
		self.isFirstMove = NO;
	}
    
	if(scrollPosition.x < self.scrollStartPoint.x){
		moveCalculator = [self.moveCalculators objectAtIndex:0];
	} else if (scrollPosition.x > self.lastScrollPoint.x){
		moveCalculator = [self.moveCalculators lastObject];
	} else {
		for(MoveCalculator * calculator in self.moveCalculators){
			if([calculator inRangeScrollPosition:scrollPosition]){
				moveCalculator = calculator;
				break;
			}
		}
	}
    
	if(moveCalculator){
		CGPoint pathPosition = [moveCalculator calculatePathPositionFor:scrollPosition];
		if(pathPosition.x != self.pathUser.center.x || pathPosition.y != self.pathUser.center.y){
			self.pathUser.center = pathPosition;
		}
	}
}


@end

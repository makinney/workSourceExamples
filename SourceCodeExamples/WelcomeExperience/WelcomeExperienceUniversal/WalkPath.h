//
//  WalkPath.h
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/26/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalkPath : NSObject

- (id)initMoveVerticalToOrigin:(UIView *)pathUser
			  scrollStartPoint:(CGPoint)scrollStartPoint;

- (id)initPathStartPoint:(CGPoint)pathStartPoint
		scrollStartPoint:(CGPoint)scrollStartPoint
				pathUser:(UIView *) pathUser;

- (void)holdPositionOverScrollLength:(CGFloat)scrollLength;

- (void)movePathToPostion:(CGPoint)pathPoint
		 overScrollLength:(CGFloat)scrollLength;

- (void)movePathVerticalTo:(CGFloat)yLocation
		  overScrollLength:(CGFloat)scrollLength;

- (void)move:(CGPoint)scrollPosition;

@end

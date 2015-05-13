//
//  WelcomeAnimator.h
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/14/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveCalculator : NSObject

- (id)initWithPathStartPoint:(CGPoint)pathStartPoint
            scrollStartPoint:(CGPoint)scrollStartPoint
                pathEndPoint:(CGPoint)pathEndPoint
              scrollEndPoint:(CGPoint)scrollEndPoint;

- (BOOL) inRangeScrollPosition:(CGPoint)scrollPosition;

- (CGPoint) calculatePathPositionFor:(CGPoint)scrollPosition;


@end

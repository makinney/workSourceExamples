//
//  WelcomeAnimator_Private.h
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/14/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "MoveCalculator.h"
@interface MoveCalculator ()

@property (nonatomic, assign) CGPoint currentPathPosition;
@property (nonatomic, assign) CGPoint pathStartPoint;
@property (nonatomic, assign) CGPoint pathEndPoint;
@property (nonatomic, assign) CGPoint scrollEndPoint;
@property (nonatomic, assign) CGPoint scrollStartPoint;
@property (nonatomic, assign) CGFloat xSlope;
@property (nonatomic, assign) CGFloat ySlope;

@end

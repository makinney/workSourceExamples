//
//  WalkPath_Private.h
//  WelcomeExperience
//
//  Created by Michael Kinney on 10/26/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "WalkPath.h"
#import "MoveCalculator.h"

@interface WalkPath ()

@property (nonatomic, assign) BOOL isFirstMove;
@property (nonatomic, assign) CGPoint lastPathPoint;
@property (nonatomic, assign) CGPoint lastScrollPoint;
@property (nonatomic, strong) NSMutableArray *moveCalculators;
@property (nonatomic, assign) CGPoint pathStartPoint;
@property (nonatomic, assign) CGPoint pathEndPoint;
@property (nonatomic, strong) UIView * pathUser;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGPoint scrollEndPoint;
@property (nonatomic, assign) CGPoint scrollStartPoint;

@end

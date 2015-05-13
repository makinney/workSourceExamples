//
//  SlideToSendAnimationView.h
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/24/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideToSendAnimationViewProtocol <NSObject>

- (void) slideToSendDidComplete:(id) sender;

@end

@interface SlideToSendAnimationView : UIView

@property (weak, nonatomic) id <SlideToSendAnimationViewProtocol> delegate;

- (void) moveButton:(CGFloat) scrollXlocation;

@end

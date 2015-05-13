//
//  MarketingDataSource.h
//  UILabelTextScroll
//
//  Created by Michael Kinney on 5/21/14.
//  Copyright (c) 2014 Xoom. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN NSString *const XmDemoDataSourceKeyPath;


@interface MarketingDataSource : NSObject

- (id)init;
- (NSString *)firstSentence;
- (NSString *)nextSentence;
- (NSString *)priorSentence;


@end

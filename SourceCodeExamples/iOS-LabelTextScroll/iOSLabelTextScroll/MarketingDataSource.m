//
//  MarketingDataSource.m
//  UILabelTextScroll
//
//  Created by Michael Kinney on 5/21/14.
//  Copyright (c) 2014 Xoom. All rights reserved.
//

#import "MarketingDataSource.h"

NSString *const XmDemoDataSourceKeyPath = @"marketingSayingsKey";

@interface MarketingDataSource()

@property (nonatomic, strong) NSArray *allMarketingSentences;
@property (nonatomic, assign) NSInteger sentenceIndex;

@end


@implementation MarketingDataSource


- (id)init {
    self = [super init];
    if(self) {
        self.sentenceIndex = -1;
    }
    return self;
}

- (NSString *)firstSentence {
	self.sentenceIndex = 0;
	NSString *demoItem = (NSString *)self.allMarketingSentences[self.sentenceIndex];
    return demoItem;
}

- (NSString *)nextSentence {
	self.sentenceIndex = self.sentenceIndex + 1;
	if(self.sentenceIndex >= self.allMarketingSentences.count) {
		self.sentenceIndex = 0; // wrap
	}
	NSString *demoItem = (NSString *)self.allMarketingSentences[self.sentenceIndex];
    return demoItem;
}

- (NSString *)priorSentence {
	self.sentenceIndex = self.sentenceIndex - 1;
	if(self.sentenceIndex < 0) {
		self.sentenceIndex = self.allMarketingSentences.count - 1; // wrap
	}
	NSString *demoItem = (NSString *)self.allMarketingSentences[self.sentenceIndex];
    return demoItem;
	
}

- (NSArray *) allMarketingSentences {
	if(!_allMarketingSentences) {
		_allMarketingSentences = @[@"Xoom",
								  @"Send money to 31 countries",
								  @"Low fees",
								  @"Locked-in exchange rates",
								  @"Safe and secure",
								  @"Peace of mind with text updates",
								  @"The easiest way to send money",
								  @"Desktop Browser",
								  @"Mobile Web",
								  @"Android App",
								  @"iPhone App"];
		
	}
	return _allMarketingSentences;
}



@end

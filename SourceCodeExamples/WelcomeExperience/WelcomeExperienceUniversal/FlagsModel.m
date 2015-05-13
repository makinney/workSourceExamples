//
//  FlagsModel.m
//  FlagShow
//
//  Created by Michael Kinney on 10/8/13.
//  Copyright (c) 2013 Michael Kinney. All rights reserved.
//

#import "FlagsModel.h"

@interface FlagsModel()

@property (nonatomic, strong, readwrite) NSArray *flagFileNames;

@end

@implementation FlagsModel

- (id)init {
	self = [super init];
	if(self) {
		[self loadFlagFileNames];
	}
	
	return self;
}

- (void)loadFlagFileNames {
	
	self.flagFileNames = @[@"ar.png",
                           @"au.png",
						   @"bo.png",
						   @"br.png",
						   @"ca.png",
						   @"cl.png",
						   @"cn.png",
						   @"co.png",
                           @"cr.png",
                           @"de.png",
                           @"do.png",
                           @"fr.png",
                           @"ec.png",
                           @"es.png",
                           @"gb.png",
                           @"gt.png",
                           @"hn.png",
                           @"ie.png",
                           @"in.png",
                           @"it.png",
                           @"jm.png",
                           @"mx.png",
                           @"ni.png",
                           @"nl.png",
                           @"pa.png",
                           @"pe.png",
                           @"ph.png",
                           @"pl.png",
                           @"sv.png",
                           @"us.png",
                           @"uy.png",
                           @"vn.png",
                           @"za.png"];
}

@end

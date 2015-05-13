//
//  FlagsModel.h
//  FlagShow
//
//  Created by Michael Kinney on 10/8/13.
//  Copyright (c) 2013 Michael Kinney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagsModel : NSObject

@property (nonatomic, strong, readonly) NSArray *flagFileNames;

- (id)init;

@end

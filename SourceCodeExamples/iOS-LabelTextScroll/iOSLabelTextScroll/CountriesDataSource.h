//
//  CountriesDataSource.h
//  UILabelTextScroll
//
//  Created by Mike Kinney on 5/17/14.
//  Copyright (c) 2014 Xoom. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN NSString *const SignUpCountryPickerViewDataSourceCountryCodeKeyPath;
OBJC_EXTERN NSString *const SignUpCountryPickerViewDataSourceCountryNameKeyPath;


@interface CountriesDataSource : NSObject


- (id)init;
- (NSString *)firstCountry; 
- (NSString *)nextCountry;
- (NSString *)previousCountry;



@end

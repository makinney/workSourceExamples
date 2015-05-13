//
//  CountriesDataSource.m
//  UILabelTextScroll
//
//  Created by Mike Kinney on 5/17/14.
//  Copyright (c) 2014 Xoom. All rights reserved.
//

#import "CountriesDataSource.h"

NSString *const SignUpCountryPickerViewDataSourceCountryCodeKeyPath = @"countryCode";
NSString *const SignUpCountryPickerViewDataSourceCountryNameKeyPath = @"countryName";

@interface CountriesDataSource()

@property (nonatomic, strong) NSArray *allCountries;
@property (nonatomic, assign) NSUInteger countryIndex;

@end


@implementation CountriesDataSource

- (id)init {
    self = [super init];
    if(self) {
        self.countryIndex = -1;
    }
    return self;
}

- (NSString *)firstCountry {
    self.countryIndex = 0;
    NSDictionary *countryDictionary = [self.allCountries objectAtIndex:self.countryIndex];
    NSString *countryName = [countryDictionary objectForKey:SignUpCountryPickerViewDataSourceCountryNameKeyPath];
    return countryName;
}

- (NSString *)nextCountry {
    self.countryIndex = self.countryIndex + 1;
    if(self.countryIndex >= self.allCountries.count){
        self.countryIndex = 0;
    }
    NSDictionary *countryDictionary = [self.allCountries objectAtIndex:self.countryIndex];
    NSString *countryName = [countryDictionary objectForKey:SignUpCountryPickerViewDataSourceCountryNameKeyPath];
    return countryName;
}

- (NSString *)previousCountry {
    if(self.countryIndex == 0){
        self.countryIndex = self.allCountries.count - 1;
    } else {
        self.countryIndex = self.countryIndex - 1;
    }
    NSDictionary *countryDictionary = [self.allCountries objectAtIndex:self.countryIndex];
    NSString *countryName = [countryDictionary objectForKey:SignUpCountryPickerViewDataSourceCountryNameKeyPath];
    return countryName;
}


- (NSArray *)allCountries {
    if (!_allCountries) {
        _allCountries = @[
								@{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"AR", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Argentina" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"AU", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Australia" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"BO", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Bolivia" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"BR", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Brazil" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"CA", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Canada" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"CL", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Chile" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"CO", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Colombia" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"CR", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Costa Rica" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"DO", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Dominican Republic" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"EC", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Ecuador" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"EG", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Egypt" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"SV", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"El Salvador" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"FR", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"France" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"DE", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Germany" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"GT", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Guatemala" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"HN", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Honduras" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"IN", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"India" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"IE", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Ireland" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"IT", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Italy" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"JM", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Jamaica" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"MX", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Mexico" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"NL", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Netherlands" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"NI", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Nicaragua" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"PA", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Panama" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"PE", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Peru" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"PH", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Philippines" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"PL", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Poland" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"ES", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Spain" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"GB", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"United Kingdom" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"UY", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Uruguay" },
                                @{ SignUpCountryPickerViewDataSourceCountryCodeKeyPath:@"VN", SignUpCountryPickerViewDataSourceCountryNameKeyPath:@"Vietnam" }
                                ];
    }
    return _allCountries;
}



@end

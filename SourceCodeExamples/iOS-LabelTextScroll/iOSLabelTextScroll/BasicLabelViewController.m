//
//  BasicLabelViewController.m
//  UILabelTextScroll
//
//  Created by Michael Kinney on 5/20/14.
//  Copyright (c) 2014 Xoom. All rights reserved.
//

#import "BasicLabelViewController.h"
#import "CountriesDataSource.h"
#import "MarketingDataSource.h"
#import "UIColor+StyleHelper.h"
#import "UILabel+XmaScroll.h"

typedef NS_ENUM(NSUInteger, DataSourceSelected) {
	CountriesDataSourceSelected = 1,
    MarketingDataSourceSelected
};


@interface BasicLabelViewController ()

- (IBAction)dataSourceSelectedChanged:(UISegmentedControl *)sender;
- (IBAction)normalDebugModeChanged:(UISegmentedControl *)sender;
- (IBAction)scrollDirectionSelectedChanged:(UISegmentedControl *)sender;
- (IBAction)sliderChanged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CountriesDataSource *countriesDataSource;
@property (nonatomic, assign) DataSourceSelected dataSourceSelected;
@property (nonatomic, assign) BOOL dataSourceSwitched;
@property (nonatomic, strong) MarketingDataSource *marketingDataSource;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, assign) XmaScrollAnimationType xmaScrollAnimationType;

@end

@implementation BasicLabelViewController

#pragma mark view life cycle and appearance

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self configureAppearance];
	[self debugDisplayModeEnabled:NO];
			
	self.xmaScrollAnimationType = XmaScrollUp;
	self.dataSourceSelected = MarketingDataSourceSelected;
	self.dataSourceSwitched = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self scrollLabel];
	[self updateTimerAndAnimationTimes:self.rateSlider.value];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.timer invalidate];
	self.timer = nil;
}

- (void)configureAppearance {
	self.labelA.layer.borderWidth = 1.0f;
	self.labelA.layer.borderColor = [UIColor grayColor].CGColor;
	self.view.backgroundColor = [UIColor lightGreen];
}

- (void)debugDisplayModeEnabled:(BOOL)debugDisplayModeEnabled {
	[self.labelA xmaDisableClipping:debugDisplayModeEnabled];
	[self.labelA xmaShowBackgrounds:debugDisplayModeEnabled];
}

#pragma mark data

-(NSString *)dataSourceText {
	NSString *text;
	if(self.dataSourceSelected == MarketingDataSourceSelected) {
		if(self.dataSourceSwitched){
			text = [self.marketingDataSource firstSentence];
			self.dataSourceSwitched = NO;
		} else {
			text = [self.marketingDataSource nextSentence];
		}
	} else {
		if(self.dataSourceSwitched){
			text = [self.countriesDataSource firstCountry];
			self.dataSourceSwitched = NO;
		} else {
			text = [self.countriesDataSource nextCountry];
		}
	}
	return text;
}


#pragma mark scroll

- (void)scrollLabel {
	[self.labelA setText:[self dataSourceText]
			   scrolling:self.xmaScrollAnimationType
				duration:self.animationDuration];
}

- (void)timerFired:(NSTimer *)timer {
	[self scrollLabel];
}


#pragma mark segmented controls

- (IBAction)normalDebugModeChanged:(UISegmentedControl *)sender {
	switch (sender.selectedSegmentIndex) {
		case 0:
			[self debugDisplayModeEnabled:NO];
			break;
		case 1:
			[self debugDisplayModeEnabled:YES];
			break;
		default:
			[self debugDisplayModeEnabled:NO];
			break;
	}
}

- (IBAction)dataSourceSelectedChanged:(UISegmentedControl *)sender {
	switch (sender.selectedSegmentIndex) {
		case 0:
			self.dataSourceSelected = MarketingDataSourceSelected;
			if(!self.dataSourceSwitched) {
				self.dataSourceSwitched = YES;
			}
			break;
		case 1:
			self.dataSourceSelected = CountriesDataSourceSelected;
			if(!self.dataSourceSwitched) {
				self.dataSourceSwitched = YES;
			}
			break;
		default:
			break;
	}
}

- (IBAction)scrollDirectionSelectedChanged:(UISegmentedControl *)sender {
	switch (sender.selectedSegmentIndex) {
		case 0:
			self.xmaScrollAnimationType = XmaScrollUp;
			break;
		case 1:
			self.xmaScrollAnimationType = XmaScrollDown;
			break;
		case 2:
			self.xmaScrollAnimationType = XmaScrollDownUp;
			break;
		case 3:
			self.xmaScrollAnimationType = XmaScrollNone;
			break;
		default:
			break;
	}
}

#pragma mark animation rate control

- (void)updateTimerAndAnimationTimes:(CGFloat)value {
	if(value < 0.5) {
		value = 0.5;
	}
	self.timerInterval = value;
	self.animationDuration = value * 0.8; // so timer firing does not interrupt animation
}


- (IBAction)sliderChanged:(UISlider *)sender {
	[self.timer invalidate];
	self.timer = nil;
	[self updateTimerAndAnimationTimes:sender.value];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}


#pragma mark lazy instantiation

- (CountriesDataSource *) countriesDataSource{
    if(!_countriesDataSource) {
        _countriesDataSource = [[CountriesDataSource alloc] init];
    }
    return _countriesDataSource;
}

- (MarketingDataSource *) marketingDataSource {
	if(!_marketingDataSource ) {
		_marketingDataSource = [[MarketingDataSource alloc] init];
	}
	return _marketingDataSource;
}


@end

//
//  HotDoggingViewController.m
//  UILabelTextScroll
//
//  Created by Michael Kinney on 5/12/14.
//  Copyright (c) 2014 Xoom. All rights reserved.
//

#import "MultiiLabelViewController.h"
#import "CountriesDataSource.h"
#import "UIColor+StyleHelper.h"
#import "UILabel+XmaScroll.h"
#import "MarketingDataSource.h"

typedef NS_ENUM(NSUInteger, DataSourceSelected) {
    MarketingDataSourceSelected = 1,
    CountriesDataSourceSelected
};

@interface MultiiLabelViewController ()

- (IBAction)dataSourceSelectedChanged:(UISegmentedControl *)sender;
- (IBAction)normalDebugModeChanged:(UISegmentedControl *)sender;
- (IBAction)rateSliderChanged:(UISlider *)sender;
- (IBAction)scrollDirectionSelectedChanged:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UILabel *labelB;
@property (weak, nonatomic) IBOutlet UILabel *labelC;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *dataSourceControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scrollTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *normalDebugMode;

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CountriesDataSource *countriesDataSource;
@property (nonatomic, assign) BOOL dataSourceSwitched;
@property (nonatomic, assign) DataSourceSelected dataSourceSelected;
@property (nonatomic, strong) MarketingDataSource *marketingDataSource;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, assign) XmaScrollAnimationType xmaScrollAnimationType;

@end

@implementation MultiiLabelViewController

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
	[self scrollLabels];
	[self updateTimerAndAnimationTimes:self.rateSlider.value];
	 self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.timer invalidate];
	self.timer = nil;
}

- (void)configureAppearance {
	self.view.backgroundColor = [UIColor lightGreen];
	self.labelA.layer.borderWidth = 1.0f;
	self.labelA.layer.borderColor = [UIColor grayColor].CGColor;
	self.labelB.layer.borderWidth = 1.0f;
	self.labelB.layer.borderColor = [UIColor grayColor].CGColor;
	self.labelC.layer.borderWidth = 1.0f;
	self.labelC.layer.borderColor = [UIColor grayColor].CGColor;

}

- (void)debugDisplayModeEnabled:(BOOL)debugDisplayModeEnabled {
	[self.labelA xmaDisableClipping:debugDisplayModeEnabled];
	[self.labelB xmaDisableClipping:debugDisplayModeEnabled];
	[self.labelC xmaDisableClipping:debugDisplayModeEnabled];
	[self.labelA xmaShowBackgrounds:debugDisplayModeEnabled];
	[self.labelB xmaShowBackgrounds:debugDisplayModeEnabled];
	[self.labelC xmaShowBackgrounds:debugDisplayModeEnabled];
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

- (void)scrollLabels {
    if(self.xmaScrollAnimationType == XmaScrollDown){
        [self scrollLabelsDownWithText:[self dataSourceText]];
    } else if(self.xmaScrollAnimationType == XmaScrollUp) {
		[self scrollLabelsUpWithText:[self dataSourceText]];
    } else {
		[self scrollLabelsUpAndDownWithText:[self dataSourceText]];
    }
}

- (void) scrollLabelsUpWithText:(NSString *)labelText {
	[self.labelA setText:self.labelB.text scrolling:XmaScrollUp];
	[self.labelB setText:self.labelC.text scrolling:XmaScrollUp];
	[self.labelC setText:labelText scrolling:XmaScrollUp];
}

- (void) scrollLabelsDownWithText:(NSString *)labelText {
	[self.labelC setText:self.labelB.text scrolling:XmaScrollDown];
	[self.labelB setText:self.labelA.text scrolling:XmaScrollDown];
	[self.labelA setText:labelText scrolling:XmaScrollDown];
}

- (void) scrollLabelsUpAndDownWithText:(NSString *)labelText {
	[self.labelA setText:self.labelB.text scrolling:XmaScrollDownUp];
	[self.labelB setText:self.labelC.text scrolling:XmaScrollDownUp];
	[self.labelC setText:labelText scrolling:XmaScrollDownUp];
}

- (void)timerFired:(NSTimer *)timer {
	[self scrollLabels];
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
		default:
			break;
	}
}

#pragma mark animation rate control

- (void)updateTimerAndAnimationTimes:(CGFloat)value {
	if(value < 1) {
		value = 1;
	}
	self.timerInterval = value;
	self.animationDuration = value * 0.8; // so timer firing does not interrupt animation
}

- (IBAction)rateSliderChanged:(UISlider *)sender {
	[self.timer invalidate];
	self.timer = nil;
	[self updateTimerAndAnimationTimes:sender.value];
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}


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

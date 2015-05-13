//
//  WelcomeExperienceViewController.m
//  WelcomeExperience
//
//  Created by Mike Kinney on 10/11/13.
//  Copyright (c) 2013 Mike Kinney. All rights reserved.
//

#import "WelcomeExperienceViewController_Private.h"

@implementation WelcomeExperienceViewController
#define PAGE_NUMBERING_BEGINS_AT 1


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageControlBeingUsed = NO;
    CGFloat yLocation = self.pageControl.center.y;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    yLocation = screenHeight - 60; // FIXME: hack hack till auto-layout turned on...
    self.pageControl.center = CGPointMake(self.pageControl.center.x, yLocation);
    self.animationCanvasView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.animationCanvasView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.animationCanvasView.frame.size.width, self.animationCanvasView.frame.size.height);
	NSLog(@"content width %f h %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height );
//	self.scrollView.delegate = self;
    [self.view bringSubviewToFront:self.pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!self.pageControlBeingUsed) {
		CGFloat pageWidth = self.scrollView.frame.size.width;
		NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + PAGE_NUMBERING_BEGINS_AT;
		self.pageControl.currentPage = page;
	}
    self.animationCanvasView.scrollLocation = self.scrollView.contentOffset;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.pageControlBeingUsed = NO;
}


- (IBAction)pageControlValueChanged:(UIPageControl *)sender {
  	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlBeingUsed = YES;
}

    
@end

//
//  MDRadialProgressTheme.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 07/10/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import "MDRadialProgressTheme.h"
#import "UIColor+CTExtensions.h"

// The font size is automatically adapted but this is the maximum it will get
// unless overridden by the user.
static const int kMaxFontSize = 64;


@implementation MDRadialProgressTheme

+ (id)themeWithName:(const NSString *)themeName
{
	return [[MDRadialProgressTheme alloc] init];
}

+ (id)standardTheme
{
	return [MDRadialProgressTheme themeWithName:STANDARD_THEME];
}

- (id)init
{
	self = [super init];
	if (self) {
		// View
        self.completedColor = [UIColor zl_getColorWithRed:37
                                                    green:156
                                                     blue:208
                                                    alpha:0.9];
		self.incompletedColor = [UIColor zl_getColorWithRed:234
                                                      green:234
                                                       blue:234
                                                      alpha:1.0];
		self.sliceDividerColor = [UIColor whiteColor];
		self.centerColor = [UIColor clearColor];
		self.thickness = 30;
		self.sliceDividerHidden = NO;
		self.sliceDividerThickness = 2;
		
		// Label
		self.labelColor = [UIColor blackColor];
		self.dropLabelShadow = YES;
		self.labelShadowColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
		self.labelShadowOffset = CGSizeMake(1, 1);
		self.font = [UIFont systemFontOfSize:kMaxFontSize];
	}
	
	return self;
}

@end

//
//  NSDate+CTExtensions.m
//  CTFoundation
//
//  Created by Haoran Chen on 2/8/14.
//  Copyright (c) 2014 Ctrip. All rights reserved.
//

#import "NSDate+CTExtensions.h"

@implementation NSDate (CTExtensions)

- (long)zl_dayNumber
{
    return (long)floor(([self timeIntervalSinceReferenceDate] + [[NSTimeZone localTimeZone] secondsFromGMTForDate:self]) / (double)(60 * 60 * 24));
}

- (NSDate *)zl_boundaryForCalendarUnit:(NSCalendarUnit)calendarUnit
{
	NSDate *boundary;
	[[NSCalendar currentCalendar] rangeOfUnit:calendarUnit startDate:&boundary interval:NULL forDate:self];
	return boundary;
}

- (NSDate *)zl_dayBoundary
{
	return [self zl_boundaryForCalendarUnit:NSDayCalendarUnit];
}

- (NSDate *)zl_minuteBoundary
{
	return [self zl_boundaryForCalendarUnit:NSMinuteCalendarUnit];
}

- (BOOL)zl_isToday
{
    return [self zl_isSameDayAsDate:[NSDate date]];
}

- (BOOL)zl_isSameDayAsDate:(NSDate *)other
{
    BOOL retValue = YES;
	
    if (self != other)
    {
        retValue = ([self zl_dayNumber] == [other zl_dayNumber]);
    }
	
    return retValue;
}

- (BOOL)zl_isBeforeDate:(NSDate *)date
{
	return ([self compare:date] == NSOrderedAscending);
}

- (BOOL)zl_isAfterDate:(NSDate *)date
{
	return ([self compare:date] == NSOrderedDescending);
}

- (BOOL)zl_isBeforeOrEqualToDate:(NSDate *)date
{
	return ! [self zl_isAfterDate:date];
}

- (BOOL)zl_isAfterOrEqualToDate:(NSDate *)date
{
	return ! [self zl_isBeforeDate:date];
}

- (BOOL)zl_isBetweenDate:(NSDate *)earlyDate andDate:(NSDate *)lateDate
{
	return ([self zl_isAfterOrEqualToDate:earlyDate] && [self zl_isBeforeOrEqualToDate:lateDate]);
}

- (NSInteger)zl_dayIntervalSinceDate:(NSDate *)date
{
    NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:[date zl_dayBoundary] toDate:[self zl_dayBoundary] options:0];
	
	return [dc day];
}

- (NSTimeInterval)zl_timeIntervalUntilNow
{
	return -[self timeIntervalSinceNow];
}

@end

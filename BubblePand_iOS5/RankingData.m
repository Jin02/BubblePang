//
//  RankingData.m
//  WishBubble
//
//  Created by imac07 on 10. 03. 15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RankingData.h"

@implementation RankingData

-(id)init
{
	if( (self = [super init]) )
	{

	}
	
	return self;
}

-(NSMutableArray*)RankingDataLoad
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *fullFileName = [NSString stringWithFormat:@"%@/RankingSaveFile", documentsDirectory];
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:fullFileName];
	
	return array;
}

-(BOOL)RankingDataSave_Name:(NSString *)name playerscore:(NSInteger)playerscore playTime:(NSInteger)playTime pop:(NSInteger)pop
{
	NSMutableArray *array;
	int t_hours, t_minutes, t_seconds;
	
	t_hours = (int)(playTime/3600);
	t_minutes = (int)(playTime/60)-(60*t_hours);
	t_seconds = (int)(playTime%60);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *fullFileName = [NSString stringWithFormat:@"%@/RankingSaveFile", documentsDirectory];
	
	NSLog(@"세이브 테스트 1");
	
	array = [self RankingDataLoad];
	
	if( [array count] == 0 )
		array = [[NSMutableArray alloc] init];
	
	if( [array count] == 200 )
		return NO;
	
	NSLog(@"Array Count %d", [array count]);
	
	NSLog(@"세이브 테스트 2");
	NSString *t_Score,*t_Time,*t_Pop;
	
	t_Score = [[NSString alloc] initWithFormat:@"%d",playerscore];
	t_Time	= [[NSString alloc] initWithFormat:@"%d hour %d minutes %d second",t_hours, t_minutes, t_seconds];
	t_Pop	= [[NSString alloc] initWithFormat:@"%d",pop];

	NSLog(@"세이브 테스트 3");
	[array addObject:name];
	[array addObject:t_Score];
	[array addObject:t_Time];
	[array addObject:t_Pop];
	NSLog(@"세이브 테스트 4");
		
	[array writeToFile:fullFileName atomically:NO];
	NSLog(@"세이브 테스트 5");
	
	//[self dataClear];
	
	[array release];
	return YES;
}

-(void)dataClear
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *fullFileName = [NSString stringWithFormat:@"%@/RankingSaveFile", documentsDirectory];
	
	NSMutableArray *array = [[NSMutableArray alloc] init];

	[array writeToFile:fullFileName atomically:NO];
	
	[array release];
}

-(void)dealloc
{
	[super dealloc];
}

@end

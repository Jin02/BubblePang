//
//  BB_Ranking.m
//  WishBubble
//
//  Created by imac07 on 10. 03. 19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BB_Ranking.h"
#import "RankingData.h"
#import "BB_Enum.h"

@implementation BB_Ranking


/*
 
 1위 ~ 5위 까지 표시

 파티클 : 비 뿌려줌 
 버튼 : 다른 플레이어 보기, 뒤로 가기, 기록 지우기
 
 다른플레이어보기:테이블 뷰를 띄어주고 플레이어 목록을 나열하고 누르면 정보가 뜨도록 함.
 뒤로가기: 뒤로가기
 기록 지우기 : 기록을 지움
 
 */


-(id)init
{
	if( (self = [super init] ))
	{
		NSLog(@"랭킹 화면 들어 옴");
		
		if( !(playerNum = [self playerDataLoad]) )
			[self MessageBox:@"플레이어의 정보가 없습니다"];
		else
			[self DataSoft];
		
		
		[self createTable];
	}
	
	return self;
}

-(void)createTable
{
	table = [[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 440) style:UITableViewStylePlain ] autorelease];
	[table setDelegate:self];
	[table setDataSource:self];
	[[[CCDirector sharedDirector] openGLView] addSubview:table];
	
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];			
	toolbar.items = [NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(Back)] autorelease], 
					 [[[UIBarButtonItem alloc] initWithTitle:@"Player Data" style:UIBarStyleDefault target:self action:nil] autorelease],nil];
	[[[CCDirector sharedDirector] openGLView] addSubview:toolbar];
	[toolbar release];	
}

-(void)Back
{
	//테이블과 툴바 제거
	[table removeFromSuperview];
	[toolbar removeFromSuperview];

	//메뉴로 갑니다 임시입니다
	[[CCDirector sharedDirector] popScene];
}

-(unsigned int)playerDataLoad
{
	RankingData* data = [[RankingData alloc] init];
	NSMutableArray *array = [data RankingDataLoad];
	
	if( [array count] == 0 )
		return NO;
	
	else
	{
		playerNum = (int)([array count] / 4);
		
		for( int loop = 0; loop < [array count]; loop )
		{
			Data[loop / 4].name		= [[NSString alloc] initWithString:[array objectAtIndex:loop]];
			Data[loop / 4].score	= [[NSString alloc] initWithString:[array objectAtIndex:loop+1]];
			Data[loop / 4].time		= [[NSString alloc] initWithString:[array objectAtIndex:loop+2]];
  		    Data[loop / 4].pop 		= [[NSString alloc] initWithString:[array objectAtIndex:loop+3]];
			
			NSLog(@"플레이어 이름들 %@",[array objectAtIndex:loop]);			
			loop+=4;
		}
	}
								   

	return ( ([array count]+1) / 4);
}

-(void)MessageBox:(NSString*)context
{
	UIAlertView *alert	= [[UIAlertView alloc] initWithTitle:[NSString stringWithString:context] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	[alert show];
	[alert release];	
}

-(void)DataSoft
{
	int min_I;
	
	for( int i = 0; i < playerNum; i++)
	{
		min_I = i;
		
		for( int j = i ; j <playerNum; j++)
		{			
			if( [Data[j].score intValue] > [Data[min_I].score intValue] )
				min_I = j;
		}
		
		if( i != min_I )
		{
			struct PlayerData temp;
			
			temp = Data[i];
			Data[i] = Data[min_I];
			Data[min_I] = temp;
		}
	}
}


/************** Table View Section **********************/

//그룹이 몇개인지 리턴해줍니다
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

//셀이 몇개인지 리턴해줍니다.
-(NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section {
	return playerNum;
}

//셀을 추가합니다
-(UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(Cell == nil )
		Cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cell"] autorelease];

	NSUInteger row = [indexPath row];	
	Cell.textLabel.text = Data[row].name;

	return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];

	NSString *message = [[NSString alloc] initWithFormat: @"Score : %@ \n Time : %@ \n Pang! : %@", Data[row].score,  Data[row].time, Data[row].pop];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Player Data" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}



/************** Table View Section **********************/

-(void)dealloc
{
	[super dealloc];
}

@end

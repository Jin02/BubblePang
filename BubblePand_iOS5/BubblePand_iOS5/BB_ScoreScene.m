//
//  BB_ScoreScene.m
//  BubbleGame
//
//  Created by imac07 on 10. 03. 10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BB_Definision.h"
#import "RankingData.h"
#import "BB_ScoreScene.h"
#import "BB_Enum.h"
#import "BB_Menu.h"

#define GAME_SCORE_DATA_FILE_NAME	"All_Player_Score"

@implementation BB_ScoreScene

@synthesize nameField;

@synthesize gameScore;
@synthesize gameTotalPlayTime;
@synthesize gameRemoveBubble;

@synthesize ButtonOK;
@synthesize ButtonNO;

@synthesize rScore;
@synthesize rTime;
@synthesize rPop;

@synthesize ClearData;
@synthesize data;

-(id)init
{
	if( (self=[super init]))
	{
		self.data = [[RankingData alloc] init];
		CCSprite *backGround = [CCSprite spriteWithFile:@"gameoverBack.png"];
		
		backGround.anchorPoint = CGPointZero;
		backGround.position = ccp(0,0);
		
		[self addChild:backGround z:BB_backGround tag:BB_backGround];
		
		NSLog(@"스코어 씬으로 들어옴 1");

		/* 버튼 생성 구역 */
		self.ButtonOK = [CCMenuItemImage itemFromNormalImage:@"Save.png" selectedImage:@"SaveClick.png" target:self selector:@selector(ButtonActionOK:)];
		ButtonOK.position = ccp(20,-110);
		
		self.ButtonNO = [CCMenuItemImage itemFromNormalImage:@"Menu.png" selectedImage:@"MenuClick.png" target:self selector:@selector(ButtonActionNO:)];
		ButtonNO.position = ccp(110,-110);
		
		self.ClearData = [CCMenuItemImage itemFromNormalImage:@"Init.png" selectedImage:@"InitClick.png" target:self selector:@selector(DataClearButton:)];
		self.ClearData.position = ccp(20,-195);
		
		CCMenu *Menu =  [CCMenu menuWithItems:self.ButtonOK, self.ButtonNO, self.ClearData, nil];
		[self addChild:Menu z:BB_menu tag:BB_menu];
		
		NSLog(@"스코어 씬으로 들어옴 2");
		
		/* 라벨 생성구역 */
		CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:@"" fontName:@"Marker Felt" fontSize:22];
		self.gameScore = label;
		self.gameScore.anchorPoint = CGPointZero;
		self.gameScore.color = ccc3(0, 0, 0);
		self.gameScore.position = ccp(95,302);
		[self addChild:self.gameScore z:BB_Interface_Score tag:BB_Interface_Score];
		[label release];
		
		NSLog(@"스코어 씬으로 들어옴 3");
		
		NSString *Str = [[NSString alloc] initWithFormat:@""];
		label = [[CCLabelTTF alloc] initWithString:Str fontName:@"Marker Felt" fontSize:22];
		self.gameTotalPlayTime = label;
		self.gameTotalPlayTime.anchorPoint = CGPointZero;
		self.gameTotalPlayTime.color = ccc3(0, 0, 0);
		self.gameTotalPlayTime.position = ccp(35, 180);
		[self addChild:self.gameTotalPlayTime z:BB_Interface_Warnning tag:BB_Interface_Warnning];
		[Str release];
		
		NSLog(@"스코어 씬으로 들어옴 4");
		
		NSString *Str2 = [[NSString alloc] initWithFormat:@""];
		label = [[CCLabelTTF alloc] initWithString:Str fontName:@"Marker Felt" fontSize:22];
		self.gameRemoveBubble = label;
		self.gameRemoveBubble.anchorPoint = CGPointZero;
		self.gameRemoveBubble.color = ccc3(0, 0, 0);
		self.gameRemoveBubble.position = ccp(130, 253);
		[self addChild:self.gameRemoveBubble z:BB_Interface_Warnning tag:BB_Interface_Warnning];
		[Str2 release];
		/* 라벨 생성끝 */
		
		NSLog(@"스코어 씬으로 들어옴 5");
		
	//	if(nameField.hidden == NO)
		{
			nameField = [[UITextField alloc] initWithFrame:CGRectMake(110, 100, 160, 30)];
			[nameField setDelegate:self];
			[nameField setText:@""];
			nameField.returnKeyType = UIReturnKeyDone;
			nameField.borderStyle = UITextBorderStyleRoundedRect;
			[[[CCDirector sharedDirector] openGLView] addSubview:nameField];
			[nameField setTag:BB_Textfield];
			[nameField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
//			[nameField release];
		}
		//else
		//	[nameField setHidden:NO];
			
		rScore	= tmp_Score;
		rTime	= TotalPlayGameTime;
		rPop	= TotalBubblepop;
		
		NSLog(@"스코어 씬으로 들어옴 6");
		
		[self GameResultPrint];
	}
	
	
	return self;
	
}

-(void)DataClearButton:(id)sender
{
	[self.data dataClear];
	[self MessageBox:@"데이터가 초기화 되었습니다"];
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
}

-(void)FlipX3DStopMotion
{	[self stopAllActions];	}

-(void)FlipX3DStartMotion
{
	id FlipX3D = [CCFlipX3D actionWithDuration:0.5];
	[self performSelector:@selector(FlipX3DStopMotion) withObject:nil afterDelay:0.5f];
	[self runAction:FlipX3D];
}

-(void)ButtonActionOK:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	
	if( strlen([nameField.text UTF8String]) == 0 )
	{
		[self MessageBox:@"이름을 입력하십시오."];
		return;
	}

	if(![data RankingDataSave_Name:nameField.text  playerscore:rScore playTime:rTime pop:rPop])
		[self MessageBox:@"기록되어 있는 플레이어수가 50이 넘습니다. 데이터를 지워주시고 등록해 주시길 바랍니다."];

	[self GotoMenu];
}

-(void)ButtonActionNO:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	[self GotoMenu];
}

-(IBAction)textFieldDone:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	
	if( strlen([nameField.text UTF8String]) > 15 )
	{
		[self MessageBox:@"이름이 너무 깁니다. \n 한글5자 영어 15자 이내로 입력해 주십시오"];
		[nameField setText:@""];		
	}
	else if( [nameField.text length] == 0  )
	{
		[self MessageBox:@"이름을 입력하십시오."];
	}
	
	[sender resignFirstResponder];
}

-(void)MessageBox:(NSString*)context
{
	UIAlertView *alert	= [[UIAlertView alloc] initWithTitle:[NSString stringWithString:context] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	[alert show];
	[alert release];	
}

-(void)GameResultPrint
{
	int t_hours, t_minutes, t_seconds;
	
	t_hours = (int)(TotalPlayGameTime/3600);
	t_minutes = (int)(TotalPlayGameTime/60)-(60*t_hours);
	t_seconds = (((int)TotalPlayGameTime)%60);
	
	NSString *str1 = [[NSString alloc] initWithFormat:@"%d", tmp_Score];
	[self.gameScore setString:str1];
	[str1 release];
	
	NSString *str2 = [[NSString alloc] initWithFormat:@"%d", TotalBubblepop];
	[self.gameRemoveBubble setString:str2];
	[str2 release];
	
	NSString *str3 = [[NSString alloc] initWithFormat:@"%d hour %d minutes %d second", t_hours, t_minutes, t_seconds];
	[self.gameTotalPlayTime setString:str3];
	[str3 release];	
}

-(void)PopScene
{ 
	[[CCDirector sharedDirector] popScene];
	[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void)GotoMenu
{
	tmp_Score				= 0;
	TotalBubblepop			= 0;
	TotalPlayGameTime		= 0;
	
	[self textFieldRemove];
	[self FlipX3DStartMotion];
	[self performSelector:@selector(PopScene) withObject:nil afterDelay:0.51f];
}

-(void)textFieldRemove
{
	NSArray *subviews = [[CCDirector sharedDirector]openGLView].subviews;
	
	for(id sv in subviews)
	{
		[((UIView*)sv) removeFromSuperview];
		[sv release];
	}
}

-(void)dealloc
{
//	[data release];
//	[gameScore release];
//	[gameTotalPlayTime release];
//	[gameRemoveBubble release];
//	[ButtonOK release];
///	[ClearData release];
//	[ButtonNO release];
	
	[self removeAllChildrenWithCleanup:YES];
	
	[super dealloc];
}

@end

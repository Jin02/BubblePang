//
//  BB_Help.m
//  WishBubble
//
//  Created by roden on 10. 4. 21..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BB_Help.h"
#import "BB_Enum.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"


@implementation BB_Help

-(id)init
{
	if( ( self = [super init] ) )
	{
		m_HelpCount = 0;
		[self CreateSprite];
		[self CreateMenu];
	}
	
	return self;
}

#pragma mark Created

-(void)CreateMenu
{
	m_HelpContext[0] = [[CCSprite alloc] initWithFile:@"H1.png"];
	m_HelpContext[1] = [[CCSprite alloc] initWithFile:@"H2.png"];
	m_HelpContext[2] = [[CCSprite alloc] initWithFile:@"H3.png"];
	m_HelpContext[3] = [[CCSprite alloc] initWithFile:@"H4.png"];
	m_HelpContext[4] = [[CCSprite alloc] initWithFile:@"H5.png"];
	m_HelpContext[5] = [[CCSprite alloc] initWithFile:@"H6.png"];
	
	for(int i = 0; i < 6; i++)
	{
		m_HelpContext[i].anchorPoint = CGPointZero;
		[m_HelpContext[i] setPosition:ccp(30,130)];
		
		[self addChild:m_HelpContext[i] z:BB_menu tag:BB_menu];
		
		[m_HelpContext[i] setVisible:NO];
	}
	
	[m_HelpContext[0] setVisible:YES];
	
	m_Next			= [CCMenuItemImage itemFromNormalImage:@"Next.png" selectedImage:@"NextClick.png" target:self selector:@selector(ButtonNext:)];
	m_Before		= [CCMenuItemImage itemFromNormalImage:@"Before.png" selectedImage:@"BeforeClick.png" target:self selector:@selector(ButtonBefore:)];
	m_Back			= [CCMenuItemImage itemFromNormalImage:@"Exit.png" selectedImage:@"ExitClick.png" target:self selector:@selector(ButtonGoMenu:)];
	
	m_MenuItem = [CCMenu menuWithItems: m_Next, m_Before, m_Back, nil];
	[m_MenuItem alignItemsHorizontally];
	
	[m_Next setPosition:ccp(80,-180)];
	[m_Before setPosition:ccp(-80,-180)];
	[m_Back setPosition:ccp(80,182)];
	
	
	[self addChild:m_MenuItem z:BB_menu tag:BB_menu];
}

-(void)CreateSprite
{
	m_BackGround = [[CCSprite alloc] initWithFile:@"3.png"];
	m_BackGround.anchorPoint = CGPointZero;
	[m_BackGround setPosition:ccp(0,0)];

	[self addChild:m_BackGround z:BB_backGround tag:BB_backGround];
	
	m_HelpBack = [[CCSprite alloc] initWithFile:@"HelpBack.png"];
	m_HelpBack.anchorPoint = CGPointZero;
	[m_HelpBack setPosition:ccp(20,30)];
	
	[self addChild:m_HelpBack z:BB_menu tag:BB_menu];
}

#pragma mark Button

-(void)ButtonNext:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	
	if( m_HelpCount == 5 )
		return;
	else 
	{
		[m_HelpContext[m_HelpCount++] setVisible:NO];
		[m_HelpContext[m_HelpCount] setVisible:YES];
	}
}

-(void)ButtonBefore:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	
	if( m_HelpCount == 0)
		return;
	else 
	{
		[m_HelpContext[m_HelpCount--] setVisible:NO];
		[m_HelpContext[m_HelpCount] setVisible:YES];
	}
}

-(void)ButtonGoMenu:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	[[CCDirector sharedDirector] popScene];
}

#pragma mark release

-(void)dealloc
{
//	for(int i = 0; i < 6; i++)
//		[m_HelpContext[i] release];
	
//	[m_MenuItem release];
//	[m_Next release];
//	[m_Before release];
//	[m_Back release];
//	[m_BackGround release];

	[self removeAllChildrenWithCleanup:YES];
	
	[super dealloc];
}

@end

//
//  BB_Help.h
//  WishBubble
//
//  Created by roden on 10. 4. 21..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface BB_Help : CCLayer {
	
	NSInteger					m_HelpCount;
	
	CCSprite					*m_BackGround;
	CCSprite					*m_HelpBack;
	CCSprite					*m_HelpContext[6];
	
	CCMenuItem					*m_Next;
	CCMenuItem					*m_Before;
	CCMenuItem					*m_Back;
	CCMenu						*m_MenuItem;
}

-(id)init;
-(void)dealloc;
-(void)CreateMenu;
-(void)CreateSprite;

@end

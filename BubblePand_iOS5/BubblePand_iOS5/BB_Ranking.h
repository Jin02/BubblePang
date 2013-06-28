//
//  BB_Ranking.h
//  WishBubble
//
//  Created by imac07 on 10. 03. 19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

struct PlayerData { //배열로 하면 순서를 기억하기 귀찮아서 일일히 생성
	
	NSString *name;
	NSString *score;
	NSString *time;
	NSString *pop;
};

@interface BB_Ranking : CCLayer <UITableViewDelegate, UITableViewDataSource> {

	struct PlayerData Data[50];
	NSInteger playerNum;

	UIToolbar *toolbar;
	UITableView *table;
}


-(unsigned int)playerDataLoad;
-(void)DataSoft;
-(void)createTable;
-(void)MessageBox:(NSString*)context;

@end

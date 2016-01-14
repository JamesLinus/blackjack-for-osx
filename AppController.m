#import "AppController.h"
#import "TableView.h"
#import "PreferenceController.h"
#define NUM_DECKS 2

@implementation AppController

- (id)init
{
	int i;
	NSNumber *num;
	NSString *path;
	
	[super init];
	deck = [[NSMutableArray alloc] init];
	for (i=0;i<52*NUM_DECKS;i++) {
		num = [[NSNumber alloc] initWithInt:i % 52];
		[deck addObject:num];
		[num release];
	}
	playerHand = [[NSMutableArray alloc] init];
	dealerHand = [[NSMutableArray alloc] init];
	for (i=0;i<5;i++) {
		//num = [[NSNumber alloc] initWithInt:i];
		[playerHand addObject:[deck objectAtIndex:i]];
		[dealerHand addObject:[deck objectAtIndex:i]];
		//[num release];
	}
	//speechArray = [self generateSpeechStrings];
	speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
	//[speechSynth setDelegate:self];
	voiceEnabled = NO;
	soundEnabled = NO;
	myBundle = [NSBundle mainBundle];
	path = [myBundle pathForResource:@"gameover" ofType:@"aif"];
	//NSLog(path);
	gameOverClip = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
	//[gameOverClip setDelegate:self];
	path = [myBundle pathForResource:@"notbadfo" ofType:@"aif"];
	notBadClip = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
	//[notBadClip setDelegate:self];
	path = [myBundle pathForResource:@"synthetic" ofType:@"aif"];
	syntheticClip = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
	[syntheticClip setDelegate:self];
	path = [myBundle pathForResource:@"yeah" ofType:@"wav"];
//	yeahClip = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
	//[yeahClip setDelegate:self];
	path = [myBundle pathForResource:@"control" ofType:@"wav"];
	controlClip = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
	[controlClip setDelegate:self];
	path = [myBundle pathForResource:@"inconceivable4" ofType:@"wav"];
//	incClip = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
	//[incClip setDelegate:self];	
	//if(!gameOverClip)
	//	NSLog(@"Sound error");
	srandom(time(NULL));
	return self;
}

- (void)awakeFromNib
{
	NSColor *initialColor = [NSColor colorWithCalibratedRed:0.0 green:0.501961 blue:0.0 alpha:1.0];
	[playerView setIsDealer:NO];
	[playerView changeColor:initialColor];
	[dealerView changeColor:initialColor]; 
	//[colorWell setColor:initialColor];
	//gameOver = YES;
	bet = 0;
	money = 500;
	[self shuffle];
}

- (IBAction)increaseBet:(id)sender
{
	int seg;
	
	seg = [sender selectedSegment];
	switch(seg) {
		case 0:
			bet += 5;
			break;
		case 1:
			bet += 25;
			break;
		case 2:
			bet += 50;
			break;
		case 3:
			bet += 100;
			break;
		case 4:
			bet = money;
			break;
		case 5:
			bet = 0;
			break;
	}
	if(bet > money)
		bet = money;
	[betText setStringValue:[NSString stringWithFormat:@"Bet: $%d",bet]];
}

/*- (NSMutableArray *)generateSpeechStrings
{
	int i;
	NSString *face;
	NSString *end;
	NSString *whole;
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	for(i=0;i<52;i++){
		switch(i/4) {
			case 0:
				face = @"Ace";
				break;
			case 1:
				face = @"King";
				break;
			case 2:
				face = @"Queen";
				break;
			case 3:
				face = @"Jack";
				break;
			case 4:
				face = @"Ten";
				break;
			case 5:
				face = @"Nine";
				break;
			case 6:
				face = @"Eight";
				break;
			case 7:
				face = @"Seven";
				break;
			case 8:
				face = @"Six";
				break;
			case 9:
				face = @"Five";
				break;
			case 10:
				face = @"Four";
				break;
			case 11:
				face = @"Three";
				break;
			case 12:
				face = @"Two";
				break;
		}
		switch(i%4) {
			case 0:
				end = @"Clubs";
				break;
			case 1:
				end = @"Spades";
				break;
			case 2:
				end = @"Hearts";
				break;
			case 3:
				end = @"Diamonds";
				break;
		}
		//NSLog(@"%@",[face stringByAppendingFormat:@" %@ %@",middle,end]);
		whole = [NSString stringWithFormat:@"%@ of %@",face,end];
		[returnArray addObject:whole];
	}
	return returnArray;
}*/

/*- (IBAction)addRandomCard:(id)sender
{
	NSImage *image;
	int randomCard = (random() % 52);
	NSLog(@"Loading Card #%d",randomCard);
	
	image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Users/bcgregg/Blackjack/%d.png",randomCard+1]];
	if(image == nil)
		NSLog(@"File loading error!");
	[tableView setImage:image];
	[image release];
}*/

- (void)shuffle
{
	//NSEnumerator *e;
	NSNumber *num;
	int i, rand;
	
	for (i=0;i<(52*NUM_DECKS);i++){
		num = [[NSNumber alloc] initWithInt:i%52];
		[deck replaceObjectAtIndex:i withObject:num];
		[num release];
	}
	for (i=0;i<(52*NUM_DECKS);i++) { //cool shuffling algorithm
		rand = random() % (52*NUM_DECKS);
		[deck exchangeObjectAtIndex:i withObjectAtIndex:rand];
	}
	currCard = 0;
	//NSLog(@"Shuffled.\n");
	//e = [deck objectEnumerator];
	//while (num = [e nextObject]) {
	//	NSLog(@"%d\n",[num intValue]);
	//}
}

- (void)changeBGColor:(NSColor *)newColor
{
	//NSColor *newColor = [sender color];
	//NSLog(@"Color changed %@",newColor);
	[playerView changeColor:newColor];
	[dealerView changeColor:newColor]; 
}

- (IBAction)newGame:(id)sender
{
	NSNumber *num,*num2;
	//int choice;
	if (bet == 0) {
		if(voiceEnabled)
			[speechSynth startSpeakingString:@"No Bet!"];
		NSRunAlertPanel(@"No Bet!",@"Your bet must be more than $0",@"OK",nil,nil);
		return;
	}
	oldBet = bet;
	isSplit = NO;
	secondHand = NO;
	//gameOver = NO;
	[dealButton setHidden:YES];
	[hitButton setHidden:NO];
	[stayButton setHidden:NO];
	[doubleButton setHidden:NO];
	if(bet == money)
		[doubleButton setEnabled:NO];
	else
		[doubleButton setEnabled:YES];
	[splitButton setHidden:NO];
	[splitButton setEnabled:NO];
	[betButtons setEnabled:NO];
	[dealerView setIsDealer:YES];
	if (bet > money) {
		bet = money;
		[betText setStringValue:[NSString stringWithFormat:@"Bet: $%d",bet]];
	}
	[dealerText setStringValue:@"Dealer Hand:"];
	[playerView clean];
	[dealerView clean];
	//[self shuffle];
	//currCard = 4;
	playerCard = 2;
	dealerCard = 2;
	[playerHand replaceObjectAtIndex:0 withObject:[deck objectAtIndex:currCard++]];
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	[dealerHand replaceObjectAtIndex:0 withObject:[deck objectAtIndex:currCard++]];
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	[playerHand replaceObjectAtIndex:1 withObject:[deck objectAtIndex:currCard++]];
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	
	[dealerHand replaceObjectAtIndex:1 withObject:[deck objectAtIndex:currCard++]];
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	num = [playerHand objectAtIndex:0];
	num2 = [playerHand objectAtIndex:1];
	if([num intValue]/4 == [num2 intValue]/4)
		[splitButton setEnabled:YES];
	//n1 = [[NSNumber alloc] initWithInt:-1];
	//for (i=2;i<5;i++) {
	//	[playerHand replaceObjectAtIndex:i withObject:n1];
	//	[dealerHand replaceObjectAtIndex:i withObject:n1];
	//}
	//[n1 release];
	[playerView drawCard:[[playerHand objectAtIndex:0] intValue]];
	//NSLog(@"Card Value is:%@\n",[playerHand objectAtIndex:0]);
	[playerView drawCard:[[playerHand objectAtIndex:1] intValue]];
	[dealerView drawCard:[[dealerHand objectAtIndex:0] intValue]];
	[dealerView drawCard:[[dealerHand objectAtIndex:1] intValue]];
	
	//blackjack logic
	playerScore = [self getScore:Player];
	//dealerScore = [self getScore:Dealer];
	[playerText setStringValue:[NSString stringWithFormat:@"Player Hand:     %d", playerScore]];
	//[dealerText setStringValue:[NSString stringWithFormat:@"Dealer Hand:   %d", dealerScore]];
}

- (void)finish
{	
	NSString *finalMessage;
	int choice;
	
	[dealerView setIsDealer:NO];
	[dealerView setNeedsDisplay:YES];
	dealerScore = [self getScore:Dealer];
	//NSLog(@"Dealer Score = %d\n",dealerScore);
	//gameOver = YES;
	
	while (dealerScore < 17 && dealerCard < 5) {
		[dealerHand replaceObjectAtIndex:dealerCard withObject:[deck objectAtIndex:currCard]];
		[dealerView drawCard:[[dealerHand objectAtIndex:dealerCard] intValue]];
		dealerCard++;
		currCard++;
		if(currCard==52*NUM_DECKS)
			[self shuffle];
		dealerScore = [self getScore:Dealer];
	}
	[dealerText setStringValue:[NSString stringWithFormat:@"Dealer Hand:     %d", dealerScore]];
	if (playerScore > 21) {
		finalMessage = @"You busted!";
		money -= bet;
		[playerView setSplitString:1 toString:@"LOST"];
		if(soundEnabled && !isSplit)
			[controlClip play];
	} else if (playerScore == 21 && playerCard == 2) {
		finalMessage = @"Blackjack!";
		[playerView setSplitString:1 toString:@"WON"];
		money += (3 * bet / 2);
		if(soundEnabled && !isSplit)
			[yeahClip play];
	} else if (playerScore > dealerScore || dealerScore > 21) {
		finalMessage = @"You won!";
		[playerView setSplitString:1 toString:@"WON"];
		money += bet;
		if (soundEnabled && !isSplit)
			[notBadClip play];
	} else if (playerScore < dealerScore) {
		finalMessage = @"You lost!";
		money -= bet;
		[playerView setSplitString:1 toString:@"LOST"];
		if (soundEnabled && !isSplit)
			[syntheticClip play];
	} else if (playerScore == dealerScore) {
		finalMessage = @"You pushed!";
		[playerView setSplitString:1 toString:@"PUSH"];
		if (soundEnabled && !isSplit)
			[incClip play];
	}
	if(isSplit) {
		if (splitScore > 21) {
			//finalMessage = @"You busted!";
			money -= splitBet;
			[playerView setSplitString:2 toString:@"LOST"];
		} else if (splitScore == 21 && splitCard == 2) {
			//finalMessage = @"Blackjack!";
			money += (3 * splitBet / 2);
			[playerView setSplitString:2 toString:@"WON"];
		} else if (splitScore > dealerScore || dealerScore > 21) {
			//finalMessage = @"You won!";
			money += splitBet;
			[playerView setSplitString:2 toString:@"WON"];
		} else if (splitScore < dealerScore) {
			//finalMessage = @"You lost!";
			money -= splitBet;
			[playerView setSplitString:2 toString:@"LOST"];
		} else if (splitScore == dealerScore) {
			[playerView setSplitString:2 toString:@"PUSH"];
		}
		finalMessage = @"Split hands.";
	}
	[playerView setNeedsDisplay:YES];
	[cashText setStringValue:[NSString stringWithFormat:@"Cash: $%d",money]];
	if(voiceEnabled)
		[speechSynth startSpeakingString:finalMessage];
	if (money > 0) {
		choice = NSRunAlertPanel(finalMessage,@"What do you wish to do?",@"Keep Bet",@"Change Bet",nil);
		if(choice == NSAlertDefaultReturn) {
			bet = oldBet;
			[self newGame:nil];
		} else {
			[playerView clean];
			[dealerView clean];
			[playerView setNeedsDisplay:YES];
			[dealerView setNeedsDisplay:YES];
			[hitButton setHidden:YES];
			[stayButton setHidden:YES];
			[doubleButton setHidden:YES];
			[splitButton setHidden:YES];
			[dealButton setHidden:NO];
			[betButtons setEnabled:YES];
			bet = 0;
			[betText setStringValue:[NSString stringWithFormat:@"Bet: $%d",bet]];
		}
	} else {
		if(soundEnabled) {
			if([syntheticClip isPlaying] || [controlClip isPlaying])
				gameOverNeedsPlaying = YES;
			else
				[gameOverClip play];
		}
		choice = NSRunAlertPanel(@"Bankrupt!",@"Would you like to play a new game?",@"Yes",@"No",nil);
		if (choice == NSAlertDefaultReturn) {
			[self newBank:nil];
		} else {
			bet = 0;
			[betText setStringValue:[NSString stringWithFormat:@"Bet: $%d",bet]];
			[dealButton setEnabled:NO];
		}
		[playerView clean];
		[dealerView clean];
		[playerView setNeedsDisplay:YES];
		[dealerView setNeedsDisplay:YES];
		[hitButton setHidden:YES];
		[stayButton setHidden:YES];
		[splitButton setHidden:YES];
		[doubleButton setHidden:YES];
		[dealButton setHidden:NO];
	}
	//NSLog(@"currCard is %d",currCard);
}

- (IBAction)newBank:(id)sender
{
	money = 500;
	bet = 0;
	[betText setStringValue:[NSString stringWithFormat:@"Bet: $%d",bet]];
	[cashText setStringValue:[NSString stringWithFormat:@"Cash: $%d",money]];
	[dealButton setEnabled:YES];
	[betButtons setEnabled:YES];
}

- (IBAction)hit:(id)sender
{
	if(secondHand){
		if(splitCard < 5){
			[splitHand addObject:[deck objectAtIndex:currCard]];
			[playerView drawCard:[[splitHand objectAtIndex:splitCard] intValue]];
			splitCard++;
			currCard++;
			if(currCard==52*NUM_DECKS)
				[self shuffle];
			playerScore = [self getScore:Player];
			[playerText setStringValue:[NSString stringWithFormat:@"Player Hand:     %d     %d", 
				playerScore, splitScore]];
			if(splitScore > 21 || playerCard == 5)
				[self finish];
		}
	} else {
		if(playerCard < 5){
			[playerHand replaceObjectAtIndex:playerCard withObject:[deck objectAtIndex:currCard]];
			[playerView drawCard:[[playerHand objectAtIndex:playerCard] intValue]];
			playerCard++;
			currCard++;
			if(currCard==52*NUM_DECKS)
				[self shuffle];
			playerScore = [self getScore:Player];
			[playerText setStringValue:[NSString stringWithFormat:@"Player Hand:     %d", playerScore]];
			[doubleButton setEnabled:NO];
			[splitButton setEnabled:NO];
			if(playerScore > 21 || playerCard == 5) {
				if(isSplit) {
					[self secondHandSetup];
				} else
					[self finish];
			}
		}
	}
}

- (IBAction)split:(id)sender
{
	[playerView setIsSplit:YES];
	isSplit = YES;
	splitBet = bet;
	splitHand = [NSMutableArray new];
	[splitHand addObject:[playerHand objectAtIndex:1]];
	[playerHand replaceObjectAtIndex:1 withObject:[deck objectAtIndex:currCard++]];
	splitCard = 1;
	[playerView drawCard:[[playerHand objectAtIndex:1] intValue]];
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	playerScore = [self getScore:Player];
	[playerText setStringValue:[NSString stringWithFormat:@"Player Hand:     %d", playerScore]];
	[doubleButton setEnabled:NO];
	[splitButton setEnabled:NO];
}

- (IBAction)doubleDown:(id)sender
{
	//int oldBet;
	[playerHand replaceObjectAtIndex:playerCard withObject:[deck objectAtIndex:currCard]];
	[playerView drawCard:[[playerHand objectAtIndex:playerCard] intValue]];
	playerCard++;
	currCard++;
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	playerScore = [self getScore:Player];
	[playerText setStringValue:[NSString stringWithFormat:@"Player Hand:     %d", playerScore]];
	[doubleButton setEnabled:NO];
	[splitButton setEnabled:NO];
	oldBet = bet;
	bet = 2 * oldBet;
	if(bet > money)
		bet = money;
	[self finish];
	//bet = oldBet;
}

- (int)getScore:(int)which
{
	int score = 0;
	int i;
	BOOL hasAce = NO;
	
	if (which == Player) {
		if(secondHand) {
			for (i=0;i<splitCard;i++) {
				if((14 - [[splitHand objectAtIndex:i] intValue]/4) == 14) {
					hasAce = YES;
					score += 1;
				} else if (14 - ([[splitHand objectAtIndex:i] intValue]/4) >= 10) {
					score += 10;
				} else {
					score += (14 - ([[splitHand objectAtIndex:i] intValue]/4));
				}
			}
			if(hasAce && (score + 10 <= 21))
				score += 10;
			splitScore = score;
			hasAce = NO;
			score = 0;
		}
		for (i=0;i<playerCard;i++) {
			if((14 - [[playerHand objectAtIndex:i] intValue]/4) == 14) {
				hasAce = YES;
				score += 1;
			} else if (14 - ([[playerHand objectAtIndex:i] intValue]/4) >= 10) {
				score += 10;
			} else {
				score += (14 - ([[playerHand objectAtIndex:i] intValue]/4));
			}
		}
		if(hasAce && (score + 10 <= 21))
			score += 10;
		return score;
		
	} else if (which == Dealer) {
		
		for (i=0;i<dealerCard;i++) {
			if((14 - [[dealerHand objectAtIndex:i] intValue]/4) == 14) {
				hasAce = YES;
				score += 1;
			} else if (14 - ([[dealerHand objectAtIndex:i] intValue]/4) >= 10) {
				score += 10;
			} else {
				score += (14 - ([[dealerHand objectAtIndex:i] intValue]/4));
			}
		}
		if(hasAce && (score + 10 <= 21))
			score += 10;
		return score;
		
	} else {
		NSLog(@"Incorrect value");
		return -1;
	}
}

- (IBAction)stay:(id)sender
{
	if(isSplit && !secondHand) {
		[self secondHandSetup];
	}
	else
		[self finish];
}

- (void)secondHandSetup
{
	[playerView setSecondHand:YES];
	secondHand = YES;
	[splitHand addObject:[deck objectAtIndex:currCard]];
	[playerView drawCard:[[splitHand objectAtIndex:splitCard] intValue]];
	splitCard++;
	currCard++;
	if(currCard==52*NUM_DECKS)
		[self shuffle];
	playerScore = [self getScore:Player];
	[playerText setStringValue:[NSString stringWithFormat:@"Player Hand:     %d     %d", 
		playerScore, splitScore]];
	if(splitScore > 21 || splitCard == 5)
		[self finish];
}

- (void)setVoiceEnabled:(BOOL)changeEnabled
{
	voiceEnabled = changeEnabled;
}

- (void)setSoundEnabled:(BOOL)changeEnabled
{
	soundEnabled = changeEnabled;
}

- (IBAction)showPreferencePanel:(id)sender
{
	if(!preferenceController) {
		preferenceController = [[PreferenceController alloc] init];
	}
	[preferenceController setParent:self];
	[preferenceController showWindow:self];
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)finished
{
	if((sound == syntheticClip || sound == controlClip ) && gameOverNeedsPlaying) {
		[gameOverClip play];
		gameOverNeedsPlaying = NO;
	}
}
/*
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finished
{
	if(gameOverNeedsPlaying) {
		[gameOverClip play];
		gameOverNeedsPlaying = NO;
	} else if(notBadNeedsPlaying) {
		[notBadClip play];
		notBadNeedsPlaying = NO;
	} else if(syntheticNeedsPlaying) {
		[syntheticClip play];
		syntheticNeedsPlaying = NO;
	}
}*/

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)dealloc
{
	[deck release];
	[playerHand release];
	[dealerHand release];
	[splitHand release];
//	[speechArray release];
	[speechSynth release];
	[preferenceController release];
	[gameOverClip release];
	[notBadClip release];
	[syntheticClip release];
	[yeahClip release];
	[controlClip release];
	[incClip release];
	[super dealloc];
}

@end

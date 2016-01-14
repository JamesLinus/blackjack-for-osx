//
//  PreferenceController.m
//  Blackjack
//
//  Created by Brian Gregg on 11/11/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"
#import "AppController.h"


@implementation PreferenceController

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	return self;
}

- (void)windowDidLoad
{
	//NSLog(@"Nib file is loaded.");
	NSColor *initialColor = [NSColor colorWithCalibratedRed:0.0 green:0.501961 blue:0.0 alpha:1.0];
	[colorWell setColor:initialColor];
}

- (IBAction)changeBackgroundColor:(id)sender
{
	NSColor *senderColor = [sender color];
	[parent changeBGColor:senderColor];
}

- (IBAction)setSoundOrVoiceEnabled:(id)sender
{
	id cell = [sender selectedCell];
	int tag = [cell tag];
	if(tag == 0) {
		[parent setVoiceEnabled:NO];
		[parent setSoundEnabled:NO];
	} else if(tag == 1) {
		[parent setVoiceEnabled:YES];
		[parent setSoundEnabled:NO];
	} else if (tag == 2) {
		[parent setSoundEnabled:YES];
		[parent setVoiceEnabled:NO];
	}
}

/*- (IBAction)setSoundEnabled:(id)sender
{
	if([sender state] == NSOnState) {
		[parent setSoundEnabled:YES];
	} else {
		[parent setSoundEnabled:NO];
	}
}*/

- (void)setParent:(AppController *)sender
{
	parent = sender;
}

@end

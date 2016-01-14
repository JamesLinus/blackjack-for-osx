//
//  PreferenceController.h
//  Blackjack
//
//  Created by Brian Gregg on 11/11/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppController;

@interface PreferenceController : NSWindowController {
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSMatrix *buttons;
	AppController *parent;
}

- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)setSoundOrVoiceEnabled:(id)sender;
//- (IBAction)setSoundEnabled:(id)sender;
//- (IBAction)allSoundDisabled:(id)sender;
- (void)setParent:(AppController *)sender;

@end

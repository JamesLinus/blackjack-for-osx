/* AppController */

#import <Cocoa/Cocoa.h>
@class TableView;
@class PreferenceController;

#define Player 0
#define Dealer 1

@interface AppController : NSObject
{
    IBOutlet TableView *playerView;
	IBOutlet TableView *dealerView;
	IBOutlet NSTextField *playerText;
	IBOutlet NSTextField *dealerText;
	IBOutlet NSTextField *betText;
	IBOutlet NSTextField *cashText;
	IBOutlet NSSegmentedControl *betButtons;
	//NSColorWell *colorWell;
	IBOutlet NSButton *hitButton;
	IBOutlet NSButton *stayButton;
	IBOutlet NSButton *doubleButton;
	IBOutlet NSButton *splitButton;
	IBOutlet NSButton *dealButton;
	PreferenceController *preferenceController;
	NSSound *gameOverClip;
	NSSound *notBadClip;
	NSSound *syntheticClip,*yeahClip,*controlClip,*incClip;
	NSMutableArray *deck;
	NSMutableArray *dealerHand;
	NSMutableArray *playerHand;
	NSMutableArray *splitHand;
//	NSMutableArray *speechArray;
	NSBundle *myBundle;
	NSSpeechSynthesizer *speechSynth;
	int currCard, playerCard, dealerCard, playerScore, dealerScore, bet, money, oldBet, splitBet, splitScore, splitCard;
	BOOL voiceEnabled,soundEnabled,gameOverNeedsPlaying,notBadNeedsPlaying,syntheticNeedsPlaying,isSplit,secondHand;
	//BOOL gameOver;
}
//- (IBAction)addRandomCard:(id)sender;
- (IBAction)hit:(id)sender;
- (IBAction)stay:(id)sender;
- (IBAction)doubleDown:(id)sender;
- (IBAction)split:(id)sender;
- (IBAction)newGame:(id)sender;
- (void)changeBGColor:(NSColor *)newColor;
- (void)setVoiceEnabled:(BOOL)changeEnabled;
- (void)setSoundEnabled:(BOOL)changeEnabled;
- (IBAction)increaseBet:(id)sender;
- (IBAction)newBank:(id)sender;
//- (NSMutableArray *)generateSpeechStrings;
- (void)shuffle;
- (void)finish;
- (int)getScore:(int)which;
- (IBAction)showPreferencePanel:(id)sender;
- (void)secondHandSetup;

@end

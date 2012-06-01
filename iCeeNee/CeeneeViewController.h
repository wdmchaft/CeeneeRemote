//
//  CeeneeViewController.h
//  iCeeNee
//
//  Created by Vinh Nguyen on 5/21/12.
//  Copyright (c) 2012 Ceenee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CeeneeRemote.h"

@interface CeeneeViewController : UIViewController  
<UITextFieldDelegate, UIActionSheetDelegate> {
    CeeneeRemote * remoter;
    NSMutableArray * deviceIp;
    BOOL isConnected;
}

@property BOOL isConnected;
@property (copy, nonatomic) CeeneeRemote *remoter;
@property (nonatomic) NSString * lastEnteredTxt;
@property (copy, nonatomic) NSMutableArray * deviceIp;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *keyboardField;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *connectionStatusBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *barItemScan;

/*
 * Interface implement
 */
- (void)actionSheet:(UIActionSheet *)actionSheet;

/**
 Remote function
 */
- (IBAction)cmdSetup:(id)sender;
- (IBAction)cmdReturn:(id)sender;
- (IBAction)cmdVolUp:(id)sender;
- (IBAction)cmdVolDown:(id)sender;
- (IBAction)cmdVolMute:(id)sender;
- (IBAction)cmdVolAudio:(id)sender;
- (IBAction)cmdFastBackward:(id)sender;
- (IBAction)cmdFastForward:(id)sender;
- (IBAction)cmdHome:(id)sender;

- (IBAction)cmdArrowUp:(id)sender;
- (IBAction)cmdArrowRight:(id)sender;
- (IBAction)cmdArrowDown:(id)sender;
- (IBAction)cmdArrowLeft:(id)sender;
- (IBAction)cmdOk:(id)sender;

- (IBAction)cmdInfo:(id)sender;
- (IBAction)cmdTimeseek:(id)sender;

- (IBAction)cmdRev:(id)sender;
- (IBAction)cmdPlay:(id)sender;
- (IBAction)cmdStop:(id)sender;
- (IBAction)cmdFwd:(id)sender;

- (IBAction)cmdSubTitle:(id)sender;
- (IBAction)cmdSlow:(id)sender;
- (IBAction)cmdRepeat:(id)sender;
- (IBAction)cmdBookmark:(id)sender;

- (IBAction)cmdZoom:(id)sender;
- (IBAction)cmdSixteenNine:(id)sender;

- (IBAction)cmdTvmode:(id)sender;

- (IBAction)cmdRed:(id)sender;
- (IBAction)cmdGreen:(id)sender;
- (IBAction)cmdYellow:(id)sender;
- (IBAction)cmdBlue:(id)sender;

- (IBAction)cmdMenu:(id)sender;
- (IBAction)cmdDelete:(id)sender;
- (IBAction)cmdEject:(id)sender;
- (IBAction)cmdPower:(id)sender;




/**
 App function
 */
- (void) discovery;
- (IBAction)btnAbout:(id)sender;
- (IBAction)btnScan:(id)sender;
- (IBAction)btnShowDevice:(id)sender;


@end
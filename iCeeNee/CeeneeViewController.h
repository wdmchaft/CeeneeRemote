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
@property (unsafe_unretained, nonatomic) IBOutlet UIProgressView *progressBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *connectionStatusBar;


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


/**
 App function
 */
- (NSArray *) discovery;
- (IBAction)btnAbout:(id)sender;
- (IBAction)btnScan:(id)sender;
- (IBAction)btnShowDevice:(id)sender;


@end
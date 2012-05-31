//
//  CeeneeViewController.h
//  iCeeNee
//
//  Created by Vinh Nguyen on 5/21/12.
//  Copyright (c) 2012 Ceenee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CeeneeRemote.h"

@interface CeeneeViewController : UIViewController  <UITextFieldDelegate> {
    CeeneeRemote * remoter;
}

@property (copy, nonatomic) CeeneeRemote *remoter;
@property (nonatomic) NSString * lastEnteredTxt;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *keyboardField;
@property (unsafe_unretained, nonatomic) IBOutlet UIProgressView *progressBar;


- (NSArray *) discovery;


- (IBAction)cmdConnect:(id)sender;
- (IBAction)cmdSetup:(id)sender;
- (IBAction)cmdReturn:(id)sender;

- (IBAction)btnAbout:(id)sender;
- (IBAction)btnScan:(id)sender;


@end
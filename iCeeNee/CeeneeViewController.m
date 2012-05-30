//
//  CeeneeViewController.m
//  iCeeNee
//
//  Created by Vinh Nguyen on 5/21/12.
//  Copyright (c) 2012 Ceenee. All rights reserved.
//

#import "CeeneeViewController.h"

@interface CeeneeViewController ()

@end

@implementation CeeneeViewController
@synthesize keyboardField;
@synthesize remoter;
@synthesize lastEnteredTxt;

- (void)viewDidLoad
{
    [super viewDidLoad];
       remoter = [[CeeneeRemote alloc] init]; 
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setKeyboardField:nil];
    [self setRemoter:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.keyboardField) {        
        [theTextField resignFirstResponder];
        lastEnteredTxt = nil;      
        
    }
    
    if (theTextField == self.keyboardField) {        
        [theTextField setText:@""];
    }
    
    return YES;
    
}

- (IBAction)cmdConnect:(id)sender {
    //[remoter discovery]; 
    
    NSString * greeting;
    NSString * ip = @"192.168.0.187";
    
    NSString * currentTitle = (NSString *) [sender currentTitle];
    if (@"Stop" == currentTitle) {
        [remoter close]; 
        [sender setTitle:@"Connect" forState:UIControlStateNormal];
    } else {        
        if ([remoter open:ip]) {
            greeting = @"Succeed to connect to the host";
            [sender setTitle:@"Stop" forState:UIControlStateNormal];
        } else {
            greeting = @"Fail to connect to the host";
            
        };
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Status" message:greeting delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        lastEnteredTxt = @"";
        [remoter press:@"info"];    
    }
    
}

- (IBAction)cmdSetup:(id)sender {
    [remoter press:@"setup"];  
}

- (IBAction)cmdReturn:(id)sender {
    [remoter press:@"return"];
}

@end

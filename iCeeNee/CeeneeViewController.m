//
//  CeeneeViewController.m
//  iCeeNee
//
//  Created by Vinh Nguyen on 5/21/12.
//  Copyright (c) 2012 Ceenee. All rights reserved.
//

#import "CeeneeViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <fcntl.h>

@interface CeeneeViewController ()

@end

@implementation CeeneeViewController

@synthesize isConnected;
@synthesize progressBar;
@synthesize connectionStatusBar;
@synthesize keyboardField;
@synthesize remoter;
@synthesize lastEnteredTxt;
@synthesize deviceIp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    remoter = [[CeeneeRemote alloc] init]; 
    deviceIp = [[NSMutableArray alloc] init];
    progressBar.hidden = TRUE;
    isConnected = FALSE;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setKeyboardField:nil];
    [self setRemoter:nil];
    [self setProgressBar:nil];
    [self setConnectionStatusBar:nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex>=2) {
        if (isConnected) {
            isConnected =  FALSE;
            [remoter close];
            //[connectionStatusBar setSelected:FALSE];
        }
        buttonIndex = buttonIndex -2;
        NSString * ip = [deviceIp objectAtIndex:buttonIndex];
        NSLog([@"App will connect to the board " stringByAppendingFormat:ip]);
        [remoter open:ip];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Status" message:[@"Connect to " stringByAppendingFormat:ip] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        isConnected = TRUE;
        [connectionStatusBar setTitle:ip forState:UIControlStateSelected];
        [connectionStatusBar setSelected:TRUE];
        [alert show];       
    } else if(buttonIndex==0) {
        isConnected =  FALSE;
        [remoter close];
        [connectionStatusBar setSelected:FALSE];
    } else {
        //User press return, do nothing
    }
}

- (NSArray *) discovery {
    NSArray * ip;
    return ip;
    
}

- (IBAction)cmdSetup:(id)sender {
    [remoter press:@"setup"];  
}

- (IBAction)cmdReturn:(id)sender {
    [remoter press:@"return"];
}

- (IBAction)cmdArrowUp:(id)sender {
}

- (IBAction)cmdArrowRight:(id)sender {
}

- (IBAction)cmdArrowDown:(id)sender {
}

- (IBAction)cmdArrowLeft:(id)sender {
}

- (IBAction)cmdOk:(id)sender {
}

- (IBAction)cmdInfo:(id)sender {
}

- (IBAction)cmdTimeseek:(id)sender {
}

- (IBAction)cmdRev:(id)sender {
}

- (IBAction)cmdPlay:(id)sender {
}

- (IBAction)cmdStop:(id)sender {
}

- (IBAction)cmdFwd:(id)sender {
}

- (IBAction)cmdSubTitle:(id)sender {
}

- (IBAction)cmdSlow:(id)sender {
}

- (IBAction)cmdRepeat:(id)sender {
}

- (IBAction)cmdBookmark:(id)sender {
}

- (IBAction)cmdZoom:(id)sender {
}

- (IBAction)cmdSixteenNine:(id)sender {
}

- (IBAction)cmdTvmode:(id)sender {
}

- (IBAction)cmdRed:(id)sender {
}

- (IBAction)cmdGreen:(id)sender {
}

- (IBAction)cmdYellow:(id)sender {
}

- (IBAction)cmdBlue:(id)sender {
}

- (IBAction)cmdMenu:(id)sender {
}

- (IBAction)cmdDelete:(id)sender {
}

- (IBAction)cmdEject:(id)sender {
}

- (IBAction)cmdPower:(id)sender {
}

- (IBAction)cmdVolUp:(id)sender {
}

- (IBAction)cmdVolDown:(id)sender {
}

- (IBAction)cmdVolMute:(id)sender {
}

- (IBAction)cmdVolAudio:(id)sender {
}

- (IBAction)cmdFastBackward:(id)sender {
}

- (IBAction)cmdFastForward:(id)sender {
}

- (IBAction)cmdHome:(id)sender {
}

- (IBAction)cmdReturn:(id)sender {
}



- (IBAction)btnAbout:(id)sender {
    NSString * greeting = @"CeeNee Remote. \nIcon by http://glyphicon.com";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCeeNee information" message:greeting delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    //[alert release];
}

- (IBAction)btnScan:(id)sender {
    //[self.progressBar setHidden:FALSE];
    [progressBar setProgress:0.5];
    NSArray * boardIp;
    NSString * ip=[remoter getIp];
    NSString * _ip;
    [deviceIp removeAllObjects];
    
    int *tempIndex = (int)([ip rangeOfString:@"." options:NSBackwardsSearch].location);
    
    NSInteger * port = 30000;
    NSLog([@"Current IP of Device" stringByAppendingFormat:ip]);
    //ip = @"192.168.0.";
    ip = [ip substringToIndex:tempIndex];
    ip = [ip stringByAppendingFormat:@"."];
    NSLog([@"Mask IP: " stringByAppendingFormat:ip]);
    int res;
    struct timeval tv; 
    fd_set myset;
    struct sockaddr_in address;
    struct sockaddr *addr;
    long arg;
    socklen_t lon; 
    int valopt;
    
    int sockfd;
    int conn;  
    BOOL retry_connect=false;
    // Create a socket
    address.sin_family = AF_INET;
    address.sin_port = htons(30000);        
        
    for (int i=190; i<=199; i++) {
        _ip = [ip stringByAppendingFormat:[NSString stringWithFormat:@"%d", i]];
        address.sin_addr.s_addr = inet_addr([_ip UTF8String]);        
        //NSLog(@"Start to process ip: ");
        NSLog(_ip);
        addr = (struct sockaddr*)&address;
        sockfd = socket(AF_INET, SOCK_STREAM, 0);   
        
        // Set non-blocking 
        arg = fcntl(sockfd, F_GETFL, NULL); 
        arg |= O_NONBLOCK; 
        fcntl(sockfd, F_SETFL, arg); 
        
        conn = connect(sockfd, addr, sizeof(address)); 
        [progressBar setProgress:i/250];
        if (conn < 0) {
            retry_connect = TRUE;             
            if (errno == EINPROGRESS) { 
                do { 
                    tv.tv_sec = 0; 
                    tv.tv_usec = 300000; 
                    FD_ZERO(&myset); 
                    FD_SET(sockfd, &myset); 
                    conn = select(sockfd+1, NULL, &myset, NULL, &tv); 
                    if (conn < 0 && errno != EINTR) { 
                        fprintf(stderr, "Error connecting %d - %s\n", errno, strerror(errno)); 
                        retry_connect = FALSE;
                        //exit(0); 
                    } else if (conn > 0) { 
                        // Socket selected for write 
                        lon = sizeof(int); 
                        if (getsockopt(sockfd, SOL_SOCKET, SO_ERROR, (void*)(&valopt), &lon) < 0) { 
                            fprintf(stderr, "Error in getsockopt() %d - %s\n", errno, strerror(errno)); 
                            retry_connect = FALSE;
                            continue;
                            //exit(0); 
                        } 
                        // Check the value returned... 
                        if (valopt) { 
                            fprintf(stderr, "Error in delayed connection() %d - %s\n", valopt, strerror(valopt) 
                                    );
                            retry_connect = FALSE;
                            continue;
                            //exit(0); 
                        } 
                        NSLog([@"Connected to IP: " stringByAppendingFormat:_ip]);
                        [deviceIp addObject:_ip];
                        break; 
                    } else { 
                        fprintf(stderr, "Timeout in select() - Cancelling!\n"); 
                        retry_connect = FALSE;
                        //exit(0); 
                    } 
                } while (retry_connect);   
            } else { 
                fprintf(stderr, "Error connecting %d - %s\n", errno, strerror(errno)); 
                //continue;
                //exit(0); 
            }               
        } else {
            //This case seems mean was able to ping IP, not really connect on the port 30000
            //Sucessful instantly
            //NSLog([@"Connected to IP: " stringByAppendingFormat:_ip]);
            [deviceIp addObject:_ip];
        }
        // Set to blocking mode again... 
        arg = fcntl(sockfd, F_GETFL, NULL); 
        arg &= (~O_NONBLOCK); 
        fcntl(sockfd, F_SETFL, arg); 
        // I hope that is all 
        close(sockfd);
    }

}

/**
 Display UIActionSheet of a list of device IP
 */
- (IBAction)btnShowDevice:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc]
                             initWithTitle:@"Choose a device to connect"
                             delegate:self
                             cancelButtonTitle:@"Return"
                             destructiveButtonTitle:@"Close Current Connection"
                             otherButtonTitles: nil
                             ];
    //action.cancelButtonIndex = 0;
    for (NSString * ip in deviceIp) {
        [action addButtonWithTitle:ip];
    }
    [action showInView:self.view];    
}

@end

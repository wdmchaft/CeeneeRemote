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
@synthesize barItemScan;

@synthesize isConnected;
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
    //progressBar.hidden = TRUE;
    isConnected = FALSE;
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [self setKeyboardField:nil];
    [self setRemoter:nil];
    //[self setProgressBar:nil];
    [self setConnectionStatusBar:nil];
    [self setBarItemScan:nil];
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


- (void)textDidChange:(NSNotification *) Notification {
    NSLog(@"sa");	
    UITextField * field = (UITextField *) [Notification object];
    if([field isEqual:keyboardField] && [field.text length] >= 0) {
        NSInteger textFieldLength = [field.text length];
        
        if ([lastEnteredTxt length]>textFieldLength) {
            [remoter press:@"delete"];
            return ;
        }
        NSString * enterdedChar = (NSString *) [field.text substringFromIndex:textFieldLength -1]; 
        [remoter press:enterdedChar];
        lastEnteredTxt = field.text;   
    }    
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

- (void) discovery {
    NSString * _ip;    
    NSArray * boardIp;
    NSString * ip=[remoter getIp];
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
    
    for (int i=2; i<=252; i++) {
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
        [barItemScan setTitle:[NSString stringWithFormat:@"Scan %d/250",i]];
        if (conn < 0) {
            retry_connect = TRUE;             
            if (errno == EINPROGRESS) { 
                do { 
                    tv.tv_sec = 0; 
                    tv.tv_usec = 100000; 
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
    barItemScan.title = @"Re-scan";
    NSString * greeting = @"Scan completed";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCeeNee information" message:greeting delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];

}

- (IBAction)cmdSetup:(id)sender {
    [remoter press:@"setup"];  
}

- (IBAction)cmdReturn:(id)sender {
    [remoter press:@"return"];
}

- (IBAction)cmdArrowUp:(id)sender {
    [remoter press:@"up"];
}

- (IBAction)cmdArrowRight:(id)sender {
    [remoter press:@"right"];
}

- (IBAction)cmdArrowDown:(id)sender {
    [remoter press:@"down"];
}

- (IBAction)cmdArrowLeft:(id)sender {
    [remoter press:@"left"];
}

- (IBAction)cmdOk:(id)sender {
    [remoter press:@"enter"];
}

- (IBAction)cmdInfo:(id)sender {
    [remoter press:@"info"];    
}

- (IBAction)cmdTimeseek:(id)sender {
    [remoter press:@"timeseek"];
}

- (IBAction)cmdRev:(id)sender {
    [remoter press:@"rewind"];
}

- (IBAction)cmdPlay:(id)sender {
    [remoter press:@"play"];
}

- (IBAction)cmdStop:(id)sender {
    [remoter press:@"stop"];
}

- (IBAction)cmdFwd:(id)sender {
    [remoter press:@"forward"];
}

- (IBAction)cmdSubTitle:(id)sender {
    [remoter press:@"title"];
}

- (IBAction)cmdSlow:(id)sender {
    [remoter press:@"slow"];
}

- (IBAction)cmdRepeat:(id)sender {
    [remoter press:@"repeat"];
}

- (IBAction)cmdBookmark:(id)sender {
    [remoter press:@"bookmark"];
}

- (IBAction)cmdZoom:(id)sender {
    [remoter press:@"zoom"];
}

- (IBAction)cmdSixteenNine:(id)sender {
    [remoter press:@"timeseek"];
}

- (IBAction)cmdTvmode:(id)sender {
    [remoter press:@"tvmode"];
}

- (IBAction)cmdRed:(id)sender {
    [remoter press:@"red"];    
}

- (IBAction)cmdGreen:(id)sender {
    [remoter press:@"green"];
}

- (IBAction)cmdYellow:(id)sender {
    [remoter press:@"yellow"];
}

- (IBAction)cmdBlue:(id)sender {
    [remoter press:@"blue"];
}

- (IBAction)cmdMenu:(id)sender {
    [remoter press:@"menu"];    
}

- (IBAction)cmdDelete:(id)sender {
    [remoter press:@"delete"];
}

- (IBAction)cmdEject:(id)sender {
    [remoter press:@"eject"];
}

- (IBAction)cmdPower:(id)sender {
    [remoter press:@"power"];
}

- (IBAction)cmdVolUp:(id)sender {
    [remoter press:@"volup"];    
}

- (IBAction)cmdVolDown:(id)sender {
    [remoter press:@"voldown"];
}

- (IBAction)cmdVolMute:(id)sender {
    [remoter press:@"mute"];
}

- (IBAction)cmdVolAudio:(id)sender {
    [remoter press:@"audio"];
}

- (IBAction)cmdFastBackward:(id)sender {
    [remoter press:@"prev"];
}

- (IBAction)cmdFastForward:(id)sender {
    [remoter press:@"next"];
}

- (IBAction)cmdHome:(id)sender {
    [remoter press:@"home"];
}


- (IBAction)btnAbout:(id)sender {
    NSString * greeting = @"CeeNee Remote by http://CeeNee.Com.\nIcon by http://glyphicon.com";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCeeNee information" message:greeting delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    //[alert release];
}

- (IBAction)btnScan:(id)sender {
    [self performSelector:@selector(discovery) withObject:nil afterDelay:0.001f];
    [barItemScan setTitle:@"Scanning"];
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

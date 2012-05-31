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
@synthesize cmdPrevious;
@synthesize progressBar;
@synthesize keyboardField;
@synthesize remoter;
@synthesize lastEnteredTxt;

- (void)viewDidLoad
{
    [super viewDidLoad];
    remoter = [[CeeneeRemote alloc] init]; 
    progressBar.hidden = TRUE;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setKeyboardField:nil];
    [self setRemoter:nil];
    [self setProgressBar:nil];
    [self setCmdPrevious:nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d", buttonIndex);
}

- (NSArray *) discovery {
    [self.progressBar setHidden:FALSE];
    [progressBar setProgress:0.002];
    NSArray * boardIp;
    NSString * ip=[remoter getIp];
    NSString * _ip;
    NSInteger * port = 30000;
    NSLog([@"Current IP of Device" stringByAppendingFormat:ip]);
    ip = @"192.168.0.";
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
    
    
    for (int i=1; i<=253; i++) {
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
                            //exit(0); 
                        } 
                        // Check the value returned... 
                        if (valopt) { 
                            fprintf(stderr, "Error in delayed connection() %d - %s\n", valopt, strerror(valopt) 
                                    );
                            retry_connect = FALSE;
                            //exit(0); 
                        } 
                        NSLog([@"Connected to IP: " stringByAppendingFormat:_ip]); 
                        break; 
                    } 
                    else { 
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
            //Sucessful instantly
            NSLog([@"Connected to IP: " stringByAppendingFormat:_ip]);
        }
        // Set to blocking mode again... 
        arg = fcntl(sockfd, F_GETFL, NULL); 
        arg &= (~O_NONBLOCK); 
        fcntl(sockfd, F_SETFL, arg); 
        // I hope that is all 
        close(sockfd);
        
        //conn = Nil;
        /*
         if ([self isPortOpen:_ip onPort:port]) {
         NSLog([@"Connected to " stringByAppendingFormat:_ip]);  
         } else {
         NSLog([@"Cannot connec to " stringByAppendingFormat:_ip]);
         }*/
        
    }

}

- (IBAction)cmdSetup:(id)sender {
    [remoter press:@"setup"];  
}

- (IBAction)cmdReturn:(id)sender {
    [remoter press:@"return"];
}

- (IBAction)cmdVolUp:(id)sender {
}

- (IBAction)cmdVolDown:(id)sender {
}

- (IBAction)cmdVolMute:(id)sender {
}

- (IBAction)cmdVolAudio:(id)sender {
}



- (IBAction)btnAbout:(id)sender {
    NSString * greeting = @"CeeNee Remote. \nIcon by http://glyphicon.com";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCeeNee information" message:greeting delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    //[alert release];
}

- (IBAction)btnScan:(id)sender {
    [self.progressBar setHidden:FALSE];
    [progressBar setProgress:0.5];
    NSArray * boardIp;
    NSString * ip=[remoter getIp];
    NSString * _ip;
    NSInteger * port = 30000;
    NSLog([@"Current IP of Device" stringByAppendingFormat:ip]);
    ip = @"192.168.0.";
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
        
    for (int i=1; i<=253; i++) {
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
                            //exit(0); 
                        } 
                        // Check the value returned... 
                        if (valopt) { 
                            fprintf(stderr, "Error in delayed connection() %d - %s\n", valopt, strerror(valopt) 
                                    );
                            retry_connect = FALSE;
                            //exit(0); 
                        } 
                        NSLog([@"Connected to IP: " stringByAppendingFormat:_ip]); 
                        break; 
                    } 
                    else { 
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
            //Sucessful instantly
            NSLog([@"Connected to IP: " stringByAppendingFormat:_ip]);
        }
        // Set to blocking mode again... 
        arg = fcntl(sockfd, F_GETFL, NULL); 
        arg &= (~O_NONBLOCK); 
        fcntl(sockfd, F_SETFL, arg); 
        // I hope that is all 
        close(sockfd);
        
        //conn = Nil;
        /*
         if ([self isPortOpen:_ip onPort:port]) {
         NSLog([@"Connected to " stringByAppendingFormat:_ip]);  
         } else {
         NSLog([@"Cannot connec to " stringByAppendingFormat:_ip]);
         }*/
        
    }
    
    
    //    [self discovery]; 
    /*
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
     }*/

}

/**
 Display UIActionSheet of a list of device IP
 */
- (IBAction)btnShowDevice:(id)sender {
    NSArray *keys = [NSArray arrayWithObjects:@"192.168.0.1", @"192.168.0.3", @"192.168.0.4", @"192.168.0.113", @"192.168.0.119", @"192.168.0.235",nil
                     ];
    /*    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"IP Result"
                          message:@"This is an alert view"
                          delegate:self
                          cancelButtonTitle:@"Connect"
                          otherButtonTitles:nil];
    [alert show];
     */
    
    UIActionSheet *action = [[UIActionSheet alloc]
                             initWithTitle:@"Choose a device to connect"
                             delegate:self
                             cancelButtonTitle:@"Close"
                             destructiveButtonTitle:@"Exit"
                             otherButtonTitles: nil
                             ];
    action.cancelButtonIndex = 0;
    for (NSString * ip in keys) {
        [action addButtonWithTitle:ip];
    }
    [action showInView:self.view];
    
}

@end

//
//  Remote.m
//  HelloWorld
//
//  Created by Vinh Nguyen on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CeeneeRemote.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

#import <sys/types.h>
#import <sys/socket.h>

@implementation CeeneeRemote

@synthesize gsocket;
@synthesize keycodes;

- (BOOL) open:(NSString *) ip {
    gsocket = [[GCDAsyncSocket alloc] initWithDelegate:self  delegateQueue:dispatch_get_main_queue()];    
    //[udpSocket enableBroadcast:YES error:nil];
    NSError *err = nil;
    if (![gsocket connectToHost:ip onPort:30000 withTimeout:2 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
        return FALSE;
    }    
    return TRUE;
}

- (BOOL) close {
    [gsocket disconnect];
    return TRUE;
}
   
- (void) execute:(NSString *) key {
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];      
    [self.gsocket writeData:data withTimeout:-1 tag:1];   
}

- (void) loadKeycodeFromFile:(NSString *) file {	
    /*
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
    keycodes = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@",  keycodes);
    NSDictionary *theDict = [NSDictionary dictionaryWithContentsOfFile:file];
    NSLog(@"%@",  theDict);
    
    NSMutableArray *mutableArray =[[NSMutableArray alloc] initWithObjects:nil];
    NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"plist"]];
    
    //---enumerate through the dictionary objects 
    NSEnumerator *enumerator = [mainDictionary objectEnumerator];
    id value;
    int i=0;
    NSLog(@"BEGIN");
    while ((value = [enumerator nextObject])) {
        //[mutableArray addObject:[value valueForKey:@"key"]];         
        [mutableArray addObject:value];  
        NSLog(@"%a", value);
        i++;
        NSLog(@"%d", i);
    }
    NSLog(@"END");*/
    
}

- (id) initWithDic {
    self = [super init];
    
    NSArray *keys = [NSArray arrayWithObjects: @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", 
                     @"~", @"!", @"@", @"#", @"$", @"%", @"^", @"&", @"*", @"(", @")", @"-", @"_", @"+", @"=", @"[", @"]", @"{", @"}", @"|", @"\\",  @":", @";", @"\"", @"\'", @"<", @",", @">", @".", @"?", @"/", 
                     
                     @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", 
                     @"p", @"q", @"r", @"s", 
                     @"t", @"u", @"v", 
                     @"w", @"x", @"y", @"z", 
                     
                     @"power", @"setup", @"eject", @"tvmode", @"mute", @"delete", 
                     @"cap_num", @"return", @"source", 
                     @"up", @"left", @"enter", @"down", @"right",                     
                     @"info", @"home", @"menu",
                     
                     @"prev", @"play", @"next", @"title", @"rewind", @"stop", @"forward", @"repeat",
                     @"angle", @"pause", @"slow", @"timeseek", @"audio", @"subtitle", @"zoom",
                     @"red", @"green", @"yellow", @"blue",
                     
                     @"volup", @"voldown",
                     
                     nil
                     ];
    
    NSArray *objects = [NSArray arrayWithObjects: @"1,0", @"4,1" ,@"4,2" ,@"4,3" ,@"4,4" ,@"4,5" ,@"4,6" ,@"5,7" ,@"4,8" ,@"5,9",
                       @"31,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1",  @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1", @"1,1",      
                        
                        @"1,2", @"2,2", @"3,2", @"1,3", @"2,3", @"3,3", @"1,4", @"2,4", @"3,4", @"1,5", @"2,5", @"3,5", @"1,6", @"2,6", @"3,6", 
                        @"1,7", @"2,7", @"3,7", @"4,7",
                        @"1,8", @"2,8",@"3,8", 
                        @"1,.119", @"2,9", @"3,9", @"4,9", 
                        
                        @"1,x", @"50,e", @"1,j", @"1,T", @"1,u", @"1,c",
                        @"1,l", @"1,E", @"1,B", 
                        @"1,U", @"1,L", @"1,\n", @"1,D", @"1,R",
                        @"1,i", @"1,O", @"1,m",
                        
                        @"1,v", @"1,y", @"1,n", @"1,t", @"1,w", @"1,s", @"1,f", @"1,r", 
                        @"1,N", @"1,p", @"1,d", @"1,H", @"1,a", @"1,b", @"1,z",
                        @"1,P", @"1,G", @"1,Y", @"1,K",
                        
                        @"1,+", @"1,-",
                                                
                        nil
                        ]; //KEYCODE,
    
    keycodes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];    
    /*NSLog(@"Start to process dictionary");
    for (id key in keycodes) {        
        NSLog(@"key: %@, value: %@", key, [keycodes objectForKey:key]);        
    }*/    
    return self;
}

- (id)init
{
	return [self initWithDic];
}

- (void) processQueue {
        
}	


/**
Put the keycode of alpha nkey (alphabet and numeric) in the queue for processing 
 */
- (BOOL) press:(NSString *) k {
    //keyQueue = [keyQueue stringByAppendingString:k];
    NSString * rules = [keycodes objectForKey:k];
    NSArray *array = [rules componentsSeparatedByString:@","];
    int i;
    for (i = 0; i < [[array objectAtIndex:0] intValue]; i++)
    {       
        NSLog([array objectAtIndex:1]);    
        [self execute:[array objectAtIndex:1]];
        if (@"E" == [array objectAtIndex:1]) { //Hack for genesis because genesis re-map return key themselves.
            //[self execute:@"O"];     
        }
        
    }
    return TRUE;
}

/**
 * Scan the network based on broadcast address to find out device. 
 * Return an array of Ip adress which have a Ceenee unit.
 */
- (NSArray *) discovery {
    NSArray * boardIp;
    NSString * ip=[self getIp];
    NSString * _ip;
    NSInteger * port = 30000;
    NSLog(ip);
    ip = @"192.168.0.";
    
    struct timeval tv; 
    fd_set my_set;
    struct sockaddr_in address;
    struct sockaddr *addr;
    long arg;
    
    int sockfd;
    int conn;  
    // Create a socket
    address.sin_family = AF_INET;
    address.sin_port = htons(30000);        
    
    
    for (int i=179; i<=194; i++) {
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
        
        if (conn < 0) { 
            if (errno == EINPROGRESS) { 
                tv.tv_sec = 15; 
                tv.tv_usec = 0; 
                FD_ZERO(&myset); 
                FD_SET(sockfd, &myset); 
                if (select(soc+1, NULL, &myset, NULL, &tv) > 0) { 
                    lon = sizeof(int); 
                    getsockopt(soc, SOL_SOCKET, SO_ERROR, (void*)(&valopt), &lon); 
                    if (valopt) { 
                        fprintf(stderr, "Error in connection() %d - %s\n", valopt, strerror(valopt)); 
                        exit(0); 
                    } 
                } 
                else { 
                    fprintf(stderr, "Timeout or error() %d - %s\n", valopt, strerror(valopt)); 
                    exit(0); 
                } 
            } 
            else { 
                fprintf(stderr, "Error connecting %d - %s\n", errno, strerror(errno)); 
                exit(0); 
            } 
        } 
        // Set to blocking mode again... 
        arg = fcntl(soc, F_GETFL, NULL); 
        arg &= (~O_NONBLOCK); 
        fcntl(soc, F_SETFL, arg); 
        // I hope that is all 
        
        
        if (!conn) {
            NSLog(@"Connected to this host"); 
        } else {
             NSLog(@"Could not connect to this host"); 
                NSLog(@"%d", errno);
        }
        
        close(sockfd);
        //conn = Nil;
        /*
        if ([self isPortOpen:_ip onPort:port]) {
            NSLog([@"Connected to " stringByAppendingFormat:_ip]);  
        } else {
            NSLog([@"Cannot connec to " stringByAppendingFormat:_ip]);
        }*/
        
    }
    return boardIp;
}

/**
 Return current IP of the board. Then based on that we run dicovery() method to find all board in network
*/
- (NSString *) getIp {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];               
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(BOOL) isPortOpen:(NSString *)ip onPort:(NSInteger *)port {
    NSLog(@"Start to process on port %d", port);
    NSLog(ip);
    struct sockaddr_in addr;
    int sockfd;
    // Create a socket
    sockfd = socket( AF_INET, SOCK_STREAM, 0 );
        
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr([ip UTF8String]);
    addr.sin_port = htons(30000);        
    int conn = connect(sockfd, &addr, sizeof(addr));         
    if (!conn) {
        close(sockfd);
        return TRUE;
    }        
    //close(sockfd);    
    return FALSE;
}

@end
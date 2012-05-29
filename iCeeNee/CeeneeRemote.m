//
//  Remote.m
//  HelloWorld
//
//  Created by Vinh Nguyen on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CeeneeRemote.h"

@implementation CeeneeRemote

@synthesize socket;
@synthesize keycodes;

- (BOOL) open:(NSString *) ip {
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self  delegateQueue:dispatch_get_main_queue()];    
    //[udpSocket enableBroadcast:YES error:nil];
    NSError *err = nil;
    if (![socket connectToHost:ip onPort:30000 error:&err]) // Asynchronous!
    {
        // If there was an error, it's likely something like "already connected" or "no delegate set"
        NSLog(@"I goofed: %@", err);
        return FALSE;
    }    
    return TRUE;
}

- (BOOL) close {
    [socket disconnect];
    return TRUE;
}
   
- (void) execute:(NSString *) key {
    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];      
    [self.socket writeData:data withTimeout:-1 tag:1];   
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
                        
                        @"1,x", @"1,e", @"1,j", @"1,T", @"1,u", @"1,c",
                        @"1,l", @"5	,E", @"1,B", 
                        @"1,U", @"1,L", @"1,\n", @"1,D", @"1,R",
                        @"1,i", @"1,O", @"1,m",
                        
                        @"1,v", @"1,y", @"1,n", @"1,t", @"1,w", @"1,s", @"1,f", @"1,r", 
                        @"1,N", @"1,p", @"1,d", @"1,H", @"1,a", @"1,b", @"1,z",
                        @"1,P", @"1,G", @"1,Y", @"1,K",
                        
                        @"1,+", @"1,-",
                                                
                        nil
                        ]; //KEYCODE,
    
    keycodes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSLog(@"Start to process dictionary");
    for (id key in keycodes) {
        
        NSLog(@"key: %@, value: %@", key, [keycodes objectForKey:key]);
        
    }
    
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
        
    }
    return TRUE;
}

/**
 * Scan the network based on broadcast address to find out device.
 */
- (void) discovery {

}

@end
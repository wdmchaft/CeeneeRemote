//
//  Remote.h
//  HelloWorld
//
//  Created by Vinh Nguyen on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

extern NSString * const CEENEE_REMOTE_KEY_A;
extern NSString * const CEENEE_REMOTE_KEY_B;
extern NSString * const CEENEE_REMOTE_KEY_C;
extern NSString * const CEENEE_REMOTE_KEY_D;
extern NSString * const CEENEE_REMOTE_KEY_E;
extern NSString * const CEENEE_REMOTE_KEY_F;
extern NSString * const CEENEE_REMOTE_KEY_G;
extern NSString * const CEENEE_REMOTE_KEY_H;
extern NSString * const CEENEE_REMOTE_KEY_I;
extern NSString * const CEENEE_REMOTE_KEY_J;
extern NSString * const CEENEE_REMOTE_KEY_K;
extern NSString * const CEENEE_REMOTE_KEY_L;
extern NSString * const CEENEE_REMOTE_KEY_M;
extern NSString * const CEENEE_REMOTE_KEY_N;
extern NSString * const CEENEE_REMOTE_KEY_O;
extern NSString * const CEENEE_REMOTE_KEY_P;
extern NSString * const CEENEE_REMOTE_KEY_Q;
extern NSString * const CEENEE_REMOTE_KEY_R;
extern NSString * const CEENEE_REMOTE_KEY_S;
extern NSString * const CEENEE_REMOTE_KEY_T;
extern NSString * const CEENEE_REMOTE_KEY_U;
extern NSString * const CEENEE_REMOTE_KEY_V;
extern NSString * const CEENEE_REMOTE_KEY_W;
extern NSString * const CEENEE_REMOTE_KEY_X;
extern NSString * const CEENEE_REMOTE_KEY_Y;
extern NSString * const CEENEE_REMOTE_KEY_Z;
extern NSString * const CEENEE_REMOTE_KEY_HOME;
extern NSString * const CEENEE_REMOTE_KEY_POWER;
extern NSString * const CEENEE_REMOTE_KEY_EJECT;
extern NSString * const CEENEE_REMOTE_KEY_INFO;
extern NSString * const CEENEE_REMOTE_KEY_FORWARD;
extern NSString * const CEENEE_REMOTE_KEY_BACKWARD;

@interface CeeneeRemote : NSObject
{
    
    GCDAsyncSocket * gsocket;
    NSDictionary * keycodes;  
    NSString * keyQueue;
    
}
@property (retain) GCDAsyncSocket* gsocket;
@property (retain) NSDictionary* keycodes;

- (BOOL) open:(NSString *) ip; 
- (BOOL) close;
- (void) execute:(NSString *) key;
- (void) loadKeycodeFromFile:(NSString *) file;
- (id) init;
- (id) initWithDic;
- (void) processQueue;
- (BOOL) press:(NSString *) k; 
- (NSArray *) discovery;
- (NSString *) getIp;    
- (BOOL) isPortOpen:(NSString *) ip
           onPort:(NSInteger *) port;
@end

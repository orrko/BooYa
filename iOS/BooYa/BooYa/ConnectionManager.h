//
//  ConnectionManager.h
//  Onset
//
//  Created by Noam Ma-Yafit on 02/09/10.
//  Copyright 2010 OnO Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

@protocol ConnectionManagerProtocol 
@required
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end

@interface ConnectionManager : NSObject {
	//a delegate so we get updates
	id				 delegate;
	ASINetworkQueue	*_queue;
}

@property (nonatomic, retain) id		delegate;

+ (id) sharedManager;
- (void)grabURLInBackground:(NSString *)urlString andDelegate:(id)dlg postDict:(NSDictionary *)postDict;
- (void)stopConnection;

@end

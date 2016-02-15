//
//  RetardModel.h
//  Televoting
//
//  Created by Thomas Mac on 25/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RetardModelProtocol <NSObject>

- (void) retardsDownloaded:(NSArray*)items;

@end

@interface RetardModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<RetardModelProtocol> delegate;

- (void) creationRetard:(int)user_id cours_id:(int)cours_id date_value:(NSString*)date_value;

@end

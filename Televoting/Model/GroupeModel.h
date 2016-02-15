//
//  GroupeModel.h
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GroupeModelProtocol <NSObject>

- (void) groupesDownloaded:(NSArray*)items;

@end

@interface GroupeModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<GroupeModelProtocol> delegate;

- (void) getListeGroupesByCours:(int)cours_id;

@end

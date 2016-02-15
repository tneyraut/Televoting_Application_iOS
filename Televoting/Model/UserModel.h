//
//  UserModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserModelProtocol <NSObject>

- (void) getUserDownloaded: (NSArray*) items;

@end

@interface UserModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<UserModelProtocol> delegate;

- (void) getUser : (NSString*) login pass:(NSString*)password;

- (void) getListeElevesByGroupe:(int)groupe_id;

@end

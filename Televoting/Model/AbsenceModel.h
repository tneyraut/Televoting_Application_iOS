//
//  AbsenceModel.h
//  Televoting
//
//  Created by Thomas Mac on 25/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbsenceModelProtocol <NSObject>

- (void) absencesDownloaded:(NSArray*)items;

@end

@interface AbsenceModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<AbsenceModelProtocol> delegate;

- (void) creationAbsence:(int)user_id cours_id:(int)cours_id date_value:(NSString*)date_value;

@end

//
//  CoursModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoursModelProtocol <NSObject>

- (void) coursDownloaded: (NSArray*) items;

@end

@interface CoursModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<CoursModelProtocol> delegate;

- (void) getCoursAFaire:(int)user_id;

- (void) getAllCoursByUser:(int)user_id;

- (void) getListeCoursProfesseur:(int)user_id;

@end

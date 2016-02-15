//
//  Retard.h
//  Televoting
//
//  Created by Thomas Mac on 25/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Retard : NSObject

@property(nonatomic) int retard_id;
@property(nonatomic) int user_id;
@property(nonatomic) int cours_id;
@property(nonatomic, strong) NSString *date_value;
@property(nonatomic) BOOL justifiee;

@end

//
//  question_eleve.h
//  Televoting
//
//  Created by Thomas Mac on 26/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface question_eleve : NSObject

@property(nonatomic) int question_eleve_id;
@property(nonatomic, strong) NSString *user_name;
@property(nonatomic, strong) NSString *question;
@property(nonatomic) BOOL repondue;

@end

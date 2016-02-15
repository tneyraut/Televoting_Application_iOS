//
//  reponse_question_eleve.h
//  Televoting
//
//  Created by Thomas Mac on 26/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reponse_question_eleve : NSObject

@property(nonatomic) int reponse_question_eleve_id;
@property(nonatomic) int question_eleve_id;
@property(nonatomic, strong) NSString *reponse;
@property(nonatomic, strong) NSString *user_name;

@end

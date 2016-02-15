//
//  Question.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic) int question_id;
@property (nonatomic) int questionnaire_id;
@property (nonatomic, strong) NSString* question;
@property (nonatomic) int temps_imparti;
@property (nonatomic, strong) NSString* image;

@end

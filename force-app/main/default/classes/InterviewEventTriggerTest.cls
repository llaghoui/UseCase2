@isTest
public class InterviewEventTriggerTest {

    @TestSetup
    static void setup(){
         TestDataFactory.defaultValueProvider = new MyDefaultValueProvider();

        Candidate__c newCanditate = (Candidate__c)TestDataFactory.createSObject('Candidate__c', new Map<String,Object>{
        'First_Name__c' => 'Test',
        'Last_Name__c' => 'Candidate'
        });

        List<Interview__c> testInterviewsList = (List<Interview__c>)TestDataFactory.createSObjectList('Interview__c', new Map<String,Object>{
            'Name' =>  'Interview {!index}',
            // 'Candidate__cId' => TestDataFactory.DEFAULT_VALUE,
            'Duration__c' => 2,
            'InterviewStartDateTime__c' => TestDataFactory.DEFAULT_VALUE
          },200);
    }

    @isTest static void CheckEventEndDateTimeForInterviewAfterInsertTest() {

        Interview__c interview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = 'Interview 1'];
        Datetime endDateTime = interview.InterviewStartDateTime__c.addHours(Integer.valueOf(interview.Duration__c));
        System.assertEquals(endDateTime, interview.InterviewEndDateTime__c);
    }

     @isTest static void CheckEventEndDateTimeForInterviewAfterUpdateTest() {
        Interview__c interview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = 'Interview 33'];
        
        interview.InterviewStartDateTime__c = Datetime.newInstance(2023, 1, 5, 12, 0, 0);
        interview.Duration__c = 3;
        
        Test.startTest();
        update interview;
        Test.stopTest();

        Interview__c updatedInterview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = 'Interview 33'];
        
        Datetime endDateTime = Datetime.newInstance(2023, 1, 5, 12, 0, 0).addHours(3);
        System.assertEquals(endDateTime, updatedInterview.InterviewEndDateTime__c);
     }


     @isTest static void SameEventDateTimeForInterviewTest() {
        Interview__c interview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = 'Interview 66'];

        Event interviewEvent = [Select Id, EndDateTime, StartDateTime,DurationInMinutes, WhatId FROM Event WHERE WhatId = :interview.Id];

        System.assertEquals(interviewEvent.EndDateTime, interview.InterviewEndDateTime__c);
        System.assertEquals(interviewEvent.StartDateTime, interview.InterviewStartDateTime__c);
        System.assertEquals(interviewEvent.DurationInMinutes, interview.Duration__c * 60);
     }

     @isTest static void SameEventCountForInterviewsTest() {
        Map<Id,Interview__c> interviewMap = new Map<Id,Interview__c>([Select Id From Interview__c]);
        Set<Id> interviewIdSet = interviewMap.keySet();

        Map<Id,Event> interviewEvent = new Map<Id,Event>([Select Id FROM Event WHERE WhatId IN :interviewIdSet]);
        Set<Id> eventId = interviewEvent.keySet();

        System.assertEquals(eventId.size(), interviewIdSet.size());
     }

}
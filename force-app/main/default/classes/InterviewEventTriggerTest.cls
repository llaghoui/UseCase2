@isTest
public class InterviewEventTriggerTest {

    public static String CANDIDATE_NAME = 'Candidate ';
    public static String INTERVIEW_NAME = 'Interview ';
    public static DateTime INTERVIEW_DATE = Datetime.newInstance(2023, 1, 5, 12, 0, 0);

    @TestSetup
    static void setup(){
        List<Candidate__c> candidateList = MyTestDataFactory.createCandidateRecords(CANDIDATE_NAME, 5, true);

        List<Interview__c> InterviewList = MyTestDataFactory.createInterviewRecords(INTERVIEW_NAME, INTERVIEW_DATE, candidateList, true);
    }

    @isTest static void CheckEventEndDateTimeForInterviewAfterInsertTest() {
        String interviewName = INTERVIEW_NAME + 1;
        Interview__c interview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = :interviewName];
        Datetime endDateTime = interview.InterviewStartDateTime__c.addHours(Integer.valueOf(interview.Duration__c));
        System.assertEquals(endDateTime, interview.InterviewEndDateTime__c);
    }

     @isTest static void CheckEventEndDateTimeForInterviewAfterUpdateTest() {
        String interviewName = INTERVIEW_NAME + 2;
        Interview__c interview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = :interviewName];
        
        interview.InterviewStartDateTime__c = INTERVIEW_DATE;
        interview.Duration__c = 3;
        
        Test.startTest();
        update interview;
        Test.stopTest();

        Interview__c updatedInterview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = :interviewName];
        
        Datetime endDateTime = INTERVIEW_DATE.addHours(3);
        System.assertEquals(endDateTime, updatedInterview.InterviewEndDateTime__c, '');
     }

     @isTest static void SameEventDateTimeForInterviewTest() {
        String interviewName = INTERVIEW_NAME + 3;
        Interview__c interview = [Select Id, Name__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = :interviewName];

        Event interviewEvent = [Select Id, EndDateTime, StartDateTime,DurationInMinutes, WhatId FROM Event WHERE WhatId = :interview.Id];

        System.assertEquals(interviewEvent.EndDateTime, interview.InterviewEndDateTime__c);
        System.assertEquals(interviewEvent.StartDateTime, interview.InterviewStartDateTime__c);
        System.assertEquals(interviewEvent.DurationInMinutes, interview.Duration__c * 60);
     }

     @isTest static void SameEventCountForInterviewsTest() {
        Map<Id,Interview__c> interviewMap = new Map<Id,Interview__c>([Select Id From Interview__c]);
        Set<Id> interviewIdSet = interviewMap.keySet();

        Map<Id,Event> interviewEvent = new Map<Id,Event>([Select Id FROM Event WHERE WhatId IN :interviewIdSet]);
        Set<Id> eventsId = interviewEvent.keySet();

        System.assertEquals(eventsId.size(), interviewIdSet.size());
     }

     @isTest static void InterviewBulkInsertTest() {
        String InterviewNameToInsert = INTERVIEW_NAME + ' To Insert ';
        List<Candidate__c> candidateList = MyTestDataFactory.createCandidateRecords(CANDIDATE_NAME, 200, true);
        List<Interview__c> interviewList = MyTestDataFactory.createInterviewRecords(InterviewNameToInsert, INTERVIEW_DATE,  candidateList, false);

        Test.startTest();
        insert interviewList;
        Test.stopTest();

        Map<Id,Interview__c> interviewMap = new Map<Id,Interview__c>([Select Id From Interview__c where Name like :InterviewNameToInsert ]);
        Map<Id,Event> interviewEvent = new Map<Id,Event>([Select Id FROM Event WHERE WhatId IN :interviewMap.keySet()]);
        Set<Id> eventsId = interviewEvent.keySet();

        System.assertEquals(eventsId.size(), interviewMap.keySet().size(),'Expect To have same events as interviews');
     }

     @isTest static void ServiceUpdateInterviewTest() {
        String interviewName = INTERVIEW_NAME + 3;
        Interview__c interview = [Select Id, Name__c, Position__c, Candidate__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c From Interview__c where Name = :interviewName];

        interview.Duration__c = 3;

        Interview__c updatedInterview = SRV_InterviewService.updateInterview(interview);

        System.assertEquals(interview.Duration__c, updatedInterview.Duration__c,'Expect to the same duration');
     }

     @isTest static void ServiceGetInterviewsByDateRengeTest() {
        DateTime startDate = INTERVIEW_DATE;
        DateTime endDate = INTERVIEW_DATE.addDays(3);

        List<Interview__c> interviews = [Select Id, Name__c, Position__c, Candidate__c, InterviewStartDateTime__c, Duration__c, InterviewEndDateTime__c 
                From Interview__c 
                Where InterviewStartDateTime__c > :startDate and InterviewStartDateTime__c < :endDate];

        List<Interview__c> searchedInterviews= SRV_InterviewService.getInterviewsByDateRange(startDate, endDate);
        System.debug(searchedInterviews.size() + ' '+ interviews.size());
        System.assertEquals(searchedInterviews.size(), interviews.size(),'Expect to the same results');
     }

}
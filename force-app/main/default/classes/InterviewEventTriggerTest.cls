@isTest
public class InterviewEventTriggerTest {
    @isTest static void InterviewEventTriggerInsert() {

        Interview__c interview1 = new Interview__c(Name='Movie 1', InterviewStartDate__c= date.today(), Duration__c= 1);

        insert interview1;

        System.debug(date.today());   

    }
}
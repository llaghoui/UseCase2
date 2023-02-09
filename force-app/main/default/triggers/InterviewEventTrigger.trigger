trigger InterviewEventTrigger on Interview__c (before insert, before update, after insert, after update) {
    new InterviewEventTriggerHandler().run();
}
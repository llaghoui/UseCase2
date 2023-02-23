public with sharing class SRV_EventService {

    public static void createEventFromInterview(List<Interview__c> newIntreviews) {
        if(newIntreviews==null || newIntreviews.isEmpty())
            return;

        List<Event> events = new List<Event>();
        for( Interview__c interview: newIntreviews) {
            Event event = new Event(
                OwnerId = interview.CreatedById,
                StartDateTime = interview.InterviewStartDate__c,
                EndDateTime = interview.InterviewEndDate__c,
                ActivityDateTime = interview.InterviewStartDate__c,
                Subject = interview.Name,
                WhatId = interview.Id
            );
            events.add(event);
        }
        insert events;
    }

    public static void updateEventDates(Map<Id, Interview__c> updatedIntreviews) {
        if(updatedIntreviews==null || updatedIntreviews.isEmpty())
            return;

        List<Event> events = new List<Event>([Select Id, WhatId FROM Event WHERE WhatId IN :updatedIntreviews.keySet()]);
        for(Event event: events) {
            Interview__c interview = updatedIntreviews.get(event.WhatId);
            event.StartDateTime = interview.InterviewStartDate__c;
            event.EndDateTime = interview.InterviewEndDate__c;
            event.Subject = event.WhatId;
        }
        update events;
    }


    @AuraEnabled(cacheable=true)
    public static List<Event> getEventsByDate(Date activityDate) {
        try {
            List<Event> events = new List<Event>([Select Id,Subject, StartDateTime, EndDateTime FROM Event WHERE ActivityDate = :activityDate]);
        
            return events;
        } catch (Exception exp) {
            System.debug(exp.getMessage());
            throw new AuraHandledException(exp.getMessage());
        }
    }
}
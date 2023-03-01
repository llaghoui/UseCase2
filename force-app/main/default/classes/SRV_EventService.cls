public with sharing class SRV_EventService {

    public static void createEventFromInterview(List<Interview__c> newIntreviews) {
        if(newIntreviews==null || newIntreviews.isEmpty())
            return;

        List<Event> events = new List<Event>();
        for( Interview__c interview: newIntreviews) {
            Event event = new Event(
                OwnerId = interview.CreatedById,
                StartDateTime = interview.InterviewStartDateTime__c,
                EndDateTime = interview.InterviewEndDateTime__c,
                ActivityDateTime = interview.InterviewStartDateTime__c,
                Subject = interview.Name__c,
                WhatId = interview.Id
            );
            events.add(event);
        }
        insert events;
    }

    public static void updateEventDates(Map<Id, Interview__c> updatedIntreviews) {
        if(updatedIntreviews==null || updatedIntreviews.isEmpty())
            return;

        List<Event> events = [Select Id, WhatId FROM Event WHERE WhatId IN :updatedIntreviews.keySet()];
        for(Event event: events) {
            Interview__c interview = updatedIntreviews.get(event.WhatId);
            event.StartDateTime = interview.InterviewStartDateTime__c;
            event.EndDateTime = interview.InterviewEndDateTime__c;
            event.Subject = event.WhatId;
        }
        update events;
    }
}
public with sharing class SRV_EventService {

    public static void createEventFromInterview(List<Interview__c> newIntreviews) {
        if(newIntreviews==null || newIntreviews.size()==0)
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
        if(updatedIntreviews==null || updatedIntreviews.size()==0)
            return;

        Map<Id, Event> events = new Map<Id, Event>([Select Id, WhatId FROM Event WHERE WhatId IN :updatedIntreviews.keySet()]);
        for(Id key: events.keySet()) {
            // update event 
            Event event = events.get(key);
            Interview__c interview = updatedIntreviews.get(event.WhatId);
            event.StartDateTime = interview.InterviewStartDate__c;
            event.EndDateTime = interview.InterviewEndDate__c;
            event.Subject = event.WhatId;
        }
        update events.values();
    }
}
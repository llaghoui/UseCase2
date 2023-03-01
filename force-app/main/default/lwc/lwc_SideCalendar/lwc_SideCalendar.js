import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getEventsByDate from '@salesforce/apex/EventController.getEventsByDate';

export default class Lwc_SideCalendar extends NavigationMixin(LightningElement) {
    @api objectApiName;
    events; 
    activityDate = new Date(new Date().setHours(1,0,0,0));

    @wire(getEventsByDate, {
        activityDate: '$activityDate'
    })
    wiredEvents({ error, data }) {
        if (data) {
            this.events = data;
            this.loadDayCalendar();
            this.setTheTimeMarkerTop();
        } else if (error) {
            console.error('error',error);
        }
    }

    @track dayCalendar = [];

    connectedCallback() {
        this.eventHomePageRef = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event',
                actionName: 'home'
            }
        };
        this[NavigationMixin.GenerateUrl](this.eventHomePageRef)
            .then(url => this.url = url);
    }

    loadDayCalendar() {
        this.dayCalendar = [];
       for (let index = 0; index < 23; index++) {
        const hour = `${index}:00`;
        const event = this.findAndMapEvents(index);
        this.dayCalendar.push({
            index: index,
            time: hour,
            showCurrentTimeLine: index == new Date().getHours(),
            showEvent: event !== null && index == event.hour ? true : false,
            event: event
        });
       }
    }

    findAndMapEvents(hour) {
        const hourEvent = this.events.find(e => new Date(Date.parse(e.StartDateTime)).getHours() === hour);
        if (hourEvent) {
            return {
                hour: hour,
                title: hourEvent.Subject,
                startDate: hourEvent.StartDateTime,
                duration: this.getDurationInHours(hourEvent.DurationInMinutes),
                class: this.getDurationClass(hourEvent.DurationInMinutes)
            }
        }

        return null;
    }

    getDurationInHours(durationInMinutes) {
        return Math.floor(durationInMinutes / 60);
    }

    getDurationClass(durationInMinutes) {
        const duration = this.getDurationInHours(durationInMinutes);
        if (duration > 8) {
            return 'event event-8h';
        }
        
        return  `event event-${duration}h`;
    }

    setTheTimeMarkerTop() {
        var calculatedTop = 0;
        var totalMinutes = 1440;
        var currentMinutes = this.getCurrentMinutes();
        calculatedTop = (currentMinutes / totalMinutes ) * 289;

        var css = this.template.host.style;
        css.setProperty('--topTimeMarker', calculatedTop+'%');
    }

    getCurrentMinutes() {
        var currentDate = new Date();
        return (currentDate.getHours() * 60 )+ currentDate.getMinutes();
    }

    showNextDayEvents() {
        const newDate = this.activityDate.setDate(this.activityDate.getDate() + 1);
        this.activityDate = new Date(newDate);
    }

    showPreviousDayEvents() {
        const newDate = this.activityDate.setDate(this.activityDate.getDate() - 1);
        this.activityDate = new Date(newDate);
    }

    navigateToCalendar(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.eventHomePageRef);
    }
}
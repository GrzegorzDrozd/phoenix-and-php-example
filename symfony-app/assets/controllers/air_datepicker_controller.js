// assets/controllers/air_datepicker_controller.js
import { Controller } from '@hotwired/stimulus';
import AirDatepicker from 'air-datepicker';

export default class extends Controller {
    static targets = ['datepickerInput'];

    connect() {
        console.log('AirDatepicker Stimulus controller connected.');
        this.datepickerInputTargets.forEach(input => {
            new AirDatepicker(input, {
                // Default options, customize as needed
                locale: {
                    days: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
                    daysShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                    daysMin: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
                    months: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
                    monthsShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    today: 'Today',
                    clear: 'Clear',
                    dateFormat: 'yyyy-MM-dd',
                    timeFormat: 'hh:mm aa',
                    firstDay: 0,
                },
                // Force ISO format on selection
                dateFormat: 'yyyy-MM-dd',
                maxDate: new Date(),
                onSelect: ({formattedDate}) => {
                    input.value = formattedDate;
                }
            });
        });
    }
}

import { startStimulusApp } from '@symfony/stimulus-bundle';
import AirDatepickerController from './controllers/air_datepicker_controller.js';

const app = startStimulusApp();
app.register('air-datepicker', AirDatepickerController);
// register any custom, 3rd party controllers here
// app.register('some_controller_name', SomeImportedController);

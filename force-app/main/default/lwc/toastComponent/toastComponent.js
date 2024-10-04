import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ToastComponent extends LightningElement {
    showToast() {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'This is a toast message',
            variant: 'success',
        });
        this.dispatchEvent(event);
    }
}

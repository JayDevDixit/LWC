import { LightningElement } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';


export default class GenericResources extends LightningElement {
    updateRecordData(recordInput) {
        updateRecord(recordInput)
        .then(() => {
            console.log('Record inserted successfully');
        })
        .catch(error => {
            console.error('Error creating record:', error);
        });
}
}
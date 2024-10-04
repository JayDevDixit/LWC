import { LightningElement, wire } from 'lwc';
import fetchAccount from '@salesforce/apex/giveAllAccounts.fetchAccount';

export default class ShowAllAccounts extends LightningElement {
    accounts;
    error;
    columns=[
        {label:'Account Name',fieldName:'Name'},
        {label:'Industry',fieldName:'Industry'},
        {label:'Phone',fieldName:'Phone'},
    ];
    @wire(fetchAccount)
    wiredAccounts({ error, data }) {
        if(data)
            this.accounts = data;
        else if(error)
            this.error = error;
    }
}
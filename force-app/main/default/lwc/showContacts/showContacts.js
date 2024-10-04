import { LightningElement, track, wire } from 'lwc';
import getContactsByAccountId from '@salesforce/apex/AccountContactsController.getContactsByAccountId';
import getAccountOptions from '@salesforce/apex/AccountContactsController.getAccountOptions';

export default class AccountContacts extends LightningElement {
    @track contacts;
    @track error;
    @track selectedAccountId;
    @track accountOptions = [];

    columns = [
        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
        { label: 'Last Name', fieldName: 'LastName', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' }
    ];

    // Fetch accounts for the combobox
    @wire(getAccountOptions)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accountOptions = data.map(account => {
                return { label: account.Name, value: account.Id };
            });
        } else if (error) {
            this.error = error.body.message;
        }
    }

    // Handle account selection
    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        this.fetchContacts();
    }

    // Fetch contacts based on selected account
    fetchContacts() {
        getContactsByAccountId({ accountId: this.selectedAccountId })
            .then(result => {
                this.contacts = result;
                this.error = undefined;
                console.log('resultsssss'+result)
            })
            .catch(error => {
                this.contacts = undefined;
                this.error = error.body.message;
            });
    }
}

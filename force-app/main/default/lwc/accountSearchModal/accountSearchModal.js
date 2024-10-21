import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/accountPicklistJS.getAccountbySearch';

export default class AccountSearchModal extends LightningElement {
    @track accounts = [];
    @track filteredAccounts = [];
    @track searchKey = '';
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Account ID', fieldName: 'Id' }
    ];

    @wire(getAccounts, { searchKey: '$searchKey' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.filteredAccounts = data; // Default to all accounts
        } else if (error) {
            // Handle error
        }
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value;
        this.filteredAccounts = this.accounts.filter(account => 
            account.Name.toLowerCase().includes(this.searchKey.toLowerCase())
        );
    }

    handleRowAction(event) {
        const selectedAccount = event.detail.row;
        this.dispatchEvent(new CustomEvent('select', {
            detail: { accountId: selectedAccount.Id, accountName: selectedAccount.Name }
        }));
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}
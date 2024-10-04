import { LightningElement,wire,track } from 'lwc';
import getAccountbySearch from '@salesforce/apex/accountPicklistJS.getAccountbySearch';

const columns = [
    {label:'Account Name',fieldName:'Name',sortable:true},
    {label:'Industry',fieldName:'Industry',sortable:true},
    {label:'Phone',fieldName:'Phone',sortable:true},
    {label:'Annual Revenue',fieldName:'AnnualRevenue',sortable:true}
];
export default class ShowAccWithSortSearch extends LightningElement {
    @track accounts = [];
    @track searchKey = '';
    columns = columns;
    @track sortedBy;

    handleChangeSearch(event){
        this.searchKey = event.target.value;
    }
    handeSort(event){
        const { fieldName: sortedBy } = event.detail;
        const cloneData = [...this.accounts];

        // Sorting logic - always ascending
        cloneData.sort((a, b) => {
            let valueA = a[sortedBy] ? a[sortedBy] : '';
            let valueB = b[sortedBy] ? b[sortedBy] : '';
            return valueA > valueB ? 1 : -1;
        });

        this.accounts = cloneData;
        this.sortedBy = sortedBy;
    }

    // Fetch Accounts from Apex when the component is initialized or when search key is changed
    @wire(getAccountbySearch, { searchKey: '$searchKey' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Enter a valid date',
                    message: error.message,
                    variant: 'error',
                }),
            );
        }
    }
}
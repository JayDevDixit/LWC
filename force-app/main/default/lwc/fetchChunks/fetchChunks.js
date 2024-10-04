import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import fetchInChunks from '@salesforce/apex/FetchObjectField.fetchInChunks';

export default class DynamicFieldFetcher extends LightningElement {
    @api objectApiName;
    @api fieldApiNames;
    @api fieldList;
    @track columns = [];
    @track data = [];
    isLoading = false;

    @track paginatedData = [];
    @track pageErrorMessage = '';
    @track limitval = 30;
    @track totalRecordsFetched = 0;

    objectError;
    objectInfo;
    errorMessage = '';
    fields = [];

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    wiredObjectInfo({ error, data }) {
        if (data) {
            this.objectInfo = data;
            this.validateFields();
        } else if (error) {
            this.objectInfo = undefined;
            this.fields = [];
            this.errorMessage = 'Object API Name ' + this.objectApiName + ' is invalid';
        }
    }

    validateFields() {
        this.errorMessage = '';
        this.fields = [];
        if (this.fieldApiNames) {
            this.fieldList = this.fieldApiNames.split(',').map(field => field.trim());
            console.log('fieldList->', this.fieldList);



            this.fieldList.forEach(field => {
                if (this.objectInfo.fields[field]) {
                    this.fields.push(this.objectInfo.fields[field].label);

                    // After field is validate add it into datatable
                    this.columns = [...this.columns, { label: this.objectInfo.fields[field].label, fieldName: field, editable: true }];
                } else {
                    this.errorMessage += `Field "${field}" does not exist on object "${this.objectApiName}".`;
                }
            });

            if (!this.errorMessage)
                this.loadData(0);  // Call the Apex method after validating fields means no error message

        }

    }


    get haserror() {
        console.log('Has error called');
        return this.errorMessage !== '';
    }

    get hasfields() {
        return !this.haserror && this.fields.length > 0;
    }


    loadData() {
        if (this.isLoading) { return; }
        else {
            this.isLoading = true;
            fetchInChunks({ fieldNames: this.fieldList, objectName: this.objectApiName, offsetval: this.totalRecordsFetched, limitval: this.limitval })
                .then(result => {
                    this.totalRecordsFetched += this.limitval;
                    this.data = [...this.data, ...result];
                    this.error = undefined;
                    this.isLoading = false;
                    console.log('inside fetch in chunk .then')

                })
                .catch(error => {
                    this.error = error.body.message;
                    console.log(error.message);
                    this.isLoading = false;
                    console.log('inside fetch in chunk .catch')

                });
        }
    }


    get isFirstPage() {
        return this.currentPage == 1;
    }
    get isLastPage() {
        return this.currentPage == this.totalPages;
    }

    async loadMoreData(event) {
        console.log('inside loadmoredata')
        const { target } = event;
        target.isLoading = true;
        console.log('inside loadmoredata', target)
        await this.loadData();
        // .then(()=> {
        //     target.isLoading = false;
        //     console.log('loaded data .then')
        // }).catch(error=>{
        //     target.isLoading = false;
        //     console.log('loaded data .catch', error);
        // });   


    }

}
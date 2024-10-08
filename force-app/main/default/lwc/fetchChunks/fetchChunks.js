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
    @track lastRecordId = null;
    @track lastModifiedDate = null;

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

            this.fieldList.forEach(field => {
                if (this.objectInfo.fields[field]) {
                    this.fields.push(this.objectInfo.fields[field].label);

                    // After field is validated, add it into the datatable
                    this.columns = [...this.columns, { label: this.objectInfo.fields[field].label, fieldName: field, editable: true }];
                } else {
                    this.errorMessage += `Field "${field}" does not exist on object "${this.objectApiName}".`;
                }
            });

            if (!this.errorMessage) {
                this.loadData();  // Call the Apex method after validating fields if no error message
            }
        }
    }

    get haserror() {
        return this.errorMessage !== '';
    }

    get hasfields() {
        return !this.haserror && this.fields.length > 0;
    }

    loadData() {
        if (this.isLoading) return;
        
        this.isLoading = true;
        fetchInChunks({
            fieldNames: this.fieldList,
            objectName: this.objectApiName,
            lastRecordId: this.lastRecordId,
            limitval: this.limitval,
            lastModifiedDate:this.lastModifiedDate
        })
            .then(result => {
                if (result.length > 0) {
                    this.lastRecordId = result[result.length - 1].Id; // Track last record's Id
                    this.lastModifiedDate = result[result.length - 1].LastModifiedDate; // Track last modified date
                    this.data = [...this.data, ...result];
                    console.log('Date= ',this.lastModifiedDate)
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.errorMessage = error.body.message;
                this.isLoading = false;
            });
    }

    async loadMoreData(event) {
        const { target } = event;
        target.isLoading = true;
        await this.loadData();
        target.isLoading = false;
    }
}

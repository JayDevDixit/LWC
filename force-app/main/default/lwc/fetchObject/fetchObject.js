import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import fetchRecords from '@salesforce/apex/FetchObjectField.fetchRecords';

export default class DynamicFieldFetcher extends LightningElement {
    @api objectApiName;
    @api fieldApiNames;
    @api fieldList;
    @track columns = [{label: 'Row Number', fieldName: 'rowNumber', type: 'number'}];
    @track data = [];

    @track paginatedData = [];
    @track currentPage = 1;
    @track recordsPerPage = 5;
    @track totalPages = 0;
    @track pageErrorMessage = '';

    objectError;
    objectInfo;
    errorMessage = '';
    fields = [];

    @wire(getObjectInfo,{objectApiName:'$objectApiName'})
    wiredObjectInfo({error,data}){
        if(data){
            this.objectInfo = data;
            this.validateFields();
        }else if(error){
            this.objectInfo = undefined;
            this.fields = [];
            this.errorMessage = 'Object API Name '+this.objectApiName+' is invalid';
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
                    this.columns.push({label:this.objectInfo.fields[field].label,fieldName:field,editable:true})
                    this.columns = [...this.columns];
                } else {
                    this.errorMessage+= `Field "${field}" does not exist on object "${this.objectApiName}".`;
                }
            });
            
            if (!this.errorMessage) 
                this.fetchRecords();  // Call the Apex method after validating fields means no error message
            
        }

    }
    

    get haserror() { 
        return this.errorMessage !== '';
    }

    get hasfields() { 
        return !this.haserror && this.fields.length > 0;
    } 


    fetchRecords() {
        fetchRecords({ fieldNames: this.fieldList,objectName: this.objectApiName})
            .then(result => {
                this.data = result;
                this.totalPages = Math.ceil(this.data.length / this.recordsPerPage);
                this.error = undefined;
                console.log(this.data);
                this.setPaginatedData();

            })
            .catch(error => {
                this.contacts = undefined;
                this.error = error.body.message; 
                console.log(this.error);
            });
    }

    setPaginatedData(){
        const start = (this.currentPage - 1) * this.recordsPerPage;
        const end = start + this.recordsPerPage;
        this.paginatedData = this.data.slice(start, end).map((row,index)=>{
            return {...row,rowNumber:start+index+1 }
        });
        
    }
    previousPage(){
        if(this.currentPage > 1){
            this.currentPage--;
            this.setPaginatedData();
        }
    }
    nextPage(){
        if(this.currentPage < this.totalPages){
            this.currentPage++;
            this.setPaginatedData();
        }
    }
    
    get isFirstPage(){
        return this.currentPage == 1;
    }
    get isLastPage(){
        return this.currentPage == this.totalPages;
    }

    handlePageChange(event){
        this.pageErrorMessage = '';
        const pageNo = Number(event.target.value);
        if(pageNo > 0 && pageNo < this.totalPages){
        this.currentPage = pageNo;
        this.setPaginatedData();
        }else if(event.target.value===0 || event.target.value !==''){
            this.pageErrorMessage = 'Invalid Input';
        }
    }

}
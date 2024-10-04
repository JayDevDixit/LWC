import { LightningElement, wire, track } from 'lwc';
import getAllObjectsName from '@salesforce/apex/ObjectFieldController.getAllObjectsName';
import getFieldsbyObjectName from '@salesforce/apex/ObjectFieldController.getFieldsbyObjectName';

export default class ShowObject extends LightningElement {
    @track selectedObject;
    @track options = [];
    @track selectedField;
    @track fieldOptions = [];
    @track fieldDetails = {};

    // When the user selects an object
    handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        console.log(`Selected object: ${this.selectedObject}`);
        this.fieldOptions = [];
        this.fieldDetails = {};

        // Fetch fields for the selected object
        getFieldsbyObjectName({ objectName: this.selectedObject })
            .then(result => {
                this.fieldOptions = result.map(field => {
                    return { 
                        label: field.label, 
                        value: field.apiName,
                        type: field.type // Capture field type in the returned value
                    };
                });
            })
            .catch(error => {
                console.error('Error fetching fields:', error);
            });
    }

    // When the user selects a field
    handleFieldChange(event) {
        this.selectedField = event.detail.value;
        console.log(`Selected field: ${this.selectedField}`);

        // Find the selected field's details
        const selectedFieldDetail = this.fieldOptions.find(
            field => field.value === this.selectedField
        );

        // Capture field details including API name and type
        if (selectedFieldDetail) {
            this.fieldDetails = {
                apiName: this.selectedField,
                type: selectedFieldDetail.type
            };
            console.log(`Field details: ${JSON.stringify(this.fieldDetails)}`);
        }
    }

    // Fetch all objects for the first picklist
    @wire(getAllObjectsName)
    wiredObjects({ error, data }) {
        if (data) {
            this.options = data.map(obj => {
                return { label: obj, value: obj };
            });
        } else if (error) {
            console.error('Error fetching objects:', error);
        }
    }
}

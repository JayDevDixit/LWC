import { LightningElement, track } from 'lwc';
import insertAccountObject from '@salesforce/apex/insertAccountJS.insertAccountObject';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateAccount extends LightningElement {
     name = '';
     phone = '';
     industry = '';
     successMessage = '';
     errorMessage = '';
     isChecked = true;
     num = '';

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.target.value;
    }
    handleCheckbox(event) {
        this.isChecked = event.target.checked;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }
    handleNumberChange(event) {
        this.num = event.target.value;
    }

    handleCreateAccount() {
        insertAccountObject({
            name: this.name,
            industry: this.industry,
            phone: this.phone,
            isChecked : this.isChecked,
            num : this.num  // Add more fields as needed for your custom object schema.
        })
        .then(result => {
            this.successMessage = `Account created successfully with id ${result.Id}`;
            this.errorMessage = '';
            this.name = '';
            this.phone = '';
            this.industry = '';
            this.isChecked = false;
            this.num = '';

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: this.successMessage,
                    variant: 'success',
                })
            );
        })
        .catch(error => {
            this.errorMessage = error.body.message;
            this.successMessage = '';
        });
    }
}

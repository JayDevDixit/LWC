import { LightningElement, track } from 'lwc';

export default class Calculator extends LightningElement {
    value1;
    value2;
    result;
    handleValue1(e) {
        this.value1 = parseFloat(e.target.value);
    }
    handleValue2(e) {
        this.value2 = parseFloat(e.target.value);
    }
    add(event) {
        this.result = this.value1 + this.value2;
    }
    subtract(event) {
        this.result = this.value1 - this.value2;
    }

    multiply(event) {
        this.result = this.value1 * this.value2;
    }
}
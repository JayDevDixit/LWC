import { LightningElement } from "lwc";


export default class GrandParentComponent extends LightningElement {
 count = 0;
 childsChanged = (event) => {
   this.count = event.detail;
 };
 handleReset = (event) => {
   this.count = 0;
   this.template.querySelector("c-parent-status").reset();
 };
}

import { LightningElement, api } from "lwc";


export default class ParentOfChildComponent extends LightningElement {
 count = 0;
 childSelected = "Deselected";
 @api reset = () => { 
   this.count = 0;
   this.childSelected = "Deselected";
   this.template.querySelector("c-child-button").reset();

 };
 handleSelected = (event) => {
   this.count = this.count + 1;
   if (this.count > 0) this.childSelected = "Selected";
   this.dispatchEvent(
     new CustomEvent("childs_changed", { detail: this.count })
   );
 };
 handleDeselected = (event) => {
   this.count = this.count - 1;
   if (this.count == 0) this.childSelected = "Deselected";
   this.dispatchEvent(
     new CustomEvent("childs_changed", { detail: this.count })
   );
 };
}

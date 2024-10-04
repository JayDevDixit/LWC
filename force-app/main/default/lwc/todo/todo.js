import { LightningElement, track } from 'lwc';

export default class Todo extends LightningElement {
    @track todos = [];  // Initialize as an array
    todo = '';          // Initialize as an empty string
    
    handleTodo(event) {
        this.todo = event.target.value;  // Use 'this' to access the class property
    }

    submitTodo() {
        if (this.todo) {
            // Add a new todo item with a 'name' and 'completed' status
            this.todos = [...this.todos, { name: this.todo, completed: false }];
            this.todo = '';  // Clear the input field
        }
    }

    deleteTodo(event) {
        const index = event.target.dataset.index;  // Get the index of the todo to be deleted
        this.todos = this.todos.filter((todo, i) => i != index);  // Remove the todo at the specified index
    }

    completeTodo(event) {
        const index = event.target.dataset.index;  // Get the index of the todo to be marked as complete
        this.todos = this.todos.map((todo, i) => {
            if (i == index) {
                return { ...todo, completed: true };  // Mark the todo as completed
            }
            return todo;
        });
    }
}

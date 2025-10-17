/*
 * This script provides client-side validation for the registration form.
 * It ensures the passwords match before submitting.
 */

// We wait for the DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {

    // Find the registration form by an ID
    // ** YOU MUST ADD id="registrationForm" to your <form> tag in register.jsp **
    const regForm = document.getElementById('registrationForm');

    if (regForm) {
        regForm.addEventListener('submit', function(event) {

            // Get the password and confirm password fields
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');

            // Clear any old error messages
            clearErrors();

            if (password.value !== confirmPassword.value) {
                // Passwords don't match
                event.preventDefault(); // Stop the form from submitting

                // Show an error message
                showError(confirmPassword, 'Passwords do not match!');
            }
        });
    }
});

function showError(inputElement, message) {
    // Create a new error message element
    const errorEl = document.createElement('div');
    errorEl.className = 'form-error-message'; // You can style this class
    errorEl.style.color = 'var(--error-color)';
    errorEl.style.fontSize = '14px';
    errorEl.style.marginTop = '4px';
    errorEl.textContent = message;

    // Insert it after the input field's parent (the .form-group)
    inputElement.parentElement.appendChild(errorEl);
}

function clearErrors() {
    const errorMessages = document.querySelectorAll('.form-error-message');
    errorMessages.forEach(el => el.remove());
}
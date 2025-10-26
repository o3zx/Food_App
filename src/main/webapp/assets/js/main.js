// Wait for DOM to load
document.addEventListener('DOMContentLoaded', function() {
    const registrationForm = document.getElementById('registrationForm');

    if (registrationForm) {
        registrationForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const errorElement = document.getElementById('js-error');

            // Clear previous errors
            errorElement.style.display = 'none';
            errorElement.textContent = '';

            // Check if passwords match
            if (password !== confirmPassword) {
                e.preventDefault(); // Stop form submission
                errorElement.textContent = 'Passwords do not match!';
                errorElement.style.display = 'block';
                return false;
            }

            // Check password length
            if (password.length < 6) {
                e.preventDefault();
                errorElement.textContent = 'Password must be at least 6 characters long!';
                errorElement.style.display = 'block';
                return false;
            }

            return true;
        });
    }
});
/* ADD THIS TO THE BOTTOM OF main.js */

// Find the password change form
const passwordForm = document.getElementById('passwordForm');

if (passwordForm) {
    passwordForm.addEventListener('submit', function(event) {
        // Get the password fields
        const newPass = document.getElementById('newPassword');
        const confirmPass = document.getElementById('confirmPassword');

        // Clear any old errors
        clearErrors(); // We reuse the function from the registration form

        if (newPass.value !== confirmPass.value) {
            // Passwords don't match
            event.preventDefault(); // Stop the form from submitting

            // Show an error message
            showError(confirmPass, 'New passwords do not match!');
        }

        if (newPass.value.length < 6) {
            event.preventDefault();
            showError(newPass, 'Password must be at least 6 characters long.');
        }
    });
}
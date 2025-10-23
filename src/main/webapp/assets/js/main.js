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
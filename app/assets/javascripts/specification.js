document.addEventListener("DOMContentLoaded", function() {
    var clearFiltersButton = document.querySelector('.clear_filters_btn');
    var filterForm = document.querySelector('.filter_form');
  
    if (clearFiltersButton && filterForm) {
      clearFiltersButton.addEventListener('click', function(event) {
        event.preventDefault();
        // Reset input fields to their default values
        filterForm.reset();
      });
    }
  });
//= require active_admin/base

function handleCourseSelection(selectedCourseId) {
    if (selectedCourseId) {
      fetchDepartments(selectedCourseId);
    } else {
      $('#course_department_select').empty().append(new Option('Select a course first', ''));
    }
  }
  
  function fetchDepartments(courseId) {
    $.ajax({
      url: "/admin/colleges/departments",
      method: 'GET',
      dataType: 'json',
      data: { course_id: courseId },
      
      success: function(data) {
        console.log(data)
        updateDepartmentOptions(data);
      },
      error: function(error) {
        console.error("Error fetching departments:", error);
      }
    });
  }
  
  function updateDepartmentOptions(departments) {
    var departmentSelect = $('#course_department_select');
    departmentSelect.empty();
  
    if (Array.isArray(departments) && departments.length > 0) {
      $.each(departments, function(index, department) {
        departmentSelect.append(new Option(department[0], department[1]));
      });
    } else {
      departmentSelect.append(new Option('No departments available', ''));
    }
  }
  $(document).ready(function() {
    $('#course_name_select').change(function() {
      var selectedCourseId = $(this).val();
      handleCourseSelection(selectedCourseId);
    });
  });  

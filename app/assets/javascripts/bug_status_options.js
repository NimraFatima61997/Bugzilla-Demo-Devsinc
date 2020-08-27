$( document ).ready(function() {
 
  $("#bug_type-option").change(function(e){
  
    $.ajax({
      
      url: "/bugs/bug_status_options",
      type: 'POST',
      data: {bug_type: $(this).val()},
      success: function(response){  
        console.log(response);
        var status = response["status"];
        $("#status-option").html('');
        $("#status-option").append(new Option("Bug Status",'', false, false));
        $('option[value=""]').attr("disabled", "disabled");
        for(var i=0; i< status.length; i++){
          $("#status-option").append(new Option(status[i], status[i], false, false));

        }},
      error: function(error){}
    })   
  });
});

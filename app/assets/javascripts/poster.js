$(document).ready(function () {
  $('#derp').click(function (e) {
    e.preventDefault();

    var url = $('#url').val();
    var type = $('#type').val();
    var body = $('#body').val();
    //var json = $.parseJSON(body);

    $.ajax({
      url: url,
      data: body,
      processData: false,
      type: type,
      headers: {
        'Accept' : 'application/json'
      },
      success: function (result) {
        $('#results').html(result);
      },
      error: function (xhr) {
        $('#results').html(xhr.responseText);
      }
    });
  });
});

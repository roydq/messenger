$(document).ready(function () {
  $('#derp').click(function (e) {
    e.preventDefault();

    $('#status').html('');
    $('#results').html('');

    var url = $('#url').val();
    var type = $('#type').val();
    var body = $('#body').val();
    var json = $.parseJSON(body);

    $.ajax({
      url: url,
      data: json,
      processData: true,
      type: type,
      headers: {
        'Accept' : 'application/json'
      },
      complete: function (xhr, textStatus) {
        $('#status').html(textStatus);
        $('#results').html(xhr.responseText);
      }
    });
  });
});

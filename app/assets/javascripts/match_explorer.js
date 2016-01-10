$(document).on('ready page:load', function () {
    $(".select_for_match").click(function (event) {
        volunteer_id = this.dataset.volunteerId
        event.preventDefault();
        $("select#match_volunteer_id option").filter(function () {
            return $(this).val() == volunteer_id;
        }).prop('selected', true);
    });

  $('#create_proposal_button').click(function (event) {
    if (!$('.matchExplorer_checkbox').is(':checked')) {
      event.preventDefault();
      $('#create-proposal-warning').text('You must select volunteers above before creating a match proposal.');
      $('#create-proposal-warning').show();
    }
  });
});
$(document).on('ready page:load', function () {
    $(".select_for_match").click(function (event) {
        volunteer_id = this.dataset.volunteerId
        event.preventDefault();
        $("select#match_volunteer_id option").filter(function () {
            return $(this).val() == volunteer_id;
        }).prop('selected', true);
    });
});
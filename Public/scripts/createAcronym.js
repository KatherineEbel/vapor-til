$.ajax({
    url: "/api/categories/",
    type: "GET",
    contentType: "application/json; charset=utf-8"
}).then(response => {
    const data = response.map(tag => ({
        id: tag["name"],
        text: tag["name"]
    }));
    $('#categories').select2({
        placeholder: "Select Categories for the Acronym",
        tags: true,
        tokenSeparators: [','],
        data: data
    });
});

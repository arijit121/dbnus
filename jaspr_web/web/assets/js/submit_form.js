function submitFormFunction(url, objStr, id) {
    // Parse the object string into a JSON object
    const obj = JSON.parse(objStr);

    // Create a new form element
    var form = document.createElement('form');
    form.setAttribute('action', url);  // Set the form's action URL
    form.setAttribute('id', id);  // Set a unique ID for the form
    form.setAttribute('method', 'POST');  // Set the form's method to POST
    document.body.appendChild(form);  // Append the form to the document body

    // Get a reference to the created form using its ID
    var frmObj = document.getElementById(id);

    // Iterate through the keys of the object and create hidden input fields
    Object.keys(obj).forEach(function (key) {
        var input = document.createElement("input");
        input.setAttribute('type', "hidden");  // Hidden input field
        input.setAttribute('name', key);  // Set the input field name
        input.setAttribute('value', obj[key]);  // Set the input field value

        // Append the input field to the form
        frmObj.appendChild(input);
    });

    // Submit the form
    frmObj.submit();
}

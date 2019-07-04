<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'fileUpload.label', default: 'FileUpload')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>

    <asset:stylesheet src="dropzone.css"/>
    <asset:stylesheet src="basic.css"/>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha384-xBuQ/xzmlsLoJpyjoggmTEz8OWUFM0/RC5BsqQBDX2v5cMvDHcMakNTNrHIW2I5f" crossorigin="anonymous"></script>
    <asset:javascript src="dropzone.js"/>

</head>
<body>
<g:if test="${!params.id}">
    <input id="reportName" type="text" placeholder="Enter a name for the Album">
</g:if>
<g:else>
    <h2>${album?.name}</h2>
</g:else>

<!-- The file upload form used as target for the file upload widget -->
<div id="uploaddropzone" class="dropzone"></div>

<script>
    Dropzone.autoDiscover = false;
    var reportId = "${params.id ?: 'none'}";

    myDropzone = $("div#uploaddropzone").dropzone({
        url: "/fileUpload/file",
        init: function() {
            this.on("sending", function(file, xhr, formData) {
                if(reportId === 'none') {
                    reportId = 'requested';
                    getReportId();
                }
                if (reportId !== 'none' && reportId !== 'requested'){
                    this.options.url = '${createLink(controller: 'fileUpload', action:'file', absolute: true)}/' + reportId.toString();
                }
            });
        },
        error: function(file, errorMessage, xhr){
            file.status = "queued";
        }});


    // Create the mock file:

    let mockFile = { name: "Filename", size: 12345 };
    myDropzone.emit("addedfile", mockFile);
    myDropzone.emit("thumbnail", mockFile, "/image/url");
    myDropzone.createThumbnailFromUrl(file, imageUrl, callback, crossOrigin);
    myDropzone.emit("complete", mockFile);

    // Load existing files:
    if(reportId !== 'none') {
        // $('#fileupload').addClass('fileupload-processing');
        $.ajax({
            url: $('#fileupload').fileupload('option', 'url'),
            dataType: 'json',
            context: $('#fileupload')[0]
        }).always(function () {
            $(this).removeClass('fileupload-processing');
        }).done(function (result) {
            $(this).fileupload('option', 'done')
                .call(this, $.Event('done'), {result: result});
        });
    }


    function getReportId() {
        $.post("${createLink(controller: 'Album', action:'save', absolute: true)}",
            {"name": $('#reportName').val()}).done(
            function (data) {
                reportId = data.id;
                window.history.replaceState( {} , '', updateURLParameter(window.location.href, 'id', reportId));
            });
    }

    // url helper function
    // From http://stackoverflow.com/a/10997390/11236
    function updateURLParameter(url, param, paramVal){
        let newAdditionalURL = "";
        let tempArray = url.split("?");
        let baseURL = tempArray[0];
        let additionalURL = tempArray[1];
        let temp = "";
        if (additionalURL) {
            tempArray = additionalURL.split("&");
            for (let i=0; i<tempArray.length; i++){
                if(tempArray[i].split('=')[0] !== param){
                    newAdditionalURL += temp + tempArray[i];
                    temp = "&";
                }
            }
        }
        let rows_txt = temp + "" + param + "=" + paramVal;
        return baseURL + "?" + newAdditionalURL + rows_txt;
    }
</script>
</body>
</html>
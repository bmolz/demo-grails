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

    function getReportId() {
        $.post("${createLink(controller: 'Album', action:'save', absolute: true)}",
            {"name": "Album1"}).done(
            function (data) {
                reportId = data.id;
            });
    }
</script>
</body>
</html>
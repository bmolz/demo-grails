<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    %{--        changed to main2 to avoid jquery conflict, should update jquery--}%
    <meta name="layout" content="main2" />
    <g:set var="entityName" value="${message(code: 'fileUpload.label', default: 'FileUpload')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>

    <!-- blueimp Gallery styles -->
    <link rel="stylesheet" href="https://blueimp.github.io/Gallery/css/blueimp-gallery.min.css">
    <!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
    %{--        <link rel="stylesheet" href="css/jquery.fileupload.css">--}%
    <asset:stylesheet src="blueimp/jquery.fileupload.css"/>
    %{--        <link rel="stylesheet" href="css/jquery.fileupload-ui.css">--}%
    <asset:stylesheet src="blueimp/jquery.fileupload-ui.css"/>

    <!-- CSS adjustments for browsers with JavaScript disabled -->
    %{--        <noscript><link rel="stylesheet" href="css/jquery.fileupload-noscript.css"></noscript>--}%
    %{--        <noscript><link rel="stylesheet" href="css/jquery.fileupload-ui-noscript.css"></noscript>--}%

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha384-xBuQ/xzmlsLoJpyjoggmTEz8OWUFM0/RC5BsqQBDX2v5cMvDHcMakNTNrHIW2I5f" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js" integrity="sha384-Dziy8F2VlJQLMShA6FHWNul/veM9bCkRUaLqr199K94ntO5QUrLJBEbYegdSkkqX" crossorigin="anonymous"></script>
    <!-- The Templates plugin is included to render the upload/download listings -->
    <script src="https://blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
    <!-- The Load Image plugin is included for the preview images and image resizing functionality -->
    <script src="https://blueimp.github.io/JavaScript-Load-Image/js/load-image.all.min.js"></script>
    <!-- The Canvas to Blob plugin is included for image resizing functionality -->
    <script src="https://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
    <!-- blueimp Gallery script -->
    <script src="https://blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"></script>
    <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
    <asset:javascript src="blueimp/jquery.iframe-transport.js"/>
    <!-- The basic File Upload plugin -->
    <asset:javascript src="blueimp/jquery.fileupload.js"/>
    <!-- The File Upload processing plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-process.js"/>
    <!-- The File Upload image preview & resize plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-image.js"/>
    <!-- The File Upload audio preview plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-audio.js"/>
    <!-- The File Upload video preview plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-video.js"/>
    <!-- The File Upload validation plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-validate.js"/>
    <!-- The File Upload user interface plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-ui.js"/>
    <!-- The File Upload jQuery UI plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-jquery-ui.js"/>


</head>
<body>
<g:if test="${!params.id}">
    <input id="reportName" type="text" placeholder="Enter a name for the Album">
</g:if>

<!-- The file upload form used as target for the file upload widget -->
<form id="fileupload" enctype="multipart/form-data">
    <!-- Redirect browsers with JavaScript disabled to the origin page -->
%{--    <noscript><input type="hidden" name="redirect" value="${createLink()}"></noscript>--}%
    <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
    <div class="fileupload-buttonbar">
        <div class="fileupload-buttons">
            <!-- The fileinput-button span is used to style the file input field as button -->
            <button class="fileinput-button">
                <span>Add files...</span>
                <input type="file" name="files[]" multiple>
            </button>
            <button id="fileupload-submit" type="submit" class="start">Start upload</button>
            <button type="reset" class="cancel">Cancel upload</button>
            <button type="button" class="delete">Delete</button>
            <input type="checkbox" class="toggle">
            <!-- The global file processing state -->
            <span class="fileupload-process"></span>
        </div>
        <!-- The global progress state -->
        <div class="fileupload-progress fade" style="display:none">
            <!-- The global progress bar -->
            <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
            <!-- The extended global progress state -->
            <div class="progress-extended">&nbsp;</div>
        </div>
    </div>
    <!-- The table listing the files available for upload/download -->
    <table role="presentation">
        <tbody class="files" id="fileList"></tbody>
    </table>
</form>
<!-- The blueimp Gallery widget -->
%{--<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-filter=":even">--}%
%{--    <div class="slides"></div>--}%
%{--    <h3 class="title"></h3>--}%
%{--    <a class="prev">‹</a>--}%
%{--    <a class="next">›</a>--}%
%{--    <a class="close">×</a>--}%
%{--    <a class="play-pause"></a>--}%
%{--    <ol class="indicator"></ol>--}%
%{--</div>--}%
<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <span class="preview"></span>
        </td>
        <td>
            {% if (window.innerWidth > 480 || !o.options.loadImageFileTypes.test(file.type)) { %}
                <p class="name">{%=file.name%}</p>
            {% } %}
            <strong class="error"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
            <div class="progress"></div>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="start" disabled hidden>Start</button>
            {% } %}
            {% if (!i) { %}
                <button class="cancel">Cancel</button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        <td>
            <span class="preview">
                {% if (file.thumbnailUrl) { %}
                    <a href="{%=file.thumbnailUrl%}" title="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}"></a>
                {% } %}
            </span>
        </td>
        <td>
            {% if (window.innerWidth > 480 || !file.thumbnailUrl) { %}
                <p class="name">
                    <a href="{%=file.url%}" title="{%=file.name%}" {%=file.url?'data-gallery':''%}>{%=file.name%}</a>
                </p>
            {% } %}
            {% if (file.error) { %}
                <div><span class="error">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
        <td>
            <button class="delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>Delete</button>
            <input type="checkbox" name="delete" value="1" class="toggle">
        </td>
    </tr>
{% } %}
</script>
<script>
    var reportId = "${params.id ?: 'none'}";
    var running = false;

    $(function () {
        'use strict'; //required for blueimp upload

        function getReportId() {
            $.post("${createLink(controller: 'Album', action:'save', absolute: true)}",
                {"name": "Album1"}).done(
                function( data ) {
                    reportId = data.id;
                    window.setInterval(function(){
                            console.log('click submit');
                            if(!running){
                                running = true;
                                $('#fileupload-submit').trigger('click');
                            }
                        },
                        3000);
            });
        }

        // Initialize the jQuery File Upload widget:
        $('#fileupload').fileupload({
            url: '${createLink(controller: 'fileUpload', action:'file', absolute: true)}',
            sequentialUploads: true,
            maxRetries: 100,
            retryTimeout: 500,
            fail: function (e, data) {
                // jQuery Widget Factory uses "namespace-widgetname" since version 1.10.0:
                var fu = $(this).data('blueimp-fileupload') || $(this).data('fileupload'),
                    retries = data.context.data('retries') || 0;//,
                    // retry = function () {
                    //     console.log('retry');
                    //     data.submit();
                    // };
                if (data.errorThrown !== 'abort' &&
                    data.uploadedBytes < data.files[0].size &&
                    retries < fu.options.maxRetries) {
                    retries += 1;
                    data.context.data('retries', retries);
                    // window.setTimeout(retry, retries * fu.options.retryTimeout);
                    return;
                }
                data.context.removeData('retries');
                $.blueimp.fileupload.prototype
                    .options.fail.call(this, e, data);
            }
        })
            .bind('fileuploadsubmit', function (e, data) {
            console.log('submit');
            if(reportId === 'none') {
                reportId = 'requested';
                getReportId();
            }
        })
            .bind('fileuploadsend', function (e, data) {
                if(reportId !== 'none' && reportId !== 'requested') {
                    data.url = '${createLink(controller: 'fileUpload', action:'file', absolute: true)}/' + reportId.toString();
                }
                console.log('post to ' + data.url);
                // modify url to post to
            })
            .bind('fileuploadprocessstop', function (e, data) {
                console.log('fileuploadstop');
                // data.submit();
                // $('#fileupload-submit').trigger('click');
                // window.setTimeout(function(){
                //         console.log('click submit');
                //         $('#fileupload-submit').trigger('click');
                //     },
                //     2000);
            })
        ;

        // Load existing files:
        if(reportId !== 'none') {
            $('#fileupload').addClass('fileupload-processing');
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
    });

    // // url helper function
    // // From http://stackoverflow.com/a/10997390/11236
    // function updateURLParameter(url, param, paramVal){
    //     let newAdditionalURL = "";
    //     let tempArray = url.split("?");
    //     let baseURL = tempArray[0];
    //     let additionalURL = tempArray[1];
    //     let temp = "";
    //     if (additionalURL) {
    //         tempArray = additionalURL.split("&");
    //         for (let i=0; i<tempArray.length; i++){
    //             if(tempArray[i].split('=')[0] !== param){
    //                 newAdditionalURL += temp + tempArray[i];
    //                 temp = "&";
    //             }
    //         }
    //     }
    //     let rows_txt = temp + "" + param + "=" + paramVal;
    //     return baseURL + "?" + newAdditionalURL + rows_txt;
    // }
</script>
</body>
</html>
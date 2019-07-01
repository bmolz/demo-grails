<!DOCTYPE html>
<html>
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
    %{--<script src="js/jquery.iframe-transport.js"></script>--}%
    <!-- The basic File Upload plugin -->
    <asset:javascript src="blueimp/jquery.fileupload.js"/>
    %{--<script src="js/jquery.fileupload.js"></script>--}%
    <!-- The File Upload processing plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-process.js"/>
    %{--<script src="js/jquery.fileupload-process.js"></script>--}%
    <!-- The File Upload image preview & resize plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-image.js"/>
    %{--<script src="js/jquery.fileupload-image.js"></script>--}%
    <!-- The File Upload audio preview plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-audio.js"/>
    %{--<script src="js/jquery.fileupload-audio.js"></script>--}%
    <!-- The File Upload video preview plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-video.js"/>
    %{--<script src="js/jquery.fileupload-video.js"></script>--}%
    <!-- The File Upload validation plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-validate.js"/>
    %{--<script src="js/jquery.fileupload-validate.js"></script>--}%
    <!-- The File Upload user interface plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-ui.js"/>
    %{--<script src="js/jquery.fileupload-ui.js"></script>--}%
    <!-- The File Upload jQuery UI plugin -->
    <asset:javascript src="blueimp/jquery.fileupload-jquery-ui.js"/>
    %{--<script src="js/jquery.fileupload-jquery-ui.js"></script>--}%
    <!-- The main application script -->
    %{--        <asset:javascript src="blueimp/main.js"/>--}%
    %{--<script src="js/main.js"></script>--}%

</head>
<body>
<!-- The file upload form used as target for the file upload widget -->
<form id="fileupload" action="https://jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
    <!-- Redirect browsers with JavaScript disabled to the origin page -->
    <noscript><input type="hidden" name="redirect" value="https://blueimp.github.io/jQuery-File-Upload/"></noscript>
    <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
    <div class="fileupload-buttonbar">
        <div class="fileupload-buttons">
            <!-- The fileinput-button span is used to style the file input field as button -->
            <button class="fileinput-button">
                <span>Add files...</span>
                <input type="file" name="files[]" multiple>
            </button>
            <button type="submit" class="start">Start upload</button>
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
    <table role="presentation"><tbody class="files"></tbody></table>
</form>
<!-- The blueimp Gallery widget -->
<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-filter=":even">
    <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev">‹</a>
    <a class="next">›</a>
    <a class="close">×</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
</div>
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
                <button class="start" disabled>Start</button>
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
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}"></a>
                {% } %}
            </span>
        </td>
        <td>
            {% if (window.innerWidth > 480 || !file.thumbnailUrl) { %}
                <p class="name">
                    <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
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
    $(function () {
        'use strict';
        // Initialize the jQuery File Upload widget:
        $('#fileupload').fileupload({
            // Uncomment the following to send cross-domain cookies:
            //xhrFields: {withCredentials: true},
            url: '${createLink(controller: 'fileUpload', action:'file', absolute: true)}'
        }).bind('fileuploadsend', function (e, data) {
            // modify url to post to
            // console.log('sending');
            // data.url='upload/1';
            // return false;
        });
        // Load existing files:
        $('#fileupload').addClass('fileupload-processing');
        $.ajax({
            // Uncomment the following to send cross-domain cookies:
            //xhrFields: {withCredentials: true},
            url: $('#fileupload').fileupload('option', 'url'),
            dataType: 'json',
            context: $('#fileupload')[0]
        }).always(function () {
            $(this).removeClass('fileupload-processing');
        }).done(function (result) {
            $(this).fileupload('option', 'done')
                .call(this, $.Event('done'), {result: result});
        });
        // }

    });
</script>
</body>
</html>
package demo.grails

import grails.converters.JSON
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.MultipartFile
import java.awt.image.BufferedImage
//import org.imgscalr.Scalr
import javax.imageio.ImageIO

class FileUploadController {

    FileUploadService fileUploadService

    def file() {
        println params
        request.headerNames.each{
            println it
        }
        switch(request.method){
            case "GET":
                def results = []
                FileUpload.findAll().each { it ->
                    results << [
                            name: it.fileName,
                            size: it.fileSize,
                            url: createLink(controller:'fileUpload', action:'picture', id: it.id, absolute: true),
                            thumbnail_url: createLink(controller:'fileUpload', action:'picture', id: it.id, absolute: true),
                            delete_url: createLink(controller:'fileUpload', action:'delete', id: it.id, absolute: true),
                            delete_type: "DELETE"
                    ]
                }
                render results as JSON
                break;
            case "POST":
                def results = [files: []]
                if (request instanceof MultipartHttpServletRequest){
                    println request
                    for(filename in request.getFileNames()){
                        println filename
                        MultipartFile file = request.getFile(filename)
//                        println file

                        def newFilenameBase = UUID.randomUUID().toString()
                        def originalFileExtension = file.originalFilename.substring(file.originalFilename.lastIndexOf("."))
                        def newFilename = newFilenameBase + originalFileExtension
//                        String storageDirectory = grailsApplication.config.file.upload.directory?:'/tmp'
//                        def storageDirectory = grailsApplication.config.getProperty('uploadDir')
                        def storageDirectory =  grailsApplication.config.getProperty('localBackend.uploadedFilesDirectory')
                        println 'storageDirectory'
                        println storageDirectory

                        def path = new File(storageDirectory + File.separator, newFilename)
//                        if (path.getParentFile() != null) {
//                            println path
//                            path.getParentFile().mkdirs()
//                        }
                        file.transferTo(path)

//                        BufferedImage thumbnail = Scalr.resize(ImageIO.read(newFile), 290);
//                        String thumbnailFilename = newFilenameBase + '-thumbnail.png'
//                        File thumbnailFile = new File("$storageDirectory/$thumbnailFilename")
//                        ImageIO.write(thumbnail, 'png', thumbnailFile)
//
                        FileUpload picture = new FileUpload(
                                fileName: file.originalFilename,
                                filePath: path.absolutePath,
//                                thumbnailFilename: thumbnailFilename,
                                fileSize: file.size
                        ).save()


                        results.files << [
                                name: picture.fileName,
                                size: picture.fileSize,
                                url: createLink(controller:'fileUpload', action:'picture', id: picture.id, absolute: true),
                                thumbnail_url: createLink(controller:'fileUpload', action:'picture', id: picture.id, absolute: true),
                                delete_url: createLink(controller:'fileUpload', action:'delete', id: picture.id, absolute: true),
                                delete_type: "DELETE"
                        ]
                    }
                }

                render results as JSON
                break;
            default: render status: HttpStatus.METHOD_NOT_ALLOWED.value()
        }
    }

    def picture(Long id){
        FileUpload pic = FileUpload.get(id)
//        def storageDirectory = grailsApplication.config.getProperty('uploadDir') ?: '/tmp'
        File picFile = new File(pic.filePath)


//        File picFile = new File("${grailsApplication.config.file.upload.directory?:'/tmp'}/${pic.filePath}")
        render file: picFile, contentType: 'image/jpeg'
    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond fileUploadService.list(params), model:[fileUploadCount: fileUploadService.count()]
    }

    def show(Long id) {
        respond fileUploadService.get(id)
    }

    def create() {
        respond new FileUpload(params)
    }

    def save(FileUpload fileUpload) {
        if (fileUpload == null) {
            notFound()
            return
        }

        try {
            fileUploadService.save(fileUpload)
        } catch (ValidationException e) {
            respond fileUpload.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'fileUpload.label', default: 'FileUpload'), fileUpload.id])
                redirect fileUpload
            }
            '*' { respond fileUpload, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond fileUploadService.get(id)
    }

    def update(FileUpload fileUpload) {
        if (fileUpload == null) {
            notFound()
            return
        }

        try {
            fileUploadService.save(fileUpload)
        } catch (ValidationException e) {
            respond fileUpload.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'fileUpload.label', default: 'FileUpload'), fileUpload.id])
                redirect fileUpload
            }
            '*'{ respond fileUpload, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        fileUploadService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'fileUpload.label', default: 'FileUpload'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'fileUpload.label', default: 'FileUpload'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}

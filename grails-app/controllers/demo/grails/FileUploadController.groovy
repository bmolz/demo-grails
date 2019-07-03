package demo.grails

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import grails.validation.ValidationException

import java.nio.file.Files
import java.nio.file.Paths

import static org.springframework.http.HttpStatus.*
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.MultipartFile
import java.awt.image.BufferedImage
import javax.imageio.ImageIO
import org.imgscalr.Scalr


@Transactional
class FileUploadController {

    FileUploadService fileUploadService

    def file(Long id) {
        println params
        if(!id) {
            response.sendError(404)
            return
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
                    for(filename in request.getFileNames()){
                        MultipartFile file = request.getFile(filename)
                        def newFilenameBase = UUID.randomUUID().toString()
                        def originalFileExtension = file.originalFilename.substring(file.originalFilename.lastIndexOf("."))
                        def newFilename = newFilenameBase + originalFileExtension
                        def storageDirectory =  grailsApplication.config.getProperty('localBackend.uploadedFilesDirectory') ?:
                                System.getProperty("user.home") + File.separator + 'tmp' + File.separator
                        File filePath = new File(storageDirectory, newFilename)
                        Files.createDirectories(Paths.get(filePath.parent))
                        file.transferTo(filePath)
                        println "Writing file to ${filePath}"

                        BufferedImage thumbnail = Scalr.resize(ImageIO.read(filePath), 100)
                        String thumbnailFilename = newFilenameBase + '-thumb.png'
                        File thumbnailFile = new File("$storageDirectory/$thumbnailFilename")
                        ImageIO.write(thumbnail, 'png', thumbnailFile)

                        FileUpload upload = new FileUpload(
                                fileName: file.originalFilename,
                                filePath: filePath.absolutePath,
                                thumbPath: thumbnailFile.absolutePath,
                                fileSize: file.size
                        ).save()

                        if (upload.hasErrors()) {
                            results.files << [
                                    name: upload.fileName,
                                    error: upload.errors
                            ]
                        } else {
                            results.files << [
                                    name: upload.fileName,
                                    size: upload.fileSize,
                                    url: createLink(controller:'fileUpload', action:'picture', id: upload.id, absolute: true),
                                    thumbnailUrl: createLink(controller:'fileUpload', action:'thumb', id: upload.id, absolute: true),
                                    deleteUrl: createLink(controller:'fileUpload', action:'delete', id: upload.id, absolute: true),
                                    deleteType: "DELETE",
                            ]
                        }
                    }
                }
                render results as JSON
                break
            default: render status: HttpStatus.METHOD_NOT_ALLOWED.value()
        }
    }

    def picture(Long id){
        def pic = FileUpload.get(id)
        File picFile = new File(pic.filePath)
        render file: picFile, contentType: 'image/jpeg'
    }

    def thumb(Long id){
        def pic = FileUpload.get(id)
        File picFile = new File(pic.thumbPath)
        render file: picFile, contentType: 'image/png'
    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond fileUploadService.list(params), model:[fileUploadCount: fileUploadService.count()]
    }

    def show(Long id) {
        respond fileUploadService.get(id)
    }

    def create(Long id) {
        respond new FileUpload(params)
    }

    def save(FileUpload fileUpload) {
        if (fileUpload == null) {
            response.sendError(404)
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

//    def edit(Long id) {
//        respond fileUploadService.get(id)
//    }

//    def update(FileUpload fileUpload) {
//        if (fileUpload == null) {
//            response.sendError(404)
//            return
//        }
//
//        try {
//            fileUploadService.save(fileUpload)
//        } catch (ValidationException e) {
//            respond fileUpload.errors, view:'edit'
//            return
//        }
//
//        request.withFormat {
//            form multipartForm {
//                flash.message = message(code: 'default.updated.message', args: [message(code: 'fileUpload.label', default: 'FileUpload'), fileUpload.id])
//                redirect fileUpload
//            }
//            '*'{ respond fileUpload, [status: OK] }
//        }
//    }

    def delete(Long id) {
        if (id == null) {
            response.sendError(404)
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
}

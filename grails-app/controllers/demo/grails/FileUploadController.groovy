package demo.grails

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class FileUploadController {

    FileUploadService fileUploadService

    def upload() {

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

package demo.grails

import grails.converters.JSON
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class AlbumController {

    AlbumService albumService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond albumService.list(params), model:[albumCount: albumService.count()]
    }

    def show(Long id) {
        respond albumService.get(id)
    }

    def create() {
        respond new Album(params)
    }

    def save(Album album) {
        println 'save album'
        println params
        if (album == null) {
            notFound()
            return
        }

        try {
            albumService.save(album)
        } catch (ValidationException e) {
            respond album.errors, view:'create'
            return
        }

        render album as JSON

//        request.withFormat {
//            form multipartForm {
//                flash.message = message(code: 'default.created.message', args: [message(code: 'album.label', default: 'Album'), album.id])
//                redirect album
//            }
//            '*' { respond album, [status: CREATED] }
//        }
    }

    def edit(Long id) {
        respond albumService.get(id)
    }

    def update(Album album) {
        if (album == null) {
            notFound()
            return
        }

        try {
            albumService.save(album)
        } catch (ValidationException e) {
            respond album.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'album.label', default: 'Album'), album.id])
                redirect album
            }
            '*'{ respond album, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        albumService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'album.label', default: 'Album'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'album.label', default: 'Album'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}

package demo.grails

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: 'fileUpload', action: 'create2')
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}

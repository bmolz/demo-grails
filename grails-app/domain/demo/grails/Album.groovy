package demo.grails

class Album {

    String name

    static hasMany = [files: FileUpload]

    static constraints = {
    }
}

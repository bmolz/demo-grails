package demo.grails

import grails.gorm.services.Service

@Service(FileUpload)
interface FileUploadService {

    FileUpload get(Serializable id)

    List<FileUpload> list(Map args)

    Long count()

    void delete(Serializable id)

    FileUpload save(FileUpload fileUpload)

}
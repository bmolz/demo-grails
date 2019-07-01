package demo.grails

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class FileUploadServiceSpec extends Specification {

    FileUploadService fileUploadService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new FileUpload(...).save(flush: true, failOnError: true)
        //new FileUpload(...).save(flush: true, failOnError: true)
        //FileUpload fileUpload = new FileUpload(...).save(flush: true, failOnError: true)
        //new FileUpload(...).save(flush: true, failOnError: true)
        //new FileUpload(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //fileUpload.id
    }

    void "test get"() {
        setupData()

        expect:
        fileUploadService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<FileUpload> fileUploadList = fileUploadService.list(max: 2, offset: 2)

        then:
        fileUploadList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        fileUploadService.count() == 5
    }

    void "test delete"() {
        Long fileUploadId = setupData()

        expect:
        fileUploadService.count() == 5

        when:
        fileUploadService.delete(fileUploadId)
        sessionFactory.currentSession.flush()

        then:
        fileUploadService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        FileUpload fileUpload = new FileUpload()
        fileUploadService.save(fileUpload)

        then:
        fileUpload.id != null
    }
}

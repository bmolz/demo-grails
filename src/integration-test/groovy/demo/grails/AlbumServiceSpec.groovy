package demo.grails

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class AlbumServiceSpec extends Specification {

    AlbumService albumService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Album(...).save(flush: true, failOnError: true)
        //new Album(...).save(flush: true, failOnError: true)
        //Album album = new Album(...).save(flush: true, failOnError: true)
        //new Album(...).save(flush: true, failOnError: true)
        //new Album(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //album.id
    }

    void "test get"() {
        setupData()

        expect:
        albumService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Album> albumList = albumService.list(max: 2, offset: 2)

        then:
        albumList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        albumService.count() == 5
    }

    void "test delete"() {
        Long albumId = setupData()

        expect:
        albumService.count() == 5

        when:
        albumService.delete(albumId)
        sessionFactory.currentSession.flush()

        then:
        albumService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Album album = new Album()
        albumService.save(album)

        then:
        album.id != null
    }
}

component extends="testbox.system.BaseSpec" {

    private boolean function isLucee() {
        return structKeyExists(server,'lucee');
    }

    function run() {
        describe( "Liquibase object", function() {

            beforeEach(function( currentSpec ) {
                if(isLucee()) {
                    queryExecute("DROP ALL OBJECTS",{},{datasource:"test"});

                } else {
     
                    var results = queryExecute("
                    select 'drop table if exists ""' || tablename || '"" cascade;' as q
                    from pg_tables
                    where schemaname = 'public'; ",{},{datasource:"test"});

                    for(var a in results) {
                        queryExecute(a['q'],{},{datasource:"test"});
                    }
                }
            });

            it( "Should create a people table with a fname and lname column as well as insert a single row.", function() {

                var a = new src.liquibase();
                a.update(expandPath('resources/liquibase/test1.xml'),'test');
                var results = queryExecute("Select * from people",{},{datasource:"test"});

                expect( results.recordCount ).toBe( 1 );
            } );

            it( "Should be able to run test1 update twice and still have 1 row.", function() {
                var a = new src.liquibase();
                a.update(expandPath('resources/liquibase/test1.xml'),'test');
                a.update(expandPath('resources/liquibase/test1.xml'),'test');

                var results = queryExecute("Select * from people",{},{datasource:"test"});

                expect( results.recordCount ).toBe( 1 );
            } );

            it(title= "Should be able to pass a structure as a datasource and run the xml files. Only ran on Lucee", body = function() {
                var testObj = new src.liquibase();
                var dbStruct = {
                    class: 'org.h2.Driver',
                    bundleName: 'org.h2',
                    bundleVersion: '1.3.172',
                    connectionString: 'jdbc:h2:#expandPath( '/tests/db/test' )#;MODE=MySQL'
                };

                testObj.update( expandPath('resources/liquibase/test1.xml'),dbStruct );

                var results = queryExecute("Select * from people",{},{datasource:dbStruct});

            },skip=function(){
                return !structKeyExists( server, "lucee" );
            });

            it(title= "Should be able to pass a structure as a datasource and run the xml files. Only ran on non-Lucee", body = function() {
                var testObj = new src.liquibase();
                var dbStruct = {
                    class: 'org.h2.Driver',
                    bundleName: 'org.h2',
                    bundleVersion: '1.3.172',
                    connectionString: 'jdbc:h2:#expandPath( '/tests/db/test' )#;MODE=MySQL'
                };

                expect( 
                    function(){ 
                        testObj.update( expandPath('resources/liquibase/test1.xml'),dbStruct ); 
                    } 
                ).toThrow( 'InvalidServer' );

            },skip=function(){
                return structKeyExists( server, "lucee" );
            });

            it("testing this",function() {
                var paths = [expandPath('/lib/liquibase-core-3.5.3/liquibase-core-3.5.3.jar')];

			    var loader = createObject("component", "modules.cbjavaloader.models.javaloader.JavaLoader").init(paths);
                
                var resourceService = loader.create("liquibase.resource.FileSystemResourceAccessor");

                var li = loader.create("liquibase.Liquibase").init(expandPath('resources/liquibase/test1.xml'));

                writedump(li);abort;
            });
        } );
    }
}
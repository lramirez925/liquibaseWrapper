component extends="testbox.system.BaseSpec" {


    function run() {
        describe( "Liquibase object", function() {

            beforeEach(function( currentSpec ) {
                 queryExecute("DROP ALL OBJECTS",{},{datasource:"test"})
            });

            it( "Should create a people table  with a fname and lname column as well as insert a single row.", function() {

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
        } );
    }
}
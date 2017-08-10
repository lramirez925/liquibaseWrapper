component {

    /**
        Runs an anonymous function which is passed a liquibase argument. This is used to run dynamic liquibase commands. 
        This will take care of opening and closing the connection to the database.

        @datasource A string or structure representing the datasource. The server must support a structure as a datasource
        @changeLog The fullpath to the changelog file. 
        @funcToRun a function which takes a liquibase argument. Used to dynamically run liquibase commands. 
     */
    public  void function runLiquibase(required any datasource, required any changeLog, required any funcToRun) {
        try {
            var connection = getDataSourceConnection(arguments.datasource);
            var liquibase = getLiquibaseObj(arguments.changeLog,connection);
            funcToRun(liquibase);

        }catch(any e) {
            rethrow;
        } finally {
            if(!isNull(connection)) {
                try {
                    connection.close();
                } catch(any e) {
                    //We can catch and ignore closing because 
                }
            }
        }
    }

    public void function update(required string changeLog, any dataSource = '', string context ='' ) {

        runLiquibase(arguments.dataSource, arguments.changeLog, function(liquibase) {
                liquibase.update(context);
        });
    }

    public string function updateSql( required string changeLog, any datasource = '') {
        return "";
    }

    public any function getLiquibaseObj(required string changeLog, required any connection) {
        return getLiquibaseCore(arguments.changeLog,arguments.connection );
    }

    private any function getLiquibaseCore(required string changeLog, required any datasource) {
        return createObject('java','liquibase.Liquibase').init(arguments.changeLog,getResourceAccessor(),arguments.dataSource);
    }

    private any function getServerFactory() {
        if(!structKeyExists(variables,'serverFactory')) {
            variables.serverFactory = new serverFactory();
        }
        return variables.serverFactory;
    }

    private any function getDataSourceConnection(required any ds) {
        return getJdbxConnection(getServerFactory().getServer().getConnection(getPageContext(), arguments.ds));
    }

    private any function getResourceAccessor() {
        return createObject('java','liquibase.resource.FileSystemResourceAccessor').init();
    }

    private any function getJdbxConnection(required any con) {
        return createObject('java','liquibase.database.jvm.JdbcConnection').init(arguments.con);
    }
}
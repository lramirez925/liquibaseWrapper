component {

    public void function update(required string changeLog, any datasource = '', string context ='' ) {
        var liquibase = getLiquibaseObj(arguments.changeLog,arguments.dataSource);
        liquibase.update(arguments.context);
    }

    public string function updateSql( required string changeLog, any datasource = '') {
        return "";
    }


    public any function getLiquibaseObj(required string changeLog, required any dataSource) {
        return getLiquibaseCore(arguments.changeLog,getDataSourceConnection(arguments.datasource) );
    }

    private any function getLiquibaseCore(required string changeLog, required any datasource) {
        return createObject('java','liquibase.Liquibase').init(arguments.changeLog,getResourceAccessor(),arguments.dataSource);
    }

    private any function getDataSourceConnection(required any ds) {
        //Not a fan of reaching out of scope here. Tho this private functions and ones those that are used here will probably move to a seperate server function once I start multi server testing. 
        var pageContext = getPageContext();
        var dataSource = {};

        if(IsStruct(arguments.ds)) {
           //Only works with lucee
            
            if(structKeyExists(server,'lucee')) {
                var appListenerUtil = createObject('java','lucee.runtime.listener.AppListenerUtil');
                var caster = createObject('java','lucee.runtime.op.Caster');
                dataSource=appListenerUtil.toDataSource("__temp__", caster.toStruct(arguments.ds));
            } else {
                throw(type='InvalidServer', message='This server does not support datasource as a struct');
            }
 

        } else {
            dataSource = pageContext.getDataSource(arguments.ds);
           
        }

        return getJdbxConnection(pageContext.getConfig().getDatasourceConnectionPool().getDatasourceConnection(dataSource, dataSource.getUserName(),  dataSource.getPassword()).getConnection());
    }

    private any function getResourceAccessor() {
        return createObject('java','liquibase.resource.FileSystemResourceAccessor');
    }

    private any function getJdbxConnection(required any con) {
        return createObject('java','liquibase.database.jvm.JdbcConnection').init(arguments.con);
    }


}
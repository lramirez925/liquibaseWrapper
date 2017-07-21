component {
    public void function update( any datasource){
        writedump(getLiquibaseCore());
        abort;
    }

    public string function updateSql( any datasource ) {
        return "";
    }

    public any function getLiquibaseCore() {
    
        return new lib.liquibase-core-3.5.3.liquibase();
    }

    private any function getDS(required any ds) {
        if(IsStruct(arguments.ds)) {
            ds = getDataSourceNameFromStruct(arguments.ds);
        }

        return ds;
    }

    private any function getDataSourceNameFromStruct(required struct ds) {
         
    }
}
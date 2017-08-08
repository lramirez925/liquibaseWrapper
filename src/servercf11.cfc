component {
    public any function getConnection(required any pageContext, required any ds) {
        var dataSource = {};
        if(IsStruct(arguments.ds)) {
            throw(type='InvalidServer',message='This server does not support datasource as a structure');
        } else {
            dataSource = CreateObject("java", "coldfusion.server.ServiceFactory").getDataSourceService().getDataSource(arguments.ds);
        }
        return dataSource.getConnection();
    }
}
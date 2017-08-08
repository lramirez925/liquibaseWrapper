component {
    public any function getConnection(required any pageContext, required any ds) {
        
        if(IsStruct(arguments.ds)) {
            var appListenerUtil = createObject('java','lucee.runtime.listener.AppListenerUtil');
            var caster = createObject('java','lucee.runtime.op.Caster');
            dataSource=appListenerUtil.toDataSource(arguments.pageContext.getConfig(),"__temp__", caster.toStruct(arguments.ds),arguments.pageContext.getConfig().getLog('application'));
        } else {
            dataSource = pageContext.getDataSource(arguments.ds);
        }
        
        return arguments.pageContext.getConfig().getDatasourceConnectionPool().getDatasourceConnection(arguments.pageContext.getConfig(), dataSource, dataSource.getUserName(),  dataSource.getPassword()).getConnection();
    }
}
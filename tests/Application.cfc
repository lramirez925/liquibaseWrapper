component {

    this.name = "ColdBoxTestingSuite" & hash( CreateUUID());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
    this.javaSettings = {LoadPaths = ['../lib/liquibase-core-3.5.3'], loadCFMLClassPath = false, reloadOnChange= true, watchInterval = 100, watchExtensions = "jar,class"};

    //This should only be ran once for tests so generate a random name for the db file. 
    this.dbFileName = CreateUUID();

    //Currently we only do cf and lucee so decide between them here to use the embedded db. 
    
    if(structKeyExists(server,'lucee')) {
        this.datasources[ 'test' ] = {
            class: 'org.h2.Driver',
            bundleName: 'org.h2',
            bundleVersion: '1.3.172',
            connectionString: 'jdbc:h2:#expandPath( '/tests/db/#this.dbFileName#' )#;MODE=MySQL'
	    };
    } else {
        this.dbFileUrl =  createDerbyDb(this.dbFileName);
        this.datasources[ 'test' ] = {
            driver="Apache Derby Embedded",
            database= this.dbFileUrl
	    };
    }



    testsPath = getDirectoryFromPath( getCurrentTemplatePath() );
    this.mappings[ "/tests" ] = testsPath;
    rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
    this.mappings[ "/root" ] = rootPath;
    this.mappings[ '/src' ] = "#rootPath#/src";
    this.mappings[ '/lib' ] = "#rootPath#/lib";
    this.mappings[ "/testingModuleRoot" ] = listDeleteAt( rootPath, listLen( rootPath, '\/' ), "\/" );
    this.mappings[ "/app" ] = testsPath & "resources/app";
    this.mappings[ "/coldbox" ] = testsPath & "resources/app/coldbox";
    this.mappings[ "/testbox" ] = rootPath & "/testbox";
    this.mappings[ "/changeLogs" ] = rootPath & "resources/liquibase";
    this.mappings["/modules"] =  "#rootPath#/modules";

    public any function onApplicationStart() {
        application.dbFileName = this.dbFileName;
    }


    private string function createDerbyDb(required string dbName) {
        //Path the the database

        var dbLocation = replace(getDirectoryFromPath( getCurrentTemplatePath() ),"\","/","all") & "db/#dbName#";
        //Create a derby database if it does not already exist
        if (!fileExists("#dbLocation#/README_DO_NOT_TOUCH_FILES.txt")) {
            //Get the apached derby JDBC class
            var Class = createObject("java","java.lang.Class");
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            // Use the DriverManager to connect
            DriverManager = createObject("java", "java.sql.DriverManager");
            //Connect and pass the create=true parameter
            con = DriverManager.getConnection("jdbc:derby:#dbLocation#;create=true;");
            con.close();
        } else {
            writedump('hhhh');abort;
        }
        return dbLocation;
    }
}

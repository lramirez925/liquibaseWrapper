component {

    this.name = "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
    this.javaSettings = {LoadPaths = ['../lib/liquibase-core-3.5.3'], loadCFMLClassPath = false, reloadOnChange= true, watchInterval = 100, watchExtensions = "jar,class"};

    this.datasources[ 'test' ] = {
		class: 'org.h2.Driver',
		bundleName: 'org.h2',
		bundleVersion: '1.3.172',
		connectionString: 'jdbc:h2:#expandPath( '/tests/db/test' )#;MODE=MySQL'
	};

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



}

<cfscript>

    ds = {
        class: 'org.gjt.mm.mysql.Driver',
        connectionString: 'jdbc:mysql://localhost:3306/bradwood?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true',
        username: 'user',
        password: 'lr1234'
    };

    a = new liquibase();
    a.update(ds);
    writedump(a);

</cfscript>
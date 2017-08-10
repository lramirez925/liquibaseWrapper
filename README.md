# liquibaseWrapper

[![Master Branch Build Status](https://img.shields.io/travis/lramirez925/liquibaseWrapper/master.svg?style=flat-square&label=master)](https://travis-ci.org/lramirez925/liquibaseWrapper)

## Wrapper for the liquibase jar

Fast use example
Map the folder you will be installing the packae to. In our example that maping will be called modules. 

```
var liquibase = new modules.src.liquibase();
liquibase.update(expandPath('PathToChangeLog'),'context');
```
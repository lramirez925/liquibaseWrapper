component {
    variables.SUPPORTEDSERVERS = {
        LUCEE4:'Lucee4',
        LUCEE5:'Lucee5',
        CF11:'AdobeCF11',
        CF2016:'AdobeCF2016'
    };

    public any function getServer() {
        var serverIdentifier =calculateServerIdentifier();
        switch(serverIdentifier) {
            case "Lucee4":
                return new serverLucee4();
            break;
            case "Lucee5":
                return new serverLucee5();
            break;
            case "AdobeCF11":
                return new servercf11();
            break;
            case "AdobeCF2016":
                return new servercf11();
            break;
            default:
        }
    }

    private any function calculateServerIdentifier() {
        if(structKeyExists(server,'lucee')) {
            //We know it is lucee so simply check the version. 
            if(structKeyExists(server.lucee,'version')) {
                var versionAr = listToArray(server.lucee.version,'.');
                if(versionAr[1]== '5') {
                    return variables.SUPPORTEDSERVERS.LUCEE5;
                } else if(versionAr[1] == '4') {
                    return variables.SUPPORTEDSERVERS.LUCEE4;
                }
            }
        }
        if(structKeyExists(server,'coldfusion')) {
             if(structKeyExists(server.coldfusion,'productversion')) {
                var versionAr = listToArray(server.coldfusion.productversion,',');

                if(versionAr[1]== '11') {
                    return variables.SUPPORTEDSERVERS.CF11;
                } else if(versionAr[1] == '2016') {
                    return variables.SUPPORTEDSERVERS.CF2016;
                }
             }
        }

        throw(type='serverFactory',message='An unsupported server type was detected i the serverFactory.cfc. ');
    }
}
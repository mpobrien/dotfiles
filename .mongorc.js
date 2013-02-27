/* 
 *
 * Mongo Hacker
 * MongoDB Shell Enhancements for Hackers 
 *
 * Tyler J. Brock - 2012
 *
 * http://tylerbrock.github.com/mongo-hacker
 *
 */

__ansi = {
    csi: String.fromCharCode(0x1B) + '[',
    reset: '0',
    text_prop: 'm',
    foreground: '3',
    bright: '1',
    underline: '4',

    colors: {
        red: '1',
        green: '2',
        yellow: '3',
        blue: '4',
        magenta: '5',
        cyan: '6'  
    }
}

if (_isWindows()) {
  print("\nSorry! MongoDB Shell Enhancements for Hackers isn't compatible with Windows.\n");
}

function getRandomInt (min, max) {
  return Math.floor(Math.random() * (max - min) + min);
}


if(typeof db != 'undefined'){
    var ver = db.version().split(".");
    if ( ver[0] <= parseInt("2") && ver[1] < parseInt("2") ) {
      print(colorize("\nSorry! Mongo Shell version 2.2.x and above is required! Please upgrade.\n", "red", true));
    } 
}

setVerboseShell(true);
setIndexParanoia(true);
setAutoMulti(true);

__indent = "  "

function setIndexParanoia( value ) { 
    if( value == undefined ) value = true; 
    _indexParanoia = value; 
}

function setAutoMulti( value ) { 
    if( value == undefined ) value = true; 
    _autoMulti = value; 
}

function controlCode( parameters ) {
    if ( parameters == undefined ) {
    	parameters = "";
    }
    else if (typeof(parameters) == 'object' && (parameters instanceof Array)) {
        parameters = parameters.join(';');
    }

    return __ansi.csi + String(parameters) + String(__ansi.text_prop);
}

function applyColorCode( string, properties ) {
    return controlCode(properties) + String(string) + controlCode();
}

function colorize( string, color, bright, underline ) {
    var params = [];
    var code = __ansi.foreground + __ansi.colors[color];

    params.push(code);

    if ( bright == true ) params.push(__ansi.bright);
    if ( underline == true ) params.push(__ansi.underline);

    return applyColorCode( string, params );
}

ObjectId.prototype.toString = function() {
    return this.str;
}

ObjectId.prototype.tojson = function(indent, nolint) {
    return tojson(this);
}

Date.prototype.tojson = function() {

    var UTC = Date.printAsUTC ? 'UTC' : '';

    var year = this['get'+UTC+'FullYear']().zeroPad(4);
    var month = (this['get'+UTC+'Month']() + 1).zeroPad(2);
    var date = this['get'+UTC+'Date']().zeroPad(2);
    var hour = this['get'+UTC+'Hours']().zeroPad(2);
    var minute = this['get'+UTC+'Minutes']().zeroPad(2);
    var sec = this['get'+UTC+'Seconds']().zeroPad(2)

    if (this['get'+UTC+'Milliseconds']())
        sec += '.' + this['get'+UTC+'Milliseconds']().zeroPad(3)

    var ofs = 'Z';
    if (!Date.printAsUTC) {
        var ofsmin = this.getTimezoneOffset();
        if (ofsmin != 0){
            ofs = ofsmin > 0 ? '-' : '+'; // This is correct
            ofs += (ofsmin/60).zeroPad(2)
            ofs += (ofsmin%60).zeroPad(2)
        }
    }

    var date =  colorize('"' + year + month + date + 'T' + hour +':' + minute + ':' + sec + ofs + '"', "cyan");
    return 'ISODate(' + date + ')';
}

Array.tojson = function( a , indent , nolint ){
    var lineEnding = nolint ? " " : "\n";

    if (!indent)
        indent = "";

    if ( nolint )
        indent = "";

    if (a.length == 0) {
        return "[ ]";
    }

    var s = "[" + lineEnding;
    indent += __indent;
    for ( var i=0; i<a.length; i++){
        s += indent + tojson( a[i], indent , nolint );
        if ( i < a.length - 1 ){
            s += "," + lineEnding;
        }
    }
    if ( a.length == 0 ) {
        s += indent;
    }

    indent = indent.substring(__indent.length);
    s += lineEnding+indent+"]";
    return s;
}

tojson = function( x, indent , nolint ) {
    if ( x === null )
        return colorize("null", "red", true);
    
    if ( x === undefined )
        return colorize("undefined", "magenta", true);

    if ( x.isObjectId ) {
        return 'ObjectId(' + colorize('"' + x.str + '"', "green", false, true) + ')';
    }
    
    if (!indent) 
        indent = "";

    switch ( typeof x ) {
    case "string": {
        var s = "\"";
        for ( var i=0; i<x.length; i++ ){
            switch (x[i]){
                case '"': s += '\\"'; break;
                case '\\': s += '\\\\'; break;
                case '\b': s += '\\b'; break;
                case '\f': s += '\\f'; break;
                case '\n': s += '\\n'; break;
                case '\r': s += '\\r'; break;
                case '\t': s += '\\t'; break;

                default: {
                    var code = x.charCodeAt(i);
                    if (code < 0x20){
                        s += (code < 0x10 ? '\\u000' : '\\u00') + code.toString(16);
                    } else {
                        s += x[i];
                    }
                }
            }
        }
        s += "\""
        return colorize(s, "green", true);
    }
    case "number":
        return colorize(x, "red") 
    case "boolean":
        return colorize("" + x, "blue");
    case "object": {
        var s = tojsonObject( x, indent , nolint );
        if ( ( nolint == null || nolint == true ) && s.length < 80 && ( indent == null || indent.length == 0 ) ){
            s = s.replace( /[\s\r\n ]+/gm , " " );
        }
        return s;
    }
    case "function":
        return colorize(x.toString(), "magenta")
    default:
        throw "tojson can't handle type " + ( typeof x );
    }
    
}

tojsonObject = function( x, indent , nolint ) {
    var lineEnding = nolint ? " " : "\n";
    var tabSpace = nolint ? "" : __indent;
    
    assert.eq( ( typeof x ) , "object" , "tojsonObject needs object, not [" + ( typeof x ) + "]" );

    if (!indent) 
        indent = "";
    
    if ( typeof( x.tojson ) == "function" && x.tojson != tojson ) {
        return x.tojson(indent,nolint);
    }
    
    if ( x.constructor && typeof( x.constructor.tojson ) == "function" && x.constructor.tojson != tojson ) {
        return x.constructor.tojson( x, indent , nolint );
    }

    if ( x.toString() == "[object MaxKey]" )
        return "{ $maxKey : 1 }";
    if ( x.toString() == "[object MinKey]" )
        return "{ $minKey : 1 }";
    
    var s = "{" + lineEnding;

    // push one level of indent
    indent += tabSpace;
    
    var total = 0;
    for ( var k in x ) total++;
    if ( total == 0 ) {
        s += indent + lineEnding;
    }

    var keys = x;
    if ( typeof( x._simpleKeys ) == "function" )
        keys = x._simpleKeys();
    var num = 1;
    for ( var k in keys ){
        
        var val = x[k];
        if ( val == DB.prototype || val == DBCollection.prototype )
            continue;

        s += indent + colorize("\"" + k + "\"", "yellow") + ": " + tojson( val, indent , nolint );
        if (num != total) {
            s += ",";
            num++;
        }
        s += lineEnding;
    }

    // pop one level of indent
    indent = indent.substring(__indent.length);
    return s + indent + "}";
}

// Hardcode multi update -- now you only need to remember upsert
DBCollection.prototype.update = function( query , obj , upsert, multi ) {
    assert( query , "need a query" );
    assert( obj , "need an object" );

    var firstKey = null;
    for (var k in obj) { firstKey = k; break; }

    if (firstKey != null && firstKey[0] == '$') {
        // for mods we only validate partially, for example keys may have dots
        this._validateObject( obj );
    } else {
        // we're basically inserting a brand new object, do full validation
        this._validateForStorage( obj );
    }

    // can pass options via object for improved readability    
    if ( typeof(upsert) === 'object' ) {
        assert( multi === undefined, "Fourth argument must be empty when specifying upsert and multi with an object." );

        opts = upsert;
        multi = opts.multi;
        upsert = opts.upsert;
    }

    this._db._initExtraInfo();
    this._mongo.update( this._fullName , query , obj , upsert ? true : false , _autoMulti ? true : multi );
    this._db._getExtraInfo("Updated");
}

// Override group because map/reduce style is deprecated
DBCollection.prototype.agg_group = function( name, group_field, operation, op_value, filter ) {
    var ops = [];
    var group_op = { $group: { _id: '$' + group_field } };

    if (filter != undefined) {
        ops.push({ '$match': filter })
    }
  
    group_op['$group'][name] = { };
    group_op['$group'][name]['$' + operation] = op_value
    ops.push(group_op);

    return this.aggregate(ops);
}

// Function that groups and counts by group after applying filter
DBCollection.prototype.gcount = function( group_field, filter ) {
    return this.agg_group('count', group_field, 'sum', 1, filter);
}

// Function that groups and sums sum_field after applying filter
DBCollection.prototype.gsum = function( group_field, sum_field, filter ) {
    return this.agg_group('sum', group_field, 'sum', '$' + sum_field, filter);
}

// Function that groups and averages avg_feld after applying filter
DBCollection.prototype.gavg = function( group_field, avg_field, filter ) {
    return this.agg_group('avg', group_field, 'avg', '$' + avg_field, filter);
}

// Improve the default prompt with hostname, process type, and version
prompt = function() {
    var serverstatus = db.serverStatus();
    var host = serverstatus.host.split('.')[0];
    var process = serverstatus.process;
    var version = db.serverBuildInfo().version;
    return host + '(' + process + '-' + version + ') ' + db + '> ';
}

DBQuery.prototype.shellPrint = function(){
    try {
        var start = new Date().getTime();
        var n = 0;
        while ( this.hasNext() && n < DBQuery.shellBatchSize ){
            var s = this._prettyShell ? tojson( this.next() ) : tojson( this.next() , "" , true );
            print( s );
            n++;
        }

        var output = []

        if (typeof _verboseShell !== 'undefined' && _verboseShell) {
            var time = new Date().getTime() - start;
            var slowms = this._db.setProfilingLevel().slowms;
            var fetched = "Fetched " + n + " record(s) in ";
            if (time > slowms) {
                fetched += colorize(time + "ms", "red", true);
            } else {
                fetched += colorize(time + "ms", "green", true);
            }
            output.push(fetched);
        }
        if (typeof _indexParanoia !== 'undefined' && _indexParanoia) {
            var explain = this.clone();
            explain._ensureSpecial();
            explain._query.$explain = true;
            explain._limit = Math.abs(n._limit) * -1;
            var result = explain.next();
            var type = result.cursor;
            var index_use = "Index["
            if (type == "BasicCursor") {
                index_use += colorize( "none", "red", true);
            } else {
                index_use += colorize( result.cursor.substring(12), "green", true );
            }
            index_use += "]";
            output.push(index_use);
        }
        if ( this.hasNext() ) {
            ___it___  = this;
            output.push("More[" + colorize("true", "green", true) + "]");
        }
        else {
            ___it___  = null;
            output.push("More[" + colorize("false", "red", true) + "]");
        }
        print(output.join(" -- "));
   }
    catch ( e ){
        print( e );
    }

}
ShardingTest.prototype.prettyPrint = function(){
    print("MONGOS instances");
    for(var i=0;i<this._mongoses.length;i++){
        print("\tmongos",this['s' + i].port, this['s' + i].getDB("admin").version())
    }

    print("\n")

    print("config servers");
    for(var i=0;i<this._configServers.length;i++){
        print("\tconfig",this._configServers[i].port, this._configServers[i].getDB("admin").version())
    }

    print("\n")

    print("Standalone Shards");
    for(var i=0;i<this._connections.length;i++){
        if(!this['d' + 0]) continue
        print("\tmongod",this._connections[i].port, this._connections[i].getDB("admin").version())
    }
    print("\n")



    print("ReplSet Shards");
    for(var i=0;i<this._rsObjects.length;i++){
        print("\tShard ", i);
        if(this._rsObjects[i]==null) continue
        var rs = this._rsObjects[i]

        var nodesById = {}
        for(var j=0;j<rs.nodes.length;j++){
            nodesById[rs.nodes[j].nodeId] = rs.nodes[j]
        }

        var rsStatus = rs.status()
        for(var j=0;j<rsStatus.members.length;j++){
            var member = rsStatus.members[j]
            var node = nodesById[member._id]
            print("\t\t",member.name, node.getDB("admin").version(), member.stateStr)
        }
        print("\n");
    }
}

ReplSetTest.prototype.prettyPrint = function(){
    var nodesById = {}
    for(var j=0;j<this.nodes.length;j++){
        nodesById[this.nodes[j].nodeId] = this.nodes[j]
    }
    
    var rsStatus = this.status()
    for(var j=0;j<rsStatus.members.length;j++){
        var member = rsStatus.members[j]
        var node = nodesById[member._id]
        print("\t\t",member.name, node.getDB("admin").version(), member.stateStr)
    }
}
ShardingTest.prototype.shellPrint = ShardingTest.prototype.prettyPrint
ReplSetTest.prototype.shellPrint = ReplSetTest.prototype.prettyPrint

//
// Utility functions for multi-version replica sets
// 

ReplSetTest.prototype.upgradeSet = function( binVersion, options ){
    
    options = options || {}
    if( options.primaryStepdown == undefined ) options.primaryStepdown = true
    
    var nodes = this.nodes
    var primary = this.getPrimary()
    
    // Upgrade secondaries first
    var nodesToUpgrade = this.getSecondaries()
    
    // Then upgrade primaries
    nodesToUpgrade.push( primary )
    
    // We can upgrade with no primary downtime if we have enough nodes
    var noDowntimePossible = nodes.length > 2
    
    for( var i = 0; i < nodesToUpgrade.length; i++ ){
        
        var node = nodesToUpgrade[ i ]
        
        if( node == primary && options.primaryStepdown ){
            
            node = this.stepdown( node )
            primary = this.getPrimary()
        }
        
        var prevPrimaryId = this.getNodeId( primary )
        
        this.upgradeNode( node, binVersion, true )
        
        if( noDowntimePossible )
            assert.eq( this.getNodeId( primary ), prevPrimaryId )
    }
}

ReplSetTest.prototype.upgradeNode = function( node, binVersion, waitForState ){
    
    var node = this.restart( node, { binVersion : binVersion } )
    
    // By default, wait for primary or secondary state
    if( waitForState == undefined ) waitForState = true
    if( waitForState == true ) waitForState = [ ReplSetTest.State.PRIMARY, 
                                                ReplSetTest.State.SECONDARY,
                                                ReplSetTest.State.ARBITER ]
    if( waitForState )
        this.waitForState( node, waitForState )
    
    return node
}

ReplSetTest.prototype.stepdown = function( nodeId ){
        
    nodeId = this.getNodeId( nodeId )
    
    assert.eq( this.getNodeId( this.getPrimary() ), nodeId )    
    
    var node = this.nodes[ nodeId ]
    
    try {
        node.getDB("admin").runCommand({ replSetStepDown: 50, force : true })
        assert( false )
    }
    catch( e ){
        printjson( e );
    }
    
    return this.reconnect( node )
}

ReplSetTest.prototype.reconnect = function( node ){
    
    var nodeId = this.getNodeId( node )
    
    this.nodes[ nodeId ] = new Mongo( node.host )
    
    // TODO
    var except = {}
    
    for( var i in node ){
        if( typeof( node[i] ) == "function" ) continue
        this.nodes[ nodeId ][ i ] = node[ i ]
    }
    
    return this.nodes[ nodeId ]
}

ReplSetTest.prototype.authAll = function(u,p){
    for(var i=0;i<this.nodes.length;i++){
        this.nodes[i].getDB("admin").auth(u, p);
    }
}

/**
 * Helpers for verifying versions of started MongoDB processes
 */

Mongo.prototype.getBinVersion = function() {
    var result = this.getDB( "admin" ).runCommand({ serverStatus : 1 })
    return result.version
}

// Checks that our mongodb process is of a certain version
assert.binVersion = function(mongo, version) {
    var currVersion = mongo.getBinVersion();
    assert(MongoRunner.areBinVersionsTheSame(MongoRunner.getBinVersionFor(currVersion),
                                             MongoRunner.getBinVersionFor(version)),
           "version " + version + " (" + MongoRunner.getBinVersionFor(version) + ")" + 
           " is not the same as " + currVersion);
}


// Compares an array of desired versions and an array of found versions,
// looking for versions not found
assert.allBinVersions = function(versionsWanted, versionsFound) {
    
    for (var i = 0; i < versionsWanted.length; i++) {

        var found = false;
        for (var j = 0; j < versionsFound.length; j++) {
            if (MongoRunner.areBinVersionsTheSame(versionsWanted[i],
                                                  versionsFound[j]))
            {
                found = true;
                break;
            }
        }

        assert(found, "could not find version " + 
                      version + " (" + MongoRunner.getBinVersionFor(version) + ")" +
                      " in " + versionsFound);
    }
}

//
// MultiVersion utility functions for clusters
//

ShardingTest.prototype.upgradeCluster = function( binVersion, options ){
    
    options = options || {}
    if( options.upgradeShards == undefined ) options.upgradeShards = true
    if( options.upgradeConfigs == undefined ) options.upgradeConfigs = true
    if( options.upgradeMongos == undefined ) options.upgradeMongos = true
    
    if( options.upgradeMongos ){
        
        // Upgrade all mongos hosts if specified
        
        var numMongoses = this._mongos.length
        
        for( var i = 0; i < numMongoses; i++ ){
            
            var mongos = this._mongos[i]
            
            MongoRunner.stopMongos( mongos )
            
            mongos = MongoRunner.runMongos({ restart : mongos,
                                             binVersion : binVersion,
                                             appendOptions : true })
            
            this[ "s" + i ] = this._mongos[i] = mongos
            if( i == 0 ) this.s = mongos
        }
        
        this.config = this.s.getDB( "config" )
        this.admin = this.s.getDB( "admin" )
    }
    
    var upgradedSingleShards = []
    
    if( options.upgradeShards ){
        
        var numShards = this._connections.length
        
        // Upgrade shards
        for( var i = 0; i < numShards; i++ ){
            
            if( this._rs && this._rs[i] ){
                
                // Upgrade replica set
                var rst = this._rs[i].test
                
                rst.upgradeSet( binVersion )
            }
            else {
                
                // Upgrade shard
                var shard = this._connections[i]
                
                MongoRunner.stopMongod( shard )
                
                shard = MongoRunner.runMongod({ restart : shard, 
                                                binVersion : binVersion,
                                                appendOptions : true })
                    
                upgradedSingleShards[ shard.host ] = shard
                
                this[ "shard" + i ] = this[ "d" + i ] = this._connections[i] = shard
            }        
        }
    }
    
    if( options.upgradeConfigs ){
        
        // Upgrade config servers if they aren't already upgraded shards 
        var numConfigs = this._configServers.length
        
        for( var i = 0; i < numConfigs; i++ ){
            
            var configSvr = this._configServers[i]
            
            if( configSvr.host in upgradedSingleShards ){
                
                configSvr = upgradedSingleShards[ configSvr.host ]
            }
            else{
                
                MongoRunner.stopMongod( configSvr )
                
                configSvr = MongoRunner.runMongod({ restart : configSvr, 
                                                    binVersion : binVersion,
                                                    appendOptions : true })
            }
            
            this[ "config" + i ] = this[ "c" + i ] = this._configServers[i] = configSvr
        }
    }
    
}

ShardingTest.prototype.restartMongoses = function() {
    
    var numMongoses = this._mongos.length;
    
    for (var i = 0; i < numMongoses; i++) {
        
        var mongos = this._mongos[i];
        
        MongoRunner.stopMongos(mongos);
        mongos = MongoRunner.runMongos({ restart : mongos })
        
        this[ "s" + i ] = this._mongos[i] = mongos;
        if( i == 0 ) this.s = mongos;
    }
    
    this.config = this.s.getDB( "config" )
    this.admin = this.s.getDB( "admin" )
}

ShardingTest.prototype.getMongosAtVersion = function(binVersion) {
    var mongoses = this._mongos;
    for (var i = 0; i < mongoses.length; i++) {
        try {
            var version = mongoses[i].getDB("admin").runCommand("serverStatus").version;
            if (version.indexOf(binVersion) == 0) {
                return mongoses[i];
            }
        }
        catch (e) {
            printjson(e);
            print(mongoses[i]);
        }
    }
}

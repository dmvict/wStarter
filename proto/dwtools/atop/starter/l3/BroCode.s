( function _BroCode_s_() {

'use strict';

let _ = _global_.wTools;

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _global = _global_;
  let _starter_ = _global_._starter_;
  let _ = _starter_;
  let path = _starter_.path;
  let sourcesMap = _starter_.sourcesMap;

  if( _global._starter_ && _global._starter_._inited )
  return;

  //

  let FilesCache = Object.create( null );
  function fileReadAct( o )
  {
    let self = this;
    let Reqeust, request, total, result;

    _.assertRoutineOptions( fileReadAct, arguments );
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( o.filePath ), 'fileReadAct :', 'Expects {-o.filePath-}' );

    if( FilesCache[ o.filePath ] )
    return FilesCache[ o.filePath ];

    /* advanced */

    o.advanced = _.routineOptions( fileReadAct, o.advanced, fileReadAct.advanced );
    o.advanced.method = o.advanced.method.toUpperCase();

    /* http request */

    if( typeof XMLHttpRequest !== 'undefined' )
    Reqeust = XMLHttpRequest;
    else if( typeof ActiveXObject !== 'undefined' )
    Reqeust = new ActiveXObject( 'Microsoft.XMLHTTP' );
    else
    {
      throw _.err( 'not implemented' );
    }

    /* set */

    request = o.request = new Reqeust();

    if( !o.sync )
    {
      if( o.encoding === 'buffer.bytes' )
      request.responseType = 'arraybuffer';
      else if( o.encoding === 'json' )
      request.responseType = 'json';
    }

    request.addEventListener( 'progress', handleProgress );
    request.addEventListener( 'load', handleEnd );
    request.addEventListener( 'error', handleErrorEvent );
    request.addEventListener( 'timeout', handleErrorEvent );
    request.addEventListener( 'readystatechange', handleState );
    request.open( o.advanced.method, o.filePath, !o.sync, o.advanced.user, o.advanced.password );
    /*request.setRequestHeader( 'Content-type', 'application/octet-stream' );*/

    handleBegin();

    try
    {
      if( o.advanced && o.advanced.send !== null )
      request.send( o.advanced.send );
      else
      request.send();
    }
    catch( err )
    {
      handleError( err );
    }

    _.assert( o.sync );
    if( o.sync )
    return result;
    // else
    // return con;

    /* - */

    /* handler */

    function getData( response )
    {
      if( request.responseType === 'text' )
      return response.responseText || response.response;
      if( request.responseType === 'document' )
      return response.responseXML || response.response;
      return response.response;
    }

    /* begin */

    function handleBegin()
    {

      // debugger;
      // console.log( 'request.responseType', request.responseType );
      // if( !o.sync )
      // request.responseType = encoder.responseType;

    }

    /* end */

    function handleEnd( e )
    {

      if( o.ended )
      return;

      try
      {

        result = getData( request );
        o.ended = 1;

        if( !_.strBegins( o.filePath, '.resolve/' ) )
        FilesCache[ o.filePath ] = result;

        // con.take( result );
      }
      catch( err )
      {
        handleError( err );
      }

    }

    /* progress */

    function handleProgress( e )
    {
    }

    /* error */

    function handleError( err )
    {

      o.ended = 1;

      // con.error( err );
    }

    /* error event */

    function handleErrorEvent( e )
    {
      let err = _.err( err, '\nNetwork error' );
      return handleError( err );
    }

    /* state */

    function handleState( e )
    {

      if( o.ended )
      return;

      if( this.readyState === 2 )
      {

      }
      else if( this.readyState === 3 )
      {

        let data = getData( this );
        if( !data ) return;
        if( !total ) total = this.getResponseHeader( 'Content-Length' );
        total = Number( total ) || 1;
        if( isNaN( total ) ) return;
        handleProgress( data.length / total, o );

      }
      else if( this.readyState === 4 )
      {

        if( o.ended )
        return;

        if( this.status === 200 )
        {
          handleEnd( e );
        }
        else if( this.status === 0 )
        {
        }
        else
        {
          handleError( '#' + this.status );
        }

      }

    }

  }

  var defaults = fileReadAct.defaults = Object.create( null );
  defaults.sync = 1;
  defaults.filePath = null;
  defaults.encoding = 'utf8';

  var advanced = fileReadAct.advanced = Object.create( null );
  advanced.send = null;
  advanced.method = 'GET';
  advanced.user = null;
  advanced.password = null;

  //

  function fileRead( o )
  {
    if( _.strIs( o ) )
    o = { filePath : o };
    _.routineOptions( fileRead, o );
    return _.fileReadAct( o );
  }

  fileRead.defaults = Object.create( fileReadAct.defaults );

  //

  function socketWrite( o )
  {
    let socket = new WebSocket( o.filePath );
    socket.onopen = function( e )
    {
      socket.send( JSON.stringify( o.data ) );
      setTimeout( () => socket.close(), 1000 );
    };
  }
  socketWrite.defaults =
  {
    filePath : null,
    data : null,
  }

  //

  function _broSourceFile( sourceFile, op )
  {
  }

  //

  function _broLog( o )
  {
    let starter = this;

    let response = starter.socketWrite
    ({
      filePath : 'ws://127.0.0.1:5000/.log/',
      // filePath : 'ws://127.0.0.1:5000',
      data : o,
    });

    return;
  }

  _broLog.defaults =
  {
    methodName : null,
    args : null,
  }

  //

  function _broResolveRemote( filePath )
  {
    let starter = this;

    if( _.path.isGlob( filePath ) )
    {
      filePath = starter.fileRead
      ({
        filePath : '/.resolve/' + filePath,
        encoding : 'json',
      });
      filePath = JSON.parse( filePath );
      return filePath;
    }
    else if( _.path.isRelative( filePath ) )
    {
      filePath = starter.fileRead
      ({
        filePath : '/.resolve/' + filePath,
        encoding : 'json',
      });
      filePath = JSON.parse( filePath );
      return filePath;
    }

    return filePath;
  }

  //

  function _broResolve( parentSource, basePath, filePath )
  {
    let resolvedFilePath = this._pathResolve( parentSource, basePath, filePath );
    try
    {
      let read = this.fileRead
      ({
        filePath : resolvedFilePath,
        sync : 1,
      });
      return resolvedFilePath;
    }
    catch( err )
    {
      debugger;
      return null;
    }
  }

  //

  function _broInclude( parentSource, basePath, filePath )
  {
    let starter = this;
    let joinedFilePath = this._pathResolve( parentSource, basePath, filePath );
    let resolvedFilePath = starter._broResolveRemote( joinedFilePath );

    if( _.arrayIs( resolvedFilePath ) )
    {
      if( resolvedFilePath !== joinedFilePath && !resolvedFilePath.length )
      {
        throw _.err( `No source file found for "${joinedFilePath}"` );
      }
      let result = [];
      for( let f = 0 ; f < resolvedFilePath.length ; f++ )
      {
        if( starter.exclude )
        {
          if( starter.exclude.test( resolvedFilePath[ f ] ) )
          continue;
        }

        let r = starter._sourceInclude( parentSource, basePath, resolvedFilePath[ f ] );
        if( r !== undefined )
        _.arrayAppendArrays( result, r );
        else
        result.push( r );
      }
      return result;
    }

    try
    {
      if( typeof window === 'undefined' )
      {
        return this._importInWorker( parentSource, resolvedFilePath );
      }

      let read = starter.fileRead
      ({
        filePath : resolvedFilePath + '?running:0',
        sync : 1,
      });

      starter._includingSource = resolvedFilePath;

      let ext = _.path.ext( resolvedFilePath );
      if( ext === 'css' || ext === 'less' )
      {
        let link = document.createElement( 'link' );
        link.href = resolvedFilePath;
        link.rel = 'stylesheet'
        link.type = 'text/' + ext
        document.head.appendChild( link );
        end();
      }
      else
      {
        // read = '//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n' + read;
        read = read + '\n//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'
        read = read + '\n//# sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'

        let script = document.createElement( 'script' );
        script.type = 'text/javascript';
        let scriptCode = document.createTextNode( read );
        script.appendChild( scriptCode );
        document.head.appendChild( script );

        let childSource = starter._sourceForPathGet( resolvedFilePath );
        let result = starter._sourceIncludeAct( parentSource, childSource, resolvedFilePath );

        end();
        return result;
      }
    }
    catch( err )
    {
      end();
      throw err;
    }

    function end()
    {
      starter._includingSource = null;
    }


  }

  //

  function _importInWorker( parentSource, resolvedFilePath )
  {
    let starter = this;

    _.assert( typeof importScripts !== 'undefined' );

    starter._includingSource = resolvedFilePath;

    importScripts( resolvedFilePath + '?running:0' );

    let childSource = starter._sourceForPathGet( resolvedFilePath );
    let result = starter._sourceIncludeAct( parentSource, childSource, resolvedFilePath );

    starter._includingSource = null;

    return result;

  }

  //

  function _sourceCodeModule()
  {
    let result = Object.create( null );

    accesor( '_cache', chacheGet, chacheSet );

    this.exports = result;

    function chacheGet()
    {
      return _starter_.sourcesMap;
    }

    function chacheSet( src )
    {
      return _starter_.sourcesMap = src;
    }

    function accesor( fieldName, onGet, onSet )
    {
      Object.defineProperty( result, fieldName,
      {
        enumerable : true,
        configurable : true,
        get : onGet,
        set : onSet,
      });
    }

  }

  //

  function _broConsoleRedirect( console )
  {
    let starter = this;
    let MethodsNames =
    [
      'log', 'debug', 'error', 'warn', 'info',
      'assert', 'clear', 'count', 'dir', 'dirxml',
      'group', 'groupCollapsed', 'groupEnd',
      'table', 'time', 'timeEnd', 'timeStamp', 'trace'
    ];

    for( let n = 0 ; n < MethodsNames.length ; n++ )
    {
      let name = MethodsNames[ n ];
      _.assert( _.routineIs( console[ name ] ) );
      console[ name ] = starter._broConsoleMethodRedirect( console, name );
    }

  }

  //

  function _broConsoleMethodRedirect( console, methodName )
  {
    let starter = this;
    let original = console[ methodName ];
    _.assert( _.routineIs( original ) );

    let wrap =
    {
      [ methodName ] : function()
      {
        let args = [];
        for( let i = 0 ; i < arguments.length ; i++ )
        args[ i ] = _.toStr( arguments[ i ] );
        starter._broLog({ methodName, args });
        return original.apply( console, arguments );
      }
    }

    return wrap[ methodName ];
  }

  //

  function _broSetup()
  {
    let starter = this;
    starter._sourceMake( 'module', '/', _sourceCodeModule );

    if( starter.redirectingConsole === null || starter.redirectingConsole )
    starter._broConsoleRedirect( console );

  }

}

// --
// end
// --

function _End()
{

  let Extend =
  {

    fileReadAct,
    fileRead,
    socketWrite,

    _broSourceFile,
    _broLog,
    _broResolveRemote,
    _broResolve,
    _broInclude,
    _importInWorker,

    _broConsoleRedirect,
    _broConsoleMethodRedirect,

    _broSetup,
    _sourceCodeModule,

  }

  Object.assign( _starter_, Extend );

}

// --
// export
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();

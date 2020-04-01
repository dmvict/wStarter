( function _StarterMaker_s_() {

'use strict';

// debugger;
// console.log( typeof exports ); /* xxx qqq : write test routine for exports. ask how */
// debugger;

//

let _ = _global_.wTools;
let Parent = null
let Self = function wStarterMakerLight( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Maker';

// --
// relations
// --

let LibrarySplits =
{
  prefix : '',
  predefined : '',
  early : '',
  extract : '',
  proceduring : '',
  interpreter : '',
  starter : '',
  env : '',
  files : '',
  externalBefore : '',
  entry : '',
  externalAfter : '',
  postfix : '',
}

// --
// routines
// --

function instanceOptions( o )
{
  let self = this;

  for( let k in o )
  {
    if( o[ k ] === null && _.longHas( self.InstanceDefaults, k ) )
    o[ k ] = self[ k ];
  }

  return o;
}

// --
// file
// --

function sourceWrapSplits( o )
{
  let self = this;

  _.routineOptions( sourceWrapSplits, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'njs', 'browser' ], o.interpreter ) );

  let relativeFilePath = _.path.dot( _.path.relative( o.basePath, o.filePath ) );
  let relativeDirPath = _.path.dot( _.path.dir( relativeFilePath ) );
  let fileName = _.strVarNameFor( _.path.fullName( o.filePath ) );
  let fileNameNaked = fileName + '_naked';

  let prefix1 = `/* */  /* begin of file ${fileName} */ ( function ${fileName}() { `;
  let prefix2 = `function ${fileNameNaked}() { `;

  let postfix2 = `\n/* */    };`;

  let ware = '\n';

  if( o.interpreter === 'browser' )
  ware +=
`
/* */  if( typeof _starter_ === 'undefined' && importScripts ) /* qqq xxx : ? */
/* */  importScripts( '/.starter' );
/* */  let _filePath_ = _starter_._pathResolve( null, '/', '${relativeFilePath}' );
/* */  let _dirPath_ = _starter_._pathResolve( null, '/', '${relativeDirPath}' );
`
  else
  ware +=
`
/* */  let _filePath_ = _starter_._pathResolve( null, _libraryFilePath_, '${relativeFilePath}' );
/* */  let _dirPath_ = _starter_._pathResolve( null, _libraryFilePath_, '${relativeDirPath}' );
`

  ware +=
`
/* */  let __filename = _filePath_;
/* */  let __dirname = _dirPath_;
/* */  let module = _starter_._sourceMake( _filePath_, _dirPath_, ${fileNameNaked} );
/* */  let exports = module.exports;
/* */  let require = module.include;
/* */  let include = module.include;
`

  if( o.running )
  ware += `/* */  ${fileNameNaked}();`;

  let postfix1 =
`
/* */  /* end of file ${fileName} */ })();
`

  let result = Object.create( null );
  result.prefix1 = prefix1;
  result.prefix2 = prefix2;
  result.ware = ware;
  result.postfix2 = postfix2;
  result.postfix1 = postfix1;
  return result;
}

sourceWrapSplits.defaults =
{
  filePath : null,
  basePath : null,
  running : 0,
  interpreter : 'njs',
}

//

function sourceWrap( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.routineOptions( sourceWrap, arguments );
  self.instanceOptions( o );

  if( o.removingShellPrologue )
  o.fileData = self.sourceRemoveShellPrologue( o.fileData );

  let splits = self.sourceWrapSplits({ filePath : o.filePath, basePath : o.basePath });
  let result = splits.prefix1 + splits.prefix2 + o.fileData + splits.postfix2 + splits.ware + splits.postfix1;
  return result;
}

var defaults = sourceWrap.defaults = Object.create( sourceWrapSplits.defaults );
defaults.fileData = null;
defaults.removingShellPrologue = null;

//

function sourceWrapSimple( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.routineOptions( sourceWrapSimple, arguments );
  self.instanceOptions( o );

  if( o.removingShellPrologue )
  o.fileData = self.sourceRemoveShellPrologue( o.fileData );

  let fileName = _.strCamelize( _.path.fullName( o.filePath ) );

  let prefix = `( function ${fileName}() { // == begin of file ${fileName}\n`;

  let postfix =
`// == end of file ${fileName}
})();
`

  let result = prefix + o.fileData + postfix;

  return result;
}

sourceWrapSimple.defaults =
{
  filePath : null,
  fileData : null,
  removingShellPrologue : null,
}

//

/*
qqq : investigate and add test case for such case
  if( fileData.charCodeAt( 0 ) === 0xFEFF )
  fileData = fileData.slice(1);
*/

function sourceRemoveShellPrologue( fileData )
{
  let self = this;
  let splits = _.strSplitFast( fileData, /^\s*\#\![^\n]*\n/ );
  _.assert( arguments.length === 1 );
  if( splits.length > 1 )
  return '// ' + splits[ 1 ] + splits[ 2 ];
  else
  return fileData;
}

// --
// files
// --

function sourcesJoinSplits( o )
{
  let self = this;
  let r = _.mapExtend( null, self.LibrarySplits );
  Object.preventExtensions( r );

  o = _.routineOptions( sourcesJoinSplits, arguments );
  _.assert( _.longHas( [ 'njs', 'browser' ], o.interpreter ) );
  _.assert( _.boolLike( o.debug ) );
  _.assert( _.boolLike( o.proceduring ) );
  _.assert( _.boolLike( o.catchingUncaughtErrors ) );
  _.assert( _.boolLike( o.loggingApplication ) );

  if( o.entryPath )
  {
    _.assert( _.strIs( o.basePath ) );
    _.assert( _.strIs( o.entryPath ) || _.arrayIs( o.entryPath ) )
    o.entryPath = _.arrayAs( o.entryPath );
    o.entryPath = _.path.s.join( o.basePath, o.entryPath );
  }

  if( o.libraryName === null )
  o.libraryName = _.strVarNameFor( _.path.fullName( o.outPath ) );

  /* prefix */

  r.prefix =
`
/* */  /* begin of library ${o.libraryName} */ ( function _library_() {
`

  /* predefined */

  r.predefined =
`
/* */  /* begin of predefined */ ( function _predefined_() {

  ${_.routineParse( self.PredefinedCode.begin ).bodyUnwrapped};

/* */  _global_._starter_.debug = ${o.debug};
/* */  _global_._starter_.interpreter = '${o.interpreter}';
/* */  _global_._starter_.proceduring = ${o.proceduring};
/* */  _global_._starter_.catchingUncaughtErrors = ${o.catchingUncaughtErrors};
/* */  _global_._starter_.loggingApplication = ${o.loggingApplication};

/* */  _global_.Config.debug = ${o.debug};

  ${_.routineParse( self.PredefinedCode.end ).bodyUnwrapped};

/* */  /* end of predefined */ })();

`

  /* early */

  r.early =
`
/* */  /* begin of early */ ( function _early_() {

  ${_.routineParse( self.EarlyCode.begin ).bodyUnwrapped};
  ${_.routineParse( self.EarlyCode.end ).bodyUnwrapped};

/* */  /* end of early */ })();

  `

  /* extract */

  r.extract =
`
/* */  /* begin of extract */ ( function _extract_() {

  ${_.routineParse( self.ExtractCode.begin ).bodyUnwrapped};

  ${extract()}

  ${_.routineParse( self.ExtractCode.end ).bodyUnwrapped};

/* */  /* end of extract */ })();

`

  /* proceduring */

  if( o.proceduring )
  r.proceduring =
`
/* */  /* begin of proceduring */ ( function _proceduring_() {

  ${_.routineParse( self.ProceduringCode.begin ).bodyUnwrapped};
  ${_.routineParse( self.ProceduringCode.end ).bodyUnwrapped};

/* */  /* end of proceduring */ })();

`

  /* bro */

  if( o.interpreter === 'browser' )
  r.interpreter =
`
/* */  /* begin of bro */ ( function _bro_() {

  ${_.routineParse( self.BroCode.begin ).bodyUnwrapped};
  ${_.routineParse( self.BroCode.end ).bodyUnwrapped};

/* */  /* end of bro */ })();

`

  /* njs */

  if( o.interpreter === 'njs' )
  r.interpreter =
`
/* */  /* begin of njs */ ( function _njs_() {

  ${_.routineParse( self.NjsCode.begin ).bodyUnwrapped};
  ${_.routineParse( self.NjsCode.end ).bodyUnwrapped};

/* */  /* end of njs */ })();

`

  /* starter */

  r.starter =
`
/* */  /* begin of starter */ ( function _starter_() {

  ${_.routineParse( self.StarterCode.begin ).bodyUnwrapped};
  ${_.routineParse( self.StarterCode.end ).bodyUnwrapped};

/* */  /* end of starter */ })();

`

  /* env */

  r.env = ``;

  if( o.interpreter !== 'browser' )
  r.env +=
`
/* */  let _libraryFilePath_ = _starter_.path.canonizeTolerant( __filename );
/* */  let _libraryDirPath_ = _starter_.path.canonizeTolerant( __dirname );

`

  if( o.interpreter === 'browser' )
  r.env +=
`
/* */  if( !_global_._libraryFilePath_ )
/* */  _global_._libraryFilePath_ = '/';
/* */  if( !_global_._libraryDirPath_ )
/* */  _global_._libraryDirPath_ = '/';
`

  /* code */

  /* ... code goes here ... */

  /* external */

  if( o.externalBeforePath || o.externalAfterPath )
  _.assert( _.strIs( o.outPath ), 'Expects out path' );

  r.externalBefore = '\n';
  if( o.externalBeforePath )
  o.externalBeforePath.forEach( ( externalPath ) =>
  {
    if( _.path.isAbsolute( externalPath ) )
    externalPath = _.path.dot( _.path.relative( _.path.dir( o.outPath ), externalPath ) );
    r.externalBefore += `/* */  _starter_._sourceInclude( null, _libraryDirPath_, '${externalPath}' );\n`;
  });

  r.externalAfter = '\n';
  if( o.externalAfterPath )
  o.externalAfterPath.forEach( ( externalPath ) =>
  {
    if( _.path.isAbsolute( externalPath ) )
    externalPath = _.path.dot( _.path.relative( _.path.dir( o.outPath ), externalPath ) );
    r.externalAfter += `/* */  _starter_._sourceInclude( null, _libraryDirPath_, '${externalPath}' );\n`;
  });

  /* entry */

  r.entry = '\n';
  if( o.entryPath )
  o.entryPath.forEach( ( entryPath ) =>
  {
    entryPath = _.path.relative( o.basePath, entryPath );
    r.entry += `/* */  module.exports = _starter_._sourceInclude( null, _libraryFilePath_, './${entryPath}' );\n`;
  });

  /* postfix */

  r.postfix =
`
/* */  /* end of library ${o.libraryName} */ })()
`

  /* */

  return r;

  /* */

  function extract()
  {

  return `
  ${rou( 'assert' )}
  ${rou( 'strIs' )}
  ${rou( 'strDefined' )}
  ${rou( '_strBeginOf' )}
  ${rou( '_strEndOf' )}
  ${rou( '_strRemovedBegin' )}
  ${rou( '_strRemovedEnd' )}
  ${rou( 'strBegins' )}
  ${rou( 'strEnds' )}
  ${rou( 'strRemoveBegin' )}
  ${rou( 'strRemoveEnd' )}
  ${rou( 'regexpIs' )}
  ${rou( 'longIs' )}
  ${rou( 'primitiveIs' )}
  ${rou( 'strBegins' )}
  ${rou( 'objectIs' )}
  ${rou( 'objectLike' )}
  ${rou( 'arrayLike' )}
  ${rou( 'mapLike' )}
  ${rou( 'strsLikeAll' )}
  ${rou( 'arrayIs' )}
  ${rou( 'numberIs' )}
  ${rou( 'setIs' )}
  ${rou( 'setLike' )}
  ${rou( 'hashMapIs' )}
  ${rou( 'hashMapLike' )}
  ${rou( 'argumentsArrayIs' )}
  ${rou( 'routineIs' )}
  ${rou( 'routineIsPure' )}
  ${rou( 'lengthOf' )}
  ${rou( 'mapIs' )}
  ${rou( 'sure' )}
  ${rou( 'mapBut' )}
  ${rou( 'mapHas' )}
  ${rou( '_mapKeys' )}
  ${rou( 'mapOwnKeys' )}
  ${rou( 'sureMapHasOnly' )}
  ${rou( 'sureMapHasNoUndefine' )}
  ${rou( 'mapSupplementStructureless' )}
  ${rou( 'assertMapHasOnly' )}
  ${rou( 'assertMapHasNoUndefine' )}
  ${rou( 'routineOptions' )}
  ${rou( 'routineExtend' )}
  ${rou( 'arrayAppendArray' )}
  ${rou( 'arrayAppendArrays' )}
  ${rou( 'arrayAppendedArray' )}
  ${rou( 'arrayAppendedArrays' )}
  ${rou( 'arrayAppended' )}
  ${rou( 'arrayAppendOnceStrictly' )}
  ${rou( 'arrayAppendArrayOnce' )}
  ${rou( 'arrayAppendedArrayOnce' )}
  ${rou( 'arrayAppendedOnce' )}
  ${rou( 'arrayRemoveOnceStrictly' )}
  ${rou( 'arrayRemoveElementOnceStrictly' )}
  ${rou( 'arrayRemovedElement' )}
  ${rou( 'arrayRemovedElementOnce' )}
  ${rou( 'longLike' )}
  ${rou( 'longLeft' )}
  ${rou( 'longLeftIndex' )}
  ${rou( 'longLeftDefined' )}
  ${rou( 'longHas' )}
  ${rou( 'routineFromPreAndBody' )}
  ${rou( 'arrayAs' )}
  ${rou( 'errIs' )}
  ${rou( 'unrollIs' )}
  ${rou( 'strType' )}
  ${rou( 'strPrimitiveType' )}
  ${rou( 'strHas' )}
  ${rou( 'strLike' )}
  ${rou( 'rangeIs' )}
  ${rou( 'numbersAre' )}
  ${rou( 'bufferTypedIs' )}
  ${rou( 'bufferNodeIs' )}
  ${rou( '_strLeftSingle' )}
  ${rou( '_strRightSingle' )}
  ${rou( 'strIsolate' )}
  ${rou( 'strIsolateLeftOrNone' )}
  ${rou( 'strIsolateRightOrNone' )}
  ${rou( 'strIsolateLeftOrAll' )}
  ${rou( 'strIsolateRightOrAll' )}
  ${rou( 'strQuote' )}
  ${rou( 'numberFromStrMaybe' )}

  ${rou( 'errOriginalMessage' )}
  ${rou( 'errOriginalStack' )}
  ${rou( 'err' )}
  ${rou( '_err' )}
  ${rou( 'errLogEnd' )}
  ${rou( 'errAttend' )}
  ${rou( '_errFields' )}
  ${rou( 'errIsStandard' )}
  ${rou( 'errIsAttended' )}
  ${rou( 'errProcess' )}

  ${rou( 'setup', '_setupUncaughtErrorHandler2' )}
  ${rou( 'setup', '_setupUncaughtErrorHandler9' )}
  ${rou( 'setup', '_errUncaughtPre' )}
  ${rou( 'setup', '_errUncaughtHandler1' )}
  ${rou( 'setup', '_errUncaughtHandler2' )}

  ${rou( 'introspector', 'code' )}
  ${rou( 'introspector', 'stack' )}
  ${rou( 'introspector', 'stackCondense' )}
  ${rou( 'introspector', 'location' )}
  ${rou( 'introspector', 'locationFromStackFrame' )}
  ${rou( 'introspector', 'locationToStack' )}
  ${rou( 'introspector', 'locationNormalize' )}

  ${rou( 'path', 'refine' )}
  ${rou( 'path', '_normalize' )}
  ${rou( 'path', 'canonize' )}
  ${rou( 'path', 'canonizeTolerant' )}
  ${rou( 'path', '_nativizeWindows' )}
  ${rou( 'path', '_nativizePosix' )}
  ${rou( 'path', 'isGlob' )}
  ${rou( 'path', 'isRelative' )}
  ${rou( 'path', 'isAbsolute' )}
  ${rou( 'path', 'ext' )}
  ${rou( 'path', 'isGlobal' )}
  ${fields( 'path' )}

  /*
  Uri namespace( parseConsecutive ) is required to make _.include working in a browser
  */

  ${rou( 'uri', 'parseConsecutive' )}
  ${rou( 'uri', 'refine' )}
  ${rou( 'uri', '_normalize' )}
  ${rou( 'uri', 'canonize' )}
  ${rou( 'uri', 'canonizeTolerant' )}
  ${fields( 'uri' )}
`

  }

  /* */

  function elementExport( srcContainer, dstContainerName, name )
  {
    let e = srcContainer[ name ];
    _.assert
    (
      _.strDefined( name ),
      () => `Cant export, expects defined name, but got ${_.strType( name )}`
    );
    _.assert
    (
         _.routineIs( e ) || _.strIs( e ) || _.regexpIs( e )
      || ( _.mapIs( e ) && _.lengthOf( e ) === 0 )
      || ( _.arrayIs( e ) && _.lengthOf( e ) === 0 )
      , () => `Cant export ${name} is ${_.strType( e )}`
    );
    let str = '';
    if( _.routineIs( e ) )
    {

      if( e.pre || e.body )
      {
        _.assert( _.routineIs( e.pre ) && _.routineIs( e.body ) );
        str = routineFromPreAndBodyToString( e )
        return str;
      }

      if( e.functor )
      str = '(' + e.functor.toString() + ')();';
      else
      str = e.toString();

      if( e.defaults )
      {
        str += `\n${dstContainerName}.${name}.defaults =\n` + _.toJs( e.defaults )
      }
    }
    else
    {
      str = _.toJs( e );
    }

    /* */

    if( _.routineIs( e ) )
    str += `;\nvar ${name} = ${dstContainerName + '.' + name}`

    let r = dstContainerName + '.' + name + ' = ' + _.strLinesIndentation( str, '  ' ) + ';\n\n//\n';

    /* */

    return r;

    /* */

    function routineProperties( dstContainerName, routine )
    {
      let r = ''
      for( var k in routine )
      r += `${dstContainerName}.${k} = ` + _.toJs( routine[ k ] ) + '\n'
      if( r )
      r = _.strLinesIndentation( r, '  ' );
      return r;
    }

    function routineToString( routine )
    {
      return _.strLinesIndentation( routine.toString(), '  ' ) + '\n\n  //\n'
    }

    function routineFromPreAndBodyToString( e )
    {
      let str =
      `\
        \n  var __${e.name}_pre = ${routineToString( e.pre )}\
        \n  var ${e.pre.name} = __${e.name}_pre\
        \n  ${routineProperties( `__${e.name}_pre`, e.pre )}\
        \n  var __${e.name}_body = ${routineToString( e.body )}\
        \n  var ${e.body.name} = __${e.name}_body\
        \n  ${routineProperties( `__${e.name}_body`, e.body )}\
      `
      if( name === 'routineFromPreAndBody' )
      {
        str += `\n${dstContainerName}.${name} = ` + _.strLinesIndentation( e.toString(), '  ' );
        str += `\n${dstContainerName}.${name}.pre = ` + `__${e.name}_pre;`
        str += `\n${dstContainerName}.${name}.body = ` + `__${e.name}_body;`
        str += `\n${dstContainerName}.${name}.defaults = ` + 'Object.create( ' + `__${e.name}_body.defaults` + ' );'
      }
      else
      {
        str += `\n  ${dstContainerName}.${name} = _.routineFromPreAndBody( __${e.name}_pre, __${e.name}_body );`
      }
      return str;
    }
  }

  function rou( namesapce, name )
  {
    if( arguments.length === 2 )
    {
      return elementExport( _[ namesapce ], `_.${namesapce}`, name );
    }
    else
    {
      name = arguments[ 0 ];
      return elementExport( _, '_', name );
    }
  }

  function fields( namespace )
  {
    let result = [];
    _.assert( _.objectIs( _[ namespace ] ) );
    for( let f in _[ namespace ] )
    {
      let e = _[ namespace ][ f ];
      if( _.strIs( e ) || _.regexpIs( e ) )
      result.push( rou( namespace, f ) );
    }
    return result.join( '  ' );
  }

  function cls( namesapce, name )
  {
    let r;
    if( arguments.length === 2 )
    {
      r = elementExport( _[ namesapce ], `_.${namesapce}`, name );
    }
    else
    {
      name = arguments[ 0 ];
      r = elementExport( _, '_', name );
    }
    r =
`
(function()
{

  let Self = ${r}

})();
`
    return r;
  }

  function clr( cls, method )
  {
    let result = '';
    if( _[ cls ][ method ] )
    result = elementExport( _[ cls ], `_.${cls}`, method );
    if( _[ cls ][ 'prototype' ][ method ] )
    result += '\n' + elementExport( _[ cls ][ 'prototype' ], `_.${cls}.prototype`, method );
    return result;
  }

}

sourcesJoinSplits.defaults =
{
  basePath : null,
  entryPath : null,
  outPath : null,
  libraryName : null,
  externalBeforePath : null,
  externalAfterPath : null,
  interpreter : 'njs',
  debug : 1,
  proceduring : 0,
  catchingUncaughtErrors : 1,
  loggingApplication : 0,
}

//

function sourcesJoin( o )
{
  let self = this;

  _.routineOptions( sourcesJoin, arguments );
  self.instanceOptions( o );

  /* */

  o.filesMap = _.map( o.filesMap, ( fileData, filePath ) =>
  {
    return self.sourceWrap
    ({
      filePath,
      fileData,
      basePath : o.basePath,
      removingShellPrologue : o.removingShellPrologue,
    });
  });

  /* */

  let result = _.mapVals( o.filesMap ).join( '\n' );

  let o2 = _.mapOnly( o, self.sourcesJoinSplits.defaults );
  let splits = self.sourcesJoinSplits( o2 );

  splits.files = result;

  result = self.librarySplitsJoin( splits );

  return result;
}

var defaults = sourcesJoin.defaults = Object.create( sourcesJoinSplits.defaults );

defaults.filesMap = null;
defaults.removingShellPrologue = null;

//

function librarySplitsJoin( o )
{
  let self = this;

  _.routineOptions( librarySplitsJoin, arguments );

  for( let i in o )
  {
    _.assert( _.strIs( o[ i ] ) );
  }

  let result =
      o.prefix
    + o.predefined
    + o.early
    + o.extract
    + o.proceduring
    + o.interpreter
    + o.starter
    + o.env
    + o.files
    + o.externalBefore
    + o.entry
    + o.externalAfter
    + o.postfix;

  return result;
}

var defaults = librarySplitsJoin.defaults =
{
  ... LibrarySplits,
}

// --
// etc
// --

function htmlSplitsFor( o )
{
  let self = this;
  let r = Object.create( null );

  _.routineOptions( htmlSplitsFor, arguments );

  if( o.starterIncluding === null )
  o.starterIncluding = htmlSplitsFor.defaults.starterIncluding;
  _.assert( _.longHas( [ 'include', 'inline', 0, false ], o.starterIncluding ) );
  _.assert( o.starterIncluding !== 'inline', 'not implemented' );

  if( o.template )
  {
    r.all = onTemplate();
    return r;
  }

  r.prefix =
`
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${o.title}</title>
`

  if( o.starterIncluding === 'include' )
  r.starter = `  <script src="/.starter"></script>\n`;

  r.scripts = [];
  for( let filePath in o.srcScriptsMap )
  {
    let split = `  <script src="${filePath}"></script>`;
    r.scripts.push( split );
  }

  r.postfix =
`
</head>
<body>
</body>
</html>
`

  return r;

  /* */

  function onTemplate()
  {
    _.assert( _.strDefined( o.template ) );

    let jsdom = require( 'jsdom' );
    let dom = new jsdom.JSDOM( o.template );
    let document = dom.window.document;

    if( o.starterIncluding === 'include' )
    appendScript( '/.starter' );

    for( let filePath in o.srcScriptsMap )
    appendScript( filePath );

    return dom.serialize();

    /* */

    function appendScript( src )
    {
      let script = document.createElement( 'script' );
      script.type = 'text/javascript';
      script.src = src;
      document.head.appendChild( script );
    }
  }
}

htmlSplitsFor.defaults =
{
  srcScriptsMap : null,
  starterIncluding : 'include',
  title : 'Title',
  template : null
}

//

function htmlFor( o )
{
  let self = this;

  _.routineOptions( htmlFor, arguments );

  let splits = self.htmlSplitsFor( o );

  if( splits.all )
  return splits.all;

  let result = splits.prefix + splits.starter + splits.scripts.join( '\n' ) + splits.postfix;

  return result;
}

htmlFor.defaults = Object.create( htmlSplitsFor.defaults );

/*

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Title</title>
  <script src="http://localhost:4444/Starter.js"></script>
  {each::<script src="{::filePath}"></script>}
</head>
<body>
  <script>
    require( '.' )
  </script>
</body>
</html>

*/

// --
// relations
// --

let InstanceDefaults = [ 'removingShellPrologue' ];

let Composes =
{
  removingShellPrologue : 1,
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  LibrarySplits,
  PredefinedCode : require( '../l1_boot/Predefined.txt.s' ),
  EarlyCode : require( '../l1_boot/Early.txt.s' ),
  ExtractCode : require( '../l1_boot/Extract.txt.s' ),
  ProceduringCode : require( '../l1_boot/Proceduring.txt.s' ),
  BroCode : require( '../l1_boot/Bro.txt.s' ),
  NjsCode : require( '../l1_boot/Njs.txt.s' ),
  StarterCode : require( '../l1_boot/Starter.txt.s' ),
  InstanceDefaults,
}

// --
// prototype
// --

let Proto =
{

  instanceOptions,

  sourceWrapSplits,
  sourceWrap,

  sourceWrapSimple,
  sourceRemoveShellPrologue,

  sourcesJoinSplits,
  sourcesJoin,
  librarySplitsJoin,

  htmlSplitsFor,
  htmlFor,

  /* */

  Composes,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_.starter[ Self.shortName ] = Self;

})();

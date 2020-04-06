( function _worker_js_( ) {

  include( '/dwtools/abase/Layer2.s' );

  var _ = _global_.wTools;

  try
  {
    _.include( '/module.js' );
    throw _.err( 'Module was included' );
  }
  catch( err )
  {
    console.log( '-' );
    // debugger;
    logger.error( String( err ) );
    // debugger;
    // _.errLogOnce( err );
  }

})();

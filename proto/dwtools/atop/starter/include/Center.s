( function _Center_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  if( Config.interpreter === 'njs' )
  {
    require( '../l5/Center.ss' );
    // require( '../l5/Remote.ss' );
  }

  // require( '../l8/Launcher.s' );

  module.exports = _;
}

})();
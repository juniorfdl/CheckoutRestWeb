var App;
(function (App) {
    'use strict';

    App.modules.App.constant('luarApp',
    {        
        //WEBAPI: 'http://192.168.0.105:1234/datasnap/rest',
        WEBAPI: 'http://localhost:1234/datasnap/rest',
        ITENS_POR_PAGINA: '15'
    });

})(App || (App = {}));
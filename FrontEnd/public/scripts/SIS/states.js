var App;
(function (App) {
    'use strict';

    App.modules.App.config(function ($stateProvider) {

        $stateProvider.state('home', {
            url: '/home',
            templateUrl: 'views/Home.html'
        }).state('login', {
            url: '/login',
            layout: 'basic',
            templateUrl: 'views/login.html',
            controller: 'LoginCtrl',
            controllerAs: 'ctrl',
            data: {
                title: "Entrar"
            }
        }).state('Iniciar', {
            url: '',
            templateUrl: 'features/Restaurante/Pedido/edit.html',
            controller: 'CrudpedidoCtrl',
            controllerAs: 'ctrl',
            resolve: {
                lista: function (CrudpedidoService) {
                    return CrudpedidoService.buscar();
                }
            }  
        }).state("otherwise",
          {
            url: '/login',
            layout: 'basic',
            templateUrl: 'views/login.html',
            controller: 'LoginCtrl',
            controllerAs: 'ctrl',
            data: {
                title: "Entrar"
            }
          }
        );
    });

})(App || (App = {}));
//# sourceMappingURL=app.js.map
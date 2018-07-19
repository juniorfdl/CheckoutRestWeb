

var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};

var App;
(function (App) {
    var Services;
    (function (Services) {
        "use strict";
        var CrudpedidoService = (function (_super) {
            __extends(CrudpedidoService, _super);

            function CrudpedidoService($q, api, $rootScope) {
                _super.apply(this, arguments);

              this.ConfirmarPedido = function (dados) {
                    debugger;
                    return this.api.save(dados);
                    //return this.api.allLook(dados, 'sis_usuario/confirmarpedido');
              };

              this.BuscarMesas = function () {
                return this.api.allLook(null,'tormbr/DadosMesas');
              }

              this.PedidoMesa = function (mesa) {
                  debugger;
                  //var params = { "id": mesa };
                  return this.api.allLook(null,'tormbr/PedidoMesa/'+mesa);
              };

            }

            
            Object.defineProperty(CrudpedidoService.prototype, "baseEntity", {
                /// @override
                get: function () {
                    return 'tormbr/ConfirmarPedido';
                },
                enumerable: true,
                configurable: true
            });

            CrudpedidoService.prototype.buscar = function () {
                debugger;
                return [{ Mesa: "1" }, { Mesa: "2" }, { Mesa: "3" }, { Mesa: "4" }, { Mesa: "5" }];
            }
   
            return CrudpedidoService;
        })(Services.CrudBaseService);
        Services.CrudpedidoService = CrudpedidoService;
        App.modules.Services
            .service('CrudpedidoService', CrudpedidoService);
    })(Services = App.Services || (App.Services = {}));
})(App || (App = {}));
//# sourceMappingURL=services.js.map
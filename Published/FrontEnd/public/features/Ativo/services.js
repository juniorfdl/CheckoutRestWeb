

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
        var CrudAtivoService = (function (_super) {
            __extends(CrudAtivoService, _super);

            function CrudAtivoService($q, api, luarApp) {
                _super.apply(this, arguments);

                this.Ligar = function (pDados){                    
                    var vURL = luarApp.APISIP;
                    var params = {};
                    params.Telefone = pDados.FONE;
                    params.CodigoLigacao = pDados.CODIGO;
                    params.NomeOperador = pDados.NOME_OPERADOR;
                    return this.api.invokePost('Ligar',params,vURL);
                }

                this.EnviarDTMF = function (pDados){
                    var vURL = luarApp.APISIP;
                    var params = {};
                    params.Telefone = pDados.FONE;
                    return this.api.invokePost('EnviarDTMF',params,vURL);
                }

                this.Transferir = function (pDados){
                    var vURL = luarApp.APISIP;
                    var params = {};
                    params.Telefone = pDados.FONE;
                    return this.api.invokePost('Transferir',params,vURL);
                }

                this.Desligar = function (pFone){
                    var params = {};
                    var vURL = luarApp.APISIP;
                    return this.api.invokePost('Desligar',params,vURL);
                }

                this.State = function (){
                    var params = {};
                    var vURL = luarApp.APISIP;
                    return this.api.invokePostDirect('State',params,vURL);
                }

                this.Registrar = function (pDados){                    
                    var vURL = luarApp.APISIP;
                    return this.api.invokePost('Registrar',pDados,vURL);
                }

                this.GetProximaLigacao = function (operador, CAMINHO_BANCO) { 
                    var params = {}; 
                    params.DATABASE = CAMINHO_BANCO;   
                    params.operador = operador;                 
                    return this.api.invokePost('ProximaLigacao', params);
                };

                this.FinalizarLigacao = function (pDados){
                    this.Desligar();
                    return this.api.invokePost('FinalizarLigacao', pDados);                    
                }

                this.LiberarLigacao = function (operador) {
                    return this.api.allLook(null, 'TAtivo/liberar');
                };

                this.GetStart = function (pCAMINHO_BANCO) {                    
                    return this.api.get('Start/'+ pCAMINHO_BANCO);
                };

                this.PesquisarCidades = function (pUF, pCAMINHO_BANCO) {
                    return this.api.allLook(null, 'TAtivo/Cidades/'+pUF+'/'+pCAMINHO_BANCO);
                };

            }

            Object.defineProperty(CrudAtivoService.prototype, "baseEntity", {
                /// @override
                get: function () {
                    return 'TAtivo';
                },
                enumerable: true,
                configurable: true
            });            
   
            return CrudAtivoService;
        })(Services.CrudBaseService);
        Services.CrudAtivoService = CrudAtivoService;
        App.modules.Services
            .service('CrudAtivoService', CrudAtivoService);
    })(Services = App.Services || (App.Services = {}));
})(App || (App = {}));
//# sourceMappingURL=services.js.map
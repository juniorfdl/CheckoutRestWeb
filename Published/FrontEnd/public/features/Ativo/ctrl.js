
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var App;
(function (App) {
    var Controllers;
    (function (Controllers) {
        'use strict';
        var CrudAtivoCtrl = (function (_super) {

            __extends(CrudAtivoCtrl, _super);
            function CrudAtivoCtrl($rootScope, api, CrudAtivoService, $q, $scope, $modal, security) { //roundProgressService, $interval,
                var _this = this;
                var _rootScope = $rootScope;
                var _scope = $scope;
                var timestampLigacao = null;                
                var input = {
                    year: 0,
                    month: 0,
                    day: 0,
                    hours: 0,
                    minutes: 0,
                    seconds: 1
                };                
                var timestamp = new Date(input.year, input.month, input.day,
                                         input.hours, input.minutes, input.seconds);                
                                                         
                _this.tempoTotal = '00:00:00';
                _this.tempoLigacao = '00:00:00';
                _super.call(this);

                this.UFLook = [{UF: 'AC'},{UF: 'AL'},{UF: 'AM'},{UF: 'AP'},{UF: 'BA'},{UF: 'CE'}
                  ,{UF: 'DF'}, {UF: 'ES'}, {UF: 'GO'}, {UF: 'MA'}, {UF: 'MG'}, {UF: 'MS'}, {UF: 'MT'}
                  ,{UF: 'PA'}, {UF: 'PB'}, {UF: 'PE'}, {UF: 'PI'}, {UF: 'PR'}, {UF: 'RJ'}
                  ,{UF: 'RN'}, {UF: 'RO'}, {UF: 'RR'}, {UF: 'RS'}, {UF: 'SC'}, {UF: 'SE'}, 
                   {UF: 'SP'}, {UF: 'TO'}]; 

                // this.fullScreen = function toggleFullScreen() {
                //     if ((document.fullScreenElement && document.fullScreenElement !== null) ||    
                //      (!document.mozFullScreen && !document.webkitIsFullScreen)) {
                //       if (document.documentElement.requestFullScreen) {  
                //         document.documentElement.requestFullScreen();  
                //       } else if (document.documentElement.mozRequestFullScreen) {  
                //         document.documentElement.mozRequestFullScreen();  
                //       } else if (document.documentElement.webkitRequestFullScreen) {  
                //         document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);  
                //       }  
                //     } else {  
                //       if (document.cancelFullScreen) {  
                //         document.cancelFullScreen();  
                //       } else if (document.mozCancelFullScreen) {  
                //         document.mozCancelFullScreen();  
                //       } else if (document.webkitCancelFullScreen) {  
                //         document.webkitCancelFullScreen();  
                //       }  
                //     }  
                //   } 
                
                // this.fullScreen();

                this.CidadeLook = [];

                this.$modal = $modal;

                this.MenuSelecionado = 'ENDEREÇO';

                this.TempoAntesProximoLigacao = function () {
                    this.modalTempo = $modal.open({
                        templateUrl: 'features/Ativo/TempoAntesProximaLigacao.html',
                        resolve: {},
                        scope: $scope,
                        backdrop: 'static',
                        rootScope: $rootScope
                    });
                }

                this.FecharTempo = function () {
                    this.modalTempo.close();
                    this.GetProximaLigacao();
                }

                this.Registrar = function () {
                    this.crudSvc.Registrar(_rootScope.currentUser.Registrar).then(function (dados) {
                        _this.RegistroOK = true;
                    }).catch(function (data) {
                        _this.RegistroOK = false;
                    });
                }

                this.LigarTeclado = function() {
                    if (_this.TelefoneTeclado){
                        var vDados = {};
                        vDados.FONE = _this.TelefoneTeclado;
                        _this.crudSvc.Ligar(vDados);
                    }                    
                }

                this.Transferir = function() {
                    if (_this.TelefoneTeclado){
                        var vDados = {};
                        vDados.FONE = _this.TelefoneTeclado;
                        _this.crudSvc.Transferir(vDados);
                    }                    
                }

                this.EnviarDTMF = function(pNro) {
                    if (pNro){
                        var vDados = {};
                        vDados.FONE = pNro;
                        _this.crudSvc.EnviarDTMF(vDados);
                    }                    
                }

                this.GetProximaLigacao = function () {

                    _this.crudSvc.GetProximaLigacao(_rootScope.currentUser.id,
                        _rootScope.currentUser.CAMINHO_DATABASE).then(function (dados) {                            
                            if (dados) {                                
                                _this.ProximaLigacao = dados;
                                _this.SelectCompra = 0;
                                _this.CidadeLook = [];
                                _this.CidadeLook.push({NOME: _this.ProximaLigacao.CIDADE});

                                _this.crudSvc.Ligar(_this.ProximaLigacao.DadosLigacao);

                                if (_this.ProximaLigacao.DadosLigacao.Historico){
                                    _this.HistoricoOBSERVACAO = 
                                       _this.ProximaLigacao.DadosLigacao.Historico[0].OBSERVACAO;
                                }
                            };
                        });
                }

                this.GetDescricaoResultado = function (item) {

                    if (item.id > -1) {
                        return item.id + " - " + item.NOME;
                    }

                    return "";
                }

                this.ChangeResultado = function () {

                    var vItens = this.DadosStart.Resultados;
                    for (var i in vItens) {
                        if (vItens[i].id == this.ProximaLigacao.DadosLigacao.Finalizar.RESULTADO) {
                            this.ProximaLigacao.DadosLigacao.Finalizar.ACAO = vItens[i].COD_ACAO;
                            this.ProximaLigacao.DadosLigacao.Finalizar.DESCRICAO_ACAO = vItens[i].DESCRICAO_ACAO;
                            return;
                        }
                    }

                }

                this.VisualizarData = function () {
                    return this.ProximaLigacao.DadosLigacao.Finalizar.ACAO == '2'
                        || this.ProximaLigacao.DadosLigacao.Finalizar.ACAO == '7'
                        || this.ProximaLigacao.DadosLigacao.Finalizar.ACAO == '8';
                }

                this.PodeFinalizar = function () {

                    if (this.ProximaLigacao.DadosLigacao.Finalizar.ACAO == 8) {
                        if (!this.ProximaLigacao.DadosLigacao.Finalizar.OperadorDelegar) {
                            _this.toaster.error("Atenção", "Informe o campo Delegar Operador!");

                            return false;
                        }
                    }

                    return true;
                }

                this.FinalizarLigacao = function () {
                    
                    if (!this.PodeFinalizar()) {
                        return;
                    }

                    if (this.ProximaLigacao) {
                        this.ProximaLigacao.DataBase = $rootScope.currentUser.CAMINHO_DATABASE;

                        if (!this.ProximaLigacao.DadosLigacao.Finalizar.OperadorDelegar) {
                            this.ProximaLigacao.DadosLigacao.Finalizar.OperadorDelegar = -1;
                        }

                        this.crudSvc.FinalizarLigacao(this.ProximaLigacao).then(function (dados) {
                            // _this.ProximaLigacao = dados;
                            // _this.SelectCompra = 0; 
                            if (dados) {
                                _this.FecharFinalizar();
                                _this.TempoAntesProximoLigacao();
                            }
                        });
                    }
                    else {
                        _this.toaster.error("Atenção", "Não existe ligação ativa!");
                    }
                }

                this.LiberarLigacao = function () {
                    if (this.ProximaLigacao) {
                        this.crudSvc.Desligar();
                        //this.stopTimer();
                        // this.crudSvc.LiberarLigacao($rootScope.currentUser.id,
                        //     $rootScope.currentUser.CAMINHO_DATABASE).then(function (dados) {
                        //         _this.LiberarOK = dados;
                        //     });
                    }
                    else {
                        _this.toaster.error("Atenção", "Não existe ligação ativa!");
                    }
                }

                this.GetStart = function () {
                    this.crudSvc.GetStart($rootScope.currentUser.CAMINHO_DATABASE).then(function (dados) {
                        _this.DadosStart = dados;
                    });
                }

                this.GetStateLigacao = function(){
                    this.crudSvc.State().then(function (dados) {
                        var statusAnt = _this.StatusLigacao;

                        if (dados){
                           _this.StatusLigacao = dados.StateDescricao;
                        }
                        else _this.StatusLigacao = ""; 

                        if (statusAnt != 'Em conversacao...' && _this.StatusLigacao == 'Em conversacao...'){
                            timestampLigacao = new Date(input.year, input.month, input.day,
                                input.hours, input.minutes, input.seconds);
                        }
                        else {
                            if (_this.StatusLigacao != 'Em conversacao...'){
                                timestampLigacao = null;
                                _this.tempoLigacao = '00:00:00';
                            }                            
                        }                        
                    });
                }

                function ExecutaStart() {
                    _this.$rootScope = $rootScope;
                    _this.api = api;
                    _this.crudSvc = CrudAtivoService;
                    _this.ApenasConsulta = true;
                    _this.GetStart();
                    _this.Registrar();
                    _this.TempoAntesProximoLigacao();
                }

                ExecutaStart();

                this.TempoDiscagem = function () {
                    var modalInstance = $modal.open({
                        templateUrl: 'TempoDiscagem.html',
                        scope: $scope,
                        controller: 'ModalTempoDiscagemCtrl',
                        controllerAs: 'Ctrl'
                    });
                }

                this.AddFoneCampanha = function (pAREA, pFONE, pDESC_FONE) {

                    if (!this.ProximaLigacao.FonesCampanha) {
                        this.ProximaLigacao.FonesCampanha = [];
                    }

                    if (pFONE != '') {

                        if (pFONE.length <= 9) {
                            pFONE = pAREA + pFONE;
                        }

                        var vFone = {};
                        var i;
                        for (i = 0; i < this.ProximaLigacao.FonesCampanha.length; i++) {
                            if (this.ProximaLigacao.FonesCampanha[i].TELEFONE == pFONE) {
                                vFone = this.ProximaLigacao.FonesCampanha[i];
                                break;
                            }
                        }

                        if (vFone.TELEFONE) {
                            vFone.TELEFONE = pFONE;
                            vFone.TIPOFONE = pDESC_FONE;
                            this.ProximaLigacao.FonesCampanha[i] = vFone;
                        }
                        else {
                            vFone.TELEFONE = pFONE;
                            vFone.TIPOFONE = pDESC_FONE;
                            this.ProximaLigacao.FonesCampanha.push(vFone);
                        }

                        if (this.ProximaLigacao.FonesCampanha.length > 3) {
                            var vlist = this.ProximaLigacao.FonesCampanha;

                            this.ProximaLigacao.FonesCampanha = [];

                            for (i = 0; i < vlist.length; i++) {
                                if (i > 0) {
                                    this.ProximaLigacao.FonesCampanha.push(vlist[i]);
                                }
                            }

                        }
                    }
                }

                this.AbrirModalFinalizar = function () {

                    this.ProximaLigacao.DadosLigacao.Finalizar.OperadorDelegar = -1;
                    this.modalFinalizar = $modal.open({
                        templateUrl: 'features/Ativo/Finalizar.html',
                        resolve: {},
                        size: 'lg',
                        scope: $scope,
                        backdrop: 'static',
                        rootScope: $rootScope
                    });

                }

                this.FecharFinalizar = function () {
                    this.modalFinalizar.close();
                };

                this.AbrirModalTeclado = function () {

                    this.modalTeclado = $modal.open({
                        templateUrl: 'features/Ativo/TecladoVirtual.html',
                        resolve: {},
                        size: 'sm',
                        scope: $scope,
                        backdrop: 'static',
                        rootScope: $rootScope
                    });

                }                

                this.FecharTeclado = function () {
                    this.modalTeclado.close();
                };

                setInterval(function () {
                    _this.GetStateLigacao();

                    _this.calcTempoTotal();
                    
                    if (timestampLigacao){
                        _this.calcTempoLigacao();
                    }

                }, Math.abs(1) * 1000);

                this.calcTempoTotal = function(){
                    timestamp = new Date(timestamp.getTime() + 1 * 1000);

                    if (timestamp.getHours().toString().length == 1) 
                      _this.tempoTotal = '0'+timestamp.getHours().toString()
                    else 
                    _this.tempoTotal = timestamp.getHours().toString();                      

                    if (timestamp.getMinutes().toString().length == 1) 
                      _this.tempoTotal = _this.tempoTotal+':0'+timestamp.getMinutes().toString()
                    else 
                    _this.tempoTotal = _this.tempoTotal+':'+timestamp.getMinutes().toString();

                    if (timestamp.getSeconds().toString().length == 1) 
                      _this.tempoTotal = _this.tempoTotal+':0'+timestamp.getSeconds().toString()
                    else 
                    _this.tempoTotal = _this.tempoTotal+':'+timestamp.getSeconds().toString();
                }

                this.calcTempoLigacao = function(){
                    timestampLigacao = new Date(timestampLigacao.getTime() + 1 * 1000);

                    if (timestampLigacao.getHours().toString().length == 1) 
                      _this.tempoLigacao = '0'+timestampLigacao.getHours().toString()
                    else 
                    _this.tempoLigacao = timestampLigacao.getHours().toString();                      

                    if (timestampLigacao.getMinutes().toString().length == 1) 
                      _this.tempoLigacao = _this.tempoLigacao+':0'+timestampLigacao.getMinutes().toString()
                    else 
                    _this.tempoLigacao = _this.tempoLigacao+':'+timestampLigacao.getMinutes().toString();

                    if (timestampLigacao.getSeconds().toString().length == 1) 
                      _this.tempoLigacao = _this.tempoLigacao+':0'+timestampLigacao.getSeconds().toString()
                    else 
                    _this.tempoLigacao = _this.tempoLigacao+':'+timestampLigacao.getSeconds().toString();
                }

                this.PesquisarCidades = function(){
                    if (!this.ProximaLigacao.ESTADO){
                        _this.toaster.error("Atenção", "Selecione um Estado!");
                    }
                    else{
                        _this.crudSvc.PesquisarCidades(this.ProximaLigacao.ESTADO,
                            _rootScope.currentUser.CAMINHO_DATABASE).then(function (dados) {                            
                                if (dados) {
                                    
                                    _this.CidadeLook = dados;
                                    
                                };
                            });

                    }                    
                }

            }

            CrudAtivoCtrl.prototype.crud = function () {
                return "Ativo";
            };

            CrudAtivoCtrl.prototype.overrideApenasConsulta = function () {
                return true;
            }

            return CrudAtivoCtrl;
        })(Controllers.CrudBaseEditCtrl);
        Controllers.CrudAtivoCtrl = CrudAtivoCtrl;

        App.modules.Controllers.controller('CrudAtivoCtrl', CrudAtivoCtrl);

    })(Controllers = App.Controllers || (App.Controllers = {}));
})(App || (App = {}));
//# sourceMappingURL=ctrl.js.map
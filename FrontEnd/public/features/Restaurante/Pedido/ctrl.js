
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
        var CrudpedidoCtrl = (function (_super) {

            __extends(CrudpedidoCtrl, _super);
            function CrudpedidoCtrl($location, $rootScope, api, CrudpedidoService, lista, $q, $scope, SweetAlert) {
                var _this = this;
                _super.call(this);

                this.$location = $location;
                this.SweetAlert = SweetAlert;
                this.$rootScope = $rootScope;
                this.api = api;
                this.crudSvc = CrudpedidoService;
                this.lista = lista;
                this.VisualizarProdutos = false;
                this.VisualizarGrupo = false;
                this.OBS_MESA = '';

                this.BuscarMesas = function (){
                    _this.crudSvc.BuscarMesas().then(function (dados) {
                        if (dados.result) {
                            debugger;
                            _this.CONFIG_RESTAURANTE = dados.result[0];
                        }
                    });
                }

                this.BuscarMesas();

                this.cssMesa = function (pmesa) {

                    if (pmesa.MESACSTATUS == 'F') {
                        return 'btn btn-success btn-lg badge-pill active';
                    }
                    else if (pmesa.MESACSTATUS == 'P') {
                        return 'btn btn-danger btn-lg badge-pill active';
                    }
                    else if (pmesa.MESACSTATUS == 'E') {
                        return 'btn btn-yellow btn-lg badge-pill active ';
                    }
                }

                this.IniciarPedido = function () {
                    this.Pedido = {};
                    this.Pedido.id = -1;
                    this.Pedido.Produtos = [];
                    this.Pedido.Mesa = 0;
                    this.Pedido.Total = 0;
                    this.Pedido.CodUsr = $rootScope.currentUser.id;
                    this.Pedido.OBS = "";
					this.Pedido.OBS_MESA = this.OBS_MESA;
                }

                this.IniciarPedido();

                this.DesejaReimprimir = function () {
                    
                    if (_this.Pedido.id > 0) {

                        _this.Pedido.ReImprimir = 'N';
                        _this.SweetAlert.swal({
                            title: "Deseja reimprimir itens j? impresso?",
                            type: "warning",
                            showCancelButton: true,
                            confirmButtonColor: "#DD6B55",
                            confirmButtonText: "Sim",
                            cancelButtonText: "Nao"
                        }, function (isConfirm) {

                            debugger;

                            if (isConfirm) {
                                _this.Pedido.ReImprimir = 'S';
                            }

                            _this.crudSvc.ConfirmarPedido(_this.Pedido).then(function (dados) {
                                _this.Pedido.id = dados.id;
                                _this.Cancelar();
                                _this.$location.path('/home');
                            });

                        });
                    }
					else {
						_this.Pedido.ReImprimir = 'S';
						_this.crudSvc.ConfirmarPedido(_this.Pedido).then(function (dados) {
                                _this.Pedido.id = dados.id;
                                _this.Cancelar();
                                _this.$location.path('/home');
                            });
					}

                }

                this.ConfirmarPedido = function () {
                    _this.Pedido.CodUsr = $rootScope.currentUser.id;
                    _this.Pedido.OBS_MESA = _this.OBS_MESA;
                    _this.Pedido.termicod  = $rootScope.currentUser.userCEMP;
                    _this.DesejaReimprimir();
                }

                this.GetTotal = function () {
                    _this.Pedido.Total = 0;
                    for (var i = 0; i < _this.Pedido.Produtos.length; i++) {
                        _this.Pedido.Total = _this.Pedido.Total + (_this.Pedido.Produtos[i].QTD * _this.Pedido.Produtos[i].PRODN3VLRVENDA);
                    }
                }

                this.BuscarDadosMesa = function (pMesa) {

                    var index = pMesa.MESA;                   

                    _this.crudSvc.PedidoMesa(index).then(function (dados) {
                        if (dados.result) {
                            debugger;
                            dados = dados.result[0];
                            _this.Pedido.id = dados.id;
                            _this.Pedido.CodUsr = dados.CodUsr;
                            _this.Pedido.Total = dados.Total;
                            _this.VerResumo = true;
                            _this.Pedido.OBS = dados.OBS;

                            for (var i = 0; i < dados.Produtos.length; i++) {
                                for (var iG = 0; iG < _this.$rootScope.currentUser.Grupos.length; iG++) {
                                    if (_this.$rootScope.currentUser.Grupos[iG].id == dados.Produtos[i].GRUPICOD) {
                                        _this.SetGrupo(_this.$rootScope.currentUser.Grupos[iG]);

                                        for (var iP = 0; iP < _this.Produtos.length; iP++) {
                                            if (_this.Produtos[iP].id == dados.Produtos[i].id) {
                                                _this.Produtos[iP].QTD = dados.Produtos[i].QTD - 1;
                                                _this.Produtos[iP].IMPRESSO = dados.Produtos[i].IMPRESSO;
                                                _this.AddProduto(_this.Produtos[iP]);
                                                break;
                                            }
                                        }
                                        break;
                                    }
                                }

                            }
                        }
                    });
                }

                this.SetMesa = function (pMesa) {
                    var index = pMesa.MESA;
                    this.OBS_MESA = pMesa.OBS;                    
                    this.Pedido.Mesa = index;
					this.Pedido.OBS_MESA = this.OBS_MESA;

                    if (pMesa.PedidoAberto != 'S') {
                       this.VisualizarProdutos = false;
                       this.VisualizarGrupo = true;                                                
                    }
                    else {
                        _this.SweetAlert.swal({
                            title: "Buscar Ultimo Pedido da Mesa?",
                            type: "warning",
                            showCancelButton: true,
                            confirmButtonColor: "#DD6B55",
                            confirmButtonText: "Sim",
                            cancelButtonText: "Nao"
                        }, function (isConfirm) {                            

                            if (isConfirm) {
                                _this.BuscarDadosMesa(pMesa);  
                            }
                            _this.VisualizarProdutos = false;
                            _this.VisualizarGrupo = true;
                        });
                    }

                }

                this.SetGrupo = function (grupo) {
                    debugger;
                    _this.GrupoSelecionado = grupo.GRUPA60DESCR;
                    _this.Produtos = grupo.Produtos;
                    _this.VisualizarProdutos = true;
                    _this.VisualizarGrupo = false;

                }

                this.AddProduto = function (Produto) {
                    debugger;
                    if (!Produto.QTD)
                        Produto.QTD = 0;

                    Produto.QTD++;

                    for (var i = 0; i < _this.Pedido.Produtos.length; i++) {
                        if (_this.Pedido.Produtos[i].id === Produto.id) {
                            _this.Pedido.Produtos[i] = Produto;
                            _this.GetTotal();
                            return;
                        }
                    }

                    _this.Pedido.Produtos.push(Produto)
                    _this.GetTotal();
                }

                this.DelProduto = function (Produto) {

                    for (var i = 0; i < _this.Pedido.Produtos.length; i++) {
                        if (_this.Pedido.Produtos[i].id === Produto.id) {
                            if (_this.Pedido.Produtos[i].QTD > 0)
                                _this.Pedido.Produtos[i].QTD--;

                            if (_this.Pedido.Produtos[i].QTD == 0)
                                _this.Pedido.Produtos.splice(i, 1);

                            _this.GetTotal();
                            return;
                        }
                    }

                }

                this.Cancelar = function () {
                    this.IniciarPedido();

                    if (_this.Produtos)
                        for (var i = 0; i < _this.Produtos.length; i++) {
                            _this.Produtos[i].QTD = 0;
                        }


                }

                this.Resumo = function () {
                    _this.GetTotal();
                    _this.VerResumo = !_this.VerResumo;
                }

                this.myFilter = function (item) {
                    return item.QTD > 0;
                };

                this.AbrirGrupo = function () {
                    _this.VisualizarProdutos = false;
                    _this.VisualizarGrupo = true;
                }

            }

            CrudpedidoCtrl.prototype.crud = function () {
                return "tormbr/ConfirmarPedido";
            };

            return CrudpedidoCtrl;
        })(Controllers.CrudBaseEditCtrl);
        Controllers.CrudpedidoCtrl = CrudpedidoCtrl;

        App.modules.Controllers.controller('CrudpedidoCtrl', CrudpedidoCtrl);


    })(Controllers = App.Controllers || (App.Controllers = {}));
})(App || (App = {}));
//# sourceMappingURL=ctrl.js.map
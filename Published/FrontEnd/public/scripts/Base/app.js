
var App;
(function (App) {
    'use strict';
    App.modules.App.constant('app', App);

    App.modules.App.config(function (uiSelectConfig) {
        uiSelectConfig.resetSearchInput = true;
    });

    App.modules.App.config(function (apiProvider, luarApp) {
        apiProvider.setBaseUrl(luarApp.WEBAPI);
    });

    App.modules.App.config(["$locationProvider", function ($locationProvider) {
        $locationProvider.html5Mode({ enabled: true, requireBase: false });
    }]);

    App.modules.App.config(function (easyMaskProvider) {
        easyMaskProvider.publishMask('cep', '99999-999');
        easyMaskProvider.publishMask('cpf', '999.999.999-99');
        easyMaskProvider.publishMask('cnpj', '99.999.999/9999-99');
        easyMaskProvider.publishMask('ddd', '99');
        easyMaskProvider.publishMask('fone', '09999-9999');
        easyMaskProvider.publishMask('ddd+fone', '(99) 09999-9999');
    });

    App.modules.App.config(function (unsavedWarningsConfigProvider) {
        unsavedWarningsConfigProvider.routeEvent = '$stateChangeStart';
        unsavedWarningsConfigProvider.navigateMessage = "As altera��es n�o salvas ser�o perdidas.";
        unsavedWarningsConfigProvider.reloadMessage = "As altera��es n�o salvas ser�o perdidas.";
    });

    App.modules.App.run(function ($locale) {
        $locale.DATETIME_FORMATS.short = 'dd/MM/yyyy HH:mm';
        $locale.DATETIME_FORMATS.shortDate = 'dd/MM/yyyy';
    });

    App.modules.App.run(function ($rootScope, $state, $location, $window, security) {

        function localLogin(checkSession) {

            if (checkSession === void 0) { checkSession = true; }
            var loginusr = localStorage.getItem("luarusr");
            var loginpass = localStorage.getItem("luarpass");
            
            if (localStorage.getItem("userEmpresa") != null) {
                var logo = "app/Logo" + localStorage.getItem("userEmpresa") + ".jpg";
                $rootScope.EmpresaSelecionadaLogo = logo;
            }

            $location.path('/login');
            // if (loginusr == null || loginpass == null) {
            //     $location.path('/login');
            // }
            // else {
            //     security.login(loginusr, loginpass).then(function () {
            //         $rootScope.currentUser.userEmpresa = localStorage.getItem("userEmpresa");
            //         $rootScope.currentUser.userCEMP = localStorage.getItem("userCEMP");
            //         $rootScope.currentUser.CODIGOSISUSUARIO = localStorage.getItem("CODIGOSISUSUARIO");
            //     });
            // }
        }

        // var pathlogin = $location.path();
        //if (pathlogin.toLowerCase() != "/login")
        localLogin(false);
        $window.addEventListener("storage", function (event) {
            $rootScope.$apply(function () {
                switch (event.key) {
                    case "loginInfo":
                        if (event.newValue === "") {
                            $location.path('/login');
                        }
                        else {
                            localLogin();
                            $location.path('/');
                        }
                        break;
                    default:
                        break;
                }
            });
        });

    });

    App.modules.App.run(function ($rootScope, $log, $state, security) {
        var setupErrors = function () {
            return $rootScope.$on('$stateChangeError', function (event, toState, toParams, fromState, fromParams, error) {
                $log.error('$stateChangeError', event, toState, error);
            });
        };
        var setupRedirects = function () {
            return $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
                if (!security.isAuthenticated() && toState.name != 'login') {
                    event.preventDefault();
                }
                if (toState.data && toState.data.redirectTo) {
                    event.preventDefault();
                    $state.go(toState.data.redirectTo, toParams);
                }
                if (/\.edit$/.test(toState.name) && !toParams.id) {
                    var newState = toState.name.replace(/\.edit$/, '.new');
                    if ($state.href(newState)) {
                        event.preventDefault();
                        $state.go(newState);
                    }
                }
            });
        };
        var setupTitle = function () {
            return $rootScope.$on('$stateChangeSuccess', function (event, toState) {                
                $rootScope.layout = toState.layout;
                var title = "Nota de Servi&ccedil;o";
                if (toState.data && toState.data.title) {
                    title += " | " + toState.data.title;
                }
                $rootScope.title = title;
            });
        };
        setupErrors();
        setupRedirects();
        setupTitle();
    });

    App.modules.App.run(function ($document, $window, $rootScope) {
        if (isItMobile()) {
            $rootScope.onMobile = true;
        }
        function isItMobile() {
            return "ontouchstart" in $document[0].documentElement && $window.innerWidth < 768;
        }
    });

})(App || (App = {}));
//# sourceMappingURL=app.js.map
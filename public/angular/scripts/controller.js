angular.module('emailParser', []).config(['$interpolateProvider',
    function($interpolateProvider) {
        //$interpolateProvider.startSymbol('__');
        //$interpolateProvider.endSymbol('__');
    }]).factory('EmailParser', ['$interpolate',
    function($interpolate) {
        // a service to handle parsing
        return {
            parse: function(text, context) {
                var template = $interpolate(text);
                return template(context);
            }
        }
    }
]);

angular.module('myApp', ['emailParser']).controller('MyController', function($scope, $timeout) {
    var updateClock = function() {
        $scope.clock = {};
        $scope.clock.now  = new Date();
        $timeout(function() {
            updateClock();
        }, 1000);
    };
    updateClock();
}).run(function($rootScope) {
    $rootScope.name = "World";
}).controller('OtherController', function($scope) {
    $scope.name = "Moshe";
}).controller('AddController', function($scope, $filter) {
    $scope.name = $filter('lowercase')('DAVID');
    $scope.counter = 0;
    $scope.add = function(amount) {
        $scope.counter += amount;
    };

    $scope.subtract = function(amount) {
        $scope.counter -= amount;
    };
}).controller('ParseController',
     function($scope, $parse) {

         $scope.$watch('expr', function(newVal, oldVal, scope) {
                 if (newVal !== oldVal) {
                     // Let's set up our parseFun with the expression
                     var parseFun = $parse(newVal);
                     // Get the value of the parsed expression
                     $scope.parsedValue = parseFun(scope);
                 }
         });
     }).controller('InterpolateController',
    function($scope, $interpolate) {
       // Set up a watch
       $scope.$watch('emailBody', function(body) {
           if (body) {
               var template = $interpolate(body);
               $scope.previewText = template({to: $scope.to, from: "moshe"});
           }
       });
    }).controller('EmailController',
    ['$scope', 'EmailParser',
        function($scope, EmailParser) {
            // Set up a watch
            $scope.$watch('emailBody', function(body) {
                if (body) {
                    $scope.previewText = EmailParser.parse(body, {to: $scope.to});
                }
            });
        }
    ]);

angular.module('myApp').filter('capitalize', function(){
    return function(input) {
        // input will be the string we pass in
        if (input) return input[0].toUpperCase() + input.slice(1);
    }
});
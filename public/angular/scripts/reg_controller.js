var app = angular.module('myApp', ['ngMessages']);

app.directive('ensureUnique', ['$http', function($http) {
    return {
        require: 'ngModel',
        link: function(scope, ele, attrs, c) {
            scope.$watch(attrs.ngModel, function() {
                $http({
                    method: 'POST',
                    url: '/api/check/' + attrs.ensureUnique,
                    data: {'field': attrs.ensureUnique}
                }).success(function(data, status, headers, cfg) {
                    c.$setValidity('unique', data.isUnique);
                }).error(function(data, status, headers, cfg) {
                    c.$setValidity('unique', true);
                });
            });
        }
    };
}]);

app.controller('SignupController',
       function($scope) {
     		$scope.submitted = false;
     		$scope.signupForm = function() {
         			if ($scope.signup_form.$valid) {
             				// Submit as normal”
                    } else {
                        $scope.signup_form.submitted = true;
                    }
            }
       });


app.directive('ngFocus', [function() {
       var FOCUS_CLASS = "ng-focused";
       return {
             restrict: 'A',
             require: 'ngModel',
             link: function(scope, element, attrs, ctrl) {
                 debugger;
               ctrl.$focused = false;
               element.bind('focus', function(evt) {
                     element.addClass(FOCUS_CLASS);
                     scope.$apply(function() {
                           ctrl.$focused = true;
                         });
                   }).bind('blur', function(evt) {
                     element.removeClass(FOCUS_CLASS);
                     scope.$apply(function() {
                           ctrl.$focused = false;
                         });
                   });
             }
       }
     }]);
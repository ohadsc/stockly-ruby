angular.module('myApp', [])

    .directive('tagList', [function () {
        debugger;
        return {
            require: 'ngModel',
            link: function (scope, elem, attrs, ngModel) {

                var toView = function (val) {
                    var result = (val || []).split(',');
                    console.log(result.toString());
                    return result;
                };



                var toModel = function (val) {
                    return (val || '').split(',').map(function (v) {
                        return v.trim();
                    });
                };

                var toModel2 = function (val) {
                    return val + "ohad";
                };

                ngModel.$formatters.unshift(toView);
                ngModel.$parsers.unshift(toModel);
                ngModel.$parsers.unshift(toModel2);

            }
        };
    }]);
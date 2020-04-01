(function (location, hostname, redirectURL, excludedPaths) {
    'use strict';
    var path = location.pathname.split('/').filter(function (el, i) {
        return el !== '';
    });
    if (location.hostname === hostname && excludedPaths.indexOf(path[ 0 ]) === -1) {
        location.replace(redirectURL);
    }
}(
    window.location,
    'minsida.malmo.se',
    'https://komin.malmo.se/',
    [ 'activities', 'api', 'api_apps', 'feeds', 'group_contacts', 'languages',
      'roles', 'shortcuts', 'skills', 'statistics', 'users' ]
));

// Use these for testing:
// 'minsidatest.malmo.se',
// 'https://komin.test.malmo.se/',

Global Assets
===============
City of Malmö’s external assets are served from a central asset host and are consumed by web applications on the organizations web sites. The assets contains a common base for the UI such as a masthead, footer, form styling, page layouts, styling for articles, widgets, and components.

Purpose of the Global Assets:

* It gives all web applications a consistent UI for the user.
* Common changes are deployed in one place and the changes are reflected immediately in all web applications.
* It decreases the load time for the end user since the majority of stylesheet and Javascript code will be cached in the browser instead of being fetch from each application.
* It speeds up development.

Apart from the common assets consumed by all applications, each application contains it’s own unique assets for additional features not included in the common assets. The application specific assets are served by the applications themselves.

For more information, contact webbteamet@malmo.se.

## How to Use the Assets
Instructions for how you use the global assets in your application is documented in City of Malmö's [Web Application Guidelines](https://malmostad.github.io/wag/).

## Dependencies for Development and Deployment
* [Vagrant](https://www.vagrantup.com/)
* A Vagrant compatible virtual machine. VirtualBox tested.

## Dependencies for Asset Hosting
A web server optimized to serve static files. Ruby is not needed on the server.


## Development Setup
We use [Puppet](https://puppetlabs.com/) in standalone mode to setup development environments, see [puppet-mcommons](https://github.com/malmostad/puppet-mcommons/) for in-depth details.

Development dependencies:

* [Vagrant](https://www.vagrantup.com/)
* A Vagrant compatible virtual machine such as VirtualBox or VMWare

To get the project files and create a Vagrant box with a ready-to-use development environment on your own machine, run the following commands:

```shell
$ git clone git@github.com:malmostad/global_assets.git
$ cd global_assets
$ vagrant up
```

Log in to the Vagrant box as the `vagrant` user and start the application in the Vagrant box:

```shell
$ vagrant ssh
$ cd /vagrant
```

Run some post install commands currently missing from the provisioning packages:

```shell
$ sudo apt-get install npm
$ sudo npm install -g grunt-cli
$ npm install
```

Start a local asset server:

```shell
$ bundle exec rails s -b 0.0.0.0
```

Point another local web applications link to the global assets at http://127.0.0.1:3039. Editing of the project files on your host system will be reflected when you hit reload in your browser.

When you run the `vagrant up` command for the first time it creates an Ubuntu 16.04 based Vagrant box with a ready-to-use development environment for the application. This will take some time. Vagrant will launch fast after the first run.

If you get port conflicts in your host system, change `forwarded_port` in the `Vagrantfile` You might also want to edit the value for `vm.hostname` and `puppet.facter` in the same file or do a mapping `localhost` mapping in your hosts `host` file to reflect that value.

You might need to map a domain name to your local host like `www.local.malmo.se` to debug and test the JavaScript code.

You can also point another locally installed web application to your started asset server or our Prototypes Jekyll application:

https://github.com/malmostad/prototypes

## Build and Deployment
Capistrano is used for build and deployment to the server from your local copy. Include the `AUDIENCE=internal|external` in the deployment command. `internal` is for the intranet version and `external` for public web sites.

```
$ AUDIENCE=internal bundle exec cap staging deploy
$ AUDIENCE=internal bundle exec cap production deploy
$ AUDIENCE=external bundle exec cap staging deploy
$ AUDIENCE=external bundle exec cap production deploy
```

The compression levels for CSS and Javascript files are configured in `config/environments/` for development, staging and production.


## Build Icons
[Grunticon](https://github.com/filamentgroup/grunticon) is used to compile SVG icons into CSS files with PNG fallbacks. Master SVG files is in `masters/icons` and the output goes to `app/assets/icons`. To setup Grunticon, make sure you have [Grunt](http://gruntjs.com/) installed and then run the following command in the project root:

To rebuild all icons, run:
```
$ grunt
```

A preview of the icons is generated in `app/assets/icons/preview.html`.


## Development

The assets contains Sass code compiled to CSS, Coffeescript compiled to JavaScript, web fonts and an icon font.

Fundamentals for the Global Assets:

* They must be highly optimized for load, execution and rendering speed.
* Have a long life cycle. The code from the asset host must be backward compatible for a long time since a lot of web application are consuming them and can’t be updated on a continues basis.
* There is no room for extensive testing of all consuming web applications. It just have to work.

### The Development Application
The Global Assets are developed using Sprockets and the Assets Pipeline in a stripped-down Ruby on Rails application. It is used in development and deployment but not in production. It can be used as a local asset server during development and when developing or adapting other applications for the The City of Malmo.

You must set a fully qualified domain name in the host file for your local development environment. such as `www.local.malmo.se`.

### Stylesheets
Stylesheets are written in Sass with the SCSS syntax and organized in smaller files. All files, except for IE specifics, are imported in the `malmo.css.scss` file. The files are served uncompressed in development and concatenated to one compressed file, `malmo.css` with a Rake task by Capistrano in the build process.

All sizes must be set in `em` or percentage units. Use the `emize()` Sass function from [`shared_assets`](https://github.com/malmostad/shared_assets) to get a consistent output for font sizes. Thin border widths can be declared with `1px`.

Do not set font sizes in global contexts, e.g. for all menus or for all `p` or `h1` elements. Specify it on a detailed level to avoid overrides and complex calculations that will break when the context is changed.

Do not use too deeply nested Sass blocks, this will make it hard to override the selectors in media queries.

The `columns()` mixin from [`shared_assets`](https://github.com/malmostad/shared_assets) is used to define responsive column layouts that and is altered in the media query file.

### Coffeescript
Use Coffeescript for JavaScript development and organize it in smaller files that will be imported in the malmo.js file using the Sprockets syntax. The files are automatically served as individual files in the development application for easy debugging and concatenated and compressed in the build phase.

### The Masthead and the footer
The common masthead and the footer that must be on every application page is found in `app/assets/content/[internal|external]masthead.html.erb`. The code is transformed to a Javascript string during the Capistrano build process for fast injection on every page or view. They are also built when you launch the servern in development mode.

### Icons
Use SVGs icons, not png images, sprites or icon fonts. See [Build Icons](#build-icons) above

### Gradients, Rounded Corners and Shadows
For gradients, rounded corners and related stuff, use CSS3. Use solid background colors as a fallback. Use the Sass mixins for vendor prefixes to keep the code clean.

### Frameworks and Third Party Code
Third party code resides in `vendor/assets`. The code is included in the global stylesheet and Javascript file in the development environment as well as in the build process.

Third party code and components are added to the Global Asets with caution, no brute force incorporation of frameworks and code without qualification. The City of Malmo’s Glboal Assets is an enterprise level solution and must be maintained with all consuming applications in mind.

## License
Released under AGPL version 3.

The `vendor` directory contains third party code that may be released under other licenses stated in the start of each file.

# Installation & Update

## Depenencies

`matestack-ui-vuejs` requires `matestack-ui-core`. Make sure to follow the install guide from https://docs.matestack.io/matestack-ui-core/getting-started/installation-update and understand the concepts of `matestack-ui-core`.

## Installation

Add 'matestack-ui-vuejs' to your Gemfile

```ruby
gem 'matestack-ui-vuejs'
```

and run

```text
$ bundle install
```

### Matestack Ui Core install steps (if not already happened)

Create a folder called 'matestack' in your app directory. All your Matestack apps, pages and components will be defined there.

```text
$ mkdir app/matestack
```

Add the Matestack helper to your controllers. If you want to make the helpers available in all controllers, add it to your 'ApplicationController' this way:

`app/controllers/application_controller.rb`

```ruby
class ApplicationController < ActionController::Base
  include Matestack::Ui::Core::Helper
  #...
end
```

### Rails 7 importmap based installation

will be shipped in `matestack-ui-vuejs` `3.1`

### Webpacker > 5.x based JavaScript installation

Add 'matestack-ui-vuejs' to your `package.json` by running:

```text
$ yarn add matestack-ui-vuejs
```

This adds the npm package that provides the JavaScript corresponding to the matestack-ui-vuejs Ruby gem. Make sure that the npm package version matches the gem version. To find out what gem version you are using, you may use `bundle info matestack-ui-vuejs`.

**Note**:

- vue3 dropped IE 11 support
- when using babel alongside webpacker, please adjust your package.json or .browserslistrc config in order to exclude IE 11 support:

```json
{
  "name": "my-app",
  "...": { },
  "browserslist": [
    "defaults",
    "not IE 11" // <-- important!
  ]
}
```

Otherwise you may encounter issues around `regeneratorRuntime` (especially when using Vuex)

Next, import and setup 'matestack-ui-vuejs' in your `app/javascript/packs/application.js`

```javascript
import { createApp } from 'vue'
import MatestackUiVueJs from 'matestack-ui-vuejs'

const appInstance = createApp({})

document.addEventListener('DOMContentLoaded', () => {
  MatestackUiVueJs.mount(appInstance)
})
```

and properly configure webpack:

`config/webpack/environment.js`
```js
const { environment } = require('@rails/webpacker')
const webpack = require('webpack');

const customWebpackConfig = {
  resolve: {
    alias: {
      vue: 'vue/dist/vue.esm-bundler',
    }
  },
  plugins: [
    new webpack.DefinePlugin({
      __VUE_OPTIONS_API__: true,
      __VUE_PROD_DEVTOOLS__: false
    })
  ]
}

environment.config.merge(customWebpackConfig)

module.exports = environment
```

(don't forget to restart webpacker when changing this file!)


and then finally compile the JavaScript code with webpack:

```text
$ bin/webpack --watch
```

{% hint style="warning" %}
When you update the `matestack-ui-vuejs` Ruby gem, make sure to update the npm package as well!
{% endhint %}

### Usage with Turbolinks/Turbo

If you want to use `matestack-ui-vuejs` alongside with Turbolinks or Turbo, please add:

```bash
yarn add vue-turbolinks
```

And use following snippet instead:

```javascript
import { createApp } from 'vue'
import MatestackUiVueJs from 'matestack-ui-vuejs'
import TurbolinksAdapter from 'vue-turbolinks'; // import vue-turbolinks

const appInstance = createApp({})

appInstance.use(TurbolinksAdapter); // tell Vue to use it

// change the trigger event
document.addEventListener('turbolinks:load', () => {
  MatestackUiVueJs.mount(appInstance)
})

```

### Application layout adjustments

You need to add the ID "matestack-ui" to some part of your application layout \(or any layout you use\). That's required for Matestack's Vue.js to work properly!

For Example, your `app/views/layouts/application.html.erb` should look like this:

```markup
<!DOCTYPE html>
<html>
  <head>
    <title>My App</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag    'application', media: 'all' %>

    <!-- if you are using webpacker: -->
    <%= javascript_pack_tag 'application' %>

    <!-- if you are using the asset pipeline: -->
    <%= javascript_include_tag 'application' %>
  </head>

  <body>
    <div id="matestack-ui">
      <%= yield %>
    </div>
  </body>
</html>
```

{% hint style="warning" %}
Don't apply the "matestack-ui" id to the body tag.
{% endhint %}

### ActionCable Integration

Some of Matestack's reactive components may be used with or require ActionCable. If you want to use ActionCable, please read the action cable guide:

{% page-ref page="../integrations/action-cable.md" %}

## Update

### Ruby Gem

Depending on the entry in your Gemfile, you might need to adjust the allowed version ranges in order to update the Gem. After checked and adjusted the version ranges, run:

```bash
bundle update matestack-ui-vuejs
```

and then check the installed version:

```bash
bundle info matestack-ui-vuejs
```

If you've installed the JavaScript dependecies via Yarn/Webpacker you need to update the JavaScript assets via yarn:

```bash
yarn update matestack-ui-vuejs
```

and finally check if the correct version is installed:

```bash
yarn list --pattern "matestack-ui-vuejs"
```

{% hint style="warning" %}
The Ruby gem version and the npm package version should match!
{% endhint %}

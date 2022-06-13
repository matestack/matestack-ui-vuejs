# Installation & Update

## Depenencies

`matestack-ui-vuejs` requires `matestack-ui-core`. Make sure to follow the install guide from https://docs.matestack.io/matestack-ui-core/getting-started/installation-update and understand the concepts of `matestack-ui-core`.

## Installation

Add 'matestack-ui-vuejs' to your Gemfile

```ruby
gem 'matestack-ui-vuejs', "~> 3.1.0"
```

and run

```
$ bundle install
```

### Matestack Ui Core install steps (if not already happened)

Create a folder called 'matestack' in your app directory. All your Matestack apps, pages and components will be defined there.

```
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

### Application layout adjustments

You need to add the ID "matestack-ui" to some part of your application layout (or any layout you use). That's required for Matestack's Vue.js to work properly!

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

    <!-- if you are using importmap: -->
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <div id="matestack-ui" v-cloak>
      <%= yield %>
    </div>
  </body>
</html>
```

{% hint style="warning" %}
Don't apply the "matestack-ui" id to the body tag.
{% endhint %}

{% hint style="success" %}
`v-cloak` is used to avoid to hide un-compiled Vuejs templates until they are ready when using a CSS rule like:

```css
[v-cloak] {
  display: none;
}
```



This is optional but highly recommended for a better UI experience. More info here: [https://vuejs.org/api/built-in-directives.html#v-cloak](https://vuejs.org/api/built-in-directives.html#v-cloak)
{% endhint %}

### JavaScript installation

#### Webpacker > 5.x based JavaScript installation

{% content-ref url="webpacker-install-steps.md" %}
[webpacker-install-steps.md](webpacker-install-steps.md)
{% endcontent-ref %}

#### Rails 7 importmap based JavaScript installation

{% content-ref url="importmap-install-steps.md" %}
[importmap-install-steps.md](importmap-install-steps.md)
{% endcontent-ref %}

#### JSBundling-Rails based JavaScript installation

{% content-ref url="jsbundling-rails-install.md" %}
[jsbundling-rails-install.md](jsbundling-rails-install.md)
{% endcontent-ref %}

### Usage with Turbolinks

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

### Usage with Turbo

Not tested yet!

```javascript
import { createApp } from 'vue'
import MatestackUiVueJs from 'matestack-ui-vuejs'

const appInstance = createApp({})

// change the trigger event
document.addEventListener('turbo:load', () => {
  MatestackUiVueJs.mount(appInstance)
}
```

### ActionCable Integration

Some of Matestack's reactive components may be used with or require ActionCable. If you want to use ActionCable, please read the action cable guide:

{% content-ref url="../../integrations/action-cable.md" %}
[action-cable.md](../../integrations/action-cable.md)
{% endcontent-ref %}

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

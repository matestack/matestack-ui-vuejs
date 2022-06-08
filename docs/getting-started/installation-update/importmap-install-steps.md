---
description: shipped in matestack-ui-vuejs 3.1
---

# Importmap Install Steps

### Asset Path

`config/initializers/assets.rb`

```ruby
Rails.application.config.assets.paths << Rails.root.join("app/matestack")
```

### Cache Sweeper Path

`config/environments/development.rb`

```ruby
config.importmap.cache_sweepers << Rails.root.join("app/matestack")
```

### Assets Manifest

`app/assets/config/manifest.js`

```javascript
// ...
//= link_tree ../../matestack .js
```

### Pins

Add the pins manually!

`config/importmap.rb`

```ruby
# other pins...
pin "vue", to: "https://ga.jspm.io/npm:vue@3.2.31/dist/vue.esm-browser.js" if Rails.env.development?
pin "vue", to: "https://ga.jspm.io/npm:vue@3.2.31/dist/vue.esm-browser.prod.js" if Rails.env.production?
pin "matestack-ui-vuejs", to: "https://cdn.jsdelivr.net/npm/matestack-ui-vuejs@3.1.0/dist/matestack-ui-vuejs.esm.js" # jspm currently not working

# optional custom components
pin "some_other_component", to: "components/some_other_component.js" # do not prefix app/matestack!
pin "demo_component", to: "demo/demo_component.js" # do not prefix app/matestack!
```

### Usage

Import and setup 'matestack-ui-vuejs' in your `app/javascript/packs/application.js`

```javascript
import { createApp } from 'vue'
import MatestackUiVueJs from 'matestack-ui-vuejs'

// optionally import custom components
import someOtherComponent from 'some_other_component' // import component definition from source
import demoComponent from 'demo_component' // import component definition from source

const appInstance = createApp({})

// optionally register custom components
appInstance.component('some-other-component', someOtherComponent) // register at appInstance
appInstance.component('demo-component', demoComponent) // register at appInstance

document.addEventListener('DOMContentLoaded', () => {
  MatestackUiVueJs.mount(appInstance)
})
```

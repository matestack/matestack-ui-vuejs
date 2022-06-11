# Custom Vue.js Components

In order to equip a Ruby component with some JavaScript, we associate the Ruby component with a Vue.js JavaScript component. The Ruby component therefore needs to inherit from `Matestack::Ui::VueJsComponent`. Matestack will then render a HTML component tag with some special attributes and props around the response defined in the Ruby component. The Vue.js JavaScript component (defined in a separate JavaScript file and managed via Webpacker) will treat the response of the Ruby component as its template.

## Structure, files and registry

A Vue.js component is defined by two files. A Ruby file and a JavaScript file:

### Vue.js Ruby component

Within the Ruby file, the Ruby class inherits from `Matestack::Ui::VueJsComponent`:

`app/matestack/components/some_component.rb`

```ruby
class SomeComponent < Matestack::Ui::VueJsComponent

  vue_name "some-component"

  def response
    div class: "some-root-element" do
      plain "hello {{ vc.foo }}!"
    end
  end

end
```

Following the rule of Vue.js, the response of the component has to consist of exactly one root element! Disregarding this rule will lead to Vue.js errors in the browser.

### Vue.js JavaScript component

The Vue.js JavaScript component is defined in a separate JavaScript file:

`app/matestack/components/some_component.js`

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

const someComponent = {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {
      foo: "bar"
    };
  },
  mounted(){
    console.log(this.foo)
  }
}

export default someComponent
```

It can be placed anywhere in your apps folder structure, but we recommend to put it right next to the Ruby component file.

{% hint style="info" %}
The Vue.js JavaScript file needs to be imported by some kind of JavaScript package manager.
{% endhint %}

For **Webpacker** it would look like this: **(follow the install guide!)**

`app/javascript/packs/application.js`

```javascript
import { createApp } from 'vue'
import MatestackUiVueJs from 'matestack-ui-vuejs'

import someComponent from '../../../app/matestack/components/some_component' // import component definition from source

const appInstance = createApp({})

appInstance.component('some-component', someComponent) // register at appInstance

document.addEventListener('DOMContentLoaded', () => {
  MatestackUiVueJs.mount(appInstance)
})
```

For **Importmap** it would like this: **(follow the install guide!)**

`config/importmap.rb`

```ruby
# other pins ...
pin "some_component", to: "components/some_component.js" # do not prefix app/matestack!
```

`app/javascript/packs/application.js`

```javascript
import { createApp } from 'vue'
import MatestackUiVueJs from 'matestack-ui-vuejs'

import someComponent from 'some_component' // import component definition from source

const appInstance = createApp({})

appInstance.component('some-component', someComponent) // register at appInstance

document.addEventListener('DOMContentLoaded', () => {
  MatestackUiVueJs.mount(appInstance)
})
```

**In both cases:**

If setup correctly, Matestack will render the component to:

```markup
<component is='some-component' :props='{}' :params='{}'>
  <matestack-component-tempate>
    <div class="some-root-element">
      hello {{ vc.foo }}!
    </div>
  </matestack-component-tempate>
</component>
```

As you can see, the component tag is referencing the Vue.js JavaScript component via `is` and tells the JavaScript component that it should use the inner html (coming from the `response` method) as the template of the component.

`{{ vc.foo }}` will be evaluated to "bar" as soon as Vue.js has booted and mounted the component in the browser. `{{ foo }}` is not working!

The prefix `vc.` is short for `Vue Component` and is necessary for referencing the correct component scope. Within the JavaScript file, you still simply use `this.` The prefix is required since Vue 3 removed proper inline template support. Behind the scenes MatestackUiVueJs is using Vue's `default slot` mechanism in order to enable inline templates.

Matestack will inject JSON objects into the Vue.js JavaScript component through the `props` and `params` tags if either props or params are available. This data is injected once on initial server side rendering of the component's markup. See below, how you can pass in data to the Vue.js JavaScript component.

## Vue.js Ruby component API

### Same as component

The basic Vue.js Ruby component API is the same as described within the [component API documenation](../ui-in-pure-ruby/components/component-api.md). The options below extend this API.

### Referencing the Vue.js JavaScript component

As seen above, the Vue.js JavaScript component name has to be referenced in the Vue.js Ruby component using the `vue_name` class method

`app/matestack/components/some_component.rb`

```ruby
class SomeComponent < Matestack::Ui::VueJsComponent

  vue_name "some-component"

  #...
end
```

{% hint style="info" %}
`vue_name` should match the name your registered the Vue JS component with on the Vue app instance.
{% endhint %}

### Passing data to the Vue.js JavaScript component

Like seen above, matestack renders a `component-config` prop as an attribute of the component tag. In order to fill in some date there, you should use the `setup` method like this:

`app/matestack/components/some_component.rb`

```ruby
class SomeComponent < Matestack::Ui::VueJsComponent

  vue_name "some-component"

  def vue_props
    {
      some_serverside_data: "bar"
    }
  end

end
```

This data is then available as:

```javascript
this.props["some_serverside_data"]
```

within the Vue.js JavaScript component.

## Vue.js JavaScript component API

### Component mixin and template

`app/matestack/components/some_component.js`

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

const someCompoent = {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  //...
};

//...
```

Please make sure to integrate the `componentMixin` and `template` which gives the JavaScript component some essential functionalities in order to work properly within MatestackUiVueJs.

### Params

If any query params are given in the URL, the JavaScript component can access them via:

```javascript
this.params
```

within the JavaScript component.

### Vue.js API

As we're pretty much implementing pure Vue.js components, you can refer to the [Vue.js guides](https://vuejs.org/v3/guide/) in order to learn more about Vue.js component usage.

**Please note the following differences from the original Vue.js API:**

#### component $refs

* use `this.getRefs()` instead of `this.$refs`
* use `matestack_ui_vuejs_ref()` when applying refs to your componen template:

```ruby
def response
    # ...
    div ref: "some-ref" # <-- not picked up by this.getRefs()
    # ...
    div "matestack-ui-vuejs-ref": matestack_ui_vuejs_ref('some-ref')
end
```

#### component $el

* use `this.getElement()` instead of `this.$el` in order to get the root element defined in your `response` method

#### component template/root element

* use `this.getTemplateElement()` in order to get the template element wrapping the root element defined in your `response` method

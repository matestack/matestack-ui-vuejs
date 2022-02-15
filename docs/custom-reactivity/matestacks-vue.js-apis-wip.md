# Matestack's Vue.js APIs \[WIP]

## Event Hub

Matestack offers an event hub, which can be used to communicate between components.

### Emitting events

`app/matestack/components/some_component.js`

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

const someComponent = {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {}
  },
  mounted(){
    MatestackUiVueJs.eventHub.$emit("some-event", { some: "optional data" })
  }
}
export default someComponent
```

Use `MatestackUiVueJs.eventHub.$emit(EVENT_NAME, OPTIONAL PAYLOAD)`

### Receiving events

`app/matestack/components/some_component.js`

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

const someComponent =  {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {}
  },
  methods: {
    reactToEvent(payload){
      console.log(payload)
    }
  },
  mounted(){
    MatestackUiVueJs.eventHub.$on("some-event", this.reactToEvent)
  },
  beforeUnmount(){
    MatestackUiVueJs.eventHub.$off("some-event", this.reactToEvent)
  }
}
export default someComponent
```

Make sure to cancel the event listener within the `beforeUnmount` hook!

## General Vue.js API

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

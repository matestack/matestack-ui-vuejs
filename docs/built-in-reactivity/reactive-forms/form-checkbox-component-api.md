# Checkbox Component API

The `form_checkbox` component is Vue.js driven child component of the `form` component and is used to collect user input.

```ruby
matestack_form my_form_config do
  form_checkbox key: :status, #...
end
```

## Parameters

### key - required

Defines the key which should be used when posting the form data to the server.

### options

Can either be nil, an Array or Hash:

**When not given**

```ruby
matestack_form my_form_config do
  form_checkbox key: :status, label: "Active"
end
```

will render a single checkbox which can switch between `true` and `false` as value for the given key. Will be `nil` initially. The boolean value (or nil) will be sent to the server when submitting the form.

**Array usage**

```ruby
matestack_form my_form_config do
  form_checkbox key: :status, options: [0, 1]
end
```

will render a collection of checkboxes and their corresponding labels.

Multiple checkboxes can be selected. Data will be sent as an Array of selected values to the server when submitting the form.

**Hash usage**

```ruby
matestack_form my_form_config do
  form_checkbox key: :status, options: { 'active': 1, 'deactive': 0 }
end
```

will render a collection of checkboxes and their corresponding labels.

The hash values will be used as values for the checkboxes, the keys as displayed label values.

Multiple checkboxes can be selected. Data will be sent as an Array of selected values to the server when submitting the form.

**ActiveRecord Enum Mapping**

If you want to use ActiveRecord enums as options for your radio input, you can use the enum class method:

```ruby
class Conversation < ActiveRecord::Base
  enum status: { active: 0, archived: 1 }
end
```

```ruby
matestack_form my_form_config do
  form_checkbox key: :status, options: Conversation.statuses
end
```

Multiple checkboxes can be selected. Data will be sent as an Array of selected values to the server when submitting the form.

### disabled\_values

NOT IMPLEMENTED YET

### init

NOT IMPLEMENTED YET

### label

An applied label is only visible, when using a single checkbox without options.

You can also use the `label` component in order to create a label for this input.

## Custom Checkbox

If you want to create your own radio component, that's easily done since `v.1.3.0`.

* Create your own Ruby component:

`app/matestack/components/my_form_checkbox.rb`

```ruby
class Components::MyFormCheckbox < Matestack::Ui::VueJs::Components::Form::Checkbox

  vue_name "my-form-checkbox"

  # optionally add some data here, which will be accessible within your Vue.js component
  def vue_props
    {
      foo: "bar"
    }
  end

  def response
    # exactly one root element is required since this is a Vue.js component template
    div class: "your-custom-markup" do
      render_options
      render_errors
    end
  end

end
```

* Create the corresponding Vue.js component:

Generic code:

`app/matestack/components/my_form_checkbox.js`

```javascript
const myFormCheckbox = {
  mixins: [MatestackUiVueJs.componentMixin, MatestackUiVueJs.formCheckboxMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {};
  },
  methods: {
    afterInitialize: function(value){
      // optional: if you need to modify the initial value
      // use this.setValue(xyz) in order to change the value
      // this method can be used in other methods or mounted hook of this component as well!
      this.setValue(xyz)
    }
  },
  mounted: function(){
    // use/initialize any third party library here
    // you can access the default initial value via this.componentConfig["init_value"]
    // if you need to, you can access your own component config data which added
    // within the prepare method of the corresponding Ruby class
    // this.props["foo"] would be "bar" in this case
  }
}

export default myFormCheckbox

// and register in your application js file like:
appInstance.component('my-form-checkbox', myFormCheckbox) // register at appInstance
```

* Don't forget to require and register the custom component JavaScript according to your JS setup!
* Finally, use it within a `matestack_form`:

```ruby
matestack_form some_form_config do
  Components::MyFormCheckbox.call(key: :foo, options: [1,2,3])
end
```

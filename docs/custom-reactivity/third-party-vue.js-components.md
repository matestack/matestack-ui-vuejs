# Third party Vue.js Components \[WIP]

Using a third party Vue.js component based on an example integrating [https://soal.github.io/vue-mapbox/](https://soal.github.io/vue-mapbox/)

{% hint style="danger" %}
Untested!
{% endhint %}

## Ruby Component

```ruby
class Components::MglMap < Matestack::Ui::VueJsComponent

  vue_name "mgl-map-component"

  optional :custom_map_style_hash

  def response
    plain tag.mglmap(":accessToken": "#{access_token}", "mapStyle": "#{map_style}")
  end

  private

    def access_token
      get_global_access_token_from_env
      #...
    end

    def map_style
      some_global_map_style_hash.merge!(context.custom_map_style_hash)
      #...
    end
end
```

## Vue.js Component

```javascript
import MatestackUiVueJs from "matestack-ui-vuejs";

import Mapbox from "mapbox-gl";
import { MglMap } from "vue-mapbox";

const mglMapComponent = {
  mixins: [MatestackUiVueJs.componentMixin],
  template: MatestackUiVueJs.componentHelpers.inlineTemplate,
  data() {
    return {
      mapbox: undefined
    };
  },
  created(){
    this.mapbox = Mapbox;
  }
}
export default mglMapComponent

// and register in your application js file like:
appInstance.component('mgl-map-component', mglMapComponent) // register at appInstance
```

## Usage

```ruby
class SomePage < Matestack::Ui::Page

  def response
    div class: "some-layout" do
      Components::MglMap.call(custom_map_style_hash: { ... })
    end
  end

end
```

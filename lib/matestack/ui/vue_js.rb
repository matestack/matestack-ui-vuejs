require "matestack/ui/core"

vue_js_base_path = 'matestack/ui/vue_js'
module Matestack
  module Ui
    module VueJs

    end
  end
end

require "#{vue_js_base_path}/version"

require "#{vue_js_base_path}/vue_attributes"
require "#{vue_js_base_path}/vue"
require "#{vue_js_base_path}/helper"
require "#{vue_js_base_path}/components/app"
require "#{vue_js_base_path}/components/page_switch"
require "#{vue_js_base_path}/components/toggle"
require "#{vue_js_base_path}/components/onclick"
require "#{vue_js_base_path}/components/transition"
require "#{vue_js_base_path}/components/async"
require "#{vue_js_base_path}/components/action"
require "#{vue_js_base_path}/components/cable"
require "#{vue_js_base_path}/components/draggable"
require "#{vue_js_base_path}/components/drop_zone"
require "#{vue_js_base_path}/components/isolated"
require "#{vue_js_base_path}/components/form/context"
require "#{vue_js_base_path}/components/form/base"
require "#{vue_js_base_path}/components/form/form"
require "#{vue_js_base_path}/components/form/nested_form"
require "#{vue_js_base_path}/components/form/input"
require "#{vue_js_base_path}/components/form/textarea"
require "#{vue_js_base_path}/components/form/checkbox"
require "#{vue_js_base_path}/components/form/radio"
require "#{vue_js_base_path}/components/form/select"
require "#{vue_js_base_path}/components/form/fields_for_remove_item"
require "#{vue_js_base_path}/components/form/fields_for_add_item"
require "#{vue_js_base_path}/components/collection/helper"
require "#{vue_js_base_path}/components/collection/content"
require "#{vue_js_base_path}/components/collection/filter"
require "#{vue_js_base_path}/components/collection/filter_reset"
require "#{vue_js_base_path}/components/collection/next"
require "#{vue_js_base_path}/components/collection/order"
require "#{vue_js_base_path}/components/collection/order_toggle"
require "#{vue_js_base_path}/components/collection/order_toggle_indicator"
require "#{vue_js_base_path}/components/collection/page"
require "#{vue_js_base_path}/components/collection/previous"
require "#{vue_js_base_path}/components"
require "#{vue_js_base_path}/initialize"

# require abbreveations for apps, pages and components
require "matestack/ui/vue_js_component"
require "matestack/ui/isolated_component"

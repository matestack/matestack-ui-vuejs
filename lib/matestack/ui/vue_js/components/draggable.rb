module Matestack
  module Ui
    module VueJs
      module Components
        class Draggable < Matestack::Ui::VueJs::Vue

          vue_name "matestack-ui-core-draggable"

          required :draggable_id
          required :drag_key

          def response
            div options.merge({
              ":draggable": "true",
              "@dragstart": "vc.onDragStart($event)",
              "@dragend": "vc.onDragEnd($event)"}) do
                yield
            end
          end

          private

          def vue_props
            {}.tap do |conf|
              conf[:draggable_id] = ctx.draggable_id
              conf[:drag_key] = ctx.drag_key
              conf[:emit_on_drag_start] = "#{ctx.drag_key}_drag_start" if ctx.drag_key
              conf[:emit_on_drag_end] = "#{ctx.drag_key}_drag_end" if ctx.drag_key
            end
          end

        end
      end
    end
  end
end

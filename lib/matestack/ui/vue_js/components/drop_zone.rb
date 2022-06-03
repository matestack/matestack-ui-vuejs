module Matestack
  module Ui
    module VueJs
      module Components
        class DropZone < Matestack::Ui::VueJs::Vue

          vue_name "matestack-ui-core-drop-zone"

          required :path, :drag_key
          optional :success, :failure, :data, :emit
          optional :highlight_class, :hover_class

          def response
            div options.merge({
              "@drop": "vc.onDrop($event)",
              "@dragenter": "vc.onDragEnter($event)",
              "@dragover": "vc.onDragOver($event)",
              "@dragleave": "vc.onDragLeave($event)",
              ":class": "[vc.highlighted ? vc.getHighlightClass() : '', vc.hovered ? vc.getHoveredClass() : '']"}) do
                yield
            end
          end

          private

          def vue_props
            {}.tap do |conf|
              conf[:path] = ctx.path
              conf[:method] = drop_method
              conf[:success] = ctx.success
              conf[:failure] = ctx.failure
              conf[:data] = ctx.data
              conf[:emit] = ctx.emit
              conf[:drag_key] = ctx.drag_key
              conf[:highlight_on] = "#{ctx.drag_key}_drag_start" if ctx.highlight_class
              conf[:disable_highlight_on] = "#{ctx.drag_key}_drag_end" if ctx.highlight_class
              conf[:highlight_class] = ctx.highlight_class
              conf[:hover_class] = ctx.hover_class
            end
          end

          def drop_method
            @drop_method ||= options.delete(:method)
          end

        end
      end
    end
  end
end

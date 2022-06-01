# overwriting core helper in order to extend request differentiation

module Matestack
  module Ui
    module Core
      module Helper

        def render(*args)
          setup_context
          if args.first.is_a?(Class) && args.first.ancestors.include?(Base)
            raise 'expected a hash as second argument' unless args.second.is_a?(Hash) || args.second.nil?

            begin
              controller_layout = self.class.send(:_layout)
            rescue
              controller_layout = nil
            end

            options = args.second || {}
            layout = options.delete(:matestack_layout) || self.class.matestack_layout
            page = args.first

            if controller_layout == false
              root_layout = layout ? layout.layout : false
            else
              # when using the turbo-rails gem, controller_layout is a Proc
              # https://github.com/hotwired/turbo-rails/blob/v1.0.1/app/controllers/turbo/frames/frame_request.rb#L16
              # and not nil or a string indicating which layout to be used like before
              if controller_layout.nil? || controller_layout.is_a?(Proc)
                root_layout = "application"
              else
                root_layout = controller_layout
              end
            end

            if layout && params[:only_page].nil? && params[:component_key].nil? && params[:component_class].nil?
              render_layout layout, page, options, root_layout
            else
              if params[:component_key] && params[:component_class].nil?
                render_component_within_page layout, page, params[:component_key], options
              elsif params[:component_class]
                if params[:component_key]
                  render_component_within_isolated_component(
                    params[:component_class].constantize,
                    params[:component_key],
                    public_context: JSON.parse(params[:public_context] || '{}')
                  )
                else
                  render html: params[:component_class].constantize.(public_context: JSON.parse(params[:public_context] || '{}'))
                end
              else
                if params[:only_page]
                  render_page page, options, false
                else
                  render_page page, options, root_layout
                end
              end
            end
          else
            super
          end
        end

        def render_component_within_page(layout, page, component_key, options)
          layout ? layout.new(options) { page.new(options) } : page.new(options) # create page structure in order to later access registered async components
          render html: Matestack::Ui::Core::Context.async_components[component_key].render_content.html_safe, layout: false
        end

        def render_component_within_isolated_component(isolated_component, component_key, options)
          isolated_component.new(nil, nil, options) # create isolated_component structure in order to later access registered async components
          render html: Matestack::Ui::Core::Context.async_components[component_key].render_content.html_safe, layout: false
        end

      end
    end
  end
end

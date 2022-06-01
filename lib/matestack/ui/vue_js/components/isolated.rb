module Matestack
  module Ui
    module VueJs
      module Components
        class Isolated < Matestack::Ui::VueJs::Vue
          vue_name 'matestack-ui-core-isolate'

          optional :defer, :init_on, :public_options, :public_context, :rerender_on, :rerender_delay, :replace_on

          def initialize(html_tag = nil, text = nil, options = {}, &block)
            extract_options(text, options)
            only_public_context!
            isolated_parent = Matestack::Ui::Core::Context.isolated_parent
            Matestack::Ui::Core::Context.isolated_parent = self
            super(html_tag, text, options, &block)
            Matestack::Ui::Core::Context.isolated_parent = isolated_parent
          end

          def create_children
            # content only should be rendered if param :component_class is present
            warn "[WARNING] '#{self.class}' was accessed but not authorized" unless authorized?
            if params[:component_class].present?
              self.response if authorized?
            else
              self.isolated do
                self.response if authorized?
              end
            end
          end

          def isolated
            vue_component do
              div class: 'matestack-isolated-component-container', 'v-bind:class': '{ loading: vc.loading === true }' do
                if self.respond_to? :loading_state_element
                  div class: 'loading-state-element-wrapper', 'v-bind:class': '{ loading: vc.loading === true }' do
                    loading_state_element
                  end
                end
                unless ctx.defer || ctx.init_on
                  div class: 'matestack-isolated-component-wrapper', 'v-if': 'vc.isolatedTemplate == null', 'v-bind:class': '{ loading: vc.loading === true }', 'v-show': '!vc.hideCurrentContent' do
                    div class: 'matestack-isolated-component-root' do
                      yield
                    end
                  end
                end
                div class: 'matestack-isolated-component-wrapper', 'v-if': 'vc.isolatedTemplate != null', 'v-bind:class': '{ loading: vc.loading === true }', 'v-show': '!vc.hideCurrentContent' do
                  div class: 'matestack-isolated-component-root' do
                    Matestack::Ui::Core::Base.new('matestack-ui-core-runtime-render', ':template': 'vc.isolatedTemplate', ':vc': 'vc')
                  end
                end
              end
            end
          end

          def vue_props
            {
              component_class: self.class.name,
              public_context: ctx.public_context,
              defer: ctx.defer,
              rerender_on: ctx.rerender_on,
              replace_on: ctx.replace_on,
              rerender_delay: ctx.rerender_delay,
              init_on: ctx.init_on,
            }
          end

          # will be depracted in the future, just here in order to not have a breaking change
          # public_context is the new way to access the context within an isolated component
          def public_options
            ctx.public_options || {}
          end

          def public_context
            @public_context ||= OpenStruct.new(ctx.public_context || {})
          end

          def authorized?
            raise "'authorized?' needs to be implemented by '#{self.class}'"
          end

          def only_public_context!
            if self.options.except(:defer, :init_on, :public_options, :public_context, :rerender_on, :rerender_delay, :replace_on).keys.any?
              error_message = "isolated components can only take params in a public_options hash, which will be exposed to the client side in order to perform an async request with these params."
              error_message << " Check your usages of '#{self.class}' components"
              raise error_message
            end
          end

        end
      end
    end
  end
end

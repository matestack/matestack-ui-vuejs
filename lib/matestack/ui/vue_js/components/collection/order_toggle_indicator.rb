module Matestack
  module Ui
    module VueJs
      module Components
        module Collection
          class OrderToggleIndicator < Matestack::Ui::Component
            required :key
            optional :default, :asc, :desc

            def response
              span do
                span "v-if": "vc.isDefaultOrdering('#{ctx.key}')" do
                  render_slot_or_plaintext(:default)
                end
                span "v-if": "vc.isAscendingOrdering('#{ctx.key}')" do
                  render_slot_or_plaintext(:asc)
                end
                span "v-if": "vc.isDescendingOrdering('#{ctx.key}')" do
                  render_slot_or_plaintext(:desc)
                end
              end
            end

            private

            def render_slot_or_plaintext(key)
              if slots && slots[key]
                slot key
              else
                plain ctx.send(key)
              end
            end
          end
        end
      end
    end
  end
end

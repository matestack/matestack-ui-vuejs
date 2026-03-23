# Support propper mapping of errors on existing nested models in nested forms
# https://github.com/rails/rails/issues/24390#issuecomment-703708842
#
# NOTE: This patch was required for Rails < 6. In Rails 8, association_valid? signature
# changed to (association, record) - no index argument. The index_errors: true option
# on the association now handles error indexing natively, making this patch unnecessary.


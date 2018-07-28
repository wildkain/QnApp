ThinkingSphinx::Index.define :user, with: :active_record do
  #fields for search
  indexes email, sortable: true

  #attributes for sorting, group_by  etc.
  has created_at, updated_at
end

ThinkingSphinx::Index.define :comment, with: :active_record do
  #fields for search
  indexes body
  indexes user.email, as: :author, sortable: true

  #attributes for sorting, group_by  etc.
  has user_id, commentable_id, created_at, updated_at
end
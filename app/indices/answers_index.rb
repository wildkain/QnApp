ThinkingSphinx::Index.define :answer, with: :active_record do
  #fields for search
  indexes body, sortable: true
  indexes user.email, as: :author, soratble: true

  #attributes for sorting, group_by  etc.
  has user_id, created_at, updated_at
end
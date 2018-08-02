class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true, optional: true, touch: true
  mount_uploader :file, FileUploader
end

module Qblox
  class Blob < Qblox::Base
    attr_accessor(:blob_status, :content_type, :created_at, :id,
                  :last_read_access_ts, :lifetime, :name, :public,
                  :ref_count, :set_completed_at, :size, :uid, :updated_at)
    def self.create(file_path, content_type: nil, name: nil, token: )
      api = Qblox::Api::Blob.new(token: token)
      data = api.create(name: name, content_type: content_type)
      if length = api.upload_file(file_path, data['blob']['blob_object_access'])
        data = api.complete(data['blob']['id'], length)
        return self.new data
      end
    end
  end
end

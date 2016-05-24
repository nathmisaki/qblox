module Qblox
  class Blob < Qblox::Base
    attr_accessor(:blob_status, :content_type, :created_at, :id,
                  :last_read_access_ts, :lifetime, :name, :public,
                  :ref_count, :set_completed_at, :size, :uid, :updated_at)
    def self.create(file_path, content_type: nil, name: nil, token: )
      api = Qblox::Api::Blob.new(token: token)
      data = api.create(name: name, content_type: content_type)
      length = api.upload_file(file_path, data['blob']['blob_object_access'])
      return unless length
      return unless api.complete(data['blob']['id'], length)
      self.new(api.show(data['blob']['id'])['blob'])
    end

    def self.find(id, token:)
      api = Qblox::Api::Blob.new(token: token)
      self.new(api.show(id)['blob'])
    end

    def download_url(token: nil)
      if @public
        api = Qblox::Api::Blob.new(token: false)
      else
        api = Qblox::Api::Blob.new(token: token)
      end
      api.download_url(id: id)
    end

    def type
      case content_type
      when /image/ then
        'image'
      when /video/ then
        'video'
      when /audio/ then
        'audio'
      else
        'file'
      end
    end
  end
end

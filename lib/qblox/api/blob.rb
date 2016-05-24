require 'cgi'
require 'uri'
require 'open-uri'
require 'tmpdir'
module Qblox
  module Api
    # Content API
    # http://quickblox.com/developers/Content#Requests_and_Responses
    class Blob < Connections::ApiEndpoint
      include RequireUserSession
      @path = 'blobs'

      def create(data = {})
        @params = data
        validate_params(@params)
        response = query(:post) do |req|
          req.params = { blob: @params }
        end
        json_parse(response.body)
      end

      def upload_file(file_path, blob_object_access)
        if File.exists?(file_path)
          upload_local_file(file_path, blob_object_access)
        else
          upload_file_from_remote(file_path, blob_object_access)
        end
      end

      def update(blob_id, data={})
        response = query(:put) do |req|
          req.url url(id: blob_id)
          req.params = { blob: data }
        end
        json_parse(response.body)
      end

      def complete(blob_id, size)
        response = query(:put) do |req|
          req.url(
            url(id: blob_id, custom_action: '/complete'),
            { blob: { size: size } })
        end
        return response.status == 200
      end

      def show(blob_id)
        response = query(:get) do |req|
          req.url url(id: blob_id)
        end
        json_parse(response.body)
      end

      def download_url(id: nil, uid: nil)
        return download_url_by_id(id) if id
        return download_url_by_uid(uid) if uid
      end

      def download_url_by_id(id)
        response = query(:get) do |req|
          req.url url(id: id, custom_action: '/download')
        end
        return response.headers['location'] if response.status == 302
      end

      def download_url_by_uid(uid)
        response = query(:get) do |req|
          req.url url(id: uid)
        end
        return response.headers['location'] if response.status == 302
      end

      private

      def upload_local_file(file_path, blob_object_access)
        uri = URI.parse(blob_object_access['params'])
        params = CGI.parse(uri.query)
        params = Hash[params.map { |k, v| [k, v.size == 1 ? v.first : v] }]

        multiconn = Faraday.new(url: "#{uri.scheme}://#{uri.host}") do |conn|
          conn.request :multipart
          conn.adapter Faraday.default_adapter # make requests with Net::HTTP
        end

        file = Faraday::UploadIO.new(file_path, params['Content-Type'])

        response = multiconn.post(uri.path, params.merge(file: file))
        puts response.inspect
        return file.size if response.status == 201
      end

      def upload_file_from_remote(url, blob_object_access)
        base = File.basename url
        random = rand(100000000000000000000).to_s(36)
        Dir.mktmpdir do |dir|
          Dir.mkdir("#{dir}/#{random}")
          local_file = File.expand_path("#{dir}/#{random}/#{base}")
          File.open(local_file, "wb") do |saved_file|
            # the following "open" is provided by open-uri
            open(url, "rb") do |read_file|
              saved_file.write(read_file.read)
            end
          end
          upload_local_file(local_file, blob_object_access)
        end
      end

      def validate_params(data)
        fail ArgumentError, 'content_type required' if data[:content_type].nil?
        fail ArgumentError, 'name required' if data[:name].nil?

        data
      end
    end
  end
end

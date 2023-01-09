require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    #def get_image_data(image_file)
    def image_analysis(profile_image)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"
      # 画像をbase64にエンコード
      #dir_tree = profile_image.key.scan(/.{1,#{2}}/)
      #base64_image = Base64.encode64(open("#{Rails.root}/public/uploads/#{dir_tree[0]}/#{dir_tree[1]}/#{profile_image.key}").read)
      base64_image = Base64.encode64(profile_image.read)

      # APIリクエスト用のJSONパラメータ
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'SAFE_SEARCH_DETECTION'
            }
          ]
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      response_body = JSON.parse(response.body)

      # APIレスポンス出力
      if response_body['responses'][0]['safeSearchAnnotation'].to_h.values.include?("LIKELY") || response_body['responses'][0]['safeSearchAnnotation'].to_h.values.include?("VERY_LIKELY")
        return false
      else
        return true
      end

       # 解析結果が「LIKELY」又は「VERY_LIKELY」を含む場合はfalse、それ以外はtrueを返す
      #if result.values.include?(:LIKELY) || result.values.include?(:VERY_LIKELY)
        #return false
      #else
        #return true
      #end
    end
  end
end




=begin
require 'base64'
require 'json'
require 'net/https'
module Vision
  class << self
    def image_analysis(profile_image)
      image_annotator = Google::Cloud::Vision::ImageAnnotator.new(
          version: :v1,
          credentials: JSON.parse(File.open('キーのファイル名') do |f| f.read end)
      )

      # リクエストパラメータ作成
      image = profile_image # 解析させたい画像(引数)
      requests_content = { image: { content: image }, features: [{ type: :SAFE_SEARCH_DETECTION }] }
      requests =   [requests_content]

      # Cloud Vision APIに画像を送信
      response = image_annotator.batch_annotate_images(requests)
      result = response.responses[0].safe_search_annotation.to_h

      # 解析結果が「LIKELY」又は「VERY_LIKELY」を含む場合はfalse、それ以外はtrueを返す
      if result.values.include?(:LIKELY) || result.values.include?(:VERY_LIKELY)
        return false
      else
        return true
      end
    end
  end
end
=end
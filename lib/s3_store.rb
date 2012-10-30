require 'aws/s3'

class S3Store
  def initialize(s3_key, s3_secret, s3_bucket)
    AWS::S3::Base.establish_connection!({
      access_key_id:      s3_key,
      secret_access_key:  s3_secret
    })
    @s3_bucket = s3_bucket
  end

  def store(path, data)
    AWS::S3::S3Object.store(path, data, @s3_bucket, {
      content_type: 'image/gif',
      access: :public_read
    })
  end

  def url
    "https://s3.amazonaws.com/#{@s3_bucket}"
  end
end

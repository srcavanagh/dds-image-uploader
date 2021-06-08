module Megahelper
    def names_array 
        names = []
        Net::SFTP.start("sftp.fulljaus.com", "drogueriasdelsur", :password => "droguerias2021", :port => 2222) do |sftp|
            sftp.dir.foreach("/imagenes") do |entry|
                names << entry.name
            end
        end
        return names
    end

    def aws_obj image
        ak = 'AKIAZ6KOVEODNFREGJRQ'
        sk = 'h1YSMMsKld68eMpYFwtjcxrJphRRxqbmgL2wAcOJ'
        Aws.config.update({
            region: 'us-east-1',
            credentials: Aws::Credentials.new(ak, sk),
        })
        s3 = Aws::S3::Resource.new(region:'us-east-1')
        @bucket = s3.bucket('fj-aws-s3-uploads')
        obj = @bucket.object("dds/#{image}")
        return obj
    end

    def download_to_tmp image        
        Net::SFTP.start("sftp.fulljaus.com", "drogueriasdelsur", :password => "droguerias2021", :port => 2222) do |sftp|
            sftp.download!("/imagenes/#{image}", "tmp/#{image}")
        end
    end
end